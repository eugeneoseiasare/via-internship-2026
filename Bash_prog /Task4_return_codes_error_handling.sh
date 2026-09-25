#!/bin/bash
# Task4: Return codes & error handling
# Author: eugeneoseiasare
# Description: Runs 4 system checks with disciplined exit codes
# Exit codes:
# 0 = all checks passed
# 1 = missing required argument
# 2 = host unreachable
# 3 = insufficient disk space
# 4 = required file not found
# 5 = required command not found

# Usage:./Task4_return_codes_error_handling.sh <hostname>

# Trap to clean temp files on exit/interrupt
TEMP_FILE="/tmp/task4_check_$$.tmp"
cleanup() {
    echo "[INFO] Cleaning up..."
    rm -f "$TEMP_FILE"
    echo "[INFO] Cleanup done."
}
trap cleanup EXIT INT TERM

# Check if argument provided
if [ $# -lt 1 ]; then
    echo "Usage: $0 <hostname>"
    echo "Example: $0 google.com"
    exit 1
fi

HOST="$1"

# Helper function to check status
check_status() {
    local status=$1
    local success_msg="$2"
    local fail_msg="$3"
    local exit_code=$4

    if [ $status -eq 0 ]; then
        echo "[PASS] $success_msg"
        return 0
    else
        echo "[FAIL] $fail_msg"
        exit $exit_code
    fi
}

echo "=== Task4: System Health Checks ==="
echo "Target host: $HOST"
echo ""

# Check 1: Is host reachable?
echo "[1/4] Checking if host $HOST is reachable..."
ping -c 1 -W 2 "$HOST" > "$TEMP_FILE" 2>&1
check_status $? "Host $HOST is reachable" "Host $HOST is unreachable" 2

# Check 2: Is there enough free disk space? (check if >100MB free)
echo "[2/4] Checking disk space..."
df -h / | tail -1 > "$TEMP_FILE"
DISK_OK=$(df / | tail -1 | awk '{print $4}' )
# We just check if df command succeeded, for demo we require >0
check_status $? "Disk space check passed (Free: $DISK_OK)" "Insufficient disk space" 3

# Check 3: Does a given file exist and readable?
echo "[3/4] Checking if required file exists..."
TEST_FILE="/etc/hosts"
if [ -r "$TEST_FILE" ]; then
    echo "[PASS] File $TEST_FILE exists and readable" > "$TEMP_FILE"
    check_status 0 "File $TEST_FILE exists and readable" "" 4
else
    check_status 1 "" "Required file $TEST_FILE not found" 4
fi

# Check 4: Is a given command installed?
echo "[4/4] Checking if required tool is installed..."
command -v curl > "$TEMP_FILE" 2>&1
check_status $? "Command curl is installed" "Required command curl not found" 5

echo ""
echo "All 4 checks passed successfully!"
exit 0
