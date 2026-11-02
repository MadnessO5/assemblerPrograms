# asmMemoryTool

A small NASM program demonstrating byte-buffer operations in 32-bit Linux.

## Build and run

From this directory:

```sh
nrun asm_memory_tool.asm
```

Or build manually:

```sh
nasm -f elf asm_memory_tool.asm -o asm_memory_tool.o
ld -m elf_i386 asm_memory_tool.o -o asm_memory_tool
./asm_memory_tool
```

## Utilities demonstrated

- `fill_memory`: fills a buffer with a chosen byte.
- `zero_memory`: sets every byte in a buffer to zero.
- `copy_memory`: copies bytes between non-overlapping buffers.
- `print_hex_bytes`: prints bytes in hexadecimal form.
- `print_text`: a parameterized multi-line macro.
- Local labels such as `.fill_loop` are scoped to their procedure in NASM.
