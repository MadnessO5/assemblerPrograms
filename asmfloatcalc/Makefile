NASM = nasm
NASMFLAGS = -f elf -g
LD = ld
AR = ar

APP_OBJECTS = calc.o io.o parse_float.o print_float.o
LIB_OBJECTS = add.o subtract.o multiply.o divide.o

.PHONY: all clean

all: prog

%.o: %.asm
	$(NASM) $(NASMFLAGS) $< -o $@

libcalc.a: $(LIB_OBJECTS)
	$(AR) crs $@ $^

prog: $(APP_OBJECTS) libcalc.a
	$(LD) -m elf_i386 $(APP_OBJECTS) libcalc.a -o $@

clean:
	rm -f *.o *.a prog
