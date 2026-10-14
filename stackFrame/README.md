# Stack Frame

A simple NASM assembly program demonstrating stack frames, parameters, and local variables.

## Requirements

- NASM
- GNU Linker (`ld`)
- `stud_io.inc`

## Build & Run

```bash
nasm -f elf stack_frame.asm -o stack_frame.o
ld -m elf_i386 stack_frame.o -o stack_frame
./stack_frame
```

## Example Output

```text
10 + 20 = 30
```

## How It Works

- `push` passes parameters through the stack.
- `call` calls the `add_numbers` subroutine.
- `push ebp` saves the old base pointer.
- `mov ebp, esp` creates a stack frame.
- `[ebp+8]` and `[ebp+12]` access the parameters.
- `[ebp-4]` accesses a local variable.
- `mov esp, ebp` and `pop ebp` restore the stack frame.
- `ret` returns to the caller.
