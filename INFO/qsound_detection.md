# QSound for the Sinclair QL: detection and ROM notes

Report date: 2026-11-16

This report describes how to detect a QSound interface from software, and records what was found in two ROM versions: **v1.32** (annotated 68000 disassembly, `Qsound1.32.ASM`) and **v1.94** (binary, `Qsound_V1_94.rom`, disassembled for this report).

Conventions: `A6` is the QDOS system-variables base (`$28000`). `ROM+$xxx` means an offset inside the card's 8 KB ROM; the real address depends on where the card is mapped (e.g. `$C000`, `$10000`, `$14000` or `$C0000`).

---

## 1. Key idea

On installation the ROM stores one long word in the system variable **SV.AYJMP = A6+$164 = `$28164`**. What that long word holds depends on the ROM version:

| ROM version | Content of `$28164` | Where it points | How to get the ROM base |
|---|---|---|---|
| **1.32** | Direct entry address of the driver's dispatcher | Into the ROM (outside RAM) | `x AND mask` |
| **1.94** | Pointer to a 146-byte RAM block allocated with `SMS.ACHP` | RAM (between 128 KB and RAMTOP) | `(x)` must be `$4EF9` (JMP abs.L); then `((x)+2) AND mask`. The JMP target is `ROM+$1C4` |

"In RAM" means the value lies between 128 KB (`$20000`, start of QL RAM) and RAMTOP. "In ROM" means below 128 KB or above RAMTOP.

The ROM base is obtained with a 16 KB alignment mask, `$FFFFC000`. See note 1 in section 3.

---

## 2. Detection pseudocode

```
x = long at SV.AYJMP            ; A6 + $164

if x is in RAM:                 ; 128 KB <= x < RAMTOP
    if word at (x) == $4EF9:    ; JMP abs.L  (v1.94 style)
        BASE = (long at (x)+2) AND mask
    else:
        abort the quick detection        ; fall through to the scan below
else:                           ; v1.32 style, x points straight into the ROM
    BASE = x AND mask

if BASE != 0:
    search for the string "QSound" at BASE   -> confirms the base
else:
    scan 16 KB blocks, looking for the string "QSound" in each block:
        1) $10000
        2) $14000
        3) jump to RAMTOP, then continue in 16 KB steps
    stop when the scan reaches RAMTOP + 256 KB or the machine's physical
    address limit (1, 2, 4 or 8 MB), whichever comes first
    (no wrap-around)

if "QSound" found:  QSound present (BASE known)
else:               no QSound (card considered not installed)
```

Where the string lives: both ROMs follow the standard QL expansion-ROM header.

| Offset | v1.32 (listing) | v1.94 (binary) |
|---|---|---|
| +0 | `$4AFB0001` | `$4AFB0001` |
| +4 | word `$1648` (not analysed) | word `$0000` |
| +6 | word = offset of init routine (`$002E`) | `$002E` |
| +8 | word `36`, then text `Jochen Merz QSound V1.31 ...` | word `$0024`, then text `QSound V1.94 ... 2022 J.Merz/M.Kilgus` |

So the signature `$4AFB0001` at `BASE`, plus the text `QSound` within the first `$30` bytes, is a reliable confirmation for both versions.

---

## 3. Notes

1. **Alignment mask.** The ROM is 8 KB, but the card occupies a 16 KB slot: the second 8 KB holds the PIA (`ROM+$2000`) and never contains ROM. The base is therefore aligned to 16 KB, so `mask = $FFFFC000`.
2. **Value 0.** If no card is installed, `$28164` is normally 0. Then `BASE = 0` and the code falls through to the memory scan.
3. **Fallback scan.** Blocks are 16 KB. The scan visits `$10000`, then `$14000`, then jumps to RAMTOP and continues in 16 KB steps until it reaches RAMTOP + 256 KB or the physical address limit (1, 2, 4 or 8 MB), whichever comes first. There is no wrap-around: if nothing is found, the card is considered not installed.
4. **Card at `$C000`.** The card can also sit at `$C000` (the QL ROM slot). There the QL always initialises it at boot, so `SV.AYJMP` is already set and no scan is needed or done for that address.
5. **Do not probe by calling functions.** Function 11 behaves differently in v1.32 and v1.94 (see section 6). In v1.32 it overwrites a 256-byte table from `(A1)`.

---

## 4. Hardware used by both ROMs

- The 6821 PIA is at **`ROM+$2000`**: both ROMs build the address with `LEA $2000(PC),A5` (v1.94) or `LEA LPSG_io,A5` with `LPSG_io EQU $12000` for a listing based at `$10000` (v1.32).
- PIA initialisation is identical in both ROMs: CRA=0, DDRA=$FF, CRA=4, CRB=0, DDRB=$0F, CRB=4, port B=$0A.
- Port A (offset 0) is the PSG data/address bus. Port B (offset 2) drives the control lines: `$0F` latches the register address, `$0E` writes data, `$0A` is inactive.
- Register write sequence (D2 = register, D1 = data):
  1. port A = register, port B = `$0F`, port B = `$0A`
  2. port A = data, port B = `$0E`, port B = `$0A`
- v1.32 also provides a `PAR` printer device (QPrint side of the card) with its own queue.

---

## 5. ROM v1.32 (`Qsound1.32.ASM`)

Source: Dea v5.0 disassembly, assumed to be at `$10000`. All addresses in the listing are absolute and based on that origin. The banner text says V1.31 although the file is named 1.32. Because the listing is a disassembly, PC-relative instructions appear as absolute ones. The real ROM must use PC-relative addressing, otherwise it could not run at `$C0000`.

### Installation (`Lrominit`, `ROM+$2E`)

1. Initialise the PIA.
2. `SMS.ACHP` for `$3E8` (1000) bytes. The block address goes to **`SV.AYBAS` = `$28160`**.
3. Write the "quiet" table to the 14 PSG registers.
4. Build the device-driver vector table at block+`$1C` and link it with `SMS.LIOD`.
5. Link the poll routine (`Lab0043`) with `SMS.LPOL` (block+8, routine pointer at +`$0C`).
6. **`LEA Lab0018,A1` followed by `MOVE.L A1,SV.AYJMP`**: the address of the dispatcher is stored directly. Listing value `$101DA` = `ROM+$1DA`.
7. Initialise variables (`$7A(block)=$000C`, `$150(block)=-1`, `$154(block)=0`), play the "gong" sound, and load the English character table (256 bytes at block+`$200`).

### Block layout (partial, as seen in the code)

| Offset | Use |
|---|---|
| `$70` / `$74` | Address and size of the PAR output queue |
| `$80` | Shadow copy of the 14 PSG registers |
| `$200` | 256-byte translation table (English, German, French, Spanish, Italian variants) |

### Dispatcher (`Lab0018`, `ROM+$1DA`)

- `D0` is the function number. If `D0 > 11` it returns `D0 = -1`.
- The 12 entries are word offsets from the ROM start, taken from `Lab0236`.
- It then does `JMP` to ROM + offset.

---

## 6. ROM v1.94 (`Qsound_V1_94.rom`, 8192 bytes)

Disassembled with capstone for this report. Everything below was read from the code; the ROM was not executed.

### Installation (`ROM+$2E`)

1. Initialise the PIA (`LEA $2000(PC),A5`).
2. `ROM+$E4`: call vector `$110` (`BP.INIT`) with the BASIC table at `ROM+$C46`. This registers the keywords BELL, EXPLODE, SHOOT, POKE_AY, LIST_AY, PLAY, HOLD, RELEASE, ENVELOPE and SOUND_AY, and the functions PEEK_AY, PLAYING, AY_CHIPS and AY_TYPE.
3. `ROM+$F8`: main driver install.
   - `SMS.INFO` gives A4 = `$28000`.
   - `SMS.ACHP` for `$92` bytes gives the block address in A0.
   - **`MOVE.L A0,$164(A4)`** stores the block address at `$28164`. This is the only write to `$164` in the ROM.
   - Block+0 = `$4EF9`, block+2 = `ROM+$1C4` (`LEA $1C4(PC),A1`). So the block starts with `JMP ROM+$1C4`.
   - `ROM+$66` initialises variables: block+6 = 1 (number of chips), block+7 = 3 (queues), block+`$8A` = `$16E360`, and a few flag bytes.
   - `ROM+$22E` runs the reset function (clears queues, writes the default table at `ROM+$CD8` to the chip).
   - The poll routine `ROM+$2B8` is linked with `SMS.LPOL` (block+8, pointer at +`$0C`).
4. `ROM+$ED4`: allocate a second block of `$60` bytes with the device-driver vector table at +`$1C`. It copies the pointer from `$28164` to +`$48`, calls function 11 through it, stores the chip count it returns, links a second poll routine (`ROM+$10D4`) and registers the driver with `SMS.LIOD`.

### What `$28164` holds

```
($28164).L = A         ; address of the RAM block
A+0 : $4EF9            ; JMP abs.L
A+2 : ROM+$01C4        ; absolute address of the dispatcher
```

ROM base = `((A)+2) - $1C4`, or the same value after the alignment mask.

### Dispatcher (`ROM+$1C4`)

- `D0` is the function number. If `D0 > 15` it returns `D0 = -1`.
- The table of 16 word offsets is at `ROM+$D1E`, **relative to `ROM+$E4`** (not to the ROM start).
- Before jumping, `ROM+$1EA` runs `SMS.INFO` and reloads A3 with the block pointer from `$164`.

### Function table (verified entries)

| D0 | v1.94 target | v1.32 target | Function |
|---|---|---|---|
| 0 | `$022E` | `$01FA` | Reset / silence |
| 1 | `$0162` | `$0168` | Write one register (D2 = register, D1 = data) |
| 2 | `$0198` | `$01B8` | Read one register |
| 3 | `$0252` | `$0200` | Write the 14 registers from the table in A1 |
| 4 | `$0280` | `$0214` | Read the 14 registers into A1 |
| 9 | `$02A0` | `$0226` | Load one of 3 preset sets (index in D1, 14 bytes each) |
| 11 | `$0BDA` | `$0696` | **Different**: v1.94 returns `D1 = $332E3033` ("3.03") and `D2` = number of chips. v1.32 copies 256 bytes from (A1) to the translation table |

Functions 5-8 and 10 (v1.32) and 5-8, 10, 12-15 (v1.94) were not analysed. In v1.94 function 12 reads or sets a byte at block+`$8E`.

In v1.94, `D2` for functions 1 and 2 carries the chip number in the high nibble and the register in the low nibble; the chip number must be lower than the chip count at block+6. In v1.32 register numbers above `$0D` return an error.

---

## 7. Calling the driver (both versions)

The same sequence works for v1.32 and v1.94:

```
        MOVEA.L ($28164).L,A0
        MOVEQ   #function,D0
        JSR     (A0)          ; D0 = 0 on success, negative on error
```

In v1.32 `A0` is the dispatcher itself. In v1.94 it is the RAM block, whose first instruction jumps to the dispatcher.
