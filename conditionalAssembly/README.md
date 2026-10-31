# Conditional Assembly

A small NASM project for practicing conditional assembly directives.

## Build and run

```sh
nrun conditional_assembly.asm
```

Enable debug mode:

```sh
nasm -DDEBUG_PRINT -f elf conditional_assembly.asm -o conditional_assembly.o
ld -m elf_i386 conditional_assembly.o -o conditional_assembly
./conditional_assembly
```

Enable the optional message with `-DSHOW_EXTRA`.
Disable the farewell message with `-DNO_FAREWELL`.

## Directives

- `%ifdef` / `%ifndef`: test whether a macro is defined.
- `%if` / `%elif` / `%else` / `%endif`: choose code at assembly time.
- `%warning` / `%error`: display a warning or stop assembly.
