# Guess the Number

Interactive NASM game for Linux i386. Choose a minimum and maximum
value, then guess the randomly selected number.

## Build

```bash
make
```

## Run

```bash
./guess
```

## Files

- `main.asm` - game loop and range selection
- `io.asm` - input/output routines
- `random.asm` - pseudo-random number routine
- `libgame.a` - static library with `io.o` and `random.o`
- `Makefile` - build instructions

## Clean

```bash
make clean
```

The `RDTSC`-based random routine is for this learning game only,
not for security-sensitive use.
