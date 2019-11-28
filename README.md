# Linux Process Isolation Check

Checks various aspects relating to isolation of a running process.

Name of the script from the concept of a 'syscall gate'.

Inspired by https://michielkalkman.com/posts/isolation-modeling-001/

Usage
---

With a PID:

    ./scallgate.sh 92017

or pgrep for a process

    ./scallgate.sh $(pgrep dockerd)

Example
---

```
$ ./scallgate.sh $(pgrep dockerd)
=== SYSTEM ===
ACTIVE LSM MODULES:     capability,yama,selinux
SELINUX:                DISABLED
AppArmor:               NOT PRESENT

=== PROCESS 92017 ===
PROCESS UID:            0
PROCESS GID:            0
SECCOMP:                DISABLED
SELINUX CONTEXT:        -

Capabilities for `92017': = cap_chown,cap_dac_override,cap_dac_read_search,cap_fowner,cap_fsetid,cap_kill,cap_setgid,cap_setuid,cap_setpcap,cap_linux_immutable,cap_net_bind_service,cap_net_broadcast,cap_net_admin,cap_net_raw,cap_ipc_lock,cap_ipc_owner,cap_sys_module,cap_sys_rawio,cap_sys_chroot,cap_sys_ptrace,cap_sys_pacct,cap_sys_admin,cap_sys_boot,cap_sys_nice,cap_sys_resource,cap_sys_time,cap_sys_tty_config,cap_mknod,cap_lease,cap_audit_write,cap_audit_control,cap_setfcap,cap_mac_override,cap_mac_admin,cap_syslog,cap_wake_alarm,cap_block_suspend,cap_audit_read+ep
```

Contributing
---

Run tests with [shellcheck](https://github.com/koalaman/shellcheck):

    make test
