# Stack String Reverse

A simple NASM assembly program that reverses a string using the stack.

## Requirements

- NASM
- GNU Linker (`ld`)
- `stud_io.inc`

## Build & Run

```bash
nasm -f elf stack_string_reverse.asm -o stack_string_reverse.o
ld -m elf_i386 stack_string_reverse.o -o stack_string_reverse
./stack_string_reverse
```

## Usage

Enter a string and press Enter.

Example:

```text
Enter a string: hello
olleh
```

## How It Works

- `push` stores each character on the stack.
- `pop` retrieves characters in reverse order.
- `ECX` counts the characters.
- `loop` repeats the output process until all characters are printed.
