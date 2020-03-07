{.push stackTrace:off.}

proc cpu_relax*(): void =
    asm "rep; nop"

proc out8*(port: uint16, data: uint8): void =
    asm """
        outb %0, %1
        :
        : "a" (`data`),
          "d" (`port`)
    """

proc in8*(port: uint16): uint8 =
    asm """
        inb %1, %0
        : "=a" (`result`)
        : "d"  (`port`)
    """

proc out16*(port: uint16, data: uint16): void =
    asm """
        outw %0, %1
        :
        : "a"  (`data`),
          "dN" (`port`)
    """

proc in16*(port: uint16): uint16 =
    asm """
        inw %1, %0
        : "=a" (`result`)
        : "dN" (`port`)
    """

proc out32*(port: uint16, data: uint32): void =
    asm """
        outl %0, %1
        :
        : "a"  (`data`),
          "dN" (`port`)
    """

proc in32*(port: uint32): uint32 =
    asm """
        inl %1, %0
        : "=a" (`result`)
        : "dN" (`port`)
    """

proc io_delay*(): void =
    const DELAY_PORT = 0x80
    asm """
        outb %%al,%0
        :
        : "dN" (`DELAY_PORT`)
    """

{.pop.}