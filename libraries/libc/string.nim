const
    EOF = '\0'
    INT_MAX = 2147483647

proc abort*(): void {.exportc.} =
    # TODO: Send SIGABRT
    return;

proc memmove*(dst: ptr, src: ptr, size: csize_t): ptr {.exportc.} =
    if dst < src:
        for i in 0..size:
            dst[i] = src[i]
    else:
        for i in size..0:
            dst[i-1] = src[i-1]
    return dst

proc strlen*(str: cstring): csize_t {.exportc.} =
    var size: csize_t = 0
    for ch in str:
        size += 1
    return size

proc memcmp*(aptr: ptr, bptr: ptr, size: csize_t): cint {.exportc.} =
    for i in 0..size:
        if aptr[i] < bptr[i]:
            return -1
        elif bptr[i] < aptr[i]:
            return 1
    return 0;

proc memset*(bufptr: ptr, value: cint, size: csize_t): ptr {.exportc.} =
    for i in 0..size:
        bufptr[i] = value
    return bufptr

proc memcpy*(dstptr: ptr, srcptr: ptr, size: csize_t): ptr {.exportc.} =
    for i in 0..size:
        dstptr[i] = srcptr[i]
    return dstptr;

proc putchar(c: char): char {.exportc.} =
    # TODO: Implement STDIO and write the system call
    return c

proc print*(data: cstring, length: csize_t): bool {.exportc.} =
    for i in 0..length:
        if putchar(data[i]) == EOF:
            return false
    return true

proc printf*[T](fmt: cstring, args: varargs[T]): cint {.exportc.} =
    var format = $fmt
    var i = 0
    var written: cint = 0
    # var parsed = 0

    while i < format.len:
        var max_rem = INT_MAX - written

        if format[0] != '%' or format[1] == '%':
            if format[0] == '%':
                i += 1
            
            var amount: cint = 1
            while (amount < format.len) and (format[amount] != '%'):
                i += 1
            
            if max_rem < amount:
                # TODO: Set errno to EOVERFLOW.
                return -1
            
            if not print(format.substr(i, amount), csize_t(amount)):
                return -1
            
            i += amount
            written += amount
            continue

        if not print(format.substr(i, 1), 1):
            return -1

        i += 1
        written += 1
    return written


            
proc puts*(str: cstring): cint {.exportc.} =
    return printf("%s\n", str)