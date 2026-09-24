# OR

A simple x86 Assembly program that performs a bitwise OR operation on two binary numbers.

## Requirements

* NASM
* Linux or FreeBSD
* `stud_io.inc`

## Build & Run

```bash
nasm -f elf32 or.asm -o or.o
ld -m elf_i386 or.o -o or
./or
```

## Usage

Enter two binary numbers:

```text
1010
1100
```

Output:

```text
00000000000000000000000000001110
```

## How It Works

* Reads two binary numbers.
* Performs a bitwise OR operation.
* Prints the result in binary.
