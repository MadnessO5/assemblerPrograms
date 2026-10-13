# Fill Memory

A simple NASM assembly program that fills a memory buffer with a character.

## Requirements

- NASM
- GNU Linker (`ld`)
- `stud_io.inc`

## Build & Run

```bash
nasm -f elf fill_memory.asm -o fill_memory.o
ld -m elf_i386 fill_memory.o -o fill_memory
./fill_memory
```

## Example Output

```text
Filled memory: @@@@@@@@@@@@@@@@@@@@
```

## How It Works

- `EDI` stores the buffer address.
- `ECX` stores the number of bytes to fill.
- `AL` contains the character to write.
- `call` calls the `fill_memory` subroutine.
- `ret` returns to the caller.

**Note:** The buffer size must be at least as large as the number of bytes being written. For example, if `ECX` is `50`, reserve at least `50` bytes using `buffer resb 50`.
