#include <openssl/evp.h>
#include <openssl/rand.h>
#include <openssl/crypto.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

#define SALT_LEN 16
#define NONCE_LEN 12
#define TAG_LEN 16
#define KEY_LEN 32
#define ITERATIONS 300000
#define HEADER_LEN (5 + SALT_LEN + NONCE_LEN)

static const unsigned char magic[5] = {'T','E','N','C','1'};

static int read_file(const char *path, unsigned char **data, size_t *len) {
    FILE *f = fopen(path, "rb");
    long size;
    unsigned char *buf;
    if (!f) return 0;
    if (fseek(f, 0, SEEK_END) != 0 || (size = ftell(f)) < 0 ||
        fseek(f, 0, SEEK_SET) != 0) {
        fclose(f);
        return 0;
    }
    buf = malloc(size ? (size_t)size : 1);
    if (!buf) { fclose(f); return 0; }
    if (size && fread(buf, 1, (size_t)size, f) != (size_t)size) {
        free(buf); fclose(f); return 0;
    }
    fclose(f);
    *data = buf;
    *len = (size_t)size;
    return 1;
}

static int write_file(const char *path, const unsigned char *data, size_t len) {
    FILE *f = fopen(path, "wb");
    int ok;
    if (!f) return 0;
    ok = (len == 0 || fwrite(data, 1, len, f) == len);
    if (fclose(f) != 0) ok = 0;
    return ok;
}

static int derive_key(const char *password, const unsigned char *salt,
                      unsigned char *key) {
    return PKCS5_PBKDF2_HMAC(password, (int)strlen(password), salt,
                             SALT_LEN, ITERATIONS, EVP_sha256(),
                             KEY_LEN, key) == 1;
}

int encrypt_buffer_to_file(const unsigned char *plain, size_t plain_len,
                           const char *password, const char *out_path) {
    unsigned char salt[SALT_LEN], nonce[NONCE_LEN], key[KEY_LEN], tag[TAG_LEN];
    unsigned char *out = NULL;
    EVP_CIPHER_CTX *ctx = NULL;
    int n = 0, total = 0, ok = 0;
    size_t out_len = 0;

    if (!plain || !password || !out_path || plain_len > INT32_MAX) return -1;
    if (RAND_bytes(salt, sizeof salt) != 1 ||
        RAND_bytes(nonce, sizeof nonce) != 1 ||
        !derive_key(password, salt, key)) goto done;

    out_len = HEADER_LEN + plain_len + TAG_LEN;
    out = malloc(out_len ? out_len : 1);
    if (!out) goto done;
    memcpy(out, magic, 5);
    memcpy(out + 5, salt, SALT_LEN);
    memcpy(out + 5 + SALT_LEN, nonce, NONCE_LEN);

    ctx = EVP_CIPHER_CTX_new();
    if (!ctx) goto done;
    if (EVP_EncryptInit_ex(ctx, EVP_aes_256_gcm(), NULL, NULL, NULL) != 1 ||
        EVP_CIPHER_CTX_ctrl(ctx, EVP_CTRL_GCM_SET_IVLEN, NONCE_LEN, NULL) != 1 ||
        EVP_EncryptInit_ex(ctx, NULL, NULL, key, nonce) != 1 ||
        EVP_EncryptUpdate(ctx, out + HEADER_LEN, &n, plain, (int)plain_len) != 1)
        goto done;
    total = n;
    if (EVP_EncryptFinal_ex(ctx, out + HEADER_LEN + total, &n) != 1) goto done;
    total += n;
    if (EVP_CIPHER_CTX_ctrl(ctx, EVP_CTRL_GCM_GET_TAG, TAG_LEN, tag) != 1)
        goto done;
    memcpy(out + HEADER_LEN + total, tag, TAG_LEN);
    ok = write_file(out_path, out, HEADER_LEN + (size_t)total + TAG_LEN);

done:
    EVP_CIPHER_CTX_free(ctx);
    if (out) { OPENSSL_cleanse(out, out_len); free(out); }
    OPENSSL_cleanse(key, sizeof key);
    return ok ? 0 : -1;
}

int encrypt_file_to_file(const char *in_path, const char *password,
                         const char *out_path) {
    unsigned char *plain = NULL;
    size_t len = 0;
    int result;
    if (!read_file(in_path, &plain, &len)) return -1;
    result = encrypt_buffer_to_file(plain, len, password, out_path);
    OPENSSL_cleanse(plain, len);
    free(plain);
    return result;
}

int decrypt_file_to_file(const char *in_path, const char *password,
                         const char *out_path) {
    unsigned char *in = NULL, *plain = NULL;
    size_t in_len = 0, cipher_len = 0;
    unsigned char key[KEY_LEN] = {0};
    EVP_CIPHER_CTX *ctx = NULL;
    int n = 0, total = 0, ok = 0;

    if (!password || !read_file(in_path, &in, &in_len)) return -1;
    if (in_len < HEADER_LEN + TAG_LEN || memcmp(in, magic, 5) != 0)
        goto done;
    cipher_len = in_len - HEADER_LEN - TAG_LEN;
    if (cipher_len > INT32_MAX) goto done;

    if (!derive_key(password, in + 5, key)) goto done;
    plain = malloc(cipher_len ? cipher_len : 1);
    if (!plain) goto done;

    ctx = EVP_CIPHER_CTX_new();
    if (!ctx) goto done;
    if (EVP_DecryptInit_ex(ctx, EVP_aes_256_gcm(), NULL, NULL, NULL) != 1 ||
        EVP_CIPHER_CTX_ctrl(ctx, EVP_CTRL_GCM_SET_IVLEN, NONCE_LEN, NULL) != 1 ||
        EVP_DecryptInit_ex(ctx, NULL, NULL, key, in + 5 + SALT_LEN) != 1 ||
        EVP_DecryptUpdate(ctx, plain, &n, in + HEADER_LEN, (int)cipher_len) != 1)
        goto done;
    total = n;
    if (EVP_CIPHER_CTX_ctrl(ctx, EVP_CTRL_GCM_SET_TAG, TAG_LEN,
                            in + HEADER_LEN + cipher_len) != 1)
        goto done;
    if (EVP_DecryptFinal_ex(ctx, plain + total, &n) != 1) goto done;
    total += n;
    ok = write_file(out_path, plain, (size_t)total);

done:
    EVP_CIPHER_CTX_free(ctx);
    if (plain) { OPENSSL_cleanse(plain, cipher_len); free(plain); }
    free(in);
    OPENSSL_cleanse(key, sizeof key);
    return ok ? 0 : -1;
}
