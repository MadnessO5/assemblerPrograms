NASM = nasm
CC = gcc
AR = ar

NASMFLAGS = -f elf64 -g -F dwarf
CFLAGS = -O2 -Wall -Wextra -fPIC
LDFLAGS = -no-pie

.PHONY: all clean

all: textEncryptor

main.o: main.asm
	$(NASM) $(NASMFLAGS) main.asm -o main.o

crypto.o: crypto.c
	$(CC) $(CFLAGS) -c crypto.c -o crypto.o

libcrypto_wrap.a: crypto.o
	$(AR) crs libcrypto_wrap.a crypto.o

textEncryptor: main.o libcrypto_wrap.a
	$(CC) $(LDFLAGS) main.o -L. -lcrypto_wrap -lcrypto -o textEncryptor

clean:
	rm -f *.o *.a textEncryptor
