#!/bin/bash

# ====================================================
# CheckMate: Student Attendance Tracking System
# ====================================================
# A shell script for tracking student attendance
# using dialog-based GUI interface
# ====================================================

# Configuration
DIALOG_TOOL="dialog"
DATA_DIR="/home/$(whoami)/checkmate"
STUDENTS_FILE="$DATA_DIR/students.txt"
ATTENDANCE_DIR="$DATA_DIR/attendance"
LOG_FILE="$DATA_DIR/attendance.log"
COURSES_FILE="$DATA_DIR/courses.txt"

# ====================================================
# Function: Initialize system
# ====================================================
initialize_system() {
    # Create necessary directories and files if they don't exist
    mkdir -p "$DATA_DIR"
    mkdir -p "$ATTENDANCE_DIR"
    
    touch "$STUDENTS_FILE"
    touch "$LOG_FILE"
    touch "$COURSES_FILE"
    
    # Set proper permissions
    chmod 755 "$DATA_DIR"
    chmod 666 "$STUDENTS_FILE"  # More permissive for troubleshooting
    chmod 666 "$LOG_FILE"
    chmod 666 "$COURSES_FILE"
    chmod 755 "$ATTENDANCE_DIR"
    
    # Log initialization
    log_action "System initialized"
}

# ====================================================
# Function: Log actions
# ====================================================
log_action() {
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] $1" >> "$LOG_FILE"
}

# ====================================================
# Function: Display main menu
# ====================================================
show_main_menu() {
    $DIALOG_TOOL --clear --title "CheckMate Attendance System" \
        --menu "Choose an option:" 15 60 8 \
        "1" "Add Student" \
        "2" "List Students" \
        "3" "Remove Student" \
        "4" "Clear All Student Records" \
        "5" "Mark Attendance" \
        "6" "View Attendance" \
        "7" "Manage Courses" \
        "8" "Exit" 2> /tmp/attendance_choice
    
    # Handle dialog exit codes
    if [ $? -ne 0 ]; then
        exit_program
        return
    fi
    
    choice=$(cat /tmp/attendance_choice)
    rm -f /tmp/attendance_choice
    
    case $choice in
        1) add_student ;;
        2) list_students ;;
        3) remove_student ;;
        4) clear_student_records ;;
        5) mark_attendance ;;
        6) view_attendance ;;
        7) manage_courses ;;
        8) exit_program ;;
    esac
}

# ====================================================
# Function: Add a new student
# ====================================================
add_student() {
    # Get student ID
    $DIALOG_TOOL --title "Add Student" \
        --inputbox "Enter Student ID:" 8 40 2> /tmp/student_id
    
    if [ $? -ne 0 ]; then
        show_main_menu
        return
    fi
    
    student_id=$(cat /tmp/student_id)
    rm -f /tmp/student_id
    
    # Input validation
    if [ -z "$student_id" ]; then
        $DIALOG_TOOL --title "Error" --msgbox "Student ID cannot be empty!" 8 40
        add_student
        return
    fi
    
    # Check if student already exists
    if grep -q "^$student_id:" "$STUDENTS_FILE"; then
        $DIALOG_TOOL --title "Error" --msgbox "Student ID already exists!" 8 40
        add_student
        return
    fi
    
    # Get student name
    $DIALOG_TOOL --title "Add Student" \
        --inputbox "Enter Student Name:" 8 40 2> /tmp/student_name
    
    if [ $? -ne 0 ]; then
        show_main_menu
        return
    fi
    
    student_name=$(cat /tmp/student_name)
    rm -f /tmp/student_name
    
    # Input validation
    if [ -z "$student_name" ]; then
        $DIALOG_TOOL --title "Error" --msgbox "Student Name cannot be empty!" 8 40
        add_student
        return
    fi
    
    # Add student to the file
    echo "$student_id:$student_name" >> "$STUDENTS_FILE"
    
    # Log the action
    log_action "Added student: $student_id ($student_name)"
    
    $DIALOG_TOOL --title "Success" --msgbox "Student added successfully!" 8 40
    show_main_menu
}

# ====================================================
# Function: List students
# ====================================================
list_students() {
    # Check if there are any students
    if [ ! -s "$STUDENTS_FILE" ]; then
        $DIALOG_TOOL --title "Error" --msgbox "No students found!" 8 40
        show_main_menu
        return
    fi
    
    # Create student list for display
    > /tmp/student_display
    echo "Student List" >> /tmp/student_display
    echo "---------------------------------" >> /tmp/student_display
    echo "ID    | Student Name" >> /tmp/student_display
    echo "---------------------------------" >> /tmp/student_display
    
    while IFS=: read -r id name; do
        printf "%-6s| %s\n" "$id" "$name" >> /tmp/student_display
    done < "$STUDENTS_FILE"
    
    $DIALOG_TOOL --title "Student List" \
        --textbox /tmp/student_display 20 60
    
    rm -f /tmp/student_display
    show_main_menu
}

# ====================================================
# Function: Remove a student
# ====================================================
remove_student() {
    # Check if there are any students
    if [ ! -s "$STUDENTS_FILE" ]; then
        $DIALOG_TOOL --title "Error" --msgbox "No students found!" 8 40
        show_main_menu
        return
    fi
    
    # Show list of students first
    > /tmp/student_display
    echo "Current Students" >> /tmp/student_display
    echo "---------------------------------" >> /tmp/student_display
    echo "ID    | Student Name" >> /tmp/student_display
    echo "---------------------------------" >> /tmp/student_display
    
    while IFS=: read -r id name; do
        printf "%-6s| %s\n" "$id" "$name" >> /tmp/student_display
    done < "$STUDENTS_FILE"
    
    $DIALOG_TOOL --title "Remove Student" \
        --textbox /tmp/student_display 20 60
    
    # Get student ID to remove
    $DIALOG_TOOL --title "Remove Student" \
        --inputbox "Enter Student ID to remove:" 8 40 2> /tmp/student_id
    
    if [ $? -ne 0 ]; then
        show_main_menu
        return
    fi
    
    student_id=$(cat /tmp/student_id)
    rm -f /tmp/student_id
    
    # Check if ID exists
    if ! grep -q "^$student_id:" "$STUDENTS_FILE"; then
        $DIALOG_TOOL --title "Error" --msgbox "Student ID not found in the system!" 8 40
        show_main_menu
        return
    fi
    
    # Get the student name
    student_name=$(grep "^$student_id:" "$STUDENTS_FILE" | cut -d: -f2)
    
    # Confirm deletion
    $DIALOG_TOOL --title "Confirm" \
        --yesno "Are you sure you want to remove student: $student_name (ID: $student_id)?" 8 70
    
    if [ $? -ne 0 ]; then
        show_main_menu
        return
    fi
    
    # Remove student from file
    grep -v "^$student_id:" "$STUDENTS_FILE" > /tmp/students_temp
    cat /tmp/students_temp > "$STUDENTS_FILE"
    rm -f /tmp/students_temp
    
    # Log the action
    log_action "Removed student: $student_id ($student_name)"
    
    $DIALOG_TOOL --title "Success" --msgbox "Student removed successfully!" 8 40
    show_main_menu
}

# ====================================================
# Function: Clear all student records
# ====================================================
clear_student_records() {
    # Check if there are any students
    if [ ! -s "$STUDENTS_FILE" ]; then
        $DIALOG_TOOL --title "Error" --msgbox "No students found!" 8 40
        show_main_menu
        return
    fi
    
    # Count number of students
    student_count=$(wc -l < "$STUDENTS_FILE")
    
    # Confirm clearing all records
    $DIALOG_TOOL --title "Warning" \
        --yesno "Are you ABSOLUTELY sure you want to remove ALL $student_count student records?\n\nThis action cannot be undone!" 10 60
    
    if [ $? -ne 0 ]; then
        show_main_menu
        return
    fi
    
    # Double-check with a different confirmation
    $DIALOG_TOOL --title "Final Warning" \
        --yesno "This will permanently delete ALL student records.\n\nType 'YES' to confirm:" 10 60
    
    if [ $? -ne 0 ]; then
        show_main_menu
        return
    fi
    
    # Clear the file
    > "$STUDENTS_FILE"
    
    # Log the action
    log_action "Cleared all student records ($student_count students removed)"
    
    $DIALOG_TOOL --title "Success" --msgbox "All student records have been cleared!" 8 40
    show_main_menu
}
