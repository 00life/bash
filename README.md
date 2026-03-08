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
