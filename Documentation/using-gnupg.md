# GPU Privacy Guard

## Creating a primary key

In this document I will be running `gpg (GnuPG) 2.3.3` on `AlmaLinux 9.1 (Lime Lynx)`

Starting off with no pre-existing key the following will begin the process

```shell
gpg --expert --full-gen-key
```

Which will have you step through the process of generating a PGP key.

I am using the following options:

- Key Type: ECC and ECC, This is a modern elliptic curve key
- Elliptic Curve: Curve 25519, considered to be pretty secure
- I have set it to not expire