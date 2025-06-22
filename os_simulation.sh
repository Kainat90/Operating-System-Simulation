BASH SCRIPT 

#!/bin/bash

# ====== Initialization ======
echo "[INIT] Starting OS Simulation..."

# Create necessary directories
mkdir -p virtual_disk memory log filesys

# Initialize log files
echo "Time,Memory Utilization,Page Faults" > log/memory_log.csv
echo "Time,Disk Request,Serviced At" > log/disk_log.csv
echo "Time,Operation,File,Process" > log/filesystem_log.csv

# Memory and process configuration
MEMORY_SIZE=5
declare -A memory_page_table
declare -a memory_usage_order
page_faults=0

declare -A process_pages
process_pages[Process1]=3
process_pages[Process2]=2
process_pages[Process3]=4

# Create file system for processes
mkdir -p filesys/Process1 filesys/Process2 filesys/Process3
touch filesys/Process1/file1.txt
echo "Hello from P1!" > filesys/Process1/file1.txt

# ====== Logging Memory Usage ======
log_memory() {
    local timestamp=$(date +%s)
    echo "$timestamp,${#memory_page_table[@]},$page_faults" >> log/memory_log.csv
}

# ====== Handle Page Faults ======
simulate_page_fault() {
    ((page_faults++))
    echo "[FAULT] Page fault for $1-$2. Handling..."

    if [ ${#memory_usage_order[@]} -ge $MEMORY_SIZE ]; then
        oldest=${memory_usage_order[0]}
        unset memory_page_table[$oldest]
        memory_usage_order=("${memory_usage_order[@]:1}")
        echo "[REPLACE] Removed $oldest from memory."
    fi

    memory_page_table[$1-$2]=1
    memory_usage_order+=("$1-$2")
    log_memory
}

# ====== Simulate File Operations ======
simulate_file_operation() {
    local proc=$1
    local file=$2
    local op=$3
    local timestamp=$(date +%s)

    echo "[FILE] $proc performs $op on $file"
    echo "$timestamp,$op,$file,$proc" >> log/filesystem_log.csv

    local path="filesys/$proc/$file"

    case $op in
        "read") cat "$path" >/dev/null 2>&1 ;;
        "write") echo "Writing to $file by $proc" >> "$path" ;;
        "delete") rm -f "$path" ;;
        "modify") echo "Modified by $proc" > "$path" ;;
    esac
}

# ====== Simulate Disk I/O ======
simulate_disk_io() {
    local proc=$1
    local req=$2
    local timestamp=$(date +%s)

    echo "[DISK] Handling $req for $proc"
    echo "$timestamp,$req,Disk0" >> log/disk_log.csv
    sleep 1
}

# ====== Run a Process ======
run_process() {
    local proc=$1
    local pages=${process_pages[$proc]}

    echo "[RUN] Executing $proc with $pages pages."

    for ((i=1; i<=pages; i++)); do
        key="$proc-Page$i"

        if [ -z "${memory_page_table[$key]}" ]; then
            simulate_page_fault $proc Page$i
        fi

        simulate_file_operation $proc "file$i.txt" "read"
        simulate_file_operation $proc "file$i.txt" "write"
        simulate_file_operation $proc "file$i.txt" "modify"
        simulate_disk_io $proc "SwapIn_Page$i"
    done

    simulate_file_operation $proc "file1.txt" "delete"
    echo "[DONE] $proc finished."
}

# ====== Run All Processes ======
run_process Process1
run_process Process2
run_process Process3

# ====== Final Output ======
echo -e "\n[RESULT] Simulation Complete. Logs available:"
echo "- Memory Log: log/memory_log.csv"
echo "- Disk Log: log/disk_log.csv"
echo "- File System Log: log/filesystem_log.csv"


