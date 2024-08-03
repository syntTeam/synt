# Build "limine" utility.
# git submodule update
# make -C limine


x86_64-elf-gcc -ffreestanding -I "limine" -c src/kernel/main.c -o out/kernel.o
if [ $? -ne 0 ]; then
    echo "Kernel compilation failed!"
    exit 1
fi

# Link the kernel
x86_64-elf-ld -o out/kernel.bin -T src/linker.ld out/kernel.o
if [ $? -ne 0 ]; then
    echo "Kernel linking failed!"
    exit 1
fi

echo "Build successful!"

cd out

# Create a directory which will be our ISO root.
rm -rf iso_root && mkdir -p iso_root

# Copy the relevant files over.
mkdir -p iso_root/boot
cp -v kernel.bin iso_root/boot/parallel
mkdir -p iso_root/boot/limine
cp -v ../src/limine.cfg ../limine/limine-bios.sys ../limine/limine-bios-cd.bin \
      ../limine/limine-uefi-cd.bin iso_root/boot/limine/

# Create the EFI boot tree and copy Limine's EFI executables over.
mkdir -p iso_root/EFI/BOOT
cp -v ../limine/BOOTX64.EFI iso_root/EFI/BOOT/
cp -v ../limine/BOOTIA32.EFI iso_root/EFI/BOOT/

cd ..

# Create the bootable ISO.
xorriso -as mkisofs -b boot/limine/limine-bios-cd.bin \
        -no-emul-boot -boot-load-size 4 -boot-info-table \
        --efi-boot boot/limine/limine-uefi-cd.bin \
        -efi-boot-part --efi-boot-image --protective-msdos-label \
        out/iso_root -o synt.iso

# Install Limine stage 1 and 2 for legacy BIOS boot.
./limine/limine bios-install synt.iso

qemu-system-x86_64 -cdrom synt.iso