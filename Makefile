# Define compiler and flags
NASM=nasm
NASMFLAGS=-f elf32
GCC=gcc
GCCFLAGS=-m32
LD=ld
GCCC=x86_64-elf-gcc
LDC=x86_64-elf-ld
LDFLAGS=-m elf_i386
QEMU=qemu-system-i386

# Define source files
SRCDIR=src
BOOT_ASM=$(SRCDIR)/boot.asm
KERNEL_C=$(SRCDIR)/kernel.c
LINKER_LD=$(SRCDIR)/linker.ld

# Default target
all: kernel
creeper: creeper

# Linking the kernel
kernel: boot.o kernel.o
	$(LD) $(LDFLAGS) -T $(LINKER_LD) -o kernel boot.o kernel.o
	rm -f boot.o kernel.o
	$(QEMU) -kernel kernel

creeper: boot.o kernel.o
	$(NASM) $(NASMFLAGS) $< -o $@
	$(GCCC) $(GCCFLAGS) -c $< -o $@
	$(LDC) $(LDFLAGS) -T $(LINKER_LD) -o kernel boot.o kernel.o
	rm -f boot.o kernel.o
	$(QEMU) -kernel kernel

# Assembling boot.asm
boot.o: $(BOOT_ASM)
	$(NASM) $(NASMFLAGS) $< -o $@

# Compiling kernel.c
kernel.o: $(KERNEL_C)
	$(GCC) $(GCCFLAGS) -c $< -o $@
