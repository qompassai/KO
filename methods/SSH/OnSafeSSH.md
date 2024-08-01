# Using OpenSSH safely


- The sshd service needs to be restarted after upgrading to openssh-9.8p1
Mon, 01 Jul 2024 16:40:26 +0000

After upgrading to `openssh-9.8p1`, the existing SSH daemon will be unable to accept
new connections (see
<https://gitlab.archlinux.org/archlinux/packaging/packages/openssh/-/issues/5>).  
When upgrading remote hosts, please make sure to restart the sshd service using

```bash
`systemctl try-restart sshd` right after upgrading.
```
Current core developers on the project are evaluating the possibility to automatically apply a restart of the sshd
service on upgrade in a future release of the openssh-9.8p1 package.

