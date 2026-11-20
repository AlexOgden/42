FlatSat Dedicated Simulation Configuration

This directory contains the simulator configuration for the Space Cyber Testbench
(NASA 42 + SimBroker + Bright Ascension FSW).

Key settings:
- Inp_Sim.txt: REAL time (0.1 s step), headless (Graphics = FALSE), 4x4 Earth gravity, IGRF.
- Orb_LEO.txt: 500 km circular Sun-Synchronous LEO (97.4 deg inclination).
- Inp_IPC.txt: TX on port 10001 ("SC", "Orb") and RX on port 10002 (actuator commands).

Available Spacecraft Profiles (all PASSIVE_FSW, 0.1 s sample, COWELL, 3-axis Gyro):
- SC_FlatSat.txt   : Active default Ion Cruiser (150 kg, MOI [25, 30, 35], IonCruiser.obj)
- SC_Cubesat6U.txt : 6U CubeSat (10 kg, MOI [0.108, 0.083, 0.042], Cubesat_6U.obj)
- SC_Cubesat3U.txt : 3U CubeSat (4 kg, MOI [0.033, 0.033, 0.0067], Cubesat_3U.obj)
- SC_Shuttle.txt   : Space Shuttle Atlantis (200 kg, MOI [100, 200, 300], SpaceShuttleOrbiter.obj)
- SC_HST.txt       : Hubble Space Telescope (12220 kg, MOI [88400, 93200, 38200], HST.obj)
- SC_ISS.txt       : International Space Station (16 bodies, 1600 kg, ISS_MainBody.obj + solar arrays)

Switching Spacecraft:
  python Utility/switch_spacecraft.py --list
  python Utility/switch_spacecraft.py <alias> [--restart]
  (Aliases: flatsat/ioncruiser, 6u, 3u, atlantis/shuttle, hst/hubble, iss)
  Utility/fsw_sim_test.py auto-detects the active spacecraft from Inp_Sim.txt.
