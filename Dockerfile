# Build 42 in a Debian container first
FROM debian:bookworm-slim AS builder

RUN apt-get update && apt-get install -y gcc make freeglut3-dev

WORKDIR /app
COPY . .
RUN make

# Use a minimal base for runtime stage
FROM debian:bookworm-slim

# Create a non-root user
RUN useradd -m 42user
ENV HOME=/home/42user

# Copy only the built binaries from the builder and adjust ownership
COPY --from=builder --chown=42user:42user /app/42 /app/42
COPY --from=builder --chown=42user:42user /app/Model /app/Model
COPY --from=builder --chown=42user:42user /app/Tx /app/Tx

# Install glut, tini, and cleanup
RUN apt-get update && \
    apt-get install -y freeglut3-dev tini && \
    apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Switch to non-root user
USER 42user

WORKDIR /app

ENTRYPOINT ["/usr/bin/tini", "--", "/app/42"]
CMD ["Tx"]