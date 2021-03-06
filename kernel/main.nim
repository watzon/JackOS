import tty
import cpuid as cpuid

type
  TMultiboot_header = object
  PMultiboot_header = ptr TMultiboot_header

var
  vram = cast[PVIDMem](0xB8000)

proc kmain(mb_header: PMultiboot_header, magic: int) {.exportc.} =
  if magic != 0x2BADB002:
    discard # Something went wrong?

  initTTY(vram)
  screenClear(vram, LightBlue) # Make the screen yellow.

  # Demonstration of error handling.
  # var x = len(vram[])
  # var outOfBounds = vram[x]

  let attr = makeColor(LightBlue, White)
  let info = cpuid.cpu_info()
  writeString(info.vendor_id, attr, (0, 0))
  writeString("Nim", attr, (25, 9))
  writeString("Expressive. Efficient. Elegant.", attr, (25, 10))
  rainbow("It's pure pleasure.", (x: 25, y: 11))
