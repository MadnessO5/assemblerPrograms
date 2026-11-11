# fileCopy

A simple file-copying program written in NASM assembly for Linux (32-bit).

## Description

This program copies a file using Linux system calls.

It accepts two command-line arguments:

- Source file
- Destination file

The program reads data in blocks of 4096 bytes and writes it to the destination file.

## Requirements

- NASM
- Linux (32-bit ELF support)
- GNU ld

## Build

```bash
nasm -f elf -dOS_LINUX copy.asm -o copy.o
ld -m elf_i386 copy.o -o copy
```

## Run

```bash
./copy source.txt destination.txt
```

Or use `nrun`:

```bash
nrun copy.asm source.txt destination.txt
```

## Example

```bash
echo "Hello from Linux!" > original.txt
./copy original.txt duplicate.txt
cat duplicate.txt
```

Output:

```text
Hello from Linux!
```

## System Calls

| System call | Number | Purpose |
|---|---:|---|
| `sys_read` | 3 | Read data from a file |
| `sys_write` | 4 | Write data to a file |
| `sys_open` | 5 | Open or create a file |
| `sys_close` | 6 | Close a file |
| `sys_exit` | 1 | Terminate the program |

## Notes

- The source file must already exist.
- The destination file is created if it does not exist.
- If the destination file exists, its previous contents are overwritten.
- Data is copied using a 4096-byte buffer.
