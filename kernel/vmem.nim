const
    UserspaceOffset* = 0x40000000 # 1GB into virtual memory
    UserspaceSize* = 16 * 1024 * 1024 # 16MB
    UserspaceEnd* = UserspaceOffset + UserspaceSize

    HeapOffset* = 0x80000000 # 2GB into virtual memory
    HeapSize* = 1 * 1024 * 1024 # 1MB
    HeapEnd* = HeapOffset + HeapSize

type
    PageFile*[T] = ptr array[T, distinct uint8]
    UserspaceVmem* = PageFile[UserspaceSize]
    HeapVmem* = PageFile[UserspaceSize]
    PageDirectory* = ref object

var
    Userspace* = cast[UserspaceVmem](UserspaceOffset)
    Heap* = cast[HeapVmem](HeapOffset)

