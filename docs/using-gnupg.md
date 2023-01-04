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

## Listing keys

`gpg -K --with-keygrip`

## Using gpg-agent as an ssh-agent

`gpg --edit-key "${KEY_ID}"`

GPG will step you through the available options.

For the purposes of authenticating to SSH servers, I created both an RSA and an Ed25519 key with only the authentication ability.

In the case of ssh authentication, you will also need to add the authentication keygrip to `${GNUPGHOME}/sshcontrol`. This can be done by running `echo "${SSH_KEYGRIP}" >> "${GNUPGHOME}/sshcontrol"`. If you use two of them as I am here, you will need to do this for both types.

NOTE: It appears that the config is read sequentially and I certainly prefer Ed25519 keys over RSA, make sure the preferred key is first in sshcontrol

You can then verify the configuration with `ssh-add -L` to show all the keys present in the agent.

For SSH, the following lines need to be present in your shell's run control:

```none
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent
```

If you arent using the agent 

## Changing the private key password

The password I used to secure the private key initially was not strong enough outside testing.

`gpg --edit-key "${KEY_ID}"`

```none
gpg> passwd
gpg> save
```

## Exporting Keys

### Public Key

This command will export an ascii armored version of the public key:

`gpg --output public.pgp --armor --export username@email`

### Private Key

This command will export an ascii armored version of the secret key:

`gpg --output private.pgp --armor --export-secret-key username@email`

If you also want to include the key(s), user attributes, signatures (including local signatures), and ownertrust values. Everything required to completely restore the key(s) and trust database as they currently exist in your gnupg directory.

`gpg --output private.pgp --armor --export-secret-keys --export-options export-backup user@email`

## Additional Notes

If this key is important to you, I recommend printing out the key on paper using [paperkey](https://www.jabberwocky.com/software/paperkey/).  And placing the paper key in a fireproof/waterproof safe.

In general, it's not advisable to post personal public keys to key servers.  There is no method of removing a key once it's posted and there is no method of ensuring that the key on the server was placed there by the supposed owner of the key.

It is much better to place your public key on a website that you own or control.  Some people recommend [keybase.io](https://keybase.io/) for distribution.  However, that method tracks participation in various social and technical communities which may not be desirable for some use cases.

For the technically adept, I personally recommend trying out the [webkey](https://www.gnupg.org/blog/20160830-web-key-service.html) domain level key discovery service.

## Troubleshooting

In testing various configuration settings I have likely created a variety of race conditions.

At one point I got the error that gpg-agent could not find a file. I purged all non-configuration files from `${GNUPGHOME}` and ran `pkill gpg-agent; strace -o /tmp/gpg-agent.trace gpg-agent --daemon; gpg -K --with-keygrip` which gave me the files I needed.

If the agent is refusing ssh: `gpg-agent --daemon`


you can test with: `ssh -vT git@github.com`

```bash
gpg --import elliana-perry.gpg-private.asc

cat <<EOF | tee -a "${GNUPGHOME}/sshcontrol"
ED2EDC2C8563ABB9404C5877DB56182523676CD1
420F1135CC6DA2519C39DFB6C2A05B70B83FE16F
EOF
```
