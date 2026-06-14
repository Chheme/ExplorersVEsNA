# ExplorersVEsNA
Making VEsNA agents good explorers project

Author: Lina-Chemeliine Titova

Course: SYMBOLIC AND DISTRIBUTED ARTIFICIAL INTELLIGENCE

Project delivered on June 2026

Setup & Architecture

Based on VEsNA-Pro/coin-game (core structure) + VEsNA-Light/env/office (office map & Godot-JaCaMo bridge).

Startup sequence:

Godot: Launch the engine. It opens WebSocket port 9080 and listens for JaCaMo.

JaCaMo: Open project in VS Code (Gradle will resolve Java dependencies). Hit gradle run to launch JaCaMo and connect to 9080.

Config: vesna.jcm defines the MAS setup and loads the alice.asl agent.

Run: Once Gradle fires up, the Jason Control Window opens, initializing the Alice script. The red man starts roaming the office map with real-time logs dumping into the Jason console.
