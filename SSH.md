`root` login via SSH is disabled by default since `PermitRootLogin` is set to
`prohibit-password`.

See also: [SSH Config](https://www.man7.org/linux/man-pages/man5/sshd_config.5.html).

To be able to login via SSH as user `root` one needs to deploy an SSH public
key on the sysWORXX device. Login as `root` user on a serial terminal and follow
the steps below to deploy a key on the device:

```sh
# On PC generate an ssh-key using ssh-keygen (or use an already existing key if
# wanted)
# (see also: https://www.man7.org/linux/man-pages/man1/ssh-keygen.1.html)
ssh-keygen
# Open the id_*.pub file and add its contents to clipboard (copy)

# On sysWORXX device create authorized-key files which contains identities (aka
# SSH identities) to login
mkdir ~/.ssh && chmod 700 ~/.ssh
cat > ~/.ssh/authorized_keys
# Paste the public key to the terminal application and quit input with CTRL-D
```
