# AssemblerPrograms

A collection of simple **x86 Assembly** programs and experiments.

## Requirements

* NASM
* Linux or FreeBSD
* 32-bit support

## Build

Example:

```bash
nasm -f elf32 program.asm -o program.o
ld -m elf_i386 program.o -o program
```

## Contents

The repository contains small Assembly programs for learning and experimenting with:

* Loops
* Registers
* System calls
* Input/output
* Arithmetic
* Bitwise operations
* Assembly macros
* `stud_io.inc`

## Purpose

This repository is mainly for learning **x86 Assembly** and experimenting with low-level programming.
