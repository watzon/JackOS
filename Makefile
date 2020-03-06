CC = i686-elf-gcc
ASMC = i686-elf-as
OUTFILE = jackos-x86.bin

# Add files here as they're created. test.nim becomes test.o.
# Standard library imports will need to be added here too as
# stdlib_[name].o
OBJECT_FILES = \
	build/boot.o \
	build/main.o \
	build/stdlib_system.o \
	build/ioutils.o

clean:
	-rm main.bin
	-rm -rf build

main.nim:
	nim c -d:release kernel/$@

boot.s:
	$(ASMC) kernel/boot.s -o build/boot.o

rename:
	-perl-rename 's/\@m(.*)\.nim\.c\.o$$/$$1\.o/g' build/*.nim.c.o
	-perl-rename 's/(.*)\.nim\.c\.o$$/$$1\.o/g' build/*.nim.c.o

link:
	$(CC) -T kernel/linker.ld -o main.bin -ffreestanding -O2 -nostdlib $(OBJECT_FILES)

build: main.nim boot.s rename link

run:
	qemu-system-x86_64 -kernel main.bin