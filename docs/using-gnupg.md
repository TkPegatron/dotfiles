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

## Creating sub keys

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

## Troubleshooting

In testing various configuration settings I have likely created a variety of race conditions.

At one point I got the error that gpg-agent could not find a file. I purged all non-configuration files from `${GNUPGHOME}` and ran `pkill gpg-agent; strace -o /tmp/gpg-agent.trace gpg-agent --daemon; gpg -K --with-keygrip` which gave me the files I needed.
