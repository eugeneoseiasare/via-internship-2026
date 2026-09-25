
#!/bin/bash
# Task1: File Handling
echo "=== Task1 File Handling ==="
FILE="students.txt"
echo -e "Name,Age\nEugene,25\nAma,22" > $FILE
cat $FILE
echo "Appending Kofi..." 
echo "Kofi,24" >> $FILE
wc -l $FILE
grep "Eugene" $FILE
echo "Task1 Done"
