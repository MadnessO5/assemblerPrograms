# Interactive asmMemoryTool

An interactive NASM memory-buffer utility for 32-bit Linux.

## Build and run

From this directory:

```sh
nrun asm_memory_tool.asm
```

Or manually:

```sh
nasm -f elf asm_memory_tool.asm -o asm_memory_tool.o
ld -m elf_i386 asm_memory_tool.o -o asm_memory_tool
./asm_memory_tool
```

## Menu

- `1`: Fill buffer A with a decimal byte value from 0 to 255.
- `2`: Zero buffer A.
- `3`: Copy buffer A to buffer B.
- `4`: Show both buffers in hexadecimal.
- `5`: Compare the buffers.
- `0`: Exit.

The program uses Linux 32-bit system calls (`int 0x80`).
