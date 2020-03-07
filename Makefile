CC = i686-elf-gcc
ASMC = i686-elf-as
OUTFILE = jackos-x86.bin
BUILDDIR = build

# Add files here as they're created. test.nim becomes test.o.
# Standard library imports will need to be added here too as
# stdlib_[name].o
OBJECT_FILES = \
	$(BUILDDIR)/boot.o \
	$(BUILDDIR)/main.o \
	$(BUILDDIR)/stdlib_system.o \
	$(BUILDDIR)/tty.o \
	# $(BUILDDIR)/io.o

clean:
	-rm *.bin
	-rm *.iso
	-rm -rf build
	-rm -rf iso

main.nim:
	nim c -d:release kernel/$@

boot.s:
	$(ASMC) kernel/boot.s -o $(BUILDDIR)/boot.o

rename:
	-perl-rename 's/\@m(.*)\.nim\.c\.o$$/$$1\.o/g' $(BUILDDIR)/*.nim.c.o
	-perl-rename 's/(.*)\.nim\.c\.o$$/$$1\.o/g' $(BUILDDIR)/*.nim.c.o

link:
	$(CC) -T kernel/linker.ld -o jackos.bin -ffreestanding -O2 -nostdlib $(OBJECT_FILES)

iso:
	mkdir -p iso/boot/grub
	mv jackos.bin iso/boot/
	cp grub/grub.cfg iso/boot/grub
	grub-mkrescue -o jackos.iso iso

build: main.nim boot.s rename link iso

run:
	qemu-system-x86_64 -cdrom jackos.iso
