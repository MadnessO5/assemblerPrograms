NASM = nasm
NASMFLAGS = -f elf -dOS_LINUX -g
LD = ld

SOURCES = calc.asm read_uint.asm parse_uint.asm print_int.asm operations.asm \
          strlen.asm putstr.asm getstr.asm quit.asm
OBJECTS = $(SOURCES:.asm=.o)

.PHONY: all clean
all: prog

%.o: %.asm
	$(NASM) $(NASMFLAGS) $< -o $@

prog: $(OBJECTS)
	$(LD) -m elf_i386 $^ -o $@

clean:
	rm -f $(OBJECTS) prog a.out core
