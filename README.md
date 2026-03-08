# Bash Conditional Operators Cheatsheet
In Bash, `if` statements use these operators within `[ ]` (test) or `[[ ]]` (extended test) blocks.

## 1. File Test Operators
Check properties of files and directories.

| Flag | True if... |
| :--- | :--- |
| `-e` | File **exists** |
| `-f` | File is a **regular file** (not a directory) |
| `-d` | File is a **directory** |
| `-s` | File is **not empty** (size > 0) |
| `-r` | File is **readable** |
| `-w` | File is **writable** |
| `-x` | File is **executable** |
| `-L` | File is a **symbolic link** |
| `-O` | You are the **owner** of the file |
| `-nt` | File1 is **newer than** File2 (`f1 -nt f2`) |
| `-ot` | File1 is **older than** File2 (`f1 -ot f2`) |


## 2. String Operators
Compare text and check for empty variables.

| Flag/Op | True if... |
| :--- | :--- |
| `-z` | String is **empty** (zero length) |
| `-n` | String is **not empty** (non-zero length) |
| `==` | Strings are **equal** |
| `!=` | Strings are **not equal** |
| `<` | String sorts **before** another (ASCII) |
| `>` | String sorts **after** another (ASCII) |
| `=~` | String matches **regex** (requires `[[ ]]`) |


## 3. Integer Operators
Compare whole numbers.

| Flag | Description |
| :--- | :--- |
| `-eq` | **Equal** to |
| `-ne` | **Not equal** to |
| `-gt` | **Greater than** |
| `-ge` | **Greater than or equal** to |
| `-lt` | **Less than** |
| `-le` | **Less than or equal** to |


## 4. Logical Operators
Combine multiple conditions.

| Operator | Usage | Description |
| :--- | :--- | :--- |
| `!` | `! CONDITION` | **NOT** (Inverts the result) |
| `&&` | `[[ C1 && C2 ]]` | **AND** (Both must be true) |
| `||` | `[[ C1 || C2 ]]` | **OR** (At least one must be true) |

---

## Basic Template
```bash
if [[ -f "$FILE" ]]; then
    echo "File exists."
elif [[ -z "$VAR" ]]; then
    echo "Variable is empty."
else
    echo "Condition not met."
fi
```

## 1. Files and Directories (`mktemp`)
The `mktemp` command is the safest way to create unique, secure temporary objects.

| Action | Command | Description |
| :--- | :--- | :--- |
| **Create File** | `tmp=$(mktemp)` | Creates a unique file in `/tmp`. |
| **Create Directory** | `dir=$(mktemp -d)` | Creates a unique folder in `/tmp`. |
| **Custom Name** | `mktemp /tmp/log.XXXX` | Uses `X` as placeholders for random chars. |
| **Dry Run** | `mktemp -u` | Generates a unique name **without** creating it. |


## 2. Temporary Data Streams
Pass data between commands without creating physical files on the disk.

| Method | Syntax | Description |
| :--- | :--- | :--- |
| **Process Sub** | `<(command)` | Treats command output like a file (e.g., `diff <(ls a) <(ls b)`). |
| **Here-Doc** | `<<EOF` | Passes a multi-line block of text to a command. |
| **Here-String**| `<<< "$VAR"` | Passes a variable's content as a file input. |


## 3. Variables
Variables are temporary to the shell session or specific functions.

| Type | Syntax | Scope |
| :--- | :--- | :--- |
| **Shell Var** | `TEMP="data"` | Available until the script ends. |
| **Local Var** | `local tmp="data"` | Only available inside a **function**. |
| **One-shot** | `VAR=val ./script` | Only available to that **one command**. |
| **Set --** | `set -- hello world` | echo ${1} ${2}. |

---

## Output Redirection Cheatsheet
| Operator | Target | Behavior |
| :--- | :--- | :--- |
| `>` | stdout | Overwrite file |
| `>>` | stdout | Append to file |
| `2>` | stderr | Overwrite file |
| `&>` | stdout + stderr | Overwrite file |
| `&>>` | stdout + stderr | Append to file |
| `> /dev/null` | stdout | Discard output |
| `2>&1` | stderr | Merge stderr into stdout |


# 2. Set the trap (runs rm when script exits, even if it fails)
# Since temporary files persist after a script crashes or finishes, use a **Trap** to delete them automatically on exit.
# EXIT covers normal finish, Ctrl+C, and errors.
trap 'rm -f "$tmp_file"' EXIT
trap 'echo "Script failed at $LINENO"' ERR

# Bash Loops Summary
| Loop Type | Usage | Best For... |
| :--- | :--- | :--- |
| **`for...in`** | `for x in list; do` | Iterating over arrays, files, or strings. |
| **`for ((...))`** | `for ((i=0; i<n; i++))` | Numeric counters and C-style logic. |
| **`while`** | `while [[ cond ]]; do` | Running until a condition is no longer met. |
| **`until`** | `until [[ cond ]]; do` | Running until a specific condition starts being met. |

## Control Flow
- **`break`**: Stop the loop entirely.
- **`continue`**: Skip to the next loop cycle.

# Bash File Iteration: `while read` vs `cat`

| Method | Syntax | Pros/Cons |
| :--- | :--- | :--- |
| **`while read`** | `while read -r line; do ... done < file` | **Safe.** Handles spaces, saves memory, standard practice. |
| **`for cat`** | `for x in $(cat file); do ... done` | **Risky.** Breaks on spaces/tabs, slow on large files. |
| **Process Sub** | `while read -r line; do ... done < <(command)` | **Powerful.** Allows reading output of a command as a file. |

### Example: Reading Multiple Columns
If your file is CSV-like (e.g., `Name,Age`), you can split it into variables immediately:
```bash
while IFS="," read -r name age; do
    echo "$name is $age years old"
done < data.csv
```

## Args Parse for the Standard Pattern
```bash
while [[ $# -gt 0 ]]; do
  case "$1" in
    -u|--user)     USER="$2"; shift 2 ;; # Flag with value
    -v|--verbose)  VERBOSE=1; shift ;;   # Boolean flag
    --)            shift; break ;;       # End of options
    *)             POSITIONAL+=("$1"); shift ;; # Save positional args
  esac
done
set -- "${POSITIONAL[@]}" # Restore positional arguments
```

# Bash `getopts` Cheatsheet (Short Flags)
`getopts` is the standard for handling single-letter options.

## Syntax Rules
- `getopts "abc" opt`: Handles `-a`, `-b`, and `-c`. No values allowed.
- `getopts "a:b" opt`: `-a` **requires** a value (e.g., `-a 100`), `-b` does not.
- `getopts ":ab:" opt`: Leading `:` enables **silent error mode** (you handle errors in the `?` case).

## Example Template
```bash
#!/bin/bash

# Default values
NAME="Guest"
VERBOSE=0

while getopts "n:v" opt; do
  case ${opt} in
    n) NAME="$OPTARG" ;;
    v) VERBOSE=1 ;;
    *) echo "Usage: $0 [-n name] [-v]" && exit 1 ;;
  esac
done

# Shift away the flags so $1 is the first non-flag argument
shift $((OPTIND -1))

echo "Hello, $NAME. Verbose is $VERBOSE. Extra args: $@"
```

# Bash Terminal & Redirection Checks

The `[ -t FD ]` test is used to detect if a **File Descriptor (FD)** is a terminal (TTY). This allows scripts to switch between **Interactive** and **Automated** modes.

## 1. File Descriptor Reference

| FD | Name | Default Source/Target |
| :--- | :--- | :--- |
| **0** | `stdin` | Keyboard (Input) |
| **1** | `stdout` | Screen (Normal Output) |
| **2** | `stderr` | Screen (Error Output) |

---

## 2. Common "If" Checks

### Check Input (`stdin`)
Determine if a human is typing or if data is being piped in.
```bash
if [ -t 0 ]; then
    echo "Interactive: Input is from a keyboard."
else
    echo "Automated: Input is being piped or redirected."
fi
---
if [ -t 1 ]; then
    echo -e "\e[32mSuccess!\e[0m (Output is a terminal, showing colors)"
else
    echo "Success! (Output is a file/pipe, hiding colors)"
fi
---
if [ ! -t 2 ]; then
    echo "Alert: Errors are being redirected to a log file."
fi
---
if [ -t 0 ]; then
    # Terminal detected: Ask a human
    read -r -p "Enter name: " name
    echo "Hello, $name"
else
    # Pipe detected: Process the stream
    while read -r line; do
        echo "Processing piped name: $line"
    done
fi
```
