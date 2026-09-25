#!/bin/bash
# Task5: CRUD console app - Todo List
# Author: eugeneoseiasare
# Description: Menu-driven Todo List with Create, Read, Update, Delete
# Usage:./Task5_crud_app.sh

DATA_FILE="todo_data.csv"
BACKUP_FILE="todo_data.csv.bak"

# Create data file if not exists
if [! -f "$DATA_FILE" ]; then
    echo "ID,Description,Status,DueDate" > "$DATA_FILE"
fi

# Help/Usage
show_usage() {
    echo "Usage: $0 [option]"
    echo "Options:"
    echo " -h, --help Show this help"
    echo " Run without args to start interactive menu"
}

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_usage
    exit 0
fi

add_todo() {
    read -p "Enter task description: " desc
    if [ -z "$desc" ]; then
        echo "Error: Description cannot be empty!"
        return 1
    fi
    read -p "Enter due date (optional YYYY-MM-DD): " due
    # Generate ID
    last_id=$(tail -n 1 "$DATA_FILE" | cut -d',' -f1)
    if [[ "$last_id" == "ID" || -z "$last_id" ]]; then
        new_id=1
    else
        new_id=$((last_id + 1))
    fi
    echo "$new_id,$desc,pending,$due" >> "$DATA_FILE"
    echo "Task added with ID $new_id"
}

view_todos() {
    echo "=== Todo List ==="
    if [ $(wc -l < "$DATA_FILE") -le 1 ]; then
        echo "No tasks found."
    else
        cat "$DATA_FILE" | column -s',' -t
    fi
}

search_todo() {
    read -p "Enter keyword or ID to search: " key
    if [ -z "$key" ]; then
        echo "Error: Search term cannot be empty!"
        return 1
    fi
    result=$(grep -i "$key" "$DATA_FILE")
    if [ -z "$result" ]; then
        echo "Record not found for: $key"
    else
        echo "$result" | column -s',' -t
    fi
}

update_todo() {
    read -p "Enter ID to update: " id
    if [ -z "$id" ]; then echo "ID cannot be empty!"; return 1; fi
    if! grep -q "^$id," "$DATA_FILE"; then
        echo "Record not found with ID $id"
        return 1
    fi
    # Backup before destructive change
    cp "$DATA_FILE" "$BACKUP_FILE"
    echo "Backup created: $BACKUP_FILE"

    read -p "New description: " new_desc
    read -p "New status (pending/done): " new_status
    read -p "New due date: " new_due

    old_line=$(grep "^$id," "$DATA_FILE")
    old_desc=$(echo "$old_line" | cut -d',' -f2)
    old_status=$(echo "$old_line" | cut -d',' -f3)
    old_due=$(echo "$old_line" | cut -d',' -f4)

    [ -z "$new_desc" ] && new_desc="$old_desc"
    [ -z "$new_status" ] && new_status="$old_status"
    [ -z "$new_due" ] && new_due="$old_due"

    # Replace line
    grep -v "^$id," "$DATA_FILE" > /tmp/todo_tmp.csv
    echo "$id,$new_desc,$new_status,$new_due" >> /tmp/todo_tmp.csv
    mv /tmp/todo_tmp.csv "$DATA_FILE"
    echo "Task $id updated."
}

delete_todo() {
    read -p "Enter ID to delete: " id
    if [ -z "$id" ]; then echo "ID cannot be empty!"; return 1; fi
    if! grep -q "^$id," "$DATA_FILE"; then
        echo "Record not found with ID $id"
        return 1
    fi
    read -p "Are you sure you want to delete ID $id? (y/n): " confirm
    if [[ "$confirm"!= "y" && "$confirm"!= "Y" ]]; then
        echo "Delete cancelled."
        return 0
    fi
    cp "$DATA_FILE" "$BACKUP_FILE"
    echo "Backup created: $BACKUP_FILE"
    grep -v "^$id," "$DATA_FILE" > /tmp/todo_tmp.csv
    mv /tmp/todo_tmp.csv "$DATA_FILE"
    echo "Task $id deleted."
}

# Main menu loop
while true; do
    echo ""
    echo "===== TODO CRUD MENU ====="
    echo "1. Add Task"
    echo "2. View/List Tasks"
    echo "3. Search Task"
    echo "4. Update Task"
    echo "5. Delete Task"
    echo "6. Exit"
    read -p "Choose option [1-6]: " choice

    case $choice in
        1) add_todo ;;
        2) view_todos ;;
        3) search_todo ;;
        4) update_todo ;;
        5) delete_todo ;;
        6) echo "Exiting..."; exit 0 ;;
        *) echo "Invalid option! Choose 1-6" ;;
    esac
done
