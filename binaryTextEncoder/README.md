# Binary Text Encoder

An interactive NASM program that converts English text into 8-bit ASCII
binary and writes the result to `binary.txt`.

The console routines and encoder are compiled into the static library
`libbinary.a`.

## Requirements

- NASM
- GNU binutils (`ld`, `ar`)
- Linux x86 with 32-bit ELF support

On Arch Linux:

```bash
sudo pacman -S nasm binutils
```

## Build and run

```bash
make
./encoder
```

Enter one line of English text. The program creates or overwrites
`binary.txt`.

Example input:

```text
Hi
```

Example file content:

```text
01001000 01101001
```

Each group of eight bits represents one ASCII byte. The program processes
input as bytes; non-ASCII characters are represented by their UTF-8 bytes.

## Files

- `main.asm` - program entry point and user interaction
- `io.asm` - console input/output routines
- `encoder.asm` - byte-to-binary conversion and file writing
- `libbinary.a` - static library built from `io.o` and `encoder.o`
- `Makefile` - build and clean commands

## Clean

```bash
make clean
```
