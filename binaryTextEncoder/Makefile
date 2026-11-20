NASM = nasm
LD = ld
AR = ar
NASMFLAGS = -f elf
LDFLAGS = -m elf_i386

.PHONY: all clean
all: encoder

io.o: io.asm
	$(NASM) $(NASMFLAGS) io.asm -o io.o

encoder.o: encoder.asm
	$(NASM) $(NASMFLAGS) encoder.asm -o encoder.o

libbinary.a: io.o encoder.o
	$(AR) crs libbinary.a io.o encoder.o

main.o: main.asm
	$(NASM) $(NASMFLAGS) main.asm -o main.o

encoder: main.o libbinary.a
	$(LD) $(LDFLAGS) main.o libbinary.a -o encoder

clean:
	rm -f *.o *.a encoder binary.txt
