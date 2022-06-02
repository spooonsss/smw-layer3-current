lorom

;---------;
; Defines ;
;---------;


!FreeRAM = $7C        ; Free RAM to use. One byte required.
!LeftCurOnPlat = $F8  ; X speed of player when standing in water on a platform, left current
!LeftCurInWat = $F0   ; X speed of player when floating in water, left current
!RightCurOnPlat = $08 ; X speed of player when standing in water on a platform, right current
!RightCurInWat = $10  ; X speed of player when floating in water, right current

!bank = $800000

;-------------;
; Ze Hijacks! ;
;-------------;

org $00D772
autoclean JML OhSauce

org $05C4F2
autoclean JML Itsa

org $00D535
DATA_00D535:

org $00D745
autoclean JML TideSwim

;------------;
; Ze Custom! ;
;------------;

freecode

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

Speed: ; DATA_00D5C9
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

Itsa:
LDX !FreeRAM
BEQ OkaySauce
SEC
SBC #$02

OkaySauce:
STA $22
LDA #$01
JML $05C4F6|!bank

TideSwim:
;	SBC.w DATA_00D535,Y			;$00D745	|| Branch if Mario is at the maximum X speed for the slope he's on.
;	BEQ CODE_00D76B				;$00D748	||
;	EOR.w DATA_00D535,Y			;$00D74A	||
;	BPL CODE_00D76B				;$00D74D	|/
CPY #$78
BCC .vanilla
CPY #$88
BCS .vanilla

PHA
LDA !FreeRAM
BEQ .vanilla_pla

LDA.b #(DATA_00D535_right-$78)>>16
STA $02
LDA.b #(DATA_00D535_right-$78)>>8
STA $01
LDA.b #DATA_00D535_right-$78
STA $00
PLA

SBC [$00],Y
BEQ CODE_00D76B
EOR [$00],Y
BPL CODE_00D76B
JML $00D74F|!bank

.vanilla_pla
PLA
.vanilla
SBC.w DATA_00D535,Y
BEQ CODE_00D76B
EOR.w DATA_00D535,Y
BPL CODE_00D76B
JML $00D74F|!bank


CODE_00D76B:
JML $00D76B|!bank

DATA_00D535_right:
	db $F8,$08,$F0,$10,$F4,$04,-$08,-$E8		; 78 - Water (ground, swimming, tide ground, tide swimming)
	db $F0,$10,$E0,$20,$EC,$0C,-$18,-$D8		; 80 - Water with item (ground, swimming, tide ground, tide swimming)
