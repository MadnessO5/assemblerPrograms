# String Reverser

A simple x86 Assembly program that reads a line of text and prints it in reverse order using the stack.

## Requirements

* NASM

* Linux or FreeBSD

* `stud_io.inc`

## Build & Run

Bash

```
nasm -f elf32 reverse.asm -o reverse.o
ld -m elf_i386 reverse.o -o reverse
./reverse
```

## Usage

```
Hello World
dlroW olleH
```

## How It Works

* Reads characters until a newline or end of input.

* Stores the characters in a buffer.

* Pushes each character onto the stack.

* Pops the characters in reverse order.

* Prints the reversed string followed by a newline.
