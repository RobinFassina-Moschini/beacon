#
# x64: Constructs the Beacon for AMD64
#
SOURCE := source/*.c source/crypt/*.c
ASMSRC := source/x64/entrypoint.asm

ASMOBJ := entrypoint.o
EXEX64 := beacon.x64.exe
BINX64 := beacon.x64.bin

CFLAGS := -Os -s -fno-asynchronous-unwind-tables
CFLAGS := $(CFLAGS) -nostdlib -fno-ident -Qn
CFLAGS := $(CFLAGS) -fpack-struct=8 -falign-functions=1
CFLAGS := $(CFLAGS) -falign-jumps=1 -falign-labels=1
CFLAGS := $(CFLAGS) -falign-loops=1 -flto
LFLAGS := -Wl,-s,--no-seh,--enable-stdcall-fixup,-Tscripts/linker.ld

all: $(ASMOBJ) $(EXEX64) $(BINX64)

$(ASMOBJ):
	nasm -f win64 $(ASMSRC) -o $@

$(EXEX64):
	x86_64-w64-mingw32-gcc $(ASMOBJ) $(SOURCE) -o $@ $(CFLAGS) $(LFLAGS) 

$(BINX64):
	python3 scripts/pedump.py -f $(EXEX64) -o $@

clean:
	rm -rf $(EXEX64) $(ASMOBJ) $(BINX64)
