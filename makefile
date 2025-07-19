# Variables
CC = x86_64-elf-gcc
LD = x86_64-elf-ld
CFLAGS = -ffreestanding -I "limine" -I "include"
LDFLAGS = -T src/linker.ld
OUT_DIR = out
ISO_DIR = out/iso_root
ISO_FILE = synt.iso
KERNEL_BIN = $(OUT_DIR)/kernel.bin
KERNEL_OBJ = $(OUT_DIR)/synt.elf
SOURCE_DIR = src
LIMINE_DIR = limine

# Targets
.PHONY: all build run clean

all: clean build run

build: $(ISO_FILE)

$(ISO_FILE): $(KERNEL_BIN)
	@echo "Creating ISO..."
	rm -rf $(ISO_DIR) && mkdir -p $(ISO_DIR)/boot
	cp -v $(KERNEL_BIN) $(ISO_DIR)/boot/synt.elf
	mkdir -p $(ISO_DIR)/boot/limine
	cp -v $(SOURCE_DIR)/limine.cfg $(LIMINE_DIR)/limine-bios.sys \
	      $(LIMINE_DIR)/limine-bios-cd.bin $(LIMINE_DIR)/limine-uefi-cd.bin \
	      $(ISO_DIR)/boot/limine/
	mkdir -p $(ISO_DIR)/EFI/BOOT
	cp -v $(LIMINE_DIR)/BOOTX64.EFI $(ISO_DIR)/EFI/BOOT/
	cp -v $(LIMINE_DIR)/BOOTIA32.EFI $(ISO_DIR)/EFI/BOOT/
	xorriso -as mkisofs -b boot/limine/limine-bios-cd.bin \
	        -no-emul-boot -boot-load-size 4 -boot-info-table \
	        --efi-boot boot/limine/limine-uefi-cd.bin \
	        -efi-boot-part --efi-boot-image --protective-msdos-label \
	        $(ISO_DIR) -o $(ISO_FILE)


$(KERNEL_BIN): $(KERNEL_OBJ)
	$(LD) -o $(KERNEL_BIN) $(LDFLAGS) $(KERNEL_OBJ)

$(KERNEL_OBJ): src/kernel/main.c
	@mkdir -p $(OUT_DIR)
	$(CC) $(CFLAGS) -c src/kernel/main.c -o $(KERNEL_OBJ)

run: $(ISO_FILE)
	@echo "Running ISO with QEMU..."
	qemu-system-x86_64 -cdrom $(ISO_FILE)

clean:
	@echo "Cleaning up..."
	rm -rf $(OUT_DIR) $(ISO_DIR) $(ISO_FILE)
