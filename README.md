# 📋 CheckMate - Student Attendance Tracking System

[![Shell Script](https://img.shields.io/badge/Shell-Script-4EAA25?style=flat&logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Dialog](https://img.shields.io/badge/GUI-Dialog-orange)](https://linux.die.net/man/1/dialog)

> 🎯 A lightweight, terminal-based student attendance management system built with shell scripting and dialog interface.

## ✨ Features

### 👥 Student Management
- ➕ **Add Student** - Register new students with ID and name
- 📋 **List Students** - View all registered students in a formatted table
- 🗑️ **Remove Student** - Delete individual student records with confirmation
- 🧹 **Clear All Records** - Bulk removal of all student data (with double confirmation)

### 📚 Course Management
- 🏫 **Manage Courses** - Add and organize course information
- 📖 **Course Listings** - View available courses with codes and names

### ✅ Attendance Tracking
- ☑️ **Mark Attendance** - Record student attendance for specific courses and dates
- 📊 **View Attendance** - Check attendance records and generate reports
- 📅 **Date-based Tracking** - Automatic date stamping for attendance records

### 🔧 System Features
- 📝 **Activity Logging** - Comprehensive logging of all system activities
- 🛡️ **Data Validation** - Input validation and error handling
- 💾 **Persistent Storage** - File-based data storage system
- 🎨 **Interactive GUI** - User-friendly dialog-based interface

## 🚀 Quick Start

### Prerequisites
- 🐧 **Linux/Unix Environment** (WSL supported on Windows)
- 🖥️ **Dialog Package** - For GUI interface
- 🐚 **Bash Shell** - Version 4.0 or higher

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/krishna1584/CheckMate.git
   cd CheckMate
   ```

2. **Install dialog (if not already installed):**
   ```bash
   # Ubuntu/Debian
   sudo apt-get install dialog
   
   # CentOS/RHEL/Fedora
   sudo yum install dialog
   # or
   sudo dnf install dialog
   
   # macOS
   brew install dialog
   ```

3. **Make the script executable:**
   ```bash
   chmod +x checkmate.sh
   ```

4. **Run CheckMate:**
   ```bash
   ./checkmate.sh
   ```

## 📖 Usage Guide

### 🏠 Main Menu
When you launch CheckMate, you'll see the main menu with the following options:

```
┌─ CheckMate Attendance System ─┐
│                               │
│  1. Add Student               │
│  2. List Students             │
│  3. Remove Student            │
│  4. Clear All Student Records │
│  5. Mark Attendance           │
│  6. View Attendance           │
│  7. Manage Courses            │
│  8. Exit                      │
│                               │
└───────────────────────────────┘
```

### 👤 Student Management Workflow

1. **Adding Students:** 
   - Select option 1
   - Enter unique Student ID
   - Enter Student Name
   - System validates and saves the record

2. **Viewing Students:**
   - Select option 2 to see formatted student list
   - View ID and name in a tabular format

3. **Removing Students:**
   - Select option 3
   - View current student list
   - Enter Student ID to remove
   - Confirm deletion

### 📊 Attendance Management

1. **Setup Courses:**
   - Select option 7 to manage courses
   - Add course codes and names

2. **Mark Attendance:**
   - Select option 5
   - Choose from available courses
   - System automatically uses current date
   - Mark students as present/absent

3. **View Reports:**
   - Select option 6 to view attendance records
   - Filter by date, course, or student

## 📁 File Structure

```
CheckMate/
├── checkmate.sh           # Main application script
├── README.md             # This documentation
└── ~/checkmate/          # Data directory (created at runtime)
    ├── students.txt      # Student records
    ├── courses.txt       # Course information
    ├── attendance.log    # Activity logs
    └── attendance/       # Attendance records by date
```

## 🗃️ Data Storage

### Student Records Format
```
student_id:student_name
123:John Doe
456:Jane Smith
```

### Course Records Format
```
course_code:course_name
CS101:Introduction to Computer Science
MATH201:Calculus II
```

### Log Format
```
[YYYY-MM-DD HH:MM:SS] Action Description
[2024-10-20 09:30:15] Added student: 123 (John Doe)
[2024-10-20 09:35:22] Marked attendance for CS101
```

## 🔧 Configuration

The script uses the following default configuration:

```bash
DATA_DIR="/home/$(whoami)/checkmate"    # Data storage directory
STUDENTS_FILE="$DATA_DIR/students.txt"  # Student records
COURSES_FILE="$DATA_DIR/courses.txt"    # Course information
ATTENDANCE_DIR="$DATA_DIR/attendance"   # Attendance records
LOG_FILE="$DATA_DIR/attendance.log"     # Activity logs
```

## 🛠️ Troubleshooting

### Common Issues

**Issue:** `dialog: command not found`
```bash
# Solution: Install dialog package
sudo apt-get install dialog  # Ubuntu/Debian
```

**Issue:** Permission denied
```bash
# Solution: Make script executable
chmod +x checkmate.sh
```

**Issue:** Data directory not created
```bash
# Solution: Check write permissions
ls -la ~/checkmate/
mkdir -p ~/checkmate  # Manual creation if needed
```

## 🤝 Contributing

We welcome contributions! Here's how you can help:

1. 🍴 **Fork the repository**
2. 🌟 **Create a feature branch** (`git checkout -b feature/amazing-feature`)
3. ✅ **Commit your changes** (`git commit -m 'Add amazing feature'`)
4. 📤 **Push to the branch** (`git push origin feature/amazing-feature`)
5. 🔄 **Open a Pull Request**

### 💡 Ideas for Contributions
- 📈 Enhanced reporting features
- 📧 Email notifications
- 🗄️ Database integration
- 🌐 Web interface
- 📱 Mobile compatibility
- 🔒 User authentication

<div align="center">
  <p>⭐ If you found CheckMate helpful, please give it a star!</p>
</div>
