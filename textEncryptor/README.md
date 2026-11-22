# TextEncryptor

Interactive 64-bit NASM program for encrypting text and files with AES-256-GCM
through OpenSSL.

## Features

- Encrypt typed text into an encrypted file.
- Encrypt an existing file.
- Decrypt a previously encrypted file.
- Detect wrong passwords and modified encrypted data.
- Derive a 256-bit key with PBKDF2-HMAC-SHA256.
- Generate a fresh random salt and nonce for every encryption.

## Requirements (Arch Linux)

```bash
sudo pacman -S nasm gcc binutils openssl
```

## Build and run

```bash
make
./textEncryptor
```

Menu:
1. Encrypt text
2. Decrypt file
3. Encrypt file
4. Exit

Use a different output filename when decrypting so the encrypted input is
not overwritten. The program reads files into memory, so use reasonably
sized files.

## Project files

- `main.asm` - 64-bit NASM menu and user interaction.
- `crypto.c` - OpenSSL encryption, decryption, and file handling.
- `libcrypto_wrap.a` - static library containing the crypto wrapper.
- `Makefile` - build and clean rules.

The NASM front end calls the C wrapper using the Linux x86-64 System V ABI.
OpenSSL supplies the AES-256-GCM implementation.

## Security notes

- Use a long, unique password.
- If the password is lost, the encrypted file cannot be recovered.
- Password input is visible in the terminal.
- Keep a separate backup of important originals.
- This is an educational project, not a replacement for a reviewed backup
  or encryption application.
