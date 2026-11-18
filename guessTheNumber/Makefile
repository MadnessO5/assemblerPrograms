NASM = nasm
NASMFLAGS = -f elf
LD = ld
AR = ar

all: guess

%.o: %.asm
	$(NASM) $(NASMFLAGS) $< -o $@

libgame.a: io.o random.o
	$(AR) crs $@ $^

guess: main.o libgame.a
	$(LD) -m elf_i386 main.o libgame.a -o $@

clean:
	rm -f *.o *.a guess

.PHONY: all clean
