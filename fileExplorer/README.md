# fileExplorer

An interactive NASM program for working with files using Linux i386 system calls.

## Features

- Create a new file or overwrite an existing file.
- Read and display file contents.
- Append text to an existing file.
- Display the current process ID.
- Handle basic system call errors.

## Requirements

- Linux x86 system call interface (i386)
- NASM
- GNU ld
- 32-bit ELF support

## Build and Run

Using `nrun`:

```bash
nrun file_explorer.asm
```

Or manually:

```bash
nasm -f elf file_explorer.asm -o file_explorer.o
ld -m elf_i386 file_explorer.o -o file_explorer
./file_explorer
```

## Usage

Run the program and select an option:

| Option | Description |
|---|---|
| 1 | Create or overwrite `notes.txt` |
| 2 | Read `notes.txt` |
| 3 | Append text to `notes.txt` |
| 4 | Display the current process ID |
| 0 | Exit |

The file is created in the current working directory.

## System Calls

| System Call | Number | Purpose |
|---|---:|---|
| `exit` | 1 | Terminate the program |
| `read` | 3 | Read data |
| `write` | 4 | Write data |
| `open` | 5 | Open a file |
| `close` | 6 | Close a file |
| `getpid` | 20 | Get the process ID |

## Learning Topics

- Linux i386 system call convention
- `int 80h`
- File descriptors
- File opening flags (`O_WRONLY`, `O_CREAT`, `O_TRUNC`, `O_APPEND`)
- File permissions
- Reading and writing files
- System call return values and error checking
- Registers and memory buffers
- Decimal number conversion
