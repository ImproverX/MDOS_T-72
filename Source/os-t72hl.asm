	.ORG    00100h
	#include "equates.inc"
;
;	#DEFINE L_MDOS L_01FF+1		; >>>> 0BE00h (���� 0 ��� ��� A000-DFFFh)
	#DEFINE L_BDOS L_MDOS+LenMDOS	; >>>> 0E200h
	#DEFINE L_BIOS L_BDOS+LenBDOS	; >>>> 0EF00h
;
	#DEFINE B_E221 0E221h	; �⪫�祭�� ��ண� �� � ����
;
L_0100: DI
	XRA     A
	OUT     010h	; �⪫�砥� ��10, �᫨ �� ���� �� ��������
	OUT     011h	; � �⪫�砥� ��11
	LXI  SP,00100h
	LXI  H, L_BIOS	; ��㤠 (L_2C00)
	LXI  D, S_FONT	; �㤠 (0EF00h-0FFFFh)
	CALL    unlzsa1	; ��ॡ�᪠ (�� ���� � ����)
	MVI  A, 07Ch	; �஢�ઠ ������ �����-��᪠ 11
	LXI  H, 0FFFEh
	MOV  M, A	; �����뢠�� � ������ ����
	CMA		; �������㥬 �, �.�. ����砥� 83h
	OUT     011h	; �� ��11: 1000 0011b -- ���� 0 ��� ��� E000-FFFFh
	MOV  M, A	; ��襬 ������஢����� ���� �� ��2 (��� ������, �᫨ ��� ���)
	XRA     A
	OUT     011h	; �⪫�砥� ��ன ��
	MOV  A, M	; ���뢠�� ����
	CPI     07Ch	; �஢��塞, ��࠭����� �� �᫮?
	PUSH PSW	; ��࠭塞 � �⥪ 䫠��
	CALL    0F800h	; ����ன�� ����: ����祭�� �� + ���뢠���
	LXI  H, L_MDOS	; ��㤠 (L_0200)
	LXI  D, S_MDOS	; �㤠 (0BE00h-DFFFh)(���� 0 ��� ��� A000-DFFFh)
	CALL    unlzsa1	; ��ॡ�᪠ (�� ���஄��)
	INX  H		;<LXI  H, L_BDOS	; ��㤠 (L_2400)
	LXI  D, S_BDOS	; �㤠 (0E200h-0E9FFh)
	CALL    unlzsa1	; ��ॡ�᪠ (�� ����)
	MVI  A, 0C3h	; JMP ...
	STA     00000h	; �� ����� 0000
	STA     00005h	; � �� ����� 0005
	LXI  H, 0F800h
	SHLD    00001h	; ... 0D800h ???????
	LXI  H, 0C000h
	SHLD    00006h	; ... 0C000h
	EI
	POP  PSW	; ���뢠�� �� �⥪� १���� �஢�ન ��ண� ��
	CNZ     B_E221	; �⪫�砥� ��ன �� � ����, �᫨ �� �� ������
L_015X:	MVI  C, 01Fh	; = ������ �࠭
	CALL    0F809h	; �뢮� ᨬ���� �� �࠭ ----
	MVI  A, 081h
	OUT     004h
	IN      001h
	ANI     040h
	CZ      0E21Bh	; �ଠ�஢���� �� ----
	JMP     S_MDOS	; ========>>>>>>>>>>>>
;
;input: 	hl=compressed data start
;		de=uncompressed destination start
unlzsa1:
	mvi b,0
	jmp ReadToken
;
NoLiterals:
	xra m
	push d
	inx h
	mov e,m
	jm LongOffset
ShortOffset:
	mvi d,0FFh
	adi 3
	cpi 15+3
	jnc LongerMatch
CopyMatch:
	mov c,a
CopyMatch_UseC:
	inx h
	xthl
	xchg
	dad d
	mov a,m
	inx h
	stax d
	inx d
	dcx b
	mov a,m
	inx h
	stax d
	inx d
	dcx b
	dcx b
	inr c
BLOCKCOPY1:
	mov a,m
	stax d
	inx h
	inx d
	dcr c
	jnz BLOCKCOPY1
	xra a
	ora b
	jz $+7
	dcr b
	jmp BLOCKCOPY1
	pop h
ReadToken:
	mov a,m
	ani 70h
	jz NoLiterals 
	cpi 70h
	jz MoreLiterals
	rrc
	rrc
	rrc
	rrc
	mov c,a
	mov b,m
	inx h
	mov a,m		; <<<
	stax d
	inx h
	inx d
	dcr c
	jnz $-5		; >>>
	push d
	mov e,m
	mvi a,8Fh
	ana b
	mvi b,0
	jp ShortOffset
LongOffset:
	inx h
	mov d,m
	adi -128+3
	cpi 15+3
	jc CopyMatch
LongerMatch:
	inx h
	add m
	jnc CopyMatch
	mov b,a
	inx h
	mov c,m
	jnz CopyMatch_UseC
	inx h
	mov b,m
	mov a,b
	ora c
	jnz CopyMatch_UseC
	pop d
	ret
;
MoreLiterals:		
	xra m
	push psw
	mvi a,7
	inx h
	add m
	jc ManyLiterals
CopyLiterals:
	mov c,a
CopyLiterals_UseC:
	inx h
	dcx b
	inr c
BLOCKCOPY2:
	mov a,m
	stax d
	inx h
	inx d
	dcr c
	jnz BLOCKCOPY2
	xra a
	ora b
	jz $+7
	dcr b
	jmp BLOCKCOPY2
	pop psw
	push d
	mov e,m
	jp ShortOffset
	jmp LongOffset
ManyLiterals:
	mov b,a
	inx h
	mov c,m
	jnz CopyLiterals_UseC
	inx h
	mov b,m
	jmp CopyLiterals_UseC
L_MDOS:	.END
