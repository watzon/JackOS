import io

proc read*(index: uint8): uint8 =
    outb(0x70, index)
    return inb(0x71)

proc write*(index: uint8, data: uint8): void =
    outb(0x70, index)
    outb(0x71, data)