# Building from source
```bash
sudo ./configure --with-libedit --with-kerberos5 --with-ssl-dir=/home/phaedrus/Forge/GH/openssl --with-pam --with-osf-sia --with-selinux --with-ldns --with-solaris-process-contract --with-solaris-project --with-solaris-privilege --with-bsd-auth
```
# Generating an SSH key
```bash
ssh-keygen -t ed25519 -f "your file path on your computer. Mine is to the right as an example" | ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519
```
