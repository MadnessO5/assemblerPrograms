# Local Labels

A simple NASM assembly program demonstrating local labels in different procedures.

## Requirements

- NASM
- GNU Linker (`ld`)
- `stud_io.inc`

## Build & Run

```bash
nasm -f elf local_labels.asm -o local_labels.o
ld -m elf_i386 local_labels.o -o local_labels
./local_labels
```

## Example Output

```text
AAA
BB
```

## How It Works

- `first_proc` prints `A` three times.
- `second_proc` prints `B` two times.
- `.cycle` is a local label in each procedure.
- Each local label belongs to the nearest preceding non-local label.
- `loop .cycle` repeats the loop until `ECX` reaches zero.
