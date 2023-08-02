#!/bin/bash

todo_file="todo.txt"
done_file="done.txt"
deleted_file="deleted.txt"

if [ ! -f "$todo_file" ]; then
    touch "$todo_file" || { echo "Error creating todo file"; exit 1; }
fi

if [ ! -f "$done_file" ]; then
    touch "$done_file" || { echo "Error creating done file"; exit 1; }
fi

if [ ! -f "$deleted_file" ]; then
    touch "$deleted_file" || { echo "Error creating deleted file"; exit 1; }
fi

add_task() {
    echo "Enter task title:"
    read title

    echo "Enter task date:"
    read date

    echo "Enter task time:"
    read time

    echo "Enter task priority (1-3):"
    read priority

    echo "[Priority $priority] $title, $date, $time" >> todo.txt || { echo "Error adding task"; exit 1; }
    echo "Task added successfully!"
}

function show_todo {
    echo "Unfinished tasks:"
    cat "$todo_file" || { echo "Error reading todo file"; exit 1; }
}

function complete_task {
    local task=$1
    sed -i "/$task/d" "$todo_file" || { echo "Error removing task from todo file"; exit 1; }
    echo "$task" >> "$done_file" || { echo "Error adding task to done file"; exit 1; }
    echo "Task \"$task\" has been marked as complete and moved to the completed tasks list."
}

function show_done {
    echo "Completed tasks:"
    cat "$done_file" || { echo "Error reading done file"; exit 1; }
}

function delete_task {
    local task=$1
    sed -i "/$task/d" "$todo_file" || { echo "Error removing task from todo file"; exit 1; }
    sed -i "/$task/d" "$done_file" || { echo "Error removing task from done file"; exit 1; }
    echo "$task" >> "$deleted_file" || { echo "Error adding task to deleted file"; exit 1; }
    echo "Task \"$task\" has been deleted and moved to the deleted tasks list."
}

function show_deleted {
    echo "Deleted tasks:"
    cat "$deleted_file" || { echo "Error reading deleted file"; exit 1; }
}

function search_task {
    local keyword=$1

    echo "Search results in unfinished tasks:"
    grep "$keyword" "$todo_file"

    echo "Search results in completed tasks:"
    grep "$keyword" "$done_file"

    echo "Search results in deleted tasks:"
    grep "$keyword" "$deleted_file"
}

while true; do
    clear
    echo "1. Add a task"
    echo "2. Show unfinished tasks"
    echo "3. Add a task to completed tasks"
    echo "4. Show completed tasks"
    echo "5. Delete a task and add it to the deleted tasks list"
    echo "6. Show deleted tasks"
    echo "7. Search in lists"
    echo "8. Exit"

    read -p "Select an operation: " choice

    case $choice in
        1)
            add_task
            ;;
        2)
            show_todo
            ;;
        3)
            read -p "Task title: " task
            complete_task "$task"
            ;;
        4)
            show_done
            ;;
        5)
            read -p "Task title: " task
            delete_task "$task"
            ;;
        6)
            show_deleted
            ;;
        7)
            read -p "Keyword: " keyword
            search_task "$keyword"
            ;;
        8)
            break
            ;;
        *)
            echo "Invalid operation."
            ;;
    esac

    read -p "Press Enter to continue..."
done
