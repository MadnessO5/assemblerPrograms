# Uppercase

A simple x86 Assembly program that converts lowercase letters to uppercase. It reads characters until Enter is pressed.

## Requirements

* NASM

* Linux or FreeBSD

* `stud_io.inc`

## Build & Run

Bash

```
nasm -f elf32 uppercase.asm -o uppercase.o
ld -m elf_i386 uppercase.o -o uppercase
./uppercase
```

## Usage

```
Type something (Enter to finish):
Hello World
HELLO WORLD
Goodbye!
```

## How It Works

* Reads characters one at a time using `GETCHAR`.

* Converts lowercase letters (`a-z`) to uppercase (`A-Z`).

* Prints each character using `PUTCHAR`.

* Stops when Enter is pressed.

* `FINISH 0` exits the program.
