# Operating System Simulation

This project is a Bash-based simulation that models fundamental operating system functionalities. Designed as a learning tool, the simulation demonstrates key concepts such as memory management, disk scheduling, and file system operations through shell scripting.

## Objectives

- Simulate memory management with page fault handling and FIFO replacement.
- Perform file operations (read, write, modify, delete) per process.
- Simulate disk I/O with logging for analysis.
- Reinforce core OS principles in a simplified, interactive environment.

## Features

- Page fault detection and handling
- Memory usage tracking and logging
- Disk request logging
- Process-based file system interaction

## Getting Started

### Prerequisites

- A Unix-based environment (Linux/macOS)
- Bash shell (typically pre-installed)

### Running the Script

1. Make the script executable:
   ```bash
   chmod +x os_simulation.sh

   **Execution**
   ./os_simulation.sh
**Output**
After execution, the following log files are generated:

log/memory_log.csv — Tracks memory utilization and page faults

log/disk_log.csv — Records disk I/O events

log/filesystem_log.csv — Logs all file operations by processes

Documentation
Report
[Os_simulation_report (1).pdf](https://github.com/user-attachments/files/20852317/Os_simulation_report.1.pdf)

Prensentation
[OS_SIMULATION_PPT.pdf](https://github.com/user-attachments/files/20852320/OS_SIMULATION_PPT.pdf)
