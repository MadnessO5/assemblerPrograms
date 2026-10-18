# Pattern Matching

A NASM assembly program that matches a null-terminated string against a pattern.

## Requirements

- NASM
- GNU Linker (`ld`)
- `stud_io.inc`

## Build & Run

```bash
nasm -f elf pattern_matching.asm -o pattern_matching.o
ld -m elf_i386 pattern_matching.o -o pattern_matching
./pattern_matching
```

## Example Output

```text
Match: 1
```

## Pattern Rules

- `?` matches exactly one character.
- `*` matches any sequence of characters, including an empty sequence.
- Other characters must match exactly.
- The entire string must match the pattern.

## How It Works

- `ESI` points to the string.
- `EDI` points to the pattern.
- `EBP` provides access to parameters and a local variable.
- `match` calls itself recursively when it encounters `*`.
- `EAX` returns `1` for a match or `0` otherwise.
- The caller removes the two parameters from the stack.
