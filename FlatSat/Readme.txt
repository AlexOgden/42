FlatSat Dedicated Simulation Configuration

This directory contains the simulator configuration for the Space Cyber Testbench
(NASA 42 + SimBroker + Bright Ascension FSW).

Key settings:
- Inp_Sim.txt: REAL time (0.1 s step), headless (Graphics = FALSE), 4x4 Earth gravity, IGRF.
- Orb_LEO.txt: 500 km circular Sun-Synchronous LEO (97.4 deg inclination).
- SC_FlatSat.txt: Active default spacecraft (150 kg, PASSIVE_FSW, 0.1 s sample time, COWELL orbit propagation).
- SC_Cubesat6U.txt: Saved 6U CubeSat profile (10 kg, MOI [0.108, 0.083, 0.042] kg*m^2, Cubesat_6U.obj).
- Inp_IPC.txt: TX on port 10001 ("SC", "Orb") and RX on port 10002 (actuator commands).

Enabling the 6U CubeSat Profile (Optional):
1. In Inp_Sim.txt, change line 14 from:
     TRUE  0 SC_FlatSat.txt
   to:
     TRUE  0 SC_Cubesat6U.txt
2. If testing with Utility/fsw_sim_test.py, scale the spacecraft constants in
   Utility/fsw_sim_test.py to match the 6U dynamics:
     DEFAULT_MOI = (0.108, 0.083, 0.042)
     MAX_WHEEL_TORQUE_NM = 0.005
     DEFAULT_THRUST_N = 1.0
   (and lower the spin-up disturbance torque in run_detumble_phase, e.g. [0.002, -0.0015, 0.001]).
