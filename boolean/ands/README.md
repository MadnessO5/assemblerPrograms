# AND

A simple x86 Assembly program that performs a bitwise AND operation on two binary numbers.

## Requirements

* NASM
* Linux or FreeBSD
* `stud_io.inc`

## Build & Run

```bash
nasm -f elf32 and.asm -o and.o
ld -m elf_i386 and.o -o and
./and
```

## Usage

Enter two binary numbers:

```text
1010
1100
```

Output:

```text
00000000000000000000000000001000
```

## How It Works

* Reads two binary numbers.
* Performs a bitwise AND operation.
* Prints the result in binary.
