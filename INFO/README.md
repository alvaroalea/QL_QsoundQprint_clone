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

The A0 line in the QL is conected to RS0 in the 6821,

## PSG (GI AY-3-8910)










