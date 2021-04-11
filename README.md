pwnbox
===

A docker environment for pwn ctf challenges or exploit dev based on **phusion/baseimage:18.04-1.0.0-amd64**

### Usage

```bash
git clone https://github.com/d3Xm/pwnbox
cd pwnbox
docker build -t pwnbox .
docker run -d --rm -v /home/kali/shares/:/shares -p 23946:23946 --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -i pwnbox
docker exec -it [pwnbox_container_ID] /bin/bash
```

### included software

- [pwntools](https://github.com/Gallopsled/pwntools)  —— CTF framework and exploit development library
- [pwngdb](https://github.com/scwuaptx/Pwngdb) —— gdb for pwn
- [gdb-peda](https://github.com/longld/peda) —— PEDA - Python Exploit Development Assistance for GDB
- [gdb-peda-intel] ——
- [gdb-peda-arm](https://github.com/alset0326/peda-arm) —— PEDA-ARM - Python Exploit Development Assistance for GDB
- [gdb-pwndbg](https://github.com/pwndbg/pwndbg)  —— a GDB plug-in that makes debugging with GDB suck less, with a focus on features needed by low-level software developers, hardware hackers, reverse-engineers and exploit developers
- [gdb-gef](https://github.com/hugsy/gef) —— is a set of commands for x86/64, ARM, MIPS, PowerPC and SPARC to assist exploit developers and reverse-engineers when using old school GDB
- [ROPgadget](https://github.com/JonathanSalwan/ROPgadget)  —— facilitate ROP exploitation tool
- [roputils](https://github.com/inaz2/roputils)     —— A Return-oriented Programming toolkit
- [one_gadget](https://github.com/david942j/one_gadget) —— A searching one-gadget of execve('/bin/sh', NULL, NULL) tool for amd64 and i386
- [angr](https://github.com/angr/angr)   ——  A platform-agnostic binary analysis framework
- [radare2](https://github.com/radare/radare2) ——  A rewrite from scratch of radare in order to provide a set of libraries and tools to work with binary files
- [welpwn](https://github.com/matrix1001/welpwn) —— designed to make pwnning an art, freeing you from dozens of meaningless jobs.
- linux_server[64]     —— IDA 7.0 debug server for linux
- [tmux](https://tmux.github.io/)     —— a terminal multiplexer
- [ltrace](https://linux.die.net/man/1/ltrace)      —— trace library function call
- [strace](https://linux.die.net/man/1/strace)     —— trace system call
- [peda](https://github.com/scwuaptx/peda) -- Python Exploit Development Assistance for GDB
- [socat](http://www.dest-unreach.org/socat/) -- A relay for bidirectional data transfer between two independent data channels.
- [z3](https://github.com/Z3Prover/z3) --  Theorem Prover
- [seccomp-tools](https://github.com/david942j/seccomp-tools) -- Provide powerful tools for seccomp analysis
- [qemu](https://www.qemu.org) -- QEMU is a generic and open source machine emulator and virtualizer.
- [checksec](https://github.com/slimm609/checksec.sh) -- Check the properties of executables (like PIE, RELRO, PaX, Canaries, ASLR, Fortify Source)
.gdbinit
.tmux.conf


### included glibc

Default compiled glibc path is `/glibc`.
- 2.19  —— ubuntu 12.04 default libc version
- 2.23  —— pwndocker default libc version
- 2.24  —— introduce vtable check in file struct
- 2.26  —— https://abi-laboratory.pro/?view=changelog&l=glibc&v=2.26
- 2.27  —— intruduce tcache in heap (since 2.26)
- 2.28  —— new libc version ubuntu19.04
- 2.29  —— new libc version ubuntu19.04
- 2.30  —— new libc version ubuntu19.10
- 2.31  —— new libc version ubuntu20.04


### include multiarch libraries

- arm -- gcc-5-arm-linux-gnueabi
- aarch64 -- gcc-5-aarch64-linux-gnu
- mips -- gcc-5-mips-linux-gnu
- mipsel -- gcc-5-mipsel-linux-gnu 
- mips64 -- gcc-5-mips64-linux-gnuabi64
- mips64el -- gcc-5-mips64el-linux-gnuabi64
- powerpc -- gcc-5-powerpc-linux-gnu
- powerpc64 -- gcc-5-powerpc64-linux-gnu
- powerpc64le -- gcc-5-powerpc64le-linux-gnu

#### How to run in custom libc version?

```shell
cp /glibc/2.27/64/lib/ld-2.27.so /tmp/ld-2.27.so
patchelf --set-interpreter /tmp/ld-2.27.so ./test
LD_PRELOAD=./libc.so.6 ./test
```

or

```python
from pwn import *
p = process(["/path/to/ld.so", "./test"], env={"LD_PRELOAD":"/path/to/libc.so.6"})
```

#### How to run in custom libc version with other lib?
if you want to run binary with glibc version 2.28:

```shell
root@pwn:/ctf/work# ldd /bin/ls
linux-vdso.so.1 (0x00007ffe065d3000)
libselinux.so.1 => /lib/x86_64-linux-gnu/libselinux.so.1 (0x00007f004089e000)
libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f00406ac000)
libpcre2-8.so.0 => /lib/x86_64-linux-gnu/libpcre2-8.so.0 (0x00007f004061c000)
libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x00007f0040616000)
/lib64/ld-linux-x86-64.so.2 (0x00007f00408f8000)

root@pwn:/ctf/work# /glibc/2.28/64/ld-2.28.so /bin/ls
/bin/ls: error while loading shared libraries: libselinux.so.1: cannot open shared object file: No such file or directory
```
You can copy /lib/x86_64-linux-gnu/libselinux.so.1 and /lib/x86_64-linux-gnu/libpcre2-8.so.0 to /glibc/2.28/64/lib/, and sometimes it fails because the built-in libselinux.so.1 requires higher version libc:

```
root@pwn:/ctf/work# /glibc/2.28/64/ld-2.28.so /bin/ls
/bin/ls: /glibc/2.28/64/lib/libc.so.6: version `GLIBC_2.30' not found (required by /glibc/2.28/64/lib/libselinux.so.1)
```

it can be solved by copying libselinux.so.1 from ubuntu 18.04 which glibc version is 2.27 to /glibc/2.28/64/lib:
```
docker run -itd --name u18 ubuntu:18.04 /bin/bash
docker cp -L u18:/lib/x86_64-linux-gnu/libselinux.so.1 .
docker cp -L u18:/lib/x86_64-linux-gnu/libpcre2-8.so.0 .
docker cp libselinux.so.1 pwn:/glibc/2.28/64/lib/
docker cp libpcre2-8.so.0 pwn:/glibc/2.28/64/lib/
```

And now it succeeds:

```
root@pwn:/ctf/work# /glibc/2.28/64/ld-2.28.so /bin/ls -l /
```

### ChangeLog

#### 2021-04-10
based on the work from 0xTac and skysider, changed base image, added checksec, added PS1 to bashrc, removed ZSH, assured correct timezone for SE.
corrected issue with installing pip2, changed entrypoint
