NASM = nasm
NASMFLAGS = -f elf
LD = ld
AR = ar

APP_OBJECTS = main.o
LIB_OBJECTS = io.o file_stats.o

.PHONY: all clean

all: textstats

%.o: %.asm
	$(NASM) $(NASMFLAGS) $< -o $@

libtext.a: $(LIB_OBJECTS)
	$(AR) crs $@ $^

textstats: $(APP_OBJECTS) libtext.a
	$(LD) -m elf_i386 -o $@ $(APP_OBJECTS) libtext.a

clean:
	rm -f *.o *.a textstats
