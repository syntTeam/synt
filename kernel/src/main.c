#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>
#include <limine.h>

static void hcf(void) {
    for (;;) {
#if defined (__x86_64__)
        asm ("hlt");
#elif defined (__aarch64__) || defined (__riscv)
        asm ("wfi");
#endif
    }
}

void _start(void) {
    hcf();
}
