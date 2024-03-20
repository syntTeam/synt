nasm -f elf32 src/boot.asm -o boot.o
clang --target=i386-unknown-linux-gnu -c src/kernel.c -o kernel.o
x86_64-elf-ld -m elf_i386 -T src/linker.ld -o kernel boot.o kernel.o
rm -f boot.o kernel.o
qemu-system-i386 -kernel kernel