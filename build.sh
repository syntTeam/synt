nasm -f elf32 src/boot.asm -o boot.o
clang --target=i386-unknown-linux-gnu -c src/kernel.c -o kernel.o
x86_64-elf-ld -m elf_i386 -T src/linker.ld -o kernel.bin boot.o kernel.o
rm -f boot.o kernel.o
mkdir -p isodir/boot/grub
mv kernel.bin isodir/boot/
cp grub.cfg isodir/boot/grub/grub.cfg
grub-mkrescue -o synt.iso isodir
rm -rf isodir
qemu-system-i386 -hda synt.iso