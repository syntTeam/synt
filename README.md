# synt

Welcome to **synt**, the one for you.

## Overview

**synt** is a modern operating system written in C.

## Current Status

### Progress

- **Currently Being Implemented:**
  - [ ] IDT (Interrupt Descriptor Table)
  - [ ] GDT (Global Descriptor Table)
  - [ ] Terminal/CLI/Shell
  - [ ] Basic Keyboard Input

- **Planned Features:**
  - [ ] GUI (Graphical User Interface)
  - [ ] User Applications
  - [ ] Functional File System and OS Installer
  - [ ] Usermode Support

## Building

To build **synt**, you'll need to set up your development environment and follow these steps:

### Prerequisites

1. **Toolchain:**
   - `x86_64-elf-gcc` (or a compatible cross-compiler)
   - `make` (or another build tool)

### Build Instructions

1. **Build the project:**
   - Run `make clean`
   - Then, run `make build`

2. **Testing:**
   - Type `make run` to run the built ISO in qemu.