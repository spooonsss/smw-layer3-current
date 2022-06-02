header
lorom

;---------;
; Defines ;
;---------;

!FreeSpace = $179717  ; Point to freespace!!
!FreeRAM = $7C        ; Free RAM to use. One byte required.
!LeftCurOnPlat = $F8  ; X speed of player when standing in water on a platform, left current
!LeftCurInWat = $F0   ; X speed of player when floating in water, left current
!RightCurOnPlat = $08 ; X speed of player when standing in water on a platform, right current
!RightCurInWat = $10  ; X speed of player when floating in water, right current

;-------------;
; Ze Hijacks! ;
;-------------;

org $00D772
JML OhSauce

org $00DA55
JML ASauce

org $05C4F2
JML Itsa

;------------;
; Ze Custom! ;
;------------;

org !FreeSpace|$800000
db "STAR"
dw End-OhSauce-1
dw End-OhSauce-1^$FFFF

OhSauce:
PHX
LDA !FreeRAM
ASL A
CLC
ADC !FreeRAM
TAX
REP #$20
LDA.l SpPtr,x
INC A
STA $00
SEP #$20
LDA.l SpPtr+2,x
STA $02
PLX
TXA
TYX
TAY

RightTide:
LDA $7B
SEC
SBC [$00],y
BPL CODE_00D77C
INX
INX

CODE_00D77C:
REP #$20
DEC $00
SEP #$20
LDA $1493
ORA $72
REP #$20
BNE CODE_00D78C
LDA.w $D309,x
BIT $85
BMI CODE_00D78F

CODE_00D78C:
LDA.w $D2CD,x

CODE_00D78F:
CLC
ADC $7A
STA $7A
SEC
SBC [$00],y
EOR.w $D2CD,x
BMI CODE_00D7A2
LDA [$00],y
STA $7A

CODE_00D7A2:
SEP #$20
JML $00D7A4

SpPtr:
dl Speed
dl Speed2

Speed:
db $00,$00,$00,$00,$00,$00,$00,$00
db $00,$00,$00,$F0,$00,$10,$00,$00
db $00,$00,$00,$00,$00,$00,$00,$E0
db $00,$20,$00,$00,$00,$00,$00,!LeftCurInWat
db $00,!LeftCurOnPlat

Speed2:
db $00,$00,$00,$00,$00,$00,$00,$00
db $00,$00,$00,$F0,$00,$10,$00,$00
db $00,$00,$00,$00,$00,$00,$00,$E0
db $00,$20,$00,$00,$00,$00,$00,!RightCurInWat
db $00,!RightCurOnPlat

OkaySauce:
STA $22
LDA #$01
JML $05C4F6

Itsa:
LDX !FreeRAM
BEQ OkaySauce
SEC
SBC #$02
BRA OkaySauce

ASauce:
LDY !FreeRAM
BNE Heh
LDY $1403
BEQ Heh
JML $00DA5A

Heh:
JML $00DA5D

End: