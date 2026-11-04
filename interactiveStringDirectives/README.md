# interactiveStringDirectives

Interactive NASM practice for section 3.5.8: `%strlen` and `%substr`.

## Build and run

```sh
nrun string_directives.asm
```

Or manually:

```sh
nasm -f elf string_directives.asm -o string_directives.o
ld -m elf_i386 string_directives.o -o string_directives
./string_directives
```

Choose one of the predefined strings, then enter a 1-based character
position. The program displays its length, its first two characters, and
the character at the position you selected.

Important: `%strlen` and `%substr` run during NASM preprocessing. They cannot
inspect text typed while the executable is running. This project uses them
on strings known at assembly time, then lets you inspect those strings
interactively at runtime.
