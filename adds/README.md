# Integer Addition

A simple x86 Assembly program that reads two signed decimal integers, adds them, and prints their sum.

## Requirements

* NASM

* Linux or FreeBSD

* `stud_io.inc`

## Build & Run

Bash

```
nasm -f elf32 add.asm -o add.o
ld -m elf_i386 add.o -o add
./add
```

## Usage

```
12
8
20

-15
7
-8
```

## How It Works

* `read_int` reads a signed decimal integer from standard input.

* Converts ASCII digits into an integer.

* Supports positive and negative numbers.

* Adds the two integers together.

* `print_int` converts the result back into decimal characters.

* `FINISH 0` exits the program.
