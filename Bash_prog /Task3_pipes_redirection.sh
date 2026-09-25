#!/bin/bash
# Task3: Pipes and Redirection
echo "=== Task3 Pipes ==="
echo "Listing files with pipes:"
ls -l | grep ".sh"
echo "Saving output to log:"
ls > output.log
cat output.log
echo -e "apple\nbanana\napple" | sort | uniq
echo "Task3 Done"
