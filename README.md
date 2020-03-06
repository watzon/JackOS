# JackOS

I've been on a bit of a kernel kick lately, so I decided I'd try and get a Nim kernel going. This project is thanks to Dom's work on [nimkernel](https://github.com/dom96/nimkernel) several years ago. It's been updated to work with the latest version of Nim, includes a Makefile that does all the heavy lifting for you, and (currently) works exactly as the original project did.

![](http://picheta.me/private/images/nimkernel2.png)

## Setup

You will need:

- GCC
- grub
- xorriso
- A GCC cross compiler for i686 (i.e. `i686-elf-gcc`)
- A GCC assembler for i686 (i.e. `i686-elf-as`)
- QEMU (for running the kernel)
- Nim 1.0.6 or later
- rename-perl (some machines come with this, and some with gnu rename)

## Building

These instructions are based off of my experience compiling on Arch linux, your milage may vary. First install the dependencies. `i686-elf-gcc` is very important. `rename-perl` is also required to rename the cached files before they get linked. This was primarily to make linking easier.

Clone this project and cd into the cloned directory. If your system is configured correctly, you should be able to build the kernel using `make build`. `make run` will then launch the kernel with `QEMU`.