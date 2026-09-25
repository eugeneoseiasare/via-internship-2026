#!/bin/bash
# Task2: Permissions and sudo
echo "=== Task2 Permissions ==="
touch myfile.txt
ls -l myfile.txt
chmod 755 myfile.txt
ls -l myfile.txt
echo "Checking sudo access:"
sudo -v
echo "Current user: $(whoami)"
echo "Task2 Done"
