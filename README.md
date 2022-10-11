# SINCLAIR QL QsoundQprint Sound and Paralel Printer port interface

(C) 2022 Alvaro Alea Fernandez

License under: CERN Open Hardware Licence Version 2 - Strongly Reciprocal

https://ohwr.org/cern_ohl_s_v2.txt

I try to follow the original desing as much as possible, with some licenses:

- It's 10mm short, to fit in a 10x10cm, that is a lot cheaps if order PCB.
- The 7805 regulator board and the output Jack was modify.
- I use a electrolitic capacitor instead the original tantalo one.
- There are some jumper to allow a future ACB stereo mix.

This project can not be possible without the help of silvester, that tracked a fault in the schematic and Marcel Kilgus that develop a new ROM with a qsound device and a pt3 player.

I test with ROM versions 1.10, 1.31 and 1.40 and work as expected, new ROM do not have the printer routines, but have a new options used by the pt3 player. 

You can use a 2764 eprom or a W27C512 flash, that is much more cheap and easy to use.

This board user the default Motorola 68K inteface as described in the documentation of AY-3-8910 PSG. with a 6821 PIA as a glue between the QL and the PSG, in the info folder you can found aditional information about this chips or the interface.

The card have full 8bit I/O in the PSG without use, and another 8 bits in the PIA, also the pins of the paralel port are directly wired to the PSG, and are bidirectional, so can be used for other propouses.

The board use the E signal as a clock for the PSG, this cause that the PSG work in a very low frecuency, below the minimun indicated in the datasheet, and also this cause that tunes from Spectrum or other systems, can not be directly converted.

![My image](QL_Qsound_1.png) 

![My image](QL_Qsound_2.png) 

