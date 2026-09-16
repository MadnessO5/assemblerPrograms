# Hello Loop

A simple x86 Assembly program that prints `Hello` five times using the `stud_io.inc` macros.

## Requirements

* NASM
* Linux or FreeBSD
* 32-bit support

On Debian/Ubuntu:

```bash
sudo apt install nasm gcc-multilib
```

## Build & Run

```bash
nasm -f elf32 hello.asm -o hello.o
ld -m elf_i386 hello.o -o hello
./hello
```

## Usage

The program prints:

```text
Hello
Hello
Hello
Hello
Hello
```

## How It Works

* `eax` is used as a counter
* The program starts with `eax = 0`
* `PRINT "Hello"` prints the text
* `PUTCHAR 10` prints a newline
* `inc eax` increases the counter
* `cmp eax, 5` checks whether the counter reached `5`
* `jl again` repeats the loop while `eax < 5`
* `FINISH` exits the program

The program uses `PRINT`, `PUTCHAR`, and `FINISH` macros provided by `stud_io.inc`.
