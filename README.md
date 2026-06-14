# ExplorersVEsNA
Making VEsNA agents good explorers project
Author: Lina-Chemeliine Titova
Course: SYMBOLIC AND DISTRIBUTED ARTIFICIAL INTELLIGENCE
Project delivered on June 2026

Project Architecture and Setup
The project uses the coin-game directory from the VEsNA-Pro toolkit as its core foundation, combined with the env/office folder from VEsNA-Light to deploy the virtual office map and manage the WebSocket bridge between Godot and JaCaMo.
The system configuration and startup sequence consist of the following stages:
Godot Initialization: Launching the Godot engine starts the simulation and opens port 9080, listening for incoming WebSocket connections from JaCaMo.
JaCaMo Workspace Setup: Opening the project in VS Code allows Gradle to initialize the workspace and resolve Java dependencies. Executing the Gradle run task launches JaCaMo and connects it directly to Godot's open port 9080.
MAS Configuration: The vesna.jcm file defines the Multi-Agent System layout and registers the alice.asl agent configuration for execution (Figure 2).
Execution: Once launched, the Jason Control Window opens, initializing the Alice agent script. The visual agent ("the red man") begins navigating the office map while real-time execution logs pipe into the Jason console.
