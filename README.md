# RV32B-1

To boot a **RISCV64** linux kernel on a **x86** machine.

## Prerequisites

``` bash
sudo apt-get install gcc libc6-dev pkg-config bridge-utils uml-utilities zlib1g-dev libglib2.0-dev autoconf automake libtool libsdl1.2-dev unzip autoconf automake autotools-dev curl libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc
```

## RUN

``` bash
make qemu-new
make qemu-make
make sifive-new
make sifive-make
make run
```

You can skip qemu-new and sifive-new the second time you make. They are needed only once.

Please note that the sifive step downloads lots of packages and takes a considerable amount of time.

After the kernel boots up, the default username and password is `root` and `sifive`.
