type
    CpuID* = tuple
        eax: uint32
        ebx: uint32
        ecx: uint32
        edx: uint32

    CpuInfo* = ref object
        vendor_id*: string
        family*: uint32
        model*: uint32
        model_name*: string
        stepping*: uint32

proc `$`*(c: CpuInfo): string =
    result = ""
    result.add("CpuInfo {")
    result.add("model_name: " & c.model_name & ", ")
    result.add("vendor_id: " & c.vendor_id & ", ")
    result.add("model: " & $int(c.model) & ", ")
    result.add("family: " & $int(c.family) & ", ")
    result.add("stepping: " & $int(c.stepping))
    result.add("}")

{.push stackTrace:off.}
proc native_cpuid(leaf: uint32): CpuID =
    asm """
        cpuid
        : "=a" (`result.Field0`),
          "=b" (`result.Field1`),
          "=c" (`result.Field2`),
          "=d" (`result.Field3`)
        : "a"  (`leaf`)
        : "memory"
    """

proc native_cpuid(leaf, subleaf: uint32): CpuID =
    asm """
        cpuid
        : "=a" (`result.Field0`),
          "=b" (`result.Field1`),
          "=c" (`result.Field2`),
          "=d" (`result.Field3`)
        : "a"  (`leaf`),
          "c"  (`subleaf`)
        : "memory"
    """
{.pop.}

proc cpuid_max*(ext: uint32): uint32 =
    ## Returns the max value
    var info = native_cpuid(ext)
    return info.eax

proc cpuid*(leaf: uint32):  CpuID =
    var ext = leaf and 0x80000000'u32
    var maxlevel = cpuid_max(ext)

    if maxlevel == 0 or maxlevel < leaf:
        return result

    return native_cpuid(leaf)

proc cpuid*(leaf, subleaf: uint32): CpuId =
    var ext = leaf and 0x80000000'u32
    var maxlevel = cpuid_max(ext)

    if maxlevel == 0 or maxlevel < leaf:
        return result

    return native_cpuid(leaf, subleaf)

proc get_vendor_id*(): string =
    var info = cpuid(0)
    var data: array[3, uint32] = [info.ebx, info.edx, info.ecx]
    var buff = cast[array[12, uint8]](data)[0..11]
    return cast[string](buff)

proc get_stepping*(): uint32 =
    var info = cpuid(1)
    return info.eax and 0xF

proc get_model*(): uint32 =
    var info = cpuid(1)
    var family = (info.eax shr 8) and 0x0F
    result = (info.eax shr 4) and 0xF
    if family == 6 or family == 15:
        var extended_model = (info.eax shr 16) and 0x0F
        result = (extended_model shl 4) + result

proc get_family*(): uint32 =
    var info = cpuid(1)
    result = (info.eax shr 8) and 0xF
    if result == 15:
        var extended_family = (info.eax shr 20) and 0xFF
        result += extended_family

proc get_model_name*(): string =
    var p1 = cpuid(0x80000002'u32)
    var p2 = cpuid(0x80000003'u32)
    var p3 = cpuid(0x80000004'u32)
    var data: array[12, uint32] = [p1.eax, p1.ebx, p1.ecx, p1.edx, p2.eax, p2.ebx, p2.ecx, p2.edx, p3.eax, p3.ebx, p3.ecx, p3.edx]
    return $cast[cstring](addr data)

proc cpu_info*(): CpuInfo =
    result = CpuInfo()
    result.vendor_id = get_vendor_id()
    result.family = get_family()
    result.model = get_model()
    result.model_name = get_model_name()
    result.stepping = get_stepping()

