*  Start of Deassembly Code - Dea v5.0 Plus 1
*  Code execution starts at $10000 with label Lromstart
LPSG_io   EQU       $12000
SV.AYBAS  EQU       $00028160
SV.AYJMP  EQU       $00028164

START_CODE

*  Bytes Data Block [10000,10001]
*  Address $10000
Lromstart DC.B      $4A,$FB,$00,$01
*         DC,W      Lsomeplace - Lromstart  = $1648 no idea where point. 
          DC,B      $16,$48
          DC,W      Lrominit - Lromstart
          DC.W      36
          DC.B      'Jochen Merz   QSound  V1.31  ','',' 1987',$0A

*  Address $1002E
Lrominit  MOVEM.L   A0/A3,-(A7)
          LEA       LPSG_io,A5
          CLR.B     $0001(A5)
          MOVE.B    #$FF,$0000(A5)
          MOVE.B    #$04,$0001(A5)
          CLR.B     $0003(A5)
          MOVE.B    #$0F,$0002(A5)
          MOVE.B    #$04,$0003(A5)
          MOVE.B    #$0A,$0002(A5)
          MOVE.L    #$000003E8,D1
          MOVEQ     #-$01,D2
          MOVEQ     #$18,D0
          TRAP      #1  ;SMS.ACHP allocate 1750 bytes of ram.
          TST.W     D0
          BNE       Lab0005
          MOVE.L    A0,SV.AYBAS
          LEA       LTquiet,A1
          BSR       Lay_wrall
          LEA       $001C(A0),A3
          CLR.L     $0070(A0)
          CLR.L     $0074(A0)
          LEA       Lab0025,A1
          MOVE.L    A1,(A3)+
          LEA       Lab0031,A1
          MOVE.L    A1,(A3)+
          LEA       Lab0037,A1
          MOVE.L    A1,(A3)+
          LEA       Lab0027,A1
          MOVE.L    A1,(A3)+
          MOVE.L    A1,(A3)+
          LEA       Lab0039,A1
          MOVE.L    A1,(A3)+
          MOVE.W    #$4E75,(A3)+
          LEA       $0018(A0),A0
          MOVEQ     #$20,D0
          TRAP      #1
*  
*  ¾¾¾ QDOS TRAP #1 - D0=$20 : SMS.LIOD ¾¾¾
*  

          MOVEA.L   SV.AYBAS,A0
          LEA       Lab0043,A1
          MOVE.L    A1,$000C(A0)
          LEA       $0008(A0),A0
          MOVEQ     #$1C,D0
          TRAP      #1
*  
*  ¾¾¾ QDOS TRAP #1 - D0=$1C : SMS.LPOL ¾¾¾
*  

          LEA       Lab0018,A1
          MOVE.L    A1, SV.AYJMP
          MOVEA.L   SV.AYBAS,A1
          MOVE.W    #$000C,$007A(A1)
          MOVE.L    #$FFFFFFFF,$0150(A1)
          CLR.L     $0154(A1)
          LEA       LTgong,A1
          BSR       Lay_wrall
          BSR       Lenglish
*  Address $100F8
Lab0005   MOVEM.L   (A7)+,A0/A3
          RTS
*  Address $100FE
Lab0006   LEA       LPSG_io,A5
          MOVEQ     #$13,D0
*  Address $10104
Lab0007   BTST      #$04,$0002(A5)
          BEQ.S     Lab0008
          DBF       D0,Lab0007
          RTS
*  Address $10112
Lab0008   MOVE.B    #$0F,$0000(A5)
          MOVE.B    #$0F,$0002(A5)
          MOVE.B    #$0A,$0002(A5)
          MOVEA.L   SV.AYBAS,A5
          ADDA.W    #$0200,A5
          ANDI.W    #$00FF,D1
          MOVE.B    $00(A5,D1.W),D1
          LEA       LPSG_io,A5
          MOVE.B    D1,$0000(A5)
          MOVE.B    #$0E,$0002(A5)
          MOVE.B    #$0A,$0002(A5)
          MOVE.B    #$02,$0002(A5)
          MOVE.B    #$0A,$0002(A5)
          MOVEQ     #$00,D0
          RTS
*  Address $1015A
Lab0009   MOVEQ     #-$01,D0
          RTS
*  Address $1015E
Lab0010   MOVEQ     #-$04,D0
          RTS
*  Address $10162
Lab0011   ADDQ.L    #4,A7
*  Address $10164
Lab0012   MOVEQ     #-$06,D0
          RTS
*  Address $10168
Lab0013   CMPI.B    #$0D,D2
          BHI.S     Lab0010
*  Address $1016E
Lab0014   CMPI.B    #$07,D2
          BNE.S     Lab0015
          ORI.B     #$C0,D1
*  Address $10178
Lab0015   MOVE.L    A5,-(A7)
          LEA       LPSG_io,A5
          ANDI.W    #$000F,D2
          MOVE.B    D2,$0000(A5)
          MOVE.B    #$0F,$0002(A5)
          MOVE.B    #$0A,$0002(A5)
          MOVE.B    D1,$0000(A5)
          MOVE.B    #$0E,$0002(A5)
          MOVE.B    #$0A,$0002(A5)
          MOVEA.L   SV.AYBAS,A5
          ADDA.L    #$00000080,A5
          MOVE.B    D1,$00(A5,D2.W)
          MOVEQ     #$00,D0
          MOVEA.L   (A7)+,A5
          RTS
*  Address $101B8
Lab0016   CMPI.B    #$0D,D2
          BHI.S     Lab0010
*  Address $101BE
Lab0017   MOVE.L    A5,-(A7)
          MOVEA.L   SV.AYBAS,A5
          ADDA.W    #$0080,A5
          MOVEQ     #$00,D1
          ANDI.W    #$000F,D2
          MOVE.B    $00(A5,D2.W),D1
          MOVEQ     #$00,D0
          MOVEA.L   (A7)+,A5
          RTS
*  Address $101DA
Lab0018   CMPI.L    #$0000000B,D0
          BHI       Lab0009
          LSL.W     #1,D0
          LEA       Lab0236,A5
          ADDA.W    D0,A5
          MOVEA.W   (A5),A5
          MOVE.L    A4,-(A7)
          LEA       $10000,A4
          ADDA.L    A4,A5
          MOVEA.L   (A7)+,A4
          JMP       (A5)
*  Address $101FA
Lab0019   MOVEQ     #$00,D0
*         LEA       Lab0228,A1  LTquiet
          LEA       $11810,A1

*  Address $10200
Lay_wrall MOVEQ     #$00,D2
Lab0021   MOVE.B    $00(A1,D2.W),D1
          BSR       Lab0014
          ADDQ.W    #1,D2
          CMPI.B    #$0E,D2
          BNE.S     Lab0021
          RTS

*  Address $10214
Lab0022   MOVEQ     #$00,D2
*  Address $10216
Lab0023   BSR       Lab0017
          MOVE.B    D1,(A1)+
          ADDQ.W    #1,D2
          CMPI.B    #$0E,D2
          BNE.S     Lab0023
          RTS

*  Address $10226
* Lab0024   LEA       Lab0230,A1
Lab0024   LEA       $1181E,A1
          ANDI.W    #$00FF,D1
          CMPI.W    #$0002,D1
          BHI       Lab0027
          MULU      #$000E,D1
          ADDA.W    D1,A1
          BRA       Lay_wrall
*  Address $10240
Lab0025   CMPI.B    #$07,D0
          BHI.S     Lab0027
          MOVEA.L   SV.AYBAS,A3
          PEA       $0028(A3)
          MOVEA.W   $00EA,A4
          JMP       (A4)
*  
*  ¾¾¾ VECTOR utility $0EA : IOU.SSIO ¾¾¾
*  

*  Address $10256
Lab0026   ADDQ.L    #4,A7
*  Address $10258
Lab0027   MOVEQ     #-$0F,D0
          RTS
*  Address $1025C
Lab0028   MOVEQ     #-$0C,D0
          RTS
*  Address $10260
Lab0029   MOVEQ     #-$09,D0
*  Address $10262
Lab0030   RTS
*  Address $10264
Lab0031   MOVEA.W   $0122,A2
          LEA       $0090(A3),A3
          JSR       (A2)
*  
*  ¾¾¾ VECTOR utility $122 : IOU.DNAM ¾¾¾
*  

          BRA.S     Lab0030
          BRA.S     Lab0030
          BRA.S     Lab0033
*  IO.NAME device driver name data
          DC.W      3
*  Address $10276
Lab0032   
          DC.B      'PAR'
*  Code alignment
          DC.B      32
          DC.W      3
          DC.W      1
          DC.B      'C'
*  Code alignment
          DC.B      0
          DC.W      1
          DC.B      'F'
*  Code alignment
          DC.B      0
          DC.B      ' _'
          DC.W      0
*  Address $10288
Lab0033   MOVEA.L   A3,A4
          MOVEA.L   SV.AYBAS,A3
          TST.B     $0076(A3)
          BNE.S     Lab0029
          MOVE.B    $0001(A4),$0078(A3)
          MOVE.B    $0003(A4),$0079(A3)
          ADDQ.L    #4,A4
          TST.W     $0074(A3)
          BEQ.S     Lab0034
          TST.B     $0077(A3)
          BNE.S     Lab0029
          MOVEA.L   $0070(A3),A0
          MOVEQ     #$19,D0
          TRAP      #1
*  
*  ¾¾¾ QDOS TRAP #1 - D0=$19 : SMS.RCHP ¾¾¾
*  

*  Address $102B8
Lab0034   MOVEA.L   SV.AYBAS,A3
          CLR.B     $0077(A3)
          CLR.W     $0074(A3)
          MOVEQ     #$00,D1
          MOVE.W    (A4),D1
          TST.W     D1
          BEQ.S     Lab0035
          MULU      #$0200,D1
          SUBQ.W    #1,D1
          MOVE.W    D1,$0074(A3)
          MOVEQ     #-$01,D2
          MOVEQ     #$18,D0
          TRAP      #1
*  
*  ¾¾¾ QDOS TRAP #1 - D0=$18 : SMS.ACHP ¾¾¾
*  

          MOVEA.L   SV.AYBAS,A3
          TST.W     D0
          BNE.S     Lab0036
          MOVE.L    A0,$0070(A3)
          MOVEA.L   A0,A2
          MOVEQ     #$00,D1
          MOVE.W    $0074(A3),D1
          MOVEA.W   $00DC,A3
          JSR       (A3)
*  
*  ¾¾¾ VECTOR utility $0DC : IOQ.SETQ ¾¾¾
*  

*  Address $102FA
Lab0035   MOVEA.L   SV.AYBAS,A3
          ST        $0076(A3)
          LEA       $00B0(A3),A0
          MOVEQ     #$00,D0
          RTS
*  Address $1030C
Lab0036   MOVEQ     #-$03,D0
          RTS
*  Address $10310
Lab0037   TST.B     $0079(A3)
          BEQ.S     Lab0038
          MOVEQ     #$0C,D1
          BSR.S     Lab0039
*  Address $1031A
Lab0038   CLR.B     $0076(A3)
          MOVEQ     #$00,D0
          RTS
*  Address $10322
Lab0039   MOVEM.L   D1-D2/A2-A3,-(A7)
          MOVEA.L   SV.AYBAS,A3
          TST.B     $0078(A3)
          BEQ.S     Lab0040
          CMPI.B    #$0A,D1
          BNE.S     Lab0040
          MOVEQ     #$0D,D1
*  Address $1033A
Lab0040   TST.W     $0074(A3)
          BEQ.S     Lab0042
          MOVEA.L   $0070(A3),A2
          MOVEA.W   $00E0,A3
          JSR       (A3)
*  
*  ¾¾¾ VECTOR utility $0E0 : IOQ.PBYT ¾¾¾
*  

          TST.W     D0
          BNE.S     Lab0041
          MOVEA.L   SV.AYBAS,A3
          ST        $0077(A3)
*  Address $10358
Lab0041   MOVEM.L   (A7)+,D1-D2/A2-A3
          RTS
*  Address $1035E
Lab0042   MOVE.L    A5,-(A7)
          BSR       Lab0006
          MOVEA.L   (A7)+,A5
          BRA.S     Lab0041
*  Address $10368
Lab0043   MOVEM.L   D0-D7/A0-A6,-(A7)
          MOVEA.L   SV.AYBAS,A3
          TST.L     $0070(A3)
          BEQ       Lab0046
          TST.L     $0074(A3)
          BEQ.S     Lab0046
          MOVEQ     #$0F,D3
*  Address $10382
Lab0044   MOVEA.L   SV.AYBAS,A3
          LEA       LPSG_io,A5
          BTST      #$04,$0002(A5)
          BNE.S     Lab0046
          MOVEA.L   $0070(A3),A2
          MOVEA.W   $00DE,A3
          JSR       (A3)
*  
*  ¾¾¾ VECTOR utility $0DE : IOQ.TEST ¾¾¾
*  

          TST.W     D0
          BNE.S     Lab0045
          MOVEA.W   $00E2,A3
          JSR       (A3)
*  
*  ¾¾¾ VECTOR utility $0E2 : IOQ.GBYT ¾¾¾
*  

          BSR       Lab0006
          DBF       D3,Lab0044
          BRA.S     Lab0046
*  Address $103B2
Lab0045   MOVEA.L   SV.AYBAS,A3
          CLR.B     $0077(A3)
*  Address $103BC
Lab0046   MOVEQ     #$00,D0
          TRAP      #1
*  
*  ¾¾¾ QDOS TRAP #1 - D0=$00 : SMS.INFO ¾¾¾
*  

          CMPI.W    #$000C,$00AA(A0)
          BNE.S     Lab0047
          MOVEA.L   SV.AYBAS,A3
          MOVE.W    $007A(A3),$00AA(A0)
*  Address $103D4
Lab0047   BSR       Lab0147
          MOVEM.L   (A7)+,D0-D7/A0-A6
          RTS
*  Address $103DE
Lexchg    MOVEA.L   A5,A2
          SUBA.L    A3,A2
          CMPA.L    #$00000018,A2
          BNE       Lab0027
          MOVEM.L   A3/A5,-(A7)
          BSR       Lab0092
          MOVEM.L   (A7)+,A3/A5
          ADDA.L    A6,A1
          MOVEA.L   A1,A0
          MOVEA.L   A1,A4
          MOVEQ     #$00,D3
          MOVEQ     #-$01,D1
          MOVEQ     #$01,D0
          TRAP      #2
*  
*  ¾¾¾ QDOS TRAP #2 - D0=$01 : IOA.OPEN ¾¾¾
*  

          TST.W     D0
          BEQ.S     Lab0053
          TST.L     $000280B0
          BEQ.S     Lab0051
          LEA       -$0040(A7),A7
          MOVEA.L   A7,A1
          MOVEA.L   $000280B0,A0
          MOVE.W    (A0)+,D2
          LEA       $0002(A1),A2
          MOVE.W    D2,D3
          SUBQ.W    #1,D3
*  Address $10428
Lab0049   MOVE.B    (A0)+,(A2)+
          DBF       D3,Lab0049
          MOVE.W    (A4)+,D3
          ADD.W     D3,D2
          MOVE.W    D2,(A1)
          SUBQ.W    #1,D3
*  Address $10436
Lab0050   MOVE.B    (A4)+,(A2)+
          DBF       D3,Lab0050
          MOVEA.L   A1,A0
          MOVEQ     #$00,D3
          MOVEQ     #-$01,D1
          MOVEQ     #$01,D0
          TRAP      #2
*  
*  ¾¾¾ QDOS TRAP #2 - D0=$01 : IOA.OPEN ¾¾¾
*  

          LEA       $0040(A7),A7
          TST.W     D0
          BEQ       Lab0053
*  Address $10450
Lab0051   MOVEQ     #-$07,D0
*  Address $10452
Lab0052   RTS
*  Address $10454
Lab0053   MOVEA.L   A0,A4
          MOVEQ     #$00,D1
          MOVEQ     #$1E,D2
          MOVE.L    #$000001F4,D3
          SUBA.L    A1,A1
          MOVEQ     #$01,D0
          TRAP      #1
*  
*  ¾¾¾ QDOS TRAP #1 - D0=$01 : SMS.CRJB ¾¾¾
*  

          TST.W     D0
          BNE.S     Lab0052
          MOVE.W    #$4EF9,(A0)+
          LEA       Lab0056,A1
          MOVE.L    A1,(A0)+
          MOVE.W    #$4AFB,(A0)+
          MOVE.W    #$0008,(A0)+
          MOVE.L    #$45786368,(A0)+
          MOVE.L    #$616E6765,(A0)+
          MOVEQ     #$0A,D0
          MOVEQ     #$00,D2
          MOVEQ     #$00,D3
          TRAP      #1
*  
*  ¾¾¾ QDOS TRAP #1 - D0=$0A : SMS.ACJB ¾¾¾
*  

          MOVE.L    D1,D7
          MOVEA.L   $005C(A0),A2
          MOVE.L    A4,-(A2)
          MOVEM.L   D1/A0/A2,-(A7)
          ADDQ.L    #8,A3
          MOVEA.W   $0116,A2
          JSR       (A2)
*  
*  ¾¾¾ VECTOR utility $116 : SB.GTSTR ¾¾¾
*  

          MOVEM.L   (A7)+,D1/A0/A2
          CMPI.W    #$0002,D3
          BNE       Lab0064
          TST.W     D0
          BNE       Lab0064
          ADDA.L    A6,A1
          MOVE.W    (A1)+,D1
          CMPI.W    #$0010,D1
          BHI       Lab0064
          MOVE.W    D1,-$0024(A2)
          ADDQ.W    #1,D1
          BCLR      #$00,D1
          SUBQ.W    #1,D1
          LEA       -$0022(A2),A3
*  Address $104D2
Lab0054   MOVE.B    (A1)+,(A3)+
          DBF       D1,Lab0054
          MOVE.W    (A1)+,D1
          CMP.W     -$0024(A2),D1
          BNE       Lab0064
          MOVE.W    D1,-$0012(A2)
          LEA       -$0010(A2),A3
          SUBQ.W    #1,D1
*  Address $104EC
Lab0055   MOVE.B    (A1)+,(A3)+
          DBF       D1,Lab0055
          MOVE.L    A2,$005C(A0)
          MOVE.L    D7,D1
          MOVEQ     #$04,D2
          MOVEQ     #$0B,D0
          TRAP      #1
*  
*  ¾¾¾ QDOS TRAP #1 - D0=$0B : SMS.SPJB ¾¾¾
*  

          RTS
*  Address $10500
Lab0056   MOVEA.L   A7,A6
          LEA       -$0036(A7),A7
          MOVEA.L   A7,A1
          MOVEQ     #$00,D7
          MOVEQ     #$00,D6
          MOVE.W    -$0024(A6),D6
          MOVE.W    D6,D4
          SUBQ.W    #1,D4
          MOVEA.L   (A6),A0
          LEA       -$0034(A6),A5
          MOVEQ     #-$01,D3
*  Address $1051C
Lab0057   MOVEQ     #$42,D0
          MOVE.L    D7,D1
          TRAP      #3
*  
*  ¾¾¾ QDOS TRAP #3 - D0=$42 : IOF.POSA ¾¾¾
*  

          TST.W     D0
          BNE       Lab0062
          MOVEQ     #$03,D0
          MOVE.L    D6,D2
          MOVEA.L   A5,A1
          TRAP      #3
*  
*  ¾¾¾ QDOS TRAP #3 - D0=$03 : IOB.FMUL ¾¾¾
*  

          TST.W     D0
          BNE       Lab0062
          MOVEA.L   A5,A2
          LEA       -$0022(A6),A4
          MOVE.W    D4,D5
*  Address $1053E
Lab0058   CMPM.B     (A2)+,(A4)+
          BNE.S     Lab0061
*  Address $10542
Lab0059   DBF       D5,Lab0058
          MOVEQ     #$42,D0
          MOVE.L    D7,D1
          TRAP      #3
*  
*  ¾¾¾ QDOS TRAP #3 - D0=$42 : IOF.POSA ¾¾¾
*  

          MOVE.W    D6,D2
          LEA       -$0010(A6),A1
          MOVEQ     #$07,D0
          TRAP      #3
*  
*  ¾¾¾ QDOS TRAP #3 - D0=$07 : IOB.SMUL ¾¾¾
*  

*  Address $10556
Lab0060   ADDQ.L    #1,D7
          BRA.S     Lab0057
*  Address $1055A
Lab0061   SUBQ.W    #1,A2
          SUBQ.W    #1,A4
          BCHG      #$05,(A2)
          CMPM.B     (A2)+,(A4)+
          BEQ.S     Lab0059
          BRA.S     Lab0060
*  Address $10568
Lab0062   MOVEA.L   (A6),A0
          MOVEQ     #$02,D0
          TRAP      #2
*  
*  ¾¾¾ QDOS TRAP #2 - D0=$02 : IOA.CLOS ¾¾¾
*  

          MOVEQ     #-$01,D1
          MOVEQ     #$00,D3
          MOVEQ     #$05,D0
          TRAP      #1
*  
*  ¾¾¾ QDOS TRAP #1 - D0=$05 : SMS.FRJB ¾¾¾
*  

*  Address $10576
Lab0063   RTS
*  Address $10578
Lab0064   MOVEA.L   (A2)+,A0
          MOVEQ     #$02,D0
          TRAP      #2
*  
*  ¾¾¾ QDOS TRAP #2 - D0=$02 : IOA.CLOS ¾¾¾
*  

          MOVE.L    D7,D1
          MOVEQ     #$00,D3
          MOVEQ     #$05,D0
          TRAP      #1
*  
*  ¾¾¾ QDOS TRAP #1 - D0=$05 : SMS.FRJB ¾¾¾
*  

*  Address $10586
Lab0065   MOVEQ     #-$0F,D0
          RTS
*  Address $1058A
Lenglish  MOVEA.L   SV.AYBAS,A0
          ADDA.W    #$0200,A0
          MOVEQ     #$00,D0
*  Address $10596
Lab0067   MOVE.B    D0,$00(A0,D0.W)
          ADDQ.B    #1,D0
          BNE.S     Lab0067
          RTS
*  Address $105A0
Lgerman   BSR       Lenglish
          MOVE.B    #$40,$00B6(A0)
          MOVE.B    #$5B,$00A0(A0)
          MOVE.B    #$5C,$00A4(A0)
          MOVE.B    #$5D,$00A7(A0)
          MOVE.B    #$7B,$0080(A0)
          MOVE.B    #$7C,$0084(A0)
          MOVE.B    #$7D,$0087(A0)
          MOVE.B    #$7E,$009C(A0)
          RTS
*  Address $105D6
Lfrench   BSR       Lenglish
          MOVE.B    #$40,$008D(A0)
          MOVE.B    #$5B,$00BA(A0)
          MOVE.B    #$5C,$0088(A0)
          MOVE.B    #$5D,$00B6(A0)
          MOVE.B    #$7B,$0083(A0)
          MOVE.B    #$7C,$009A(A0)
          MOVE.B    #$7D,$0090(A0)
          MOVE.B    #$7E,$00A8(A0)
          RTS
*  Address $1060C
Lspanish  BSR       Lenglish
          MOVE.B    #$5B,$00B3(A0)
          MOVE.B    #$5C,$00A9(A0)
          MOVE.B    #$5D,$00B4(A0)
          MOVE.B    #$7C,$0089(A0)
          RTS
*  Address $1062A
Litalian  BSR       Lenglish
          MOVE.B    #$5B,$00BA(A0)
          MOVE.B    #$5D,$0083(A0)
          MOVE.B    #$60,$009A(A0)
          MOVE.B    #$7B,$008D(A0)
          MOVE.B    #$7C,$0097(A0)
          MOVE.B    #$7D,$0090(A0)
          MOVE.B    #$7E,$0094(A0)
          RTS
*  Address $1065A
Ltranslat MOVEA.W   $0116,A2
          JSR       (A2)
*  
*  ¾¾¾ VECTOR utility $116 : SB.GTSTR ¾¾¾
*  

          CMPI.W    #$0002,D3
          BNE       Lab0027
          CMPI.W    #$0001,$00(A6,A1.L)
          BNE       Lab0027
          CMPI.W    #$0001,$04(A6,A1.L)
          BNE       Lab0027
          MOVEQ     #$00,D0
          MOVE.B    $02(A6,A1.L),D0
          MOVEA.L   SV.AYBAS,A0
          ADDA.W    #$0200,A0
          MOVE.B    $06(A6,A1.L),$00(A0,D0.W)
          MOVEQ     #$00,D0
          RTS
*  Address $10696
Lab0073   MOVEA.L   SV.AYBAS,A0
          ADDA.W    #$0200,A0
          MOVEQ     #$3F,D0
*  Address $106A2
Lab0074   MOVE.L    (A1)+,(A0)+
          DBF       D0,Lab0074
          MOVEQ     #$00,D0
          RTS
*  Address $106AC
Lpokeay   MOVEA.W   $0112,A2
          JSR       (A2)
*  
*  ¾¾¾ VECTOR utility $112 : SB.GTINT ¾¾¾
*  

          CMP.W     #$0002,D3
          BNE       Lab0027
          MOVE.W    $00(A6,A1.L),D2
          MOVE.W    $02(A6,A1.L),D1
          BRA       Lab0014
*  Address $106C6
Lcurflash MOVEA.W   $0112,A2
          JSR       (A2)
*  
*  ¾¾¾ VECTOR utility $112 : SB.GTINT ¾¾¾
*  

          SUBQ.W    #1,D3
          BNE       Lab0027
          MOVE.W    $00(A6,A1.L),D1
          CMPI.W    #$0002,D1
          BHI       Lab0027
          LSL.W     #2,D1
          MOVEQ     #$0B,D0
          SUB.W     D1,D0
          MOVEA.L   SV.AYBAS,A5
          MOVE.W    D0,$007A(A5)
          MOVEQ     #$00,D0
          RTS
*  Address $106F2
Llistay   MOVEA.W   $0112,A2
          JSR       (A2)
*  
*  ¾¾¾ VECTOR utility $112 : SB.GTINT ¾¾¾
*  

          CMP.W     #$000E,D3
          BNE       Lab0027
          MOVEQ     #$00,D2
*  Address $10702
Lab0078   MOVE.W    $00(A6,A1.L),D1
          ADDQ.L    #2,A1
          BSR       Lab0015
          ADDQ.W    #1,D2
          CMP.W     #$000E,D2
          BNE.S     Lab0078
          RTS
*  Address $10716
Lab0079   MOVEA.W   $0112,A2
          JSR       (A2)
*  
*  ¾¾¾ VECTOR utility $112 : SB.GTINT ¾¾¾
*  

          SUBQ.W    #1,D3
          BNE       Lab0027
          MOVE.W    $00(A6,A1.L),D2
          BSR       Lab0017
          MOVE.W    D1,$00(A6,A1.L)
          MOVEQ     #$03,D4
          MOVEQ     #$00,D0
          RTS
*  Address $10734
Lab0080   MOVEQ     #-$01,D1
          MOVEQ     #-$01,D2
          MOVEQ     #$10,D0
          TRAP      #1
*  
*  ¾¾¾ QDOS TRAP #1 - D0=$10 : SMS.DMOD ¾¾¾
*  

          ANDI.W    #$00FF,D1
          CMPI.B    #$08,D1
          BEQ.S     Lab0083
          MOVEQ     #$04,D1
          BRA.S     Lab0083
*  Address $1074A
Lab0081   MOVEQ     #-$01,D1
          MOVEQ     #-$01,D2
          MOVEQ     #$10,D0
          TRAP      #1
*  
*  ¾¾¾ QDOS TRAP #1 - D0=$10 : SMS.DMOD ¾¾¾
*  

          MOVEQ     #$00,D1
          MOVE.B    D2,D1
          BRA.S     Lab0083
*  Address $10758
Lab0082   MOVEQ     #$00,D1
          MOVE.B    $00028037,D1
*  Address $10760
Lab0083   MOVE.L    D1,D7
          MOVEQ     #$02,D1
          MOVEA.W   $011A,A2
          JSR       (A2)
*  
*  ¾¾¾ VECTOR utility $11A : QA.RESRI ¾¾¾
*  

          MOVEA.L   $0058(A6),A1
          SUBQ.L    #2,A1
          MOVE.W    D7,$00(A6,A1.L)
          MOVE.L    A1,$0058(A6)
          MOVEQ     #$03,D4
          MOVEQ     #$00,D0
          RTS
*  Address $1077E
Lparuse   BSR       Lab0092
          BNE.S     Lab0085
          SUBQ.W    #3,$00(A6,A1.L)
          BNE       Lab0027
          MOVE.L    $02(A6,A1.L),D6
          ANDI.L    #$5F5F5F00,D6
          ADDI.B    #$20,D6
          LEA       Lab0032,A3
          MOVE.L    D6,(A3)
          MOVEQ     #$00,D0
*  Address $107A2
Lab0085   RTS

*  Address $107A4
Lbell     LTbell,A1
          BRA       Lay_wrall

*  Address $107AC
Lexplode  LEA       LTexplode,A1
          BRA       Lay_wrall

*  Address $107B4
Lshoot    LEA       LTshoot,A1
          BRA       Lay_wrall

*  Address $107BC
Lab0089   CMPA.L    A3,A5
          BNE       Lab0027
          MOVEQ     #$06,D1
          MOVEA.W   $011A,A0
          JSR       (A0)
*  
*  ¾¾¾ VECTOR utility $11A : QA.RESRI ¾¾¾
*  

          MOVEA.L   $0058(A6),A1
          SUBQ.L    #6,A1
          MOVE.W    #$0004,$00(A6,A1.L)
          MOVEQ     #$00,D0
          TRAP      #1
*  
*  ¾¾¾ QDOS TRAP #1 - D0=$00 : SMS.INFO ¾¾¾
*  

          MOVE.L    D2,$02(A6,A1.L)
          MOVE.L    A1,$0058(A6)
          MOVEQ     #$01,D4
          RTS
*  Address $107E6
Lparstop  MOVEA.L   SV.AYBAS,A3
          TST.W     $0074(A3)
          BEQ       Lab0091
          MOVEA.L   $0070(A3),A0
          MOVEQ     #$19,D0
          TRAP      #1
*  
*  ¾¾¾ QDOS TRAP #1 - D0=$19 : SMS.RCHP ¾¾¾
*  

          MOVEA.L   SV.AYBAS,A3
          CLR.L     $0070(A3)
          CLR.W     $0074(A3)
*  Address $1080A
Lab0091   MOVEQ     #$00,D0
          RTS
*  Address $1080E
Lab0092   MOVEQ     #$0F,D0
          AND.B     $01(A6,A3.L),D0
          SUBQ.B    #1,D0
          BNE.S     Lab0094
          MOVE.L    A5,-(A7)
          LEA       $0008(A3),A5
          MOVEA.W   $0116,A2
          JSR       (A2)
*  
*  ¾¾¾ VECTOR utility $116 : SB.GTSTR ¾¾¾
*  

          MOVEA.L   (A7)+,A5
          BNE.S     Lab0093
          MOVEQ     #$03,D1
          ADD.W     $00(A6,A1.L),D1
          BCLR      #$00,D1
          ADD.L     D1,$0058(A6)
          MOVEQ     #$00,D0
*  Address $10838
Lab0093   RTS
*  Address $1083A
Lab0094   MOVEQ     #-$0F,D0
          MOVEQ     #$00,D1
          MOVE.W    $02(A6,A3.L),D1
          BMI.S     Lab0093
          LSL.L     #3,D1
          ADD.L     $0018(A6),D1
          MOVEQ     #$00,D6
          MOVE.W    $02(A6,D1.L),D6
          ADD.L     $0020(A6),D6
          MOVEQ     #$00,D1
          MOVE.B    $00(A6,D6.L),D1
          ADDQ.L    #1,D1
          BCLR      #$00,D1
          MOVE.W    D1,D4
          ADDQ.L    #2,D1
          MOVEA.W   $011A,A2
          JSR       (A2)
*  
*  ¾¾¾ VECTOR utility $11A : QA.RESRI ¾¾¾
*  

          MOVEA.L   $0058(A6),A1
          ADD.W     D4,D6
*  Address $10870
Lab0095   SUBQ.L    #1,A1
          MOVE.B    $00(A6,D6.L),$00(A6,A1.L)
          SUBQ.L    #1,D6
          DBF       D4,Lab0095
          SUBQ.L    #1,A1
          CLR.B     $00(A6,A1.L)
          MOVEQ     #$00,D0
          RTS
*  Address $10888
Lup       BSR       Lab0106
          MOVEQ     #-$01,D3
          MOVEQ     #$15,D0
          TRAP      #3
*  
*  ¾¾¾ QDOS TRAP #3 - D0=$15 : IOW.PROW ¾¾¾
*  

          RTS
*  Address $10894
Ldown     BSR       Lab0106
          MOVEQ     #-$01,D3
          MOVEQ     #$16,D0
          TRAP      #3
*  
*  ¾¾¾ QDOS TRAP #3 - D0=$16 : IOW.NROW ¾¾¾
*  

          RTS
*  Address $108A0
Lleft     BSR       Lab0106
          MOVEQ     #-$01,D3
          MOVEQ     #$13,D0
          TRAP      #3
*  
*  ¾¾¾ QDOS TRAP #3 - D0=$13 : IOW.PCOL ¾¾¾
*  

          RTS
*  Address $108AC
Lright    BSR       Lab0106
          MOVEQ     #-$01,D3
          MOVEQ     #$14,D0
          TRAP      #3
*  
*  ¾¾¾ QDOS TRAP #3 - D0=$14 : IOW.NCOL ¾¾¾
*  

          RTS
*  Address $108B8
Lhome     BSR       Lab0106
          MOVEQ     #-$01,D3
          MOVEQ     #$00,D1
          MOVEQ     #$00,D2
          MOVEQ     #$10,D0
          TRAP      #3
*  
*  ¾¾¾ QDOS TRAP #3 - D0=$10 : IOW.SCUR ¾¾¾
*  

          MOVEQ     #$0E,D0
          TRAP      #3
*  
*  ¾¾¾ QDOS TRAP #3 - D0=$0E : IOW.ECUR ¾¾¾
*  

          RTS
*  Address $108CC
Lcursen   BSR       Lab0106
          MOVEQ     #-$01,D3
          MOVEQ     #$0E,D0
          TRAP      #3
*  
*  ¾¾¾ QDOS TRAP #3 - D0=$0E : IOW.ECUR ¾¾¾
*  

          RTS
*  Address $108D8
Lcurdis   BSR       Lab0106
          MOVEQ     #-$01,D3
          MOVEQ     #$0F,D0
          TRAP      #3
*  
*  ¾¾¾ QDOS TRAP #3 - D0=$0F : IOW.DCUR ¾¾¾
*  

          RTS
*  Address $108E4
Lnewfont  BSR       Lab0106
          LEA       Lab0258,A1
          BRA.S     Lab0105
*  Address $108EE
Loldfont  BSR       Lab0106
          SUBA.L    A1,A1
*  Address $108F4
Lab0105   SUBA.L    A2,A2
          MOVEQ     #-$01,D3
          MOVEQ     #$25,D0
          TRAP      #3
*  
*  ¾¾¾ QDOS TRAP #3 - D0=$25 : IOW.FONT ¾¾¾
*  

          RTS
*  Address $108FE
Lab0106   MOVEQ     #$01,D7
          CMPA.L    A3,A5
          BEQ.S     Lab0107
          BTST      #$07,$01(A6,A3.L)
          BEQ       Lab0026
          MOVEA.W   $0112,A2
          JSR       (A2)
*  
*  ¾¾¾ VECTOR utility $112 : SB.GTINT ¾¾¾
*  

          TST.W     D0
          BNE       Lab0026
          SUBQ.W    #1,D3
          BNE       Lab0026
          MOVEQ     #$00,D7
          MOVE.W    $00(A6,A1.L),D7
          MOVEA.L   $0058(A6),A1
*  Address $1092A
Lab0107   MULU      #$0028,D7
          MOVEA.L   $0030(A6),A2
          ADDA.L    D7,A2
          CMPA.L    $0034(A6),A2
          BHI       Lab0026
          BEQ       Lab0011
          MOVEA.L   $00(A6,A2.L),A0
          RTS
*  Address $10946
Lab0108   MOVEA.L   A0,A1
          SUBA.L    A6,A1
          MOVE.W    D1,D7
          BRA       Lab0110
*  Address $10950
Lplay   SUBA.L    A3,A5
          CMPA.L    #$00000010,A5
          BNE       Lab0027
          LEA       $0008(A3),A5
          MOVEM.L   A3/A5,-(A7)
          MOVEA.W   $0112,A2
          JSR       (A2)
*  
*  ¾¾¾ VECTOR utility $112 : SB.GTINT ¾¾¾
*  

          MOVEM.L   (A7)+,A3/A5
          TST.W     D0
          BNE       Lab0027
          MOVEQ     #$00,D7
          MOVE.W    $00(A6,A1.L),D7
          LEA       $0008(A3),A3
          LEA       $0008(A3),A5
          MOVEA.W   $0116,A2
          JSR       (A2)
*  
*  ¾¾¾ VECTOR utility $116 : SB.GTSTR ¾¾¾
*  

          TST.W     D0
          BNE       Lab0027
*  Address $1098E
Lab0110   TST.W     D7
          BEQ       Lab0027
          CMPI.W    #$0003,D7
          BHI       Lab0027
          SUBQ.W    #1,D7
          MOVEA.L   SV.AYBAS,A3
          MOVEQ     #$00,D6
          MOVE.W    $00(A6,A1.L),D6
          TST.W     D6
          BEQ       Lab0027
          LEA       $010F(A3),A2
          SF        $00(A2,D7.W)
          ADDA.L    A6,A1
          MOVEA.L   A1,A4
          LEA       $0100(A3),A2
          MOVEQ     #$00,D1
          MOVE.B    D7,D1
          LSL.W     #2,D1
          TST.L     $00(A2,D1.W)
          BNE       Lab0112
          MOVE.L    #$00001000,D1
          MOVEQ     #-$01,D2
          MOVEQ     #$18,D0
          TRAP      #1
*  
*  ¾¾¾ QDOS TRAP #1 - D0=$18 : SMS.ACHP ¾¾¾
*  

          TST.W     D0
          BNE       Lab0036
          MOVEA.L   SV.AYBAS,A3
          LEA       $0100(A3),A2
          MOVEQ     #$00,D1
          MOVE.B    D7,D1
          LSL.W     #2,D1
          MOVE.L    A0,$00(A2,D1.W)
          MOVEA.L   A0,A1
          MOVE.W    #$03FF,D1
*  Address $109FA
Lab0111   CLR.L     (A1)+
          DBF       D1,Lab0111
          MOVEA.L   A0,A2
          MOVE.L    #$00001000,D1
          MOVEA.W   $00DC,A1
          JSR       (A1)
*  
*  ¾¾¾ VECTOR utility $0DC : IOQ.SETQ ¾¾¾
*  

          MOVEA.W   $00E0,A1
          MOVEQ     #$01,D1
          JSR       (A1)
*  
*  ¾¾¾ VECTOR utility $0E0 : IOQ.PBYT ¾¾¾
*  

          MOVEQ     #$00,D1
          JSR       (A1)
          MOVEQ     #$02,D1
          JSR       (A1)
          MOVEQ     #$00,D1
          JSR       (A1)
          MOVEQ     #$06,D1
          JSR       (A1)
          MOVEQ     #$00,D1
          JSR       (A1)
          MOVEQ     #$07,D1
          JSR       (A1)
          MOVEQ     #$00,D1
          JSR       (A1)
          MOVEQ     #$08,D1
          JSR       (A1)
          MOVEQ     #$00,D1
          JSR       (A1)
          MOVEQ     #$00,D1
          JSR       (A1)
          MOVEA.L   SV.AYBAS,A3
          LEA       $0118(A3),A2
          MOVE.B    #$04,$00(A2,D7.W)
          LEA       $0112(A3),A2
          MOVE.B    #$05,$00(A2,D7.W)
          BRA.S     Lab0113
*  Address $10A5A
Lab0112   LEA       $0100(A3),A2
          MOVEQ     #$00,D1
          MOVE.B    D7,D1
          LSL.W     #2,D1
          MOVEA.L   $00(A2,D1.W),A0
*  Address $10A68
Lab0113   LEA       Lab0118,A2
          MOVE.L    A2,-(A7)
          LEA       $0120(A3),A2
          MOVE.L    A0,(A2)
          ADDQ.W    #1,D6
          ADDA.L    #$00000002,A4
*  Address $10A7C
Lab0114   MOVEA.L   SV.AYBAS,A3
          MOVEQ     #$00,D0
          SUBQ.W    #1,D6
          BEQ       Lab0030
          MOVEQ     #$00,D1
          MOVE.B    (A4)+,D1
          MOVE.W    D1,D2
          SUB.W     #$0020,D1
          LEA       Lab0240,A0
          MOVE.B    $00(A0,D1.W),D1
          ANDI.L    #$0000000F,D1
          LSL.W     #1,D1
          LEA       Lab0241,A0
          ADDA.L    D1,A0
          ADDA.W    (A0),A0
          JSR       (A0)
          TST.W     D0
          BNE       Lab0030
          BRA.S     Lab0114
*  Address $10AB6
Lab0115   ADDA.L    #$00000004,A7
          BRA       Lab0027
*  Address $10AC0
Lab0116   SUB.B     #$20,D2
          SUB.B     #$41,D2
          LEA       Lab0242,A1
          ANDI.W    #$000F,D2
          LSL.W     #1,D2
          MOVE.W    $00(A1,D2.W),D1
          LEA       Lab0243,A1
          MOVEQ     #$00,D2
          LEA       $0118(A3),A2
          MOVE.B    $00(A2,D7.W),D2
          MULU      #$0018,D2
          ADDA.W    D2,A1
          MOVEQ     #$00,D2
          LEA       $011B(A3),A2
          MOVE.B    $00(A2,D7.W),D2
          EXT.W     D2
          CLR.B     $00(A2,D7.W)
          ADD.W     D2,D1
          AND.L     #$00000FFF,D1
          MOVE.W    $00(A1,D1.W),D1
*  Address $10B06
Lab0117   MOVEQ     #$00,D2
          BRA       Lab0131
*  Address $10B0C
Lab0118   MOVEA.L   SV.AYBAS,A3
          LEA       $010F(A3),A2
          ST        $00(A2,D7.W)
          RTS
*  Address $10B1C
Lab0119   LEA       $011B(A3),A2
          MOVE.B    #$FE,$00(A2,D7.W)
          RTS
*  Address $10B28
Lab0120   LEA       $011B(A3),A2
          MOVE.B    #$02,$00(A2,D7.W)
          RTS
*  Address $10B34
Lab0121   MOVEQ     #$00,D1
          BRA.S     Lab0117
*  Address $10B38
Lab0122   BSR       Lab0134
          CMPI.W    #$0010,D1
          BHI       Lab0010
          MOVEQ     #$01,D2
          BRA       Lab0132
*  Address $10B4A
Lab0123   MOVEQ     #$04,D1
          BRA       Lab0133
*  Address $10B50
Lab0124   BSR       Lab0134
          TST.W     D1
          BEQ       Lab0010
          CMPI.W    #$0003,D1
          BHI       Lab0010
          SUBQ.W    #1,D1
          MOVEQ     #$05,D2
          BRA       Lab0132
*  Address $10B6A
Lab0125   BSR       Lab0134
          CMPI.W    #$0009,D1
          BHI       Lab0010
          LEA       $0118(A3),A2
          MOVE.B    D1,$00(A2,D7.W)
          RTS
*  Address $10B80
Lab0126   BSR       Lab0134
          TST.W     D1
          BEQ.S     Lab0127
          ANDI.W    #$00FF,D1
          MOVEQ     #$06,D2
          BSR       Lab0132
          ST        D1
*  Address $10B94
Lab0127   MOVEQ     #$02,D2
          BRA       Lab0132
*  Address $10B9A
Lab0128   BSR       Lab0134
          MOVEQ     #$03,D2
          BRA       Lab0132
*  Address $10BA4
Lab0129   BSR       Lab0134
          CMPI.W    #$000F,D1
          BHI       Lab0027
          MOVEQ     #$07,D2
          BRA       Lab0132
*  Address $10BB6
Lab0130   BSR       Lab0134
          MOVEQ     #$08,D2
*  Address $10BBC
Lab0131   MOVE.L    D1,-(A7)
          MOVE.W    D2,D1
          BSR       Lab0133
          MOVE.L    (A7)+,D1
          TST.W     D0
          BNE       Lab0030
          MOVE.L    D1,-(A7)
          AND.W     #$00FF,D1
          BSR       Lab0133
          MOVE.L    (A7)+,D1
          TST.W     D0
          BNE       Lab0030
          LSR.W     #8,D1
          AND.W     #$00FF,D1
          BSR       Lab0133
          RTS
*  Address $10BEA
Lab0132   MOVE.L    D1,-(A7)
          MOVE.W    D2,D1
          BSR       Lab0133
          MOVE.L    (A7)+,D1
          TST.W     D0
          BNE       Lab0030
          BSR       Lab0133
          RTS
*  Address $10C00
Lab0133   MOVEA.L   $0120(A3),A2
          MOVEA.W   $00E0,A1
          JSR       (A1)
*  
*  ¾¾¾ VECTOR utility $0E0 : IOQ.PBYT ¾¾¾
*  

          TST.W     D0
          BNE       Lab0030
          MOVEA.L   SV.AYBAS,A3
          RTS
*  Address $10C18
Lab0134   LEA       $0130(A3),A5
          MOVEQ     #$00,D1
*  Address $10C1E
Lab0135   MOVE.B    (A4),D2
          CMPI.B    #$2F,D2
          BLS.S     Lab0136
          CMPI.B    #$39,D2
          BHI.S     Lab0136
          ADDA.L    #$00000001,A4
          ADDQ.W    #1,D1
          SUBQ.W    #1,D6
          MOVE.B    D2,(A5)+
          CMPI.B    #$04,D1
          BNE.S     Lab0135
*  Address $10C3E
Lab0136   TST.B     D1
          BEQ.S     Lab0139
          MOVEQ     #$00,D2
          MOVEQ     #$01,D3
*  Address $10C46
Lab0137   TST.B     D1
          BEQ.S     Lab0138
          MOVEQ     #$00,D4
          MOVE.B    -(A5),D4
          SUB.B     #$30,D4
          MULU      D3,D4
          ADD.W     D4,D2
          MULU      #$000A,D3
          SUBQ.W    #1,D1
          BRA.S     Lab0137
*  Address $10C5E
Lab0138   MOVE.L    D2,D1
*  Address $10C60
Lab0139   RTS
*  Address $10C62
Lrelease  MOVEA.W   $0112,A2
          JSR       (A2)
*  
*  ¾¾¾ VECTOR utility $112 : SB.GTINT ¾¾¾
*  

          TST.W     D3
          BEQ.S     Lab0141
          SUBQ.W    #1,D3
          BNE       Lab0027
          MOVE.W    $00(A6,A1.L),D1
          TST.B     D1
          BEQ.S     Lab0141
          SUBQ.W    #1,D1
          CMPI.W    #$0002,D1
          BHI       Lab0010
          MOVEA.L   SV.AYBAS,A3
          LEA       $0100(A3),A1
          MOVE.W    D1,D2
          LSL.W     #2,D2
          TST.L     $00(A1,D2.W)
          BEQ       Lab0012
          LEA       $010F(A3),A1
          ST        $00(A1,D1.W)
          MOVEQ     #$00,D0
          RTS
*  Address $10CA6
Lab0141   LEA       $010F(A3),A1
          ST        (A1)
          ST        $0001(A1)
          ST        $0002(A1)
          RTS
*  Address $10CB6
Lab0142   MOVEA.W   $0112,A2
          JSR       (A2)
*  
*  ¾¾¾ VECTOR utility $112 : SB.GTINT ¾¾¾
*  

          TST.W     D0
          BNE       Lab0030
          CMPI.W    #$0001,D3
          BNE       Lab0027
          MOVE.W    $00(A6,A1.L),D1
          BSR       Lab0143
          TST.W     D0
          BNE       Lab0030
          MOVE.W    D1,$00(A6,A1.L)
          MOVE.L    A1,$0058(A6)
          MOVEQ     #$00,D0
          MOVEQ     #$03,D4
          RTS
*  Address $10CE6
Lab0143   SUBQ.W    #1,D1
          CMPI.W    #$0002,D1
          BHI       Lab0010
          MOVEA.L   SV.AYBAS,A3
          MOVE.W    D1,D2
          LEA       $0100(A3),A2
          LSL.W     #2,D2
          TST.L     $00(A2,D2.W)
          BEQ       Lab0012
          LEA       $010F(A3),A2
          MOVE.B    $00(A2,D1.W),D1
          ANDI.W    #$0001,D1
          MOVEQ     #$00,D0
          RTS
*  Address $10D16
Lhold   MOVEA.W   $0112,A2
          JSR       (A2)
*  
*  ¾¾¾ VECTOR utility $112 : SB.GTINT ¾¾¾
*  

          TST.W     D3
          BEQ       Lab0145
          CMPI.W    #$0001,D3
          BNE       Lab0027
          MOVE.W    $00(A6,A1.L),D1
          TST.B     D1
          BEQ.S     Lab0145
          SUBQ.W    #1,D1
          CMPI.B    #$02,D1
          BHI       Lab0027
          MOVEA.L   SV.AYBAS,A3
          MOVE.W    D1,D2
          LSL.W     #2,D2
          LEA       $0100(A3),A1
          TST.L     $00(A1,D2.W)
          BEQ       Lab0012
          LEA       $010F(A3),A1
          SF        $00(A1,D1.W)
          MOVEQ     #$00,D0
          RTS
*  Address $10D5E
Lab0145   LEA       $010F(A3),A1
          SF        (A1)
          SF        $0001(A1)
          SF        $0002(A1)
          RTS
*  Address $10D6E
Lenvelope MOVEA.W   $0112,A2
          JSR       (A2)
*  
*  ¾¾¾ VECTOR utility $112 : SB.GTINT ¾¾¾
*  

          TST.W     D0
          BNE       Lab0030
          CMPI.W    #$0002,D3
          BNE       Lab0027
          MOVE.W    $00(A6,A1.L),D1
          CMPI.W    #$000F,D1
          BHI       Lab0010
          MOVE.W    D1,D6
          MOVE.W    $02(A6,A1.L),D1
          CMPI.W    #$0FFF,D1
          BHI       Lab0010
          MOVE.W    D1,D7
          MOVE.W    D6,D1
          MOVEQ     #$0D,D2
          BSR       Lab0013
          MOVE.W    D7,D1
          ANDI.W    #$00FF,D1
          MOVEQ     #$0B,D2
          BSR       Lab0013
          MOVE.W    D7,D1
          LSR.W     #8,D1
          MOVEQ     #$0C,D2
          BSR       Lab0013
          MOVEQ     #$00,D0
          RTS
*  Address $10DC0
Lab0147   MOVEQ     #$00,D7
          BSR       Lab0148
          MOVEQ     #$01,D7
          BSR       Lab0148
          MOVEQ     #$02,D7
*  Address $10DCE
Lab0148   MOVEA.L   SV.AYBAS,A3
          LEA       $0100(A3),A2
          MOVE.L    D7,D6
          LSL.W     #2,D6
          TST.L     $00(A2,D6.W)
          BEQ       Lab0030
          LEA       $010F(A3),A2
          TST.B     $00(A2,D7.W)
          BEQ       Lab0030
          MOVEQ     #$00,D1
          LEA       $0115(A3),A2
          MOVE.B    $00(A2,D7.W),D1
          TST.B     D1
          BEQ.S     Lab0149
          SUBQ.W    #1,D1
          MOVE.B    D1,$00(A2,D7.W)
          RTS
*  Address $10E06
Lab0149   BSR       Lab0163
          TST.W     D0
          BNE       Lab0154
          CMPI.B    #$08,D1
          BHI       Lab0154
          ANDI.L    #$0000000F,D1
          LEA       Lab0239,A0
          LSL.W     #1,D1
          ADDA.W    D1,A0
          ADDA.W    (A0),A0
          JMP       (A0)
*  Address $10E2A
Lab0150   LEA       $0112(A3),A2
          LEA       $0115(A3),A4
          MOVE.B    $00(A2,D7.W),$00(A4,D7.W)
          RTS
*  Address $10E3A
Lab0151   LEA       $0115(A3),A2
          CLR.B     $00(A2,D7.W)
          RTS
*  Address $10E44
Lab0152   BSR       Lab0163
          TST.W     D0
          BNE.S     Lab0154
          MOVE.W    D1,D4
          BSR       Lab0163
          TST.W     D0
          BNE.S     Lab0154
          MOVE.W    D1,D5
          MOVEQ     #$00,D6
          MOVE.B    D7,D6
          LSL.W     #1,D6
          MOVE.W    D6,D2
          MOVE.W    D4,D1
          BSR       Lab0013
          ADDQ.W    #1,D6
          MOVE.W    D6,D2
          MOVE.W    D5,D1
          BSR       Lab0013
          BRA       Lab0150
*  Address $10E74
Lab0153   BSR       Lab0163
          TST.W     D0
          BNE.S     Lab0154
          LEA       $0112(A3),A2
          MOVE.B    D1,$00(A2,D7.W)
          BRA       Lab0149
*  Address $10E88
Lab0154   LEA       $010F(A3),A2
          SF        $00(A2,D7.W)
          BRA       Lab0150
*  Address $10E94
Lab0155   BSR       Lab0163
          TST.W     D0
          BNE.S     Lab0154
          ANDI.W    #$00FF,D1
          LEA       $010F(A3),A2
          ST        $00(A2,D1.W)
          BRA       Lab0151
*  Address $10EAC
Lab0156   BSR       Lab0163
          TST.W     D0
          BNE.S     Lab0154
          MOVEQ     #$06,D2
          BSR       Lab0013
          BRA       Lab0151
*  Address $10EBE
Lab0157   BSR       Lab0163
          TST.W     D0
          BNE.S     Lab0154
          TST.B     D1
          BEQ.S     Lab0158
          MOVEQ     #$08,D2
          ADD.B     D7,D2
          BSR       Lab0013
          MOVEQ     #$07,D2
          BSR       Lab0016
          BCLR      D7,D1
          BSR       Lab0013
          BRA       Lab0149
*  Address $10EE2
Lab0158   MOVEQ     #$08,D2
          ADD.B     D7,D2
          BSR       Lab0013
          MOVEQ     #$07,D2
          BSR       Lab0016
          BSET      D7,D1
          BSR       Lab0013
          BRA       Lab0149
*  Address $10EFA
Lab0159   BSR       Lab0163
          TST.W     D0
          BNE.S     Lab0154
          TST.B     D1
          BEQ       Lab0160
          MOVE.W    D7,D6
          ADDQ.W    #3,D6
          MOVEQ     #$07,D2
          BSR       Lab0016
          BCLR      D6,D1
          MOVEQ     #$07,D2
          BSR       Lab0013
          BRA       Lab0149
*  Address $10F1E
Lab0160   MOVE.W    D7,D6
          ADDQ.W    #3,D6
          MOVEQ     #$07,D2
          BSR       Lab0016
          BSET      D6,D1
          MOVEQ     #$07,D2
          BSR       Lab0013
          BRA       Lab0149
*  Address $10F34
Lab0161   BSR       Lab0163
          TST.W     D0
          BNE       Lab0154
          MOVEQ     #$0D,D2
          BSR       Lab0013
          BRA       Lab0149
*  Address $10F48
Lab0162   BSR       Lab0163
          TST.W     D0
          BNE       Lab0154
          MOVE.W    D1,D4
          BSR       Lab0163
          TST.W     D0
          BNE       Lab0154
          MOVE.W    D1,D5
          MOVE.W    D4,D1
          MOVEQ     #$0B,D2
          BSR       Lab0013
          MOVE.W    D5,D1
          MOVEQ     #$0C,D2
          BSR       Lab0013
          BRA       Lab0149
*  Address $10F74
Lab0163   MOVEA.L   SV.AYBAS,A3
          LEA       $0100(A3),A2
          MOVEQ     #$00,D5
          MOVE.B    D7,D5
          LSL.W     #2,D5
          MOVEA.L   $00(A2,D5.W),A2
          MOVEA.W   $00E2,A1
          JSR       (A1)
*  
*  ¾¾¾ VECTOR utility $0E2 : IOQ.GBYT ¾¾¾
*  

          MOVEA.L   SV.AYBAS,A3
          ANDI.L    #$000000FF,D1
          RTS
*  Address $10F9C
control   MOVEA.L   SV.AYBAS,A4
          TST.L     $0154(A4)
          BEQ.S     Lab0165
          MOVE.L    $0154(A4),D1
          MOVEQ     #$00,D2
          MOVEQ     #$02,D0
          TRAP      #1
*  
*  ¾¾¾ QDOS TRAP #1 - D0=$02 : SMS.INJB ¾¾¾
*  

          TST.W     D0
          BEQ       Lab0030
*  Address $10FB8
Lab0165   MOVEQ     #$00,D1
          MOVE.L    #$0000001C,D2
          MOVE.W    #$00C8,D3
          SUBA.L    A1,A1
          MOVEQ     #$01,D0
          TRAP      #1
*  
*  ¾¾¾ QDOS TRAP #1 - D0=$01 : SMS.CRJB ¾¾¾
*  

          TST.W     D0
          BNE       Lab0030
          MOVEA.L   A0,A1
          MOVE.W    #$4EF9,(A1)+
          LEA       Lab0166,A2
          MOVE.L    A2,(A1)+
          MOVE.W    #$4AFB,(A1)+
          MOVE.W    #$000D,(A1)+
          MOVE.L    #$496E7075,(A1)+
          MOVE.L    #$7420436F,(A1)+
          MOVE.L    #$6E74726F,(A1)+
          MOVE.B    #$6C,(A1)
          MOVEQ     #$01,D2
          MOVEQ     #$00,D3
          MOVEQ     #$0A,D0
          TRAP      #1
*  
*  ¾¾¾ QDOS TRAP #1 - D0=$0A : SMS.ACJB ¾¾¾
*  

          MOVE.L    D1,$0154(A4)
          RTS
*  Address $11008
Lab0166   MOVEQ     #$00,D0
          TRAP      #1
*  
*  ¾¾¾ QDOS TRAP #1 - D0=$00 : SMS.INFO ¾¾¾
*  

          MOVEA.L   A0,A6
          LEA       Lab0244,A1 ; $11A04
          MOVEA.W   $00C8,A0
          JSR       (A0)
*  
*  ¾¾¾ VECTOR utility $0C8 : OPW.SCR ¾¾¾
*  

          MOVEA.L   A0,A5
*  Address $1101A
Lab0167   MOVEA.L   $004C(A6),A4
          MOVEA.L   $0078(A6),A3
          MOVE.W    $0072(A6),D7
          SUBQ.W    #1,D7
*  Address $11028
Lab0168   MOVEA.L   (A3)+,A2
          ADDA.L    #$00000068,A2
          CMPA.L    A2,A4
          BEQ.S     Lab0169
          DBF       D7,Lab0168
          BRA.S     Lab0167
*  Address $1103A
Lab0169   SUBA.L    #$00000068,A2
          MOVE.L    $0014(A2),D1
          MOVE.L    $0008(A2),D2
          MOVE.L    D1,D7
          MOVEQ     #$02,D0
          TRAP      #1
*  
*  ¾¾¾ QDOS TRAP #1 - D0=$02 : SMS.INJB ¾¾¾
*  

          LEA       $0008(A0),A0
          MOVEA.L   A0,A4
          MOVEA.L   A5,A0
          MOVEA.L   SV.AYBAS,A3
          CMP.L     $0150(A3),D7
          BNE.S     Lab0170
          MOVEQ     #$00,D1
          MOVEQ     #$00,D2
          MOVEQ     #$10,D0
          TRAP      #3
*  
*  ¾¾¾ QDOS TRAP #3 - D0=$10 : IOW.SCUR ¾¾¾
*  

          BRA.S     Lab0171
*  Address $1106C
Lab0170   MOVE.L    D7,$0150(A3)
          MOVEQ     #-$01,D3
          MOVEQ     #$20,D0
          TRAP      #3
*  
*  ¾¾¾ QDOS TRAP #3 - D0=$20 : IOW.CLRA ¾¾¾
*  

*  Address $11076
Lab0171   MOVEQ     #$02,D1
          MOVEQ     #$00,D2
          MOVEQ     #-$01,D3
          MOVEQ     #$2D,D0
          TRAP      #3
*  
*  ¾¾¾ QDOS TRAP #3 - D0=$2D : IOW.SSIZ ¾¾¾
*  

          MOVEA.W   $00D0,A2
          LEA       LMcurjob,A1
          JSR       (A2)
*  
*  ¾¾¾ VECTOR utility $0D0 : UT.WTEXT ¾¾¾
*  

          TST.L     D7
          BNE.S     Lab0172
          LEA       LMsuperb,A4
*  Address $11092
Lab0172   MOVEA.L   A4,A1
          MOVE.W    (A1)+,D2
          CMPI.W    #$000A,D2
          BLS.S     Lab0173
          MOVEQ     #$0A,D2
*  Address $1109E
Lab0173   MOVEQ     #$07,D0
          TRAP      #3
*  
*  ¾¾¾ QDOS TRAP #3 - D0=$07 : IOB.SMUL ¾¾¾
*  

          MOVEQ     #$04,D1
          MOVEQ     #$01,D2
          MOVEQ     #$0C,D0
          TRAP      #3
*  
*  ¾¾¾ QDOS TRAP #3 - D0=$0C : IOW.DEFB ¾¾¾
*  

          MOVEQ     #$24,D0
          TRAP      #3
*  
*  ¾¾¾ QDOS TRAP #3 - D0=$24 : IOW.CLRR ¾¾¾
*  

          MOVEQ     #$12,D0
          TRAP      #3
*  
*  ¾¾¾ QDOS TRAP #3 - D0=$12 : IOW.NEWL ¾¾¾
*  

          LEA       LMjob,A1
          MOVEA.W   $00D0,A2
          JSR       (A2)
*  
*  ¾¾¾ VECTOR utility $0D0 : UT.WTEXT ¾¾¾
*  

          MOVE.W    D7,D1
          MOVEA.W   $00CE,A1
          JSR       (A1)
*  
*  ¾¾¾ VECTOR utility $0CE : UT.WINT ¾¾¾
*  

          MOVEQ     #$24,D0
          TRAP      #3
*  
*  ¾¾¾ QDOS TRAP #3 - D0=$24 : IOW.CLRR ¾¾¾
*  

          BRA       Lab0167
*  Address $110CC
Lab0174   TST.W     D1
          BEQ       Lab0182
          MOVE.W    D2,D0
          OR.W      D3,D0
          BEQ       Lab0178
          MOVEM.L   D4-D7/A0-A4,-(A7)
          ANDI.L    #$00000FFF,D1
          MOVE.L    #$00016E36,D4
          DIVU      D1,D4
          MOVE.L    D2,D5
          MOVE.B    D4,D1
          BSR       Lab0013
          MOVE.W    D4,D1
          LSR.W     #8,D1
          ADDQ.W    #1,D2
          BSR       Lab0013
          ADDQ.W    #7,D2
          MOVE.B    D3,D1
          BSR       Lab0013
          MOVEQ     #$07,D2
          BSR       Lab0016
          BCLR      D5,D1
          MOVE.L    D5,D2
          ADDQ.W    #3,D5
          BSET      D5,D1
          BSR       Lab0013
          MOVEM.L   (A7)+,D4-D7/A0-A4
          RTS
*  Address $1111E
Lsound    MOVEA.W   $0114,A2
          JSR       (A2)
*  
*  ¾¾¾ VECTOR utility $114 : SB.GTFP ¾¾¾
*  

          TST.W     D3
          BEQ       Lab0182
          CMPI.W    #$0001,D3
          BEQ       Lab0179
          CMPI.W    #$0003,D3
          BNE       Lab0027
          MOVEA.W   $011C,A2
          MOVEQ     #$04,D0
          JSR       (A2)
*  
*  ¾¾¾ VECTOR utility $11C : QA.OP ¾¾¾
*  

          TST.W     D0
          BNE       Lab0030
          MOVE.W    $00(A6,A1.L),D4
          TST.W     D4
          BEQ       Lab0010
          CMPI.W    #$0003,D4
          BHI       Lab0010
          MOVEA.L   SV.AYBAS,A0
          LEA       $0140(A0),A0
          SUBQ.W    #1,D4
          MOVE.W    D4,(A0)
          SUBA.L    #$00000004,A1
          MOVE.L    #$08115B8D,$00(A6,A1.L)
          MOVE.W    #$8000,$04(A6,A1.L)
          TST.L     $06(A6,A1.L)
          BNE       Lab0176
          TST.W     $0A(A6,A1.L)
          BNE       Lab0176
          ADDA.L    #$0000000C,A1
          MOVEA.L   SV.AYBAS,A0
          LEA       $0140(A0),A0
          CLR.W     $0002(A0)
          BRA       Lab0177
*  Address $111A4
Lab0176   MOVEA.L   SV.AYBAS,A0
          LEA       $0140(A0),A0
          MOVE.L    $00(A6,A1.L),$0002(A0)
          MOVE.W    $04(A6,A1.L),$0006(A0)
          MOVE.L    $06(A6,A1.L),$00(A6,A1.L)
          MOVE.W    $0A(A6,A1.L),$04(A6,A1.L)
          MOVE.L    $0002(A0),$06(A6,A1.L)
          MOVE.W    $0006(A0),$0A(A6,A1.L)
          MOVEA.W   $011E,A2
          LEA       Lab0237,A3
          JSR       (A2)
*  
*  ¾¾¾ VECTOR utility $11E : QA.MOP ¾¾¾
*  

          TST.W     D0
          BNE       Lab0030
          MOVEA.L   SV.AYBAS,A0
          LEA       $0140(A0),A0
          MOVE.W    $00(A6,A1.L),$0002(A0)
          ADDA.L    #$00000002,A1
*  Address $111F8
Lab0177   MOVEA.W   $011C,A2
          MOVEQ     #$04,D0
          JSR       (A2)
*  
*  ¾¾¾ VECTOR utility $11C : QA.OP ¾¾¾
*  

          TST.W     D0
          BNE       Lab0030
          MOVEA.L   SV.AYBAS,A0
          LEA       $0140(A0),A0
          MOVE.W    $00(A6,A1.L),$0004(A0)
          CMPI.W    #$0FFF,$0002(A0)
          BHI       Lab0010
          CMPI.W    #$0010,$0004(A0)
          BHI       Lab0010
          MOVEQ     #$00,D2
          MOVE.W    (A0),D2
          ADD.W     D2,D2
          MOVEQ     #$00,D1
          MOVE.W    $0002(A0),D1
          ANDI.W    #$00FF,D1
          BSR       Lab0013
          MOVE.W    $0002(A0),D1
          LSR.W     #8,D1
          ANDI.W    #$000F,D1
          ADDQ.W    #1,D2
          BSR       Lab0013
          MOVEQ     #$08,D2
          ADD.W     (A0),D2
          MOVE.W    $0004(A0),D1
          BSR       Lab0013
          MOVEQ     #$07,D2
          BSR       Lab0016
          MOVE.W    (A0),D3
          BCLR      D3,D1
          ADDQ.W    #3,D3
          BSET      D3,D1
          BSR       Lab0013
          MOVEQ     #$00,D0
          RTS
*  Address $11270
Lab0178   MOVE.W    D1,D4
          BRA.S     Lab0180
*  Address $11274
Lab0179   MOVEQ     #$04,D0
          MOVEA.W   $011C,A2
          JSR       (A2)
*  
*  ¾¾¾ VECTOR utility $11C : QA.OP ¾¾¾
*  

          TST.W     D0
          BNE       Lab0030
          MOVE.W    $00(A6,A1.L),D4
*  Address $11286
Lab0180   TST.W     D4
          BEQ       Lab0010
          CMPI.W    #$0003,D4
          BHI       Lab0010
          SUBQ.W    #1,D4
          MOVE.W    D4,D2
          MOVEQ     #$00,D3
          MOVE.B    D4,D3
          ADD.W     D2,D2
          MOVEQ     #$00,D1
          BSR       Lab0013
          ADDQ.W    #1,D2
          BSR       Lab0013
          MOVE.W    D4,D2
          ADDQ.W    #8,D2
          BSR       Lab0013
          MOVEQ     #$07,D2
          BSR       Lab0016
          BSET      D3,D1
          BSR       Lab0013
          MOVEA.L   SV.AYBAS,A3
          ANDI.L    #$0000000F,D4
          LEA       $010F(A3),A1
          SF        $00(A1,D4.W)
          MOVE.W    #$4000,D1
*  Address $112D6
Lab0181   DBF       D1,Lab0181
          LEA       $0100(A3),A1
          LSL.W     #2,D4
          TST.L     $00(A1,D4.W)
          BEQ       Lab0030
          MOVEA.L   $00(A1,D4.W),A0
          CLR.L     $00(A1,D4.W)
          MOVEQ     #$19,D0
          TRAP      #1
*  
*  ¾¾¾ QDOS TRAP #1 - D0=$19 : SMS.RCHP ¾¾¾
*  

          MOVEQ     #$00,D0
          RTS
*  Address $112F8
Lab0182   BSR       Lab0019
          MOVEA.L   SV.AYBAS,A3
          TST.L     $0100(A3)
          BEQ.S     Lab0183
          MOVEA.L   $0100(A3),A0
          MOVEQ     #$19,D0
          TRAP      #1
*  
*  ¾¾¾ QDOS TRAP #1 - D0=$19 : SMS.RCHP ¾¾¾
*  

          MOVEA.L   SV.AYBAS,A3
          CLR.L     $0100(A3)
*  Address $1131A
Lab0183   TST.L     $0104(A3)
          BEQ.S     Lab0184
          MOVEA.L   $0104(A3),A0
          MOVEQ     #$19,D0
          TRAP      #1
*  
*  ¾¾¾ QDOS TRAP #1 - D0=$19 : SMS.RCHP ¾¾¾
*  

          MOVEA.L   SV.AYBAS,A3
          CLR.L     $0104(A3)
*  Address $11332
Lab0184   TST.L     $0108(A3)
          BEQ.S     Lab0185
          MOVEA.L   $0108(A3),A0
          MOVEQ     #$19,D0
          TRAP      #1
*  
*  ¾¾¾ QDOS TRAP #1 - D0=$19 : SMS.RCHP ¾¾¾
*  

          MOVEA.L   SV.AYBAS,A3
          CLR.L     $0108(A3)
*  Address $1134A
Lab0185   RTS
*  Address $1134C
Lrepdelay LEA       $0002808C,A4
*  Address $11352
Lab0187   MOVEA.W   $0112,A2
          JSR       (A2)
*  
*  ¾¾¾ VECTOR utility $112 : SB.GTINT ¾¾¾
*  

          SUBQ.W    #1,D3
          BNE       Lab0027
          MOVE.W    $00(A6,A1.L),(A4)
          RTS
*  Address $11364
Lrepfreq  LEA       $0002808E,A4
          BRA.S     Lab0187
*  Address $1136C
Lab0189   MOVEA.W   $0114,A2
          JSR       (A2)
*  
*  ¾¾¾ VECTOR utility $114 : SB.GTFP ¾¾¾
*  

          SUBQ.W    #1,D3
          BNE       Lab0027
          TST.L     $00(A6,A1.L)
          BNE.S     Lab0190
          TST.W     $04(A6,A1.L)
          BEQ       Lab0191
*  Address $11386
Lab0190   MOVEA.W   $011C,A2
          MOVEQ     #$16,D0
          JSR       (A2)
*  
*  ¾¾¾ VECTOR utility $11C : QA.OP ¾¾¾
*  

          MOVEQ     #$12,D0
          JSR       (A2)
          MOVEQ     #$10,D0
          JSR       (A2)
*  Address $11396
Lab0191   MOVEQ     #$02,D4
          RTS
*  Address $1139A
Lab0192   MOVEA.W   $0114,A2
          JSR       (A2)
*  
*  ¾¾¾ VECTOR utility $114 : SB.GTFP ¾¾¾
*  

          TST.W     D0
          BNE       Lab0030
          LEA       Lab0193,A3
          MOVEA.W   $011E,A2
          JSR       (A2)
*  
*  ¾¾¾ VECTOR utility $11E : QA.MOP ¾¾¾
*  

          BRA.S     Lab0191

*  Bytes Data Block [113B2,113B7]
*  Address $113B2
Lab0193   
          DC.B      $12,$16,$04,$08
          DC.B      $0C,$00
*  Address $113B8
Lchannels BSR       Lab0106
          BSR       Lab0218
          LEA       LMchanty,A1
          MOVEA.W   $00D0,A2
          MOVEA.W   $00CE,A3
          JSR       (A2)
          MOVEA.L   $0030(A6),A4
          MOVEQ     #$00,D7
*  Address $113D4
Lab0195   CMPA.L    $0034(A6),A4
          BEQ       Lab0201
          MOVEQ     #$23,D1
          BSR       Lab0209
          MOVE.L    D7,D1
          JSR       (A3)
*  
*  ¾¾¾ VECTOR utility $0CE : UT.WINT ¾¾¾
*  

          MOVEQ     #$09,D1
          BSR       Lab0223
          MOVE.L    $00(A6,A4.L),D1
          BMI       Lab0202
          MOVEA.L   $00028078,A5
          MOVEQ     #$00,D2
          MOVE.W    D1,D2
          LSL.W     #2,D2
          ADDA.W    D2,A5
          MOVEA.L   (A5),A5
          SWAP      D1
          CMP.W     $0010(A5),D1
          BNE       Lab0203
          CMPI.L    #$00020000,$0032(A5)
          BEQ.S     Lab0197
          CMPI.L    #$00028000,$0032(A5)
          BEQ.S     Lab0197
          TST.W     $0032(A5)
          BEQ.S     Lab0196
          CMPI.W    #$0024,$0032(A5)
          BLS.S     Lab0198
*  Address $11430
Lab0196   LEA       LMnoiden,A1
          JSR       (A2)
          MOVE.W    $0002(A5),D1
          JSR       (A3)
          BRA.S     Lab0199
*  Address $1143E
Lab0197   LEA       LMscr,A1
          JSR       (A2)
          MOVE.W    $001C(A5),D1
          JSR       (A3)
          MOVEQ     #$78,D1
          BSR       Lab0209
          MOVE.W    $001E(A5),D1
          JSR       (A3)
          MOVEQ     #$61,D1
          BSR       Lab0209
          MOVE.W    $0018(A5),D1
          JSR       (A3)
          MOVEQ     #$78,D1
          BSR       Lab0209
          MOVE.W    $001A(A5),D1
          JSR       (A3)
          BRA.S     Lab0199
*  Address $11470
Lab0198   LEA       $0032(A5),A1
          JSR       (A2)
*  Address $11476
Lab0199   BSR       Lab0218
*  Address $1147A
Lab0200   ADDQ.W    #1,D7
          ADDA.W    #$0028,A4
          TST.B     $008F(A6)
          BEQ.S     Lab0203
          BRA       Lab0195
*  Address $1148A
Lab0201   MOVEQ     #$00,D0
          RTS
*  Address $1148E
Lab0202   LEA       LMnoope,A1
          JSR       (A2)
          BRA.S     Lab0200
*  Address $11496
Lab0203   MOVEQ     #-$01,D0
          RTS
*  Address $1149A
Lsystem   BSR       Lab0106
          BSR       Lab0218
          LEA       LMq2ver,A1
          MOVEA.W   $00D0,A5
          JSR       (A5)
*  
*  ¾¾¾ VECTOR utility $0D0 : UT.WTEXT ¾¾¾
*  

          MOVEA.L   #$0000BFF6,A1
          MOVEQ     #$07,D0
          MOVEQ     #-$01,D3
          MOVEQ     #$04,D2
          TRAP      #3
*  
*  ¾¾¾ QDOS TRAP #3 - D0=$07 : IOB.SMUL ¾¾¾
*  

          LEA       LMrom,A1
          JSR       (A5)
          MOVEA.L   #$0000BFFC,A1
          MOVEQ     #$02,D2
          MOVEQ     #$07,D0
          TRAP      #3
*  
*  ¾¾¾ QDOS TRAP #3 - D0=$07 : IOB.SMUL ¾¾¾
*  

          BSR       Lab0218
          TST.W     $00028088
          BEQ.S     Lab0205
          LEA       LMcaps,A1
          JSR       (A5)
*  Address $114DE
Lab0205   LEA       LMrepeat,A1
          JSR       (A5)
          MOVE.W    $0002808E,D1
          MOVEA.W   $00CE,A4
          JSR       (A4)
*  
*  ¾¾¾ VECTOR utility $0CE : UT.WINT ¾¾¾
*  

          LEA       LMafter,A1
          JSR       (A5)
          MOVE.W    $0002808C,D1
          JSR       (A4)
          BSR       Lab0218
          LEA       LMdirdev,A1
          JSR       (A5)
          LEA       $00028048,A4
*  Address $1150E
Lab0206   TST.L     (A4)
          BEQ.S     Lab0208
          MOVEA.L   (A4),A4
          LEA       $0024(A4),A1
          CMPI.W    #$0014,(A1)
          BHI.S     Lab0207
          JSR       (A5)
*  Address $11520
Lab0207   MOVEQ     #$20,D1
          BSR.S     Lab0209
          BRA.S     Lab0206
*  Address $11526
Lab0208   BSR       Lab0218
          MOVEQ     #$00,D0
          RTS
*  Address $1152E
Lab0209   MOVEQ     #$05,D0
          MOVEQ     #-$01,D3
          TRAP      #3
*  
*  ¾¾¾ QDOS TRAP #3 - D0=$05 : IOB.SBYT ¾¾¾
*  

          RTS
*  Address $11536
Lextras   BSR       Lab0106
          MOVEQ     #$00,D7
          BSR       Lab0218
          BSR       Lab0218
          MOVEA.L   $0018(A6),A3
*  Address $11548
Lab0211   MOVEQ     #$0E,D1
          AND.B     $00(A6,A3.L),D1
          SUBQ.B    #8,D1
          BNE.S     Lab0212
          CMPI.L    #$0000C000,$04(A6,A3.L)
          BLT.S     Lab0212
          MOVE.L    A3,D1
          BSR       Lab0214
          BSR       Lab0221
          BSR       Lab0219
          BNE.S     Lab0213
          BSR       Lab0218
          BNE.S     Lab0213
*  Address $11572
Lab0212   ADDQ.L    #8,A3
          CMPA.L    $001C(A6),A3
          BLT.S     Lab0211
*  Address $1157A
Lab0213   RTS
*  Address $1157C
Lab0214   MOVEQ     #$00,D3
          MOVE.W    $02(A6,D1.L),D3
          ADD.L     $0020(A6),D3
          BSR.S     Lab0215
          RTS
*  Address $1158A
Lab0215   MOVEQ     #$03,D1
          ADD.B     $00(A6,D3.L),D1
          BCLR      #$00,D1
          BSR.S     Lab0217
          ADD.W     D1,D3
*  Address $11598
Lab0216   SUBQ.L    #1,D3
          SUBQ.L    #1,A1
          MOVE.B    -$01(A6,D3.L),$00(A6,A1.L)
          SUBQ.W    #1,D1
          BGT.S     Lab0216
          CLR.B     $00(A6,A1.L)
          RTS
*  Address $115AC
Lab0217   MOVEA.W   $011A,A2
          MOVEM.L   D1-D3,-(A7)
          JSR       (A2)
*  
*  ¾¾¾ VECTOR utility $11A : QA.RESRI ¾¾¾
*  

          MOVEM.L   (A7)+,D1-D3
          MOVEA.L   $0058(A6),A1
          RTS
*  Address $115C0
Lab0218   MOVEQ     #$0A,D1
          MOVEQ     #$05,D0
          BRA.S     Lab0220
*  Address $115C6
Lab0219   MOVE.W    $00(A6,A1.L),D2
          ADDQ.L    #2,A1
          MOVEQ     #$07,D0
          TRAP      #4
*  Address $115D0
Lab0220   MOVE.L    D3,-(A7)
          MOVEQ     #-$01,D3
          TRAP      #3
          MOVE.L    (A7)+,D3
          TST.L     D0
          RTS
*  Address $115DC
Lab0221   TST.W     D7
          BEQ       Lab0222
          MOVEM.L   D1-D3,-(A7)
          MOVE.W    D7,D1
          ADD.W     #$000C,D1
          BSR.S     Lab0223
          MOVEM.L   (A7)+,D1-D3
          TST.W     D0
          BEQ.S     Lab0222
          BSR.S     Lab0218
          MOVEQ     #$00,D7
*  Address $115FA
Lab0222   MOVEM.L   D1-D3,-(A7)
          MOVE.W    D7,D1
          BSR.S     Lab0223
          MOVEM.L   (A7)+,D1-D3
          ADD.W     #$000C,D7
          RTS
*  Address $1160C
Lab0223   MOVEQ     #$11,D0
          MOVEQ     #-$01,D3
          TRAP      #3
*  
*  ¾¾¾ QDOS TRAP #3 - D0=$11 : IOW.SCOL ¾¾¾
*  

          RTS
*  Address $11614
Lab0224   LEA       $00028000,A1
          MOVEA.L   $006C(A1),A2
          MOVEA.L   $0068(A1),A1
          ADDQ.L    #4,A1
          MOVEQ     #$01,D2
*  Address $11626
Lab0225   MOVEA.L   (A1)+,A3
          MOVE.W    $0010(A3),D1
          SWAP      D1
          MOVE.W    D2,D1
          ADDQ.W    #1,D2
          MOVEM.L   D2/A1-A2,-(A7)
          MOVEQ     #$05,D0
          MOVEQ     #$00,D3
          TRAP      #1
*  
*  ¾¾¾ QDOS TRAP #1 - D0=$05 : SMS.FRJB ¾¾¾
*  

*  Address $1163C
Lab0226   MOVEM.L   (A7)+,D2/A1-A2
          CMPA.L    A1,A2
          BNE.S     Lab0225
          MOVEQ     #$00,D0
          RTS

** Basic definitions
*  Def SB extensions
*  Address $11648
Lab0227   DC.W      38

          DC.W      Lexchg-*
          DC.B      5,'EXCHG'

          DC.W      Lbell-*
          DC.B      4,'BELL',32

          DC.W      Lexplode-*
          DC.B      7,'EXPLODE'

          DC.W      Lshoot-*
          DC.B      5,'SHOOT'

          DC.W      Lpokeay-*
          DC.B      7,'POKE_AY'

          DC.W      Llistay-*
          DC.B      7,'LIST_AY'

          DC.W      Lplay-*
          DC.B      4,'PLAY',32

          DC.W      Lhold-*
          DC.B      4,'HOLD',32

          DC.W      Lrelease-*
          DC.B      7,'RELEASE'

          DC.W      Lenvelope-*
          DC.B      8,'ENVELOPE',32

          DC.W      Lparuse-*
          DC.B      7,'PAR_USE'

          DC.W      Lparstop-*
          DC.B      8,'PAR_STOP',32

          DC.W      Lenglish-*
          DC.B      7,'ENGLISH'

          DC.W      Lgerman-*
          DC.B      6'GERMAN',32

          DC.W      Lfrench-*
          DC.B      6,'FRENCH',32

          DC.W      Lspanish-*
          DC.B      7,'SPANISH'

          DC.W      Litalian-*
          DC.B      7,'ITALIAN'

          DC.W      Lenglish-*
          DC.B      8,'AMERICAN',32

          DC.W      Lenglish-*
          DC.B      7,'GRAPHIC'

          DC.W      Ltranslat-*
          DC.B      9,'TRANSLATE'

          DC.W      Lcurflash-*
          DC.B      9,'CUR_FLASH'

          DC.W      Lup-*
          DC.B      2,'UP',32

          DC.W      Ldown-*
          DC.B      4,'DOWN',32

          DC.W      Lleft-*
          DC.B      4,'LEFT',32

          DC.W      Lright-*
          DC.B      5,'RIGHT'

          DC.W      Lcursen-*
          DC.B      6,'CURSEN',32

          DC.W      Lcurdis-*
          DC.B      6,'CURDIS',32

          DC.W      Lnewfont-*
          DC.B      8,'NEW_FONT',32

          DC.W      Loldfont-*
          DC.B      8,'OLD_FONT',32

          DC.W      Lcontrol-*
          DC.B      7,'CONTROL'

          DC.W      Lsound-*
          DC.B      5,'SOUND'

          DC.W      Lextras-*
          DC.B      6,'EXTRAS',32

          DC.W      Lsystem-*
          DC.B      6,'SYSTEM',32

          DC.W      Lchannels-*
          DC.B      8,'CHANNELS',32

          DC.W      Lrepdelay-*
          DC.B      9,'REP_DELAY'

          DC.W      Lrepfreq-*
          DC.B      8,'REP_FREQ',32

          DC.W      Lab0224-*
          DC.B      6,'RJOB_A',32

          DC.W      Lhome-*
          DC.B      4,'HOME',32

          DC.W      0
          DC.W      8

          DC.W      Lab0079-*
          DC.B      7,'PEEK_AY'

          DC.W      Lab0142-*
          DC.B      7,'PLAYING'

          DC.W      Lab0089-*
          DC.B      5,'QDOS$'

          DC.W      Lab0080-*
          DC.B      6,'D_MODE',32

          DC.W      Lab0081-*
          DC.B      6,'D_TYPE',32

          DC.W      Lab0082-*
          DC.B      6,'NET_NR',32

          DC.W      Lab0189-*
          DC.B      3,'SGN'

          DC.W      Lab0192-*
          DC.B      4,'FRAC',32

          DC.W      0
*  End SB ext

*  Bytes Data Block [11810,11813]
LTquiet   DC.B      $00,$00,$00,$00,$00,$00,$00,$FF,$00,$00,$00,$00,$00,$00
LTexplode DC.B      $00,$00,$00,$00,$00,$00,$1F,$07,$10,$10,$10,$00,$10,$00
LTshoot   DC.B      $00,$00,$00,$00,$00,$00,$10,$07,$10,$10,$10,$00,$03,$00
LTbell    DC.B      $64,$00,$65,$00,$00,$00,$00,$F8,$10,$10,$00,$00,$04,$00
LTgong    DC.B      $3C,$00,$3D,$00,$3F,$00,$00,$F8,$10,$10,$10,$00,$09,$00

*  Address $11856
Lab0236   
          DC.B      $01,$FA,$01,$68
          DC.B      $01,$B8,$02,$00
          DC.B      $02,$14,$09,$46
          DC.B      $0C,$E6,$0D,$2E
          DC.B      $0C,$76,$02,$26
          DC.B      $10,$CC,$06,$96

*  Bytes Data Block [1186E,11870]
*  Address $1186E
Lab0237   
          DC.B      $10,$04,$00

*  Undecoded code in [11871,11A03]
*  Address $11871
Lab0238   
          DC.B      $00
*  Address $11872
Lab0239   
          DC.B      $F5,$D2,$F6,$4A
          DC.B      $F6,$84,$F5,$FC
          DC.B      $F6,$0E,$F6,$18
          DC.B      $F6,$2E,$F6,$B4
          DC.B      $F6,$C6
*  Address $11884
Lab0240   
          DC.B      $00,$00,$00,$01
          DC.B      $00,$00,$00,$00
          DC.B      $00,$00,$00,$00
          DC.B      $00,$00,$00,$00
          DC.B      $00,$00,$00,$00
          DC.B      $00,$00,$00,$00
          DC.B      $00,$00,$00,$00
          DC.B      $00,$00,$00,$00
          DC.B      $00,$0C,$02,$0C
          DC.B      $0C,$0C,$0C,$0C
          DC.B      $0C,$00,$00,$00
          DC.B      $03,$00,$07,$08
          DC.B      $09,$00,$06,$05
          DC.B      $00,$00,$04,$0A
          DC.B      $0B,$00,$00,$00
          DC.B      $00,$00,$00,$00
          DC.B      $00,$0D,$02,$0D
          DC.B      $0D,$0D,$0D,$0D
          DC.B      $0D,$00,$00,$00
          DC.B      $03,$00,$07,$08
          DC.B      $09,$00,$06,$05
          DC.B      $00,$00,$04,$0A
          DC.B      $0B,$00,$00,$00
          DC.B      $00,$00,$00,$00
*  Address $118E4
Lab0241   
          DC.B      $F1,$D2,$F2,$42
          DC.B      $F2,$34,$F2,$B0
          DC.B      $F2,$4C,$F2,$5C
          DC.B      $F2,$60,$F2,$8E
          DC.B      $F2,$76,$F2,$3E
          DC.B      $F2,$AC,$F2,$BC
          DC.B      $F1,$C8,$F1,$C2
*  Address $11900
Lab0242   
          DC.B      $00,$12,$00,$FF
          DC.B      $00,$00,$00,$04
          DC.B      $00,$08,$00,$0A
          DC.B      $00,$0E,$00,$16
          DC.B      $0F,$A0
*  Address $11912
Lab0243   
          DC.B      $0E,$EE,$0E,$18
          DC.B      $0D,$4D,$0C,$8E
          DC.B      $0B,$DA,$0B,$2F
          DC.B      $0A,$8F,$09,$F7
          DC.B      $09,$68,$08,$E1
          DC.B      $08,$61,$07,$E9
          DC.B      $07,$77,$07,$0C
          DC.B      $06,$A7,$06,$47
          DC.B      $05,$ED,$05,$98
          DC.B      $05,$47,$04,$FC
          DC.B      $04,$B4,$04,$70
          DC.B      $04,$31,$03,$F4
          DC.B      $03,$BC,$03,$86
          DC.B      $03,$53,$03,$24
          DC.B      $02,$F6,$02,$CC
          DC.B      $02,$A4,$02,$7E
          DC.B      $02,$5A,$02,$38
          DC.B      $02,$18,$01,$FA
          DC.B      $01,$DE,$01,$C3
          DC.B      $01,$AA,$01,$92
          DC.B      $01,$7B,$01,$66
          DC.B      $01,$52,$01,$3F
          DC.B      $01,$2D,$01,$1C
          DC.B      $01,$0C,$00,$FD
          DC.B      $00,$EF,$00,$E1
          DC.B      $00,$D5,$00,$C9
          DC.B      $00,$BE,$00,$B3
          DC.B      $00,$A9,$00,$9F
          DC.B      $00,$96,$00,$8E
          DC.B      $00,$86,$00,$7F
          DC.B      $00,$77,$00,$71
          DC.B      $00,$6A,$00,$64
          DC.B      $00,$5F,$00,$59
          DC.B      $00,$54,$00,$50
          DC.B      $00,$4B,$00,$47
          DC.B      $00,$43,$00,$3F
          DC.B      $00,$3C,$00,$38
          DC.B      $00,$35,$00,$32
          DC.B      $00,$2F,$00,$2D
          DC.B      $00,$2A,$00,$28
          DC.B      $00,$26,$00,$24
          DC.B      $00,$22,$00,$20
          DC.B      $00,$1E,$00,$1C
          DC.B      $00,$1B,$00,$19
          DC.B      $00,$18,$00,$16
          DC.B      $00,$15,$00,$14
          DC.B      $00,$13,$00,$12
          DC.B      $00,$11,$00,$10
          DC.B      $00,$0F,$00,$0E
          DC.B      $00,$0D,$00,$0C
          DC.B      $00,$0C,$00,$0B
          DC.B      $00,$0A,$00,$0A
          DC.B      $00,$09,$00,$09
          DC.B      $00,$08,$00,$08
          DC.B      $00,$07,$00,$07
          DC.B      $00,$06,$00,$06
          DC.B      $00,$06,$00,$05
          DC.B      $00,$05,$00,$05
          DC.B      $00,$04,$00,$04
          DC.B      $00,$04,$00,$04
          DC.B      $00,$03

*  Bytes Data Block [11A04,11A0F]
*  Address $11A04
Lab0244   
          DC.B      $04,$01,$00,$07
          DC.B      $00,$94,$00,$20
          DC.B      $01,$60,$00,$00

LMcurjob  DC.W      13
          DC.B      'Current Job:',$0A,$00

LMjob     DC.W      7
          DC.B      '   Job#',$00

LMsuperb  DC.W      10
          DC.B      'SuperBasic'

LMq2ver   DC.W      13
          DC.B      'QDOS Version ',' '

LMrom     DC.W      7
          DC.B      ' - ROM ',' '

LMdirdev  DC.W      19
          DC.B      'Directory devices:',$0A,$0A

LMcaps    DC.W      10
          DC.B      'Caps lock',$0A

LMrepeat  DC.W      7
          DC.B      'Repeat ',' '

LMafter   DC.W      7
          DC.B      ' after ',' '

LMchanty  DC.W      23
          DC.B      'Channel  Type/Filename',$0A,$00

LMnoope   DC.W      9
          DC.B      'Not open',$0A,$00

LMscr     DC.W      7
          DC.B      'Screen ',' '

LMnoiden  DC.W      17
          DC.B      'No ident; length ',$20

*  Address $11ACA
Lab0258   
          DC.B      $20,$60,$00,$00
          DC.B      $00,$00,$00,$00
          DC.B      $00,$00,$00,$10
          DC.B      $10,$10,$10,$10
          DC.B      $00,$10,$00,$00
          DC.B      $28,$28,$00,$00
          DC.B      $00,$00,$00,$00
          DC.B      $00,$28,$7C,$28
          DC.B      $28,$28,$7C,$28
          DC.B      $00,$00,$10,$3C
          DC.B      $50,$38,$14,$78
          DC.B      $10,$00,$00,$64
          DC.B      $64,$08,$10,$20
          DC.B      $4C,$4C,$00,$00
          DC.B      $20,$50,$50,$20
          DC.B      $54,$48,$34,$00
          DC.B      $00,$10,$10,$20
          DC.B      $00,$00,$00,$00
          DC.B      $00,$00,$08,$10
          DC.B      $10,$10,$10,$10
          DC.B      $08,$00,$00,$20
          DC.B      $10,$10,$10,$10
          DC.B      $10,$20,$00,$00
          DC.B      $00,$28,$10,$7C
          DC.B      $10,$28,$00,$00
          DC.B      $00,$00,$10,$10
          DC.B      $7C,$10,$10,$00
          DC.B      $00,$00,$00,$00
          DC.B      $00,$00,$00,$10
          DC.B      $10,$20,$00,$00
          DC.B      $00,$00,$7C,$00
          DC.B      $00,$00,$00,$00
          DC.B      $00,$00,$00,$00
          DC.B      $00,$30,$30,$00
          DC.B      $00,$04,$04,$08
          DC.B      $10,$20,$40,$40
          DC.B      $00,$00,$38,$44
          DC.B      $4C,$54,$64,$44
          DC.B      $38,$00,$00,$10
          DC.B      $30,$10,$10,$10
          DC.B      $10,$38,$00,$00
          DC.B      $38,$44,$44,$08
          DC.B      $10,$24,$7C,$00
          DC.B      $00,$38,$44,$04
          DC.B      $18,$04,$44,$38
          DC.B      $00,$00,$40,$48
          DC.B      $48,$7C,$08,$08
          DC.B      $1C,$00,$00,$7C
          DC.B      $44,$40,$78,$04
          DC.B      $44,$38,$00,$00
          DC.B      $38,$44,$40,$78
          DC.B      $44,$44,$38,$00
          DC.B      $00,$7C,$44,$08
          DC.B      $10,$10,$10,$10
          DC.B      $00,$00,$38,$44
          DC.B      $44,$38,$44,$44
          DC.B      $38,$00,$00,$38
          DC.B      $44,$44,$3C,$04
          DC.B      $44,$38,$00,$00
          DC.B      $00,$00,$10,$00
          DC.B      $00,$10,$00,$00
          DC.B      $00,$00,$00,$10
          DC.B      $00,$00,$10,$10
          DC.B      $20,$00,$00,$08
          DC.B      $10,$20,$10,$08
          DC.B      $00,$00,$00,$00
          DC.B      $00,$7C,$00,$7C
          DC.B      $00,$00,$00,$00
          DC.B      $00,$20,$10,$08
          DC.B      $10,$20,$00,$00
          DC.B      $00,$38,$44,$08
          DC.B      $10,$10,$00,$10
          DC.B      $00,$00,$38,$44
          DC.B      $4C,$54,$54,$5C
          DC.B      $40,$3C,$00,$10
          DC.B      $28,$28,$38,$28
          DC.B      $28,$6C,$00,$00
          DC.B      $78,$24,$24,$38
          DC.B      $24,$24,$78,$00
          DC.B      $00,$38,$44,$40
          DC.B      $40,$40,$44,$38
          DC.B      $00,$00,$78,$24
          DC.B      $24,$24,$24,$24
          DC.B      $78,$00,$00,$7C
          DC.B      $24,$20,$38,$20
          DC.B      $24,$7C,$00,$00
          DC.B      $7C,$24,$20,$38
          DC.B      $20,$20,$70,$00
          DC.B      $00,$38,$44,$40
          DC.B      $4C,$44,$44,$38
          DC.B      $00,$00,$6C,$28
          DC.B      $28,$38,$28,$28
          DC.B      $6C,$00,$00,$38
          DC.B      $10,$10,$10,$10
          DC.B      $10,$38,$00,$00
          DC.B      $1C,$08,$08,$08
          DC.B      $08,$48,$30,$00
          DC.B      $00,$64,$28,$28
          DC.B      $30,$28,$28,$64
          DC.B      $00,$00,$60,$20
          DC.B      $20,$20,$20,$24
          DC.B      $7C,$00,$00,$44
          DC.B      $6C,$54,$54,$44
          DC.B      $44,$44,$00,$00
          DC.B      $44,$64,$54,$54
          DC.B      $54,$4C,$44,$00
          DC.B      $00,$38,$44,$44
          DC.B      $44,$44,$44,$38
          DC.B      $00,$00,$78,$24
          DC.B      $24,$38,$20,$20
          DC.B      $70,$00,$00,$38
          DC.B      $44,$44,$44,$54
          DC.B      $48,$34,$00,$00
          DC.B      $78,$24,$24,$38
          DC.B      $30,$28,$64,$00
          DC.B      $00,$38,$44,$40
          DC.B      $38,$04,$44,$38
          DC.B      $00,$00,$7C,$54
          DC.B      $10,$10,$10,$10
          DC.B      $38,$00,$00,$44
          DC.B      $44,$44,$44,$44
          DC.B      $44,$38,$00,$00
          DC.B      $44,$44,$44,$44
          DC.B      $44,$28,$10,$00
          DC.B      $00,$44,$44,$44
          DC.B      $44,$54,$54,$28
          DC.B      $00,$00,$44,$44
          DC.B      $28,$10,$28,$44
          DC.B      $44,$00,$00,$44
          DC.B      $44,$44,$28,$10
          DC.B      $10,$38,$00,$00
          DC.B      $7C,$44,$08,$10
          DC.B      $20,$44,$7C,$00
          DC.B      $00,$18,$10,$10
          DC.B      $10,$10,$10,$18
          DC.B      $00,$00,$40,$40
          DC.B      $20,$10,$08,$04
          DC.B      $04,$00,$00,$30
          DC.B      $10,$10,$10,$10
          DC.B      $10,$30,$00,$00
          DC.B      $10,$38,$54,$10
          DC.B      $10,$10,$10,$00
          DC.B      $00,$00,$00,$00
          DC.B      $00,$00,$00,$00
          DC.B      $7C,$00,$18,$24
          DC.B      $20,$70,$20,$24
          DC.B      $7C,$00,$00,$00
          DC.B      $00,$30,$08,$38
          DC.B      $48,$3C,$00,$00
          DC.B      $60,$20,$38,$24
          DC.B      $24,$24,$38,$00
          DC.B      $00,$00,$00,$18
          DC.B      $20,$20,$20,$18
          DC.B      $00,$00,$0C,$08
          DC.B      $38,$48,$48,$48
          DC.B      $38,$00,$00,$00
          DC.B      $00,$18,$24,$3C
          DC.B      $20,$18,$00,$00
          DC.B      $0C,$10,$10,$38
          DC.B      $10,$10,$10,$00
          DC.B      $00,$00,$00,$1C
          DC.B      $24,$24,$24,$1C
          DC.B      $04,$38,$60,$20
          DC.B      $38,$24,$24,$24
          DC.B      $24,$00,$00,$10
          DC.B      $00,$30,$10,$10
          DC.B      $10,$38,$00,$00
          DC.B      $10,$00,$10,$10
          DC.B      $10,$10,$10,$10
          DC.B      $20,$60,$20,$24
          DC.B      $28,$30,$28,$24
          DC.B      $00,$00,$30,$10
          DC.B      $10,$10,$10,$10
          DC.B      $38,$00,$00,$00
          DC.B      $00,$78,$54,$54
          DC.B      $54,$54,$00,$00
          DC.B      $00,$00,$38,$24
          DC.B      $24,$24,$24,$00
          DC.B      $00,$00,$00,$18
          DC.B      $24,$24,$24,$18
          DC.B      $00,$00,$00,$00
          DC.B      $78,$24,$24,$24
          DC.B      $38,$20,$60,$00
          DC.B      $00,$38,$48,$48
          DC.B      $48,$38,$08,$0C
          DC.B      $00,$00,$2C,$30
          DC.B      $20,$20,$20,$00
          DC.B      $00,$00,$00,$1C
          DC.B      $20,$18,$04,$38
          DC.B      $00,$00,$10,$10
          DC.B      $38,$10,$10,$10
          DC.B      $0C,$00,$00,$00
          DC.B      $00,$24,$24,$24
          DC.B      $24,$1C,$00,$00
          DC.B      $00,$00,$44,$44
          DC.B      $28,$28,$10,$00
          DC.B      $00,$00,$00,$44
          DC.B      $54,$54,$54,$28
          DC.B      $00,$00,$00,$00
          DC.B      $44,$28,$10,$28
          DC.B      $44,$00,$00,$00
          DC.B      $00,$44,$44,$28
          DC.B      $28,$10,$10,$20
          DC.B      $00,$00,$7C,$08
          DC.B      $10,$20,$7C,$00
          DC.B      $00,$08,$10,$10
          DC.B      $20,$10,$10,$08
          DC.B      $00,$00,$10,$10
          DC.B      $10,$10,$10,$10
          DC.B      $10,$00,$00,$20
          DC.B      $10,$10,$08,$10
          DC.B      $10,$20,$00,$00
          DC.B      $00,$20,$54,$08
          DC.B      $00,$00,$00,$00
          DC.B      $00,$38,$44,$5C
          DC.B      $64,$64,$64,$5C
          DC.B      $44,$38,$01,$01
          DC.B      $00,$00,$85,$00
          DC.B      $00,$00,$01,$80
          DC.B      $00,$00,$01,$00
          DC.B      $00,$00,$00,$00
          DC.B      $00,$00,$01,$80
          DC.B      $00,$00,$01,$00
          DC.B      $00,$00,$00,$00
          DC.B      $00,$00,$01,$80
          DC.B      $00,$00

* 456 unused $FF

END_CODE  
          END
*  End of Deasm
