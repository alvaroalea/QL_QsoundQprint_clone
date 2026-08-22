# SINCLAIR QL QsoundQprint Sound and Paralel Printer port interface
(C) 2022 Alvaro Alea Fernandez

License under: CERN Open Hardware Licence Version 2 - Strongly Reciprocal

https://ohwr.org/cern_ohl_s_v2.txt

## Aditional info

Pictures of the original interfaz by Ioannis: https://qlforum.co.uk/viewtopic.php?f=2&t=1587&start=10#p17687

Interface Manual, from Dilwyn Jones site: http://www.dilwyn.me.uk/docs/manuals/index.html

6821 Manual, from archive.org

AY-3-8910 Manual, Silvester point to the source: https://dev-docs.atariforge.org/ , he also do the original schematic

## Technical Info

## Memory Map
The Sinclair QL expect that all external board use the last 256Kb of the 1Mb memory space (that is A19,A18=1)

The 'Plug-n-play' characteristic allow up to 16 "block" of 16Kb of memory can be shared between diferent expansion board, through the use of a
expecial SP0 to SP3 lines present in the expansion port.

This lines are tied to GND in the Sinclair QL Main Board, and compared with the actual A14 to A17 of the 68008, in real life, this mean, that if 
you are not using any expecial backplane to allow several card, or using a custom card that has passthrough conector, 
the Qsound memory base address will be on 0b110000xxxxxxxxxxxxxx or 0xC0000.

This is also the unique address that is recognized by some ROM versions.

Of this memory the first 8K (0xC0000 to 0xC3FFF) is decoded for the ROM of the Qsound.

The 6821 PIO is decoded using A0,A1 and A13 to A19, so will be available in the top 8K of the card (0b1100001xxxxxxxxxxxAB)

Is expected that the ROM wil be reallocatable, and should work on any of the 16 bank of ROM (PENDING TO CONFIRM) so the 6821 can be also allocated in any of this bank.

The QSound manual indicate that 2 system variables are defined to indentify the real position in the bank, SV.AYBAS (0x28160) and SV.AYJMP (0x28164) but some toolkits are also using this address for his internal propouse.

A definitive way to identify the real base address of the interface is not clear, searching for "QSound" ascii signature at beggining of the rom block is another options but has also it's cabeats.

## PIO (MC6821)
The pio has 2 8-bit lines, that the use of A or B is defined by RS1, that is A1 in the Sinclair QL. the Port A is linked to the data of the PSG, and the port B is using bit 0 and bit 2 to manage the selection of the PSG, bit 3 ant bit 4 are exposed in the 2x13 pin conector to be used as strobe and busy in the centronics printer port part of the interface.

- RS0 on 6821 is conected to The A0 on the QL
- RS1 on 6821 is conected to The A1 on the QL
- RESET on 6821 is conected to RESET on the QL

RS0 manage the Port in use, 0 for A, 1 for B.

- When RS1 is 1, you write to Control register of each port.
- When RS1 is 0, depend on the bit 2 of Control register you access to Data Direction (if 0) or the port itself (if 1)

The other bits of Control Register are related to interuptions and are not in use for this card.

When you write to the Data direction, each bit indicate if Port bit is Input (when 1) or output (when 0)


## PSG (GI AY-3-8910)

- The data bus of the PGS is conected to the Port A of the PIO.
- BC1 is conected to bit 0 of PIO's port B 
- BC2 is tied to 1 (Vcc) 
- BDIR is conected to bit 2 of PIO's port B 
- CLOCK is conected to E of QL, so it's 750Khz, as it's 1/10 of clock of CPU 68008
- RESET on PSG is conected to RESET on the QL

So a sequence to write to a register on the PSG shall be:

```
; INIT

LEA       LPSG_io,A5          ; A5 = base address of I/O Port of 6821, (0x12000)

CLR.B     $0001(A5)           ; disable all interupts and select Direction for Port A
MOVE.B    #$FF,$0000(A5)      ; configure all bits of Port A as Output
MOVE.B    #$04,$0001(A5)      ; select register data, any write to $0000(A5) now will be put on Port A

CLR.B     $0003(A5)           ; disable all interupts and select Direction for Port B
MOVE.B    #$0F,$0002(A5)      ; set BC0, BDIR, Strobe as ouput, and Busy as input
MOVE.B    #$04,$0003(A5)      ; select register data, any access to $0002(A5) now will be to Port B

MOVE.B    #$0A,$0002(A5)      ; Set BC1 to 0, and BDIR to 1, so inactive.


; Write D1 on register D2

MOVE.B    D2  ,$0000(A5)      ; Write the Register Number to port A
MOVE.B    #$0F,$0002(A5)      ; Set BC1 to 1, and BDIR to 1 latch adress of port A to PSG
MOVE.B    #$0A,$0002(A5)      ; Set BC1 to 0, and BDIR to 1, so inactive.

MOVE.B    D1,  $0000(A5)      ; Write the Data to port A
MOVE.B    #$0E,$0002(A5)      ; Set BC1 to 0, and BDIR to 1 write data of port A to register of PSG
MOVE.B    #$0A,$0002(A5)      ; "write" (graba el valor en el registro) y vuelve a inactivo
```




