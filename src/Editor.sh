#!/bin/bash

add_text_to_files() {
    for file in "${files[@]}"; do
        echo "Hello world" >> "$file"
    done
    echo "Text successfully added to files."
}

replace_word_in_files() {
    for file in "${files[@]}"; do
        sed -i 's/world/bash/g' "$file"
    done
    echo "The word 'world' has been replaced with 'bash' in files."
}

print_file_contents() {
    for file in "${files[@]}"; do
        echo "Contents of $file:"
        cat "$file"
        echo "________________________"
    done
}

files=("file1.txt" "file2.txt" "file3.txt" "file4.txt" "file5.txt")

while true; do
    clear
    PS3="Please select an option: "
    options=("Create five text files and add'Hello world'"
             "Replace the word 'world' with 'bash'"
             "Print the files"
             "Exit")
    select opt in "${options[@]}"; do
        case $opt in
            "Create five text files and add'Hello world'")
                add_text_to_files
                read -p "Press Enter to continue..."
                break
                ;;
            "Replace the word 'world' with 'bash'")
                replace_word_in_files
                read -p "Press Enter to continue..."
                break
                ;;
            "Print the files")
                print_file_contents
                read -p "Press Enter to continue..."
                break
                ;;
            "Exit")
                break 2
                ;;
            *)
                echo "wrong choice! Please select one of the options."
                ;;
        esac
    done
done
