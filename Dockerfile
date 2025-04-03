# Build 42 in a Debian container first
FROM debian:bookworm-slim AS builder

RUN apt-get update && apt-get install -y gcc make freeglut3-dev wget

# Install Julia
RUN wget -q https://julialang-s3.julialang.org/bin/linux/x64/1.11/julia-1.11.4-linux-x86_64.tar.gz && \
    tar -xzf julia-1.11.4-linux-x86_64.tar.gz -C /opt && \
    ln -s /opt/julia-1.11.4/bin/julia /usr/local/bin/julia && \
    rm julia-1.11.4-linux-x86_64.tar.gz

# Install Julia JSON package
RUN julia -e 'import Pkg; Pkg.add("JSON")'

WORKDIR /app
COPY . .

# Set the database fields to send over IPC defined in Database/42.json
RUN julia MetaCode/JsonToTxRxIPC.jl

# Compile the 42 C code
RUN make -s

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