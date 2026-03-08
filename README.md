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

## Bash Temporary Data Cheatsheet
Summary of methods for handling temporary files, folders, and variables in Bash.
---

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

## 4. Best Practice: Automatic Cleanup
Since temporary files persist after a script crashes or finishes, use a **Trap** to delete them automatically on exit.

```bash
# 1. Create the temp file
tmp_file=$(mktemp)
```

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
# EXIT covers normal finish, Ctrl+C, and errors.
trap 'rm -f "$tmp_file"' EXIT

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

## Pro-Tip: File Globbing
```bash
for file in *.jpg; do
    mv "$file" "${file%.jpg}.png"
done
```
# 3. Use the file
echo "Working..." > "$tmp_file"
