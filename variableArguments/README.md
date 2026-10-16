# Variable Arguments

A simple NASM assembly program that sums a variable number of integers passed through the stack.

## Requirements

- NASM
- GNU Linker (`ld`)
- `stud_io.inc`

## Build & Run

```bash
nasm -f elf variable_arguments.asm -o variable_arguments.o
ld -m elf_i386 variable_arguments.o -o variable_arguments
./variable_arguments
```

## Example Output

```text
Sum: 60
```

## How It Works

- The first argument specifies the number of integers.
- The integers are passed through the stack in reverse order.
- `EBP` is used to access the arguments.
- `ECX` counts the integers.
- `EAX` stores the sum.
- The caller cleans up the stack after the function returns.
