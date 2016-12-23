DIR_TOP := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
DIR_TOP := $(DIR_TOP:/=)

DIR_QEMU := $(DIR_TOP)/riscv-qemu
DIR_SIFIVE := $(DIR_TOP)/freedom-u-sdk

REPO_QEMU := https://github.com/riscv/riscv-qemu
REPO_SIFIVE := https://github.com/sifive/freedom-u-sdk


.PHONY: all, qemu-new, qemu-make, sifive-new, sifive-make, run

all:
	@echo
	@echo "Run the following commands in order:"
	@echo "make qemu-new"
	@echo "make qemu-make"
	@echo "make sifive-new"
	@echo "make sifive-make"
	@echo "make run"
	@echo
	@echo "You can skip qemu-new and sifive-new the second time you make. They are needed only once."

qemu-new:
	@echo "Removing old qemu repo..."
	@rm -rf $(DIR_QEMU)
	@echo "Fetching qemu..."
	@git clone $(REPO_QEMU)
	@cd $(DIR_QEMU); \
		git reset --hard fe43ef4; \
		git fetch origin pull/46/head:working; \
		git checkout working; \
		git submodule update --init pixman;\
		git apply $(DIR_TOP)/qemu.patch
	
qemu-make:
	@echo "Configuring qemu..."
	@cd $(DIR_QEMU); ./configure --target-list=riscv64-softmmu --disable-werror
	@echo "Building qemu..."
	@cd $(DIR_QEMU); make -j4

sifive-new:
	@echo "Removing old sifive repo..."
	@rm -rf $(DIR_SIFIVE)
	@echo "Fetching sifive..."
	@git clone $(REPO_SIFIVE)
	@cd $(DIR_SIFIVE); \
		git reset --hard 5d38ed5d; \
		git submodule update --init --recursive; \
		git apply $(DIR_TOP)/sifive.patch
	@cd $(DIR_SIFIVE)/riscv-pk; \
		git apply $(DIR_TOP)/pk.patch
	
sifive-make:
	@echo "Building..."
	@cd $(DIR_SIFIVE); \
		make -j4

run:
	@$(DIR_QEMU)/riscv64-softmmu/qemu-system-riscv64 -kernel $(DIR_SIFIVE)/work/riscv-pk/bbl -nographic
