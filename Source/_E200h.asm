	#include "equates.inc"
	.ORG    S_BDOS	;0E200h
;	#DEFINE D_E9AC L_E9AB+1		; ���� ������ ��� ����஫� �� ����������� ��᪠ �:
	#DEFINE D_E9AD D_E9AC+21h	; ���� ������ ��� ����஫� �� ����������� ��᪠ �:
	#DEFINE D_E9CD D_E9AD+21h	; ���� ������ ��� ����஫� �� ����������� ��᪠ �:
	#DEFINE D_EA00 D_E9CD+33h	; ���� ������ ��� ����஫� �� ����������� ��᪠ �:
	#DEFINE D_EA33 D_EA00+33h	; ���� ������ �ᯮ��㥬�� ��� ����஫� ᬥ�� ��᪠ �:
	#DEFINE D_EA53 D_EA33+20h	; ���� ������ �ᯮ��㥬�� ��� ����஫� ᬥ�� ��᪠ �:
	#DEFINE D_EA73 D_EA53+20h	; ���� 128 ���⭮�� ���� ��� ����権 � ��४�ਥ�
	#DEFINE D_EB00 D_EA73+80h	; ���� ���� ��� ���� 512�
	#DEFINE D_FD_B 0BC00h	; ���� ���� ��� 䫮����� 1��, ����砫쭮 EB00-EEFF
;
	#DEFINE D_E962 00000h	; ����窠, �� ⠡��� ����� �� �ᯮ������
;
	#DEFINE M_FFC4 0FFC4h	; ᪮���� ����� �� �������� �����
	#DEFINE M_FFC5 0FFC5h	; ᪮���� ���뢠��� � �����⭮� �����
;
L_E200: JMP     L_IHDD	; ���樠������ ���� (L_E225)
L_E203: JMP     L_IFHD	; ����稩 ����� ���� (L_E225)
L_E206: JMP     L_E236	; ����� ���᮫� (����������), �ਭ�� � ���.����.
L_E209: JMP     L_E23F	; ���� ᨬ���� � ����������, �ਭ�� ��� �.�.(RET)
L_E20C: JMP     L_E248	; �뢮� ᨬ���� �� �࠭, �ਭ�� ��� �.�.(RET)
L_E20F: JMP     L_E251	; �����頥� ���� DPH ������ ��� ��᪮����
L_E212: JMP     L_E2E4	; ����� � ��᪮�묨 ���ன�⢠��	; (�뫮 E2CA) ���� ������� �� E2C4 !!!
L_E215: JMP     L_E61A	; ������ ��뫪� �� ⠡���� � ��ப��� ⥪��.ᮮ�饭��
L_E218: JMP     L_E291	; ��ࠡ�⪠ ������ ���짮��⥫� (�믮������ ��஢�� ������ ����)
L_E21B: JMP     L_E5D4	; �ଠ�஢���� �� C:
L_E21E:	JMP     L_E224	; // ���� ���室� �� L_E212
L_E221:	MVI  A, 003h	; // �⪫�祭�� ��ண� ��
	STA     LxE255+1; �����뢠��, �� ��᪮� ��.
	STA     LxE5DZ+1; � � ����ணࠬ�� �ଠ�஢����/���஢���� ��
	RET
;
L_E224:	LXI  H, L_E2C4	; ���塞 ���� � L_E212 �� ���...
	SHLD    L_E212+1
	RET
;
;; === �� ��砫쭮� ���樠����樨 ���� ===
L_IHDD:
#ifndef NoHDD
	XRA  A
	STA     L_RWD	; ०�� �⥭��, =0 (��⪠ "�ॡ���� ������ ����" =0)
	STA     L_E86F	; ᥪ��, =0
	CMA		; A = 0FFh
	STA     L_E86D	; ��஦��, =-1 (FFh)
	STA     L_DSKT+1	; ������ �������� ����让 ����� ��᪥��, 0FFxxh
	CALL    L_RWHD	; -->> ��㧨� ᥪ�� � ����
	PUSH PSW
	JNZ     L_EHDD	; �� ����稫��� -- �⪫�砥� ����
	LHLD    D_EB00+084h	; �⠥� �� ���� ������⢮ ��᪥� �� ����
#else
	XRA  A
	DCR  A
	PUSH PSW	; ��� ������ FF � Z=0
	JMP     L_EHDD	; �⪫�砥� ����
#endif
L__HDD:	MOV  A, H	; ������� HL
	CMA
	MOV  H, A
	MOV  A, L
	CMA
	MOV  L, A
	SHLD    LxDMAX+1	; -- ���� �� ���ᨬ��쭮� ������⢮ ��᪥� ����
	POP  PSW	; ����㦠�� ��� ������ �� ���饭�� � ����
	RET
;
L_EHDD: LXI  H, 00000h	; ���� �� ��।������
	SHLD    T_DrvA	; ����塞 ����� ��᪥�� � �:
	SHLD    T_DrvB	; ����塞 ����� ��᪥�� � �:
	JMP     L__HDD  ; ��室
;
; ------------------- END init HDD ---------------
;
L_E236: CALL    L_E2A8	; �맮� PCHL (1) � ���祭��� HL �����:
; ��뫪� ��� PCHL (1), ���� ��砫� ������� �� ���� ������ CALL
	.dw     B_F812	; 00	; ����� ����������
	.dw     L_E617	; 01	; �=1 � RET
	.dw     L_E615	; 02	; �=0 � RET
;
L_E23F: CALL    L_E2A8	; �맮� PCHL (1) � ���祭��� HL �����:
; ��뫪� ��� PCHL (1), ���� ��砫� ������� �� ���� ������ CALL
	.dw     B_F803	; 00	; ���� ᨬ���� � ����������
	.dw     L_E615	; 01	; �=0 � RET
	.dw     B_F806	; 02	; ���� ���� � �/� -- �ࠧ� RET
;
L_E248: CALL    L_E2A8	; �맮� PCHL (1) � ���祭��� HL �����:
; ��뫪� ��� PCHL (1), ���� ��砫� ������� �� ���� ������ CALL
	.dw     B_F809	; 00	; �뢮� ᨬ���� �� �࠭
	.dw     B_F80F	; 01	; �뢮� ᨬ���� �� �ਭ��
	.dw     B_F80C	; 02	; �뢮� ���� �� �/� -- �ࠧ� RET
;
L_E251: LXI  H, 00000h	; �� �����頥� ���� DPH ������ ��� ��᪮����
	MOV  A, C
LxE255:	CPI     004h	; << ��� ��।������ ������⢮ ��᪮� � ��⥬�!
	RNC		; ������, �᫨ ����� ��� ࠢ�� 4
	CALL    L_E2B6	; ����ᨬ ���祭�� �� (�.���� + � + �)
			; � HL � ������ RET (�।��騩 �맮�? 0DC1Eh)
T_PDH:	.dw T_E261	; 00
	.dw T_E271	; 01
	.dw T_E281	; 02
	.dw T_E291	; 03
;
T_E261: .dw D_E962	; 00 ���� ⠡���� �࠭��樨 �����᪨� ᥪ�஢ � 䨧��᪨� (��।����� �㭪樨 SECTRAN � DE) ��� 0 �᫨ �࠭���� �� �㦭�
	.dw 00000h	; 01 ���� ����
	.dw 00000h	; 02 ���� ����
	.dw 00000h	; 03 ���� ����
	.dw D_EA73	; 04 ���� 128 ���⭮�� ���� ��� ����権 � ��४�ਥ�. �� ���� � ��� DPH � ��⥬� ����� ᮢ������.
	.dw D_E935	; 05 ���� ⠡���� ��ࠬ��஢ ��᪠. ����᪠���� ᮢ���⭮� �ᯮ�짮����� ����� � ⮩ �� ⠡���� ࠧ�묨 DPH.
	.dw D_EA33	; 06 ���� ������ �ᯮ��㥬�� ��� ����஫� ᬥ�� ��᪠. ��� ������� DPH � ��⥬� ������ ���� ᢮� �������.
	.dw D_E9CD	; 07 ���� ������ ��� ����஫� �� ����������� ��᪠. ��� ������� DPH � ��⥬� ������ ���� ᢮� �������.

T_E271: .dw D_E962	; 00
	.dw 00000h	; 01
	.dw 00000h	; 02
	.dw 00000h	; 03
	.dw D_EA73	; 04	���� ���� ��� ��᪮��� ����権
	.dw D_E935	; 05	// �뫮 D_E944
	.dw D_EA53	; 06
	.dw D_EA00	; 07

T_E281: .dw D_E962	; 00
	.dw 00000h	; 01
	.dw 00000h	; 02
	.dw 00000h	; 03
	.dw D_EA73	; 04	���� ���� ��� ��᪮��� ����権
	.dw D_E953	; 05
	.dw 00000h	; 06
	.dw D_E9AC	; 07

T_E291: .dw D_E962	; 00
	.dw 00000h	; 01
	.dw 00000h	; 02
	.dw 00000h	; 03
	.dw D_EA73	; 04	���� ���� ��� ��᪮��� ����権
	.dw D_E953	; 05
	.dw 00000h	; 06
	.dw D_E9AD	; 07
;
L_E291: CALL    L_E2B1
; ��뫪� ��� PCHL (1), ���� ��砫� ������� �� ���� ������ CALL
; (�믮������ ��஢�� ������ ����)
	.dw P_E426	; 00 -- ������� "0"		��⠭�������� ��ࠬ���� �����/�뢮��
	.dw P_E526	; 01 -- ������� "1"		������ 䠩�� �� ����⨢��� ����� �� ���
	.dw P_E5CF	; 02 -- ������� "2" (RET)	������� 䠩�� � �����⭮� ����� �� ���
	.dw P_E5CF	; 03 -- ������� "3" (RET)	�����뢠�� 䠩�� � ��᪠ �� �������� �����
	.dw P_E5CF	; 04 (RET)		+++++++	+ ��ᬮ�� � 㪠����� ��� ���᪠ 䠩���
	.dw P_E5BB	; 05 -- ������� "5"		��२�����력� 䠩��
	.dw P_E5CF	; 06 (RET)		+++++++	+ ��� �ਧ����� 䠩��
	.dw P_E5CF	; 07 (RET)		+++++++	+ ��⠭���� �ਧ����� 䠩���
	.dw P_E5D0	; 08 -- ������� "8"		�஢�ઠ/�ଠ�஢���� ���஭���� ��᪠
	.dw P_Ex01	; 09 -- ������� "9" (���.)	�����祭�� ��᪥� ���� �� ��᪨ �: � �:
;
L_E2A8: POP  H		; ����� ���� ������
	MOV  A, D
	CPI     003h	; �᫨ D < 3
	JC      L_E2B2	; ��뢠�� pchl(1) �� ���� �� ⠡����
	XRA  A		; ���� ����塞 � � ������
	RET
;
L_E2B1:	POP  H
L_E2B2: CALL    L_E2B7	; ����ᨬ � HL ���祭�� �� ���� HL	;-)
	PCHL		; >>>> (1)
;
L_E2B6: POP  H
L_E2B7:	ADD  A
	ADD  L
	MOV  L, A
	JNC     L_E2BE
	INR  H
L_E2BE: MOV  E, M
	INX  H
	MOV  H, M
	MOV  L, E
	RET
;
; ===== ����� � ��᪮�묨 ���ன�⢠�� ============================
L_E2C4: LXI  D, L_E98A	; ��७�� ����⥫� ��᪮��� ����樨
	MOV  C, M	; C = ����� ��᪠ (��� � = 0, ��� � = 1...)
	MVI  B, 008h
L_E2CF: MOV  A, M
	STAX D
	INX  H
	INX  D
	DCR  B
	JNZ     L_E2CF	; 横� 8 ࠧ, �⠥� � adr(HL), ��襬 � L_E98A++
	MOV  A, C	; ����� ��᪠ (��� � = 0, ��� � = 1...)
	CPI     002h
	JNC     L_KD	; >> ���饭�� � ��, �᫨ ��� >= 2
	CALL    LaD9B2	; ����祭�� ��뫪� �� ⠡���� ������ ��᪥�� �� ����, � � ����� ��᪠
	MOV  A, M
	MOV  E, A
	INX  H
	MOV  D, M
	INX  H		; DE = ����� ��᪥��, HL = ��뫪� �� ⠡���� ���� +2
	ORA  D		; DE = 0 -- 䫮�����, �� 0 -- ����
	JZ      L_E716	; >>>>>>>>>>>>>>>>>>> ���饭�� � 䫮�����
#ifndef NoHDD
	XCHG		; � HL ����� ��᪥��
	SHLD    L_DSKT	; ��࠭塞 ����� ��᪥�� (�ᯮ������ ⮫쪮 ��� �஢�ન ���㠫쭮�� ������ � ����)
	LDA     L_BDS	; ��᪥�,��.�	(������ � ����)
	CMP  L
	JNZ     L_RW0	; >> �� ᮢ����
	LDA     L_BDS+1	; ��᪥�,��.�	(������ � ����)
	CMP  H
	JZ      L_RW1	; >> ᮢ����
L_RW0:	PUSH D		; � �⥪ ��뫪� �� ⠡���� ���� +2
	LDA     L_RWD	; ᬮ�ਬ ���� "�ॡ���� ������ ����"
	ANA  A		; �ਧ���� �� �, A<>0 -- �ॡ���� ������.
	CNZ     L_RWHD	; ���饭�� � ���� � �।��騬� ��⠭������, ������
	POP  H		; HL = ��뫪� �� ⠡���� ���� +2
	RNZ		; ��室 � ��砥 �訡��
	SHLD    L_1SEC	; ��࠭���� ��뫪� �� ⠡���� ���� +2
	MVI  B, 0FFh	; � � ��⪠, �� ��� �� ᮢ��� (���� �㤥� �=0)
L_RW1:	LHLD    L_BDR	; H = (ᥪ��-1)/4 � ����; L = ��஦�� � ����
	LDA     L_E98E	; ����� ��஦�� ��᪠ ����
	MOV  E, A
	LDA     L_E98F	; ����� ᥪ�� ��᪠ ����
	DCR  A
	ANI     0FCh	; 1111 1100
	RRC
	RRC		; � = (ᥪ��-1)/4	(�����)
	MOV  D, A
	SUB  H
	JNZ     L_RW2	; >> �� ᮢ��� ᥪ��
	CMP  B		; �஢��塞 ���� ᮢ������� ��᪠
	JNZ     L_RW3	; >> �� ᮢ����� ��� (� �⮬ ��砥 ��� ���� 㦥 ��)
	MOV  A, E
	CMP  L		; �஢��塞 ��஦��
	JZ      L_RWBF	; >> ��� ᮢ����, ࠡ�⠥� � ���஬
L_RW2:	PUSH D		; D = (ᥪ��-1)/4 (�����); E = ��஦�� (�����)
	LDA     L_RWD	; ᬮ�ਬ ���� "�ॡ���� ������ ����"
	ANA  A		; �ਧ���� �� �, A<>0 -- �ॡ���� ������.
	CNZ     L_RWHD	; ���饭�� � ���� � �।��騬� ��⠭������, ������
	POP  D
	RNZ		; ��室 � ��砥 �訡��
L_RW3:	MOV  A, D	; ���������� ������ � ���� � ��᪠
	STA     L_E86F	; ���. (ᥪ��-1)/4	(�����)
	MOV  A, E
	STA	L_E86D	; ���. ��஦��		(�����)
	XRA  A		; ����塞 ����� � ����:
	STA     L_BDR	; ��஦��
	STA     L_BSC	; (ᥪ��-1)/4
	STA     L_RWD	; ���.०�� �⥭�� (=0)
	CMA		; A = FFh
	STA     L_BDS+1	; ��᪥� = 0FFxxh, ����� ���ᨬ��쭮�� ���祭��
	CALL    L_RWHD	; ���饭�� � ���� (���������� ����) -- ⮫쪮 �⥭��!
	RNZ		; >>> ��室, �᫨ �뫨 �訡��
	; ��ॡ�᪠ 128 ���� �� ���� D_EB00 � L_E990 (��� ������� �� �����)
L_RWBF:	LXI  D, D_EB00	; ����
	LDA     L_E98F	; ᥪ�� ���� ��᪥��
	DCR  A
	ANI     003h	; (ᥪ��-1) mod 4
	RAR		; ((ᥪ��-1) mod 4) / 2, �㫥��� ࠧ�� � �ਧ��� �
	MOV  H, A
	MVI  A, 000h
	RAR		; A = <C>000 0000b
	MOV  L, A	; HL = ((ᥪ��-1) mod 4) * 128
	DAD  D		; HL -- ��砫� ������ � ���� ��� ��ॡ�᪨
	LDA     L_E98C	; �⥭��(04h)/������(06h)
	SUI     006h	; �᫨ ������, � � = 0 � Z = 1
	PUSH PSW	; ��࠭塞 १���� �஢�ન � �⥪
	CALL    L_MBUF	; ��ॡ�᪠ ������ ��/� ��᪮�� ���� ����
	POP  PSW	; �� �⥪�, �᫨ ������, � � = 0 � Z = 1
	JNZ	L_EXI	; �� ������ -> ��室
	CMA
	STA     L_RWD	; (=FFh), �⠢�� ���� "�㦭� ������ ����"
	LDA     L_E98F	; ᥪ�� ���� ��᪥��
	ANI     003h	; (ᥪ��) mod 4, ��᫥���� ᥪ�� � ������?
	CZ      L_RWHD	; �᫨ �� -> ���饭�� � ����, ������
L_EXI:	LDA     L_E873	; ��� ������ �⥭��/����� ��᪠
#endif
	ANA  A
	RET
;
	; HL -- ��㤠 ����/�㤠 ��࠭���
	; Z=0 -- ������
L_MBUF:	XCHG		; DE = ��砫� ������
	LHLD    L_E990	; ���� ���� ��᪮��� ����樨
	JNZ     L_NWR	; �� ������
	XCHG
L_NWR:	PUSH H		; ���� ���� ��᪮��� ����樨 � �⥪
	MVI  C, 040h	; ����稪 �� 64 (= 128 ���� /2)
	LXI  H, 00002h
	DAD  SP		; HL = SP + 2
	SHLD    LxPSP+1	; HL ����ᨬ � ��⠭���� ���� �⥪�
	XCHG
	POP  D
	DI
	SPHL		; �� = ��㤠 ���� �����
	XCHG		; HL = �㤠 �����뢠��
L_ML1:	POP  D
	MOV  M, E
	INX  H
	MOV  M, D
	INX  H
	DCR  C
	JNZ     L_ML1
LxPSP:	LXI  SP,00000h	; ���� �������!!!
	EI
	RET
;
; ===== �� ========================================================
L_KD:	LDA     L_E98C	; �⥭��(04h)/������(06h)
	CPI     004h
	JZ      L_E332	; �⥭�� ᥪ�� �� � ��᪮�� ����
	CPI     006h
	JZ      L_E39B	; ������ ᥪ�� �� �� ��᪮���� ����
L_E2E4:	XRA  A
;	ANA  A
	RET
;
; ----- �� ----- 	; �⥭�� ᥪ�� �� � ��᪮�� ����
L_E332: CALL    L_E3DB	; ���᫥��� ०��� � ���� �� �� ��஦�� � ᥪ���
	LXI  H, 00000h
	DAD  SP		; SP => HL
	SHLD    L_E38X+1	; HL ����ᨬ � ��⠭���� ���� �⥪�
	LHLD    L_E992	; HL= ���� ᥪ�� ��
	MVI  A, 080h
	ADD  L
	MOV  L, A
	JC      L_E347
	DCR  H		; HL+128 ����
L_E347: DI
	SPHL
	LHLD    L_E990	; ���뢠�� ���� ���� ��� ��᪮��� ����権
	MVI  C, 020h	; ����稪, 20h*4 = 128 ���� (1 ᥪ��)
	XRA  A		; �⪫�砥� ���� ��
	OUT     010h	; ��ࠢ�塞 �� ��������
	LDA     L_E98A  ; ���뢠�� ����� ��᪠
	ADI     00Eh
        STA     L_E352+1; ���稬 � �ணࠬ�� ����� ����, 10h / 11h
        STA     L_E37X+1;
;	CPI     002h	; = 2?
	LDA     L_E994	; ���䨣.��
;	JZ      L_E352
;	OUT     011h	; ��ன ��
;	JMP     L_E353
L_E352:	OUT     010h	; ��ࠢ�塞 �� �������� <<< ����� ���� �������!
L_E353:	XRA  A
L_E354: POP  D
	MOV  M, E
	ADD  E
	INX  H
	MOV  M, D
	ADD  D
	INX  H
	POP  D
	MOV  M, E
	ADD  E
	INX  H
	MOV  M, D
	ADD  D
	INX  H
	DCR  C
	JNZ     L_E354
	MOV  B, A	; B = ����஫쭠� �㬬�
	MVI  A, 01Fh	; 0001 1111 -- ���� 0 ��� ����
L_E37X:	OUT     010h	; ��ࠢ�塞 �� �������� <<< ����� ���� �������!
L_E37Y:	LHLD    L_E995	; ���� ����஫쭮� �㬬� ᥪ�� ��
	SPHL
	POP  D
	MOV  A, E
	CMP  D
	JNZ     L_E37E
	CMP  B
	JZ      L_E38A
	MVI  C, 002h	; �� �� ᮢ������?
	JMP     L_E38A
;
L_E37E: CMP  B
	JZ      L_E388
	MOV  A, D
	CMP  B
	MOV  E, D
	JZ      L_E389
	MVI  C, 003h
	JMP     L_E38A
L_E388: MOV  D, E
L_E389: PUSH D		; ������ ����஫쭮� �㬬� �� ��
L_E38A: XRA  A
	OUT     011h	; �⪫�砥� ��ன ���, � �� ��砥
L_E38X:	LXI  SP,00000h	; ���� ������� !!!
	MVI  A, 023h	; 0010 0011b -- ���� 0 ��� ��� A000-DFFFh
	OUT     010h	; ��ࠢ�塞 �� ��������
	EI
	MOV  A, C
	ANA  A
	RET
;
; ----- �� -----	; ������ ᥪ�� �� �� ��᪮���� ����
L_E39B: CALL    L_E3DB	; ���᫥��� ०��� � ���� �� �� ��஦�� � ᥪ���
	LXI  D, 0007Fh  ; ࠧ��� ᥪ�� - 1
	LXI  H, 00000h
	DAD  SP		; SP => HL
	SHLD    L_E38X+1	; HL ����ᨬ � ��⠭���� ���� �⥪�
	LHLD    L_E992
	DI
	SPHL
	LHLD    L_E990	; ���� ���� ��� ��᪮��� ����権
	DAD  D
	MVI  C, 020h
	XRA  A		; �⪫�砥� ���� ��
	OUT     010h	; ��ࠢ�塞 �� ��������
	LDA     L_E98A  ; ���뢠�� ����� ��᪠
	ADI     00Eh
        STA     L_E3B7+1; ���稬 � �ணࠬ�� ����� ����, 10h / 11h
        STA     L_E3DX+1;
	LDA     L_E994	; ���䨣.��
L_E3B7:	OUT     010h	; ��ࠢ�塞 �� �������� <<< ����� ���� �������!
L_E3B8:	XRA  A
L_E3B9: MOV  D, M
	ADD  D
	DCX  H
	MOV  E, M
	ADD  E
	DCX  H
	PUSH D
	MOV  D, M
	ADD  D
	DCX  H
	MOV  E, M
	ADD  E
	DCX  H
	PUSH D
	DCR  C
	JNZ     L_E3B9
	MOV  D, A
	MVI  A, 01Fh	; 0001 1111 -- ���� 0 ��� ����
L_E3DX:	OUT     010h	; ��ࠢ�塞 �� �������� <<< ����� ���� �������!
L_E3DY:	LHLD    L_E995	; ���� ����஫쭮� �㬬� ᥪ�� ��
	SPHL
	POP  H		; ���뢠��� ������ SP = SP + 2
	MOV  E, D
	JMP     L_E389
;
; ----- �� -----	; ���᫥��� ०��� � ���� �� �� ��஦�� � ᥪ���
; �室:		L_E98E -- ����� ��஦�� ��, L_E98F -- ����� ᥪ�� ��
; ��室:	L_E994 -- ���䨣.��, L_E992 -- ���� �� ��,
;		L_E995 -- ���� ����஫쭮� �㬬� ᥪ�� ��
;
L_E3DB: LDA     L_E98E	; ����� ��஦�� ��
	MVI  H, 0ECh
	CPI     004h
	JNC     L_E3E7	; �᫨ ��஦�� >= 4
	MVI  H, 0FCh
L_E3E7: SUB  H		; A = �����_��஦�� - H
	CMA
	RLC
	RLC
	MOV  H, A
	RLC
	RLC
	ANI     00Ch	; 0000 1100
	ORI     033h	; 0011 0011	010h	; 0001 0000 //
	STA     L_E994	; ���䨣.��
	MVI  A, 003h
	ORA  H
	MOV  H, A	; H = ��.���� ����
	MVI  L, 0FFh
	INX  H
	LDA     L_E98F	; ����� ᥪ�� ��
	LXI  D, 0FF80h	; -------
L_E402: DCR  A
	JZ      L_E40A
	DAD  D
	JMP     L_E402
;
L_E40A: SHLD    L_E992	; ���� �� ��
	LDA     L_E98E	; ����� ��஦�� ��
	MOV  L, A
	MVI  H, 000h
	DAD  H
	DAD  H
	DAD  H
	DAD  H
	LDA     L_E98F	; ����� ᥪ�� ��
	DCR  A
	ADD  A
	ADD  L
	MOV  L, A
	LXI  D, 0F000h	; --------
	DAD  D
	SHLD    L_E995	; ���� ����஫쭮� �㬬� ᥪ�� ��
	RET
;
; ----- �� ----- ���஢����/�ଠ�஢���� <<<-- ������� "8"
P_E5D0:	LDA     A_005C	; ���� ��㬥�� �믮��塞�� ������� (�᫨ �� ���)
	ANA  A
	JNZ     L_E5DY	; >> ��㬥�� �� �㫥���
	MVI  A, 003h	; ��⠭�������� ��� �:, �᫨ ��� �� �� 㪠���
	STA     A_006C+1; � ���ࠥ� ��ன ��㬥�� �믮��塞�� �������, �� ��直� ��砩
L_E5DY:	CPI     003h	; < "C:"?
	JC      L_E457	; >> �뢮� "����୮� ���" � RET
	DCR  A
LxE5DZ:	CPI     004h	; > "D:"?  << ��� �ࠢ���� ���祭�� �� �����⢨� �:
	JNC     L_E457	; >> �뢮� "����୮� ���" � RET
	STA     L_E98A  ; �����뢠�� ����� ��᪠
	LDA     A_006C+1; ��ன ��㬥�� �믮��塞�� �������
	CPI     046h	; = "F" ?
	MVI  A, 004h	; (�⥭�� � ��)
	JNZ     L_E5D7	; ���, >> ��� ��
	CALL    L_E5D5	; �맮� �ଠ�஢���� ��
	MVI  C, 00Dh	; ���� ��᪮��� ��⥬�
	JMP     00005h	; <<<<<< � ��室
;
L_E5D4:	MVI  A, 002h	; <<< ��砫쭮� �ଠ�஢���� �� �:
	STA     L_E98A  ; �����뢠�� ����� ��᪠ �:
L_E5D5: MVI  A, 006h	; (������ �� ��) <<< �ଠ�஢���� ��
L_E5D7: STA     L_E98C	; �⥭��(04h)/������(06h)
	LXI  D, 00008h
	LXI  H, D_EA73	; -----------
	SHLD    L_E990	; ���. ���� ���� ��� ��᪮��� ����権
	MVI  C, 080h
	MVI  A, 0E5h
L_E5E7: MOV  M, A
	INX  H
	DCR  C
	JNZ     L_E5E7	; ������塞 ���� ���祭��� "E5"
L_E5F2: MOV  A, E
	STA     L_E98F	; ����� ᥪ�� ��
	MOV  A, D
	STA     L_E98E	; ����� ��஦�� ��
	PUSH D
	LXI  H, L_E98A
	CALL    L_E2C4	; ��᪮�� ����樨, == E212
	CNZ     L_E2E7	; �뢮� �訡�� �⥭��/�����
	POP  D
	DCR  E
	JNZ     L_E5F2	; 横� �� ᥪ�ࠬ
	MVI  E, 008h
	INR  D
	MOV  A, D
	CPI     0ECh	; ��饥 �᫮ ��஦�� ��
	JNZ     L_E5F2	; 横� �ଠ�஢����/���஢����
	CALL    L_E5B2	; �뢮� "Ok"
	XRA  A
	RET
;
L_E2E7: PUSH PSW	; �뢮� �訡�� �⥭��/����� ��
	LXI  H, L_E98A
	LXI  D, L_E305	; >> ��ப� "ER=..."
	MVI  B, 009h
L_E2F0: XCHG
	PUSH PSW
	CALL    B_F818	; �뢮� ᮮ�饭�� �� �࠭ (������ ����稢����� 0 ���⮬)
	POP  PSW
	XCHG
	PUSH B
	CALL    B_F815	; �뢮� ���� �� �࠭ 16-�筮� ����
	POP  B
	MOV  A, M
	INX  H
	INX  D
	DCR  B
	JNZ     L_E2F0
	POP  PSW
	RET
;
L_E305: .db 00Dh, 00Ah, "ER=", 000h
	.db " D=", 000h			;(offset 020Bh)
	.db " CHW=", 000h		;(offset 0210h)
	.db " OP=", 000h		;(offset 0216h)
	.db " NS=", 000h		;(offset 021Bh)
	.db " T=", 000h			;(offset 0220h)
	.db " S=", 000h			;(offset 0224h)
	.db " A2=", 000h		;(offset 0228h)
	.db " A1=", 000h		;(offset 022Dh)
;
; =================================
;
			; ��ࠡ�⪠ "0" -- ��⠭�������� ��ࠬ���� �����/�뢮��
P_E426: ;CALL    L_E6DE	; /��ॢ�� ��ப�/ <<<<<<<< ���譨� �맮� �� 0DA91h
	LXI  D, A_005C+1; ���� ��㬥�� �믮��塞�� �������
	LDAX D
	CALL    L_E4BA
	LXI  D, A_006C+1; ��ன ��㬥�� �믮��塞�� �������
	LDAX D
	CPI     052h	; = "R" ?
	JZ      L_E45E	; ���.᪮��� ���뢠��� � �����⭮� �����
	CPI     057h	; = "W" ?
	JZ      L_E463	; ���.᪮��� ����� �� �������� �����
	CPI     041h	; = "A" ?
	JZ      L_E468	; �뢮��� �� ��ᯫ�� �ࠢ������ ��᫥����⥫쭮��� 1�h,L
	CPI     050h	; = "P" ?
	JZ      L_E474	; ���.梥� �⮡ࠦ���� � 梥� 䮭�
;;	CPI     04Dh	; = "M" ?
;;	JZ      L_E483	; ��⠭�������� ०�� ����
;	CPI     053h	; = "S" ?
;	JZ      L_E4A2	; ���� ������� � �� ��� 䫮������ ??????
;	CPI     056h	; = "V" ? --  �뫮 057h, � �� �� �ࠡ�⠥� �������...
;	JZ      L_E4B6	; ��� ���� �� ��� 䫮������ ?????
L_E457: LXI  D, S_E6A5	; >>"����୮� ���$"
	JMP     L_E6E1	; �뢮� ��᫥����⥫쭮�� ᨬ����� (�� "$")
;	RET
;
L_E45E: MOV  A, L
	STA     M_FFC5	; >>> ᪮���� ���뢠��� � �����⭮� �����
	RET
;
L_E463: MOV  A, L
	STA     M_FFC4	; >>> ᪮���� ����� �� �������� �����
	RET
;
L_E468: PUSH H		; �뢮��� �� ��ᯫ�� �ࠢ������ ��᫥����⥫쭮��� 1�h,L
	MVI  C, 01Bh
L_E46B: CALL    B_F809	; >>>>>>>>
	POP  H
	MOV  C, L
	CALL    B_F809	; >>>>>>>>
	RET
;
L_E474: PUSH H		; ���.梥� �⮡ࠦ���� � 梥� 䮭�
	MVI  C, 01Bh
	CALL    B_F809	; >>>>>>>>
	MVI  C, 050h
	CALL    B_F809	; >>>>>>>>
	MOV  C, H
	JMP     L_E46B
;
;L_E483: MOV  A, L	; ��⠭�������� ०�� ����
;	STA     L_E49C
;	MOV  A, H
;	STA     L_E4A0
;	LXI  H, L_E49A
;	MVI  B, 008h
;L_E490: MOV  C, M
;	CALL    B_F80F	; >>>>>>>> �뢮� ᨬ���� �� �ਭ��
;	INX  H
;	DCR  B
;	JNZ     L_E490
;	RET
;
;L_E49A: .db 01Bh	; ����� �ࠢ���騥 ᨬ���� ��� �ਭ��
;	.db 033h	;
;L_E49C: .db 012h	;
;	.db 01Bh	;
;	.db 043h	;
;	.db 000h	;
;L_E4A0: .db 00Ch	;
;	.db 007h	;
;
;L_E4A2: XRA  A	; ���� ������� � �� ��� 䫮������ ??????
;	ORA  L
;	JZ      L_E4AA
;	DCR  L
;	MVI  A, 047h	; = MOV B,A
;L_E4AA: STA     L_E83A	; !!! ��������� �ணࠬ�� !!!
;	MVI  A, 003h
;	ANA  L
;	ORI     010h
;	STA     LxE86F+1	; !!! ��������� �ணࠬ�� !!!
;	RET
;
; -- � �� �� ࠡ�⠫� �������...
;L_E4B6: SHLD    LxE847+1	; !!! ��������� �ணࠬ�� !!!
;	RET
;
L_E4BA: LXI  H, 00000h
L_E4BD: LDAX D
	INX  D
	CPI     020h
	RZ
	SUI     030h
	JM      L_E4E4
	CPI     00Ah
	JM      L_E4D8
	CPI     011h
	JM      L_E4E4
	CPI     017h
	JP      L_E4E4
	SUI     007h
L_E4D8: MOV  C, A
	DAD  H
	DAD  H
	DAD  H
	DAD  H
	JC      L_E4E4
	DAD  B
	JMP     L_E4BD
;
L_E4E4: CALL    L_E457	; �뢮� "����୮� ���"
;	LXI  D, A_005C	; ���� ��㬥�� �믮��塞�� ������� (���.� ���)
	CALL    L_E6EB	; �����⨥ 䠩��
	STC
	RET
;
L_E4EF: PUSH H
	PUSH B
	XCHG
	MVI  C, 01Ah	; ��⠭���� ���� ���� ���
	CALL    00005h
	LXI  D, A_005C	; ���� ��㬥�� �믮��塞�� ������� (���.� ���)
	MVI  C, 015h	; ��᫥����⥫쭠� ������
	CALL    00005h
	LXI  D, L_E502	; "��� �����"
	ORA  A
	POP  B
	POP  H
	RET
;
L_E502: .db 0E4h	; <�>
	.db 0C9h	; <�>
	.db 0D3h	; <�>
	.db 0CBh	; <�>
	.db 020h	; < >
	.db 0D0h	; <�>
	.db 0CFh	; <�>
	.db 0CCh	; <�>
	.db 0CEh	; <�>
	.db 0D9h	; <�>
	.db 0CAh	; <�>
	.db 024h	; <$>
;
S_E50D: .db 00Dh	; <_>
	.db 00Ah	; <_>
S_E50E: .db 0E4h	; <�>
	.db 0C9h	; <�>
	.db 0D2h	; <�>
	.db 0C5h	; <�>
	.db 0CBh	; <�>
	.db 0D4h	; <�>
	.db 0CFh	; <�>
	.db 0D2h	; <�>
	.db 0C9h	; <�>
	.db 0D1h	; <�>
	.db 020h	; < >
	.db 0D0h	; <�>
	.db 0CFh	; <�>
	.db 0CCh	; <�>
	.db 0CEh	; <�>
	.db 0C1h	; <�>
	.db 0D1h	; <�>
	.db 024h	; <$>
;
S_E520: .db 00Dh	; <_>
	.db 00Ah	; <_>
	.db 020h	; < >
	.db 04Fh	; <O>
	.db 06Bh	; <k>
	.db 024h	; <$>
;
P_E526: ;CALL    L_E6DE	; <<<<< ���譨� �맮� �� "1" (�⢥�: "����୮� ���")
	LXI  D, A_005C+1; ���� ��㬥�� �믮��塞�� �������
	CALL    L_E4BA	; � HL ��ॢ������ ��㬥�� � HEX
	RC
	XRA  A
	CMP  L		; � L ������⢮ ������
	JZ      L_E457	; �뢮� "����୮� ���" � RET
	SHLD    L_E5B9
	LXI  D, A_005C	; ���� ��㬥�� �믮��塞�� ������� (���.� ���)
	LXI  H, A_006C	; ��ன ��㬥�� �믮��塞�� ������� (���.� ���)
	MOV  A, M
	STAX D
	INX  H
	INX  D
	MVI  B, 00Bh
L_E544: MOV  A, M
	STAX D
	ANI     07Fh
	CPI     000h	; = 00h ?
	JZ      L_E56B	; ��� �����...
	CPI     020h	; = " " ?
	JZ      L_E56B	; ��� �����...
	CPI     03Fh	; = "?" ?
	JZ      L_E457	; �뢮� "����୮� ���" � RET
	CPI     05Bh	; >= "[" ?
	JNC     L_E457	; �뢮� "����୮� ���" � RET
	CPI     041h	; >= "A" ?
	JNC     L_E56B	; ��� �����...
	CPI     02Fh	; < "/" ?
	JC      L_E457	; �뢮� "����୮� ���" � RET
	CPI     03Ah	; >= ":" ?
	JNC     L_E457	; �뢮� "����୮� ���" � RET
L_E56B: INX  D
	INX  H
	DCR  B
	JNZ     L_E544
	MVI  B, 019h
L_E573: XRA  A
	STAX D
	INX  D
	DCR  B
	JNZ     L_E573	; ��� � 横�� �஢������ � ��७����� � ���� ��㬥�� ��� 䠩��
	LXI  D, A_005C	; ���� ��㬥�� �믮��塞�� ������� (���.� ���)
	MVI  C, 013h	; �������� 䠩��
	CALL    00005h
	LXI  D, A_005C	; ���� ��㬥�� �믮��塞�� ������� (���.� ���)
	MVI  C, 016h	; �������� 䠩��
	CALL    00005h
	LXI  D, S_E50D	; >> "��४��� ������"
	INR  A
	JZ      L_E6E1	; �뢮� ��᫥����⥫쭮�� ᨬ����� (�� "$") � RET
	LDA     L_E5B9
	MOV  B, A
	LXI  H, 00100h
L_E594: CALL    L_E4EF
	JNZ     L_E6E1	; �뢮� ��᫥����⥫쭮�� ᨬ����� (�� "$") � RET
	LXI  D, A_0080	; ��㬥�� �믮��塞�� ������� (<��>< ><��ப�>)
	DAD  D
	CALL    L_E4EF
	JNZ     L_E6E1	; �뢮� ��᫥����⥫쭮�� ᨬ����� (�� "$") � RET
	LXI  D, A_0080	; ��㬥�� �믮��塞�� ������� (<��>< ><��ப�>)
	DAD  D
	DCR  B
	JNZ     L_E594
	CALL    L_E6EB	; �����⨥ 䠩��
L_E5B2:	LXI  D, S_E520	; >> "Ok"
	JMP     L_E6E1	; �뢮� ��᫥����⥫쭮�� ᨬ����� (�� "$") � RET
;	RET
;
L_E5B9: .dw 00000h	; (offset 04B9h)
;
P_E5BB: LXI  D, A_005C	; ���� ��㬥�� �믮��塞�� ������� (���.� ���)	; <<<<<-- �맮� �� 0DA91h �� ������� 5
	MVI  C, 017h	; ��२��������� 䠩��
	CALL    00005h
	CPI     004h
	JC      L_E5B2	; �뢮� "Ok" � RET
	JMP     L_E457	; �뢮� "����୮� ���" � RET
;
P_E5CF: RET		; <<<<<<-- �맮� �� 0DA91h �� ������� 2 � 3
;
L_E615: XRA  A
	RET
;
L_E617: MVI  A, 001h
	RET
;
L_E61A: LXI  H, L_E61E
	RET
;
; ��뫪� �� ��ப�:
L_E61E: .dw LsE638	; "�訡�� ���� �� $"		<<< 0DA05h, �� "E:" (1)
LsE620: .dw LsE648	; " �訡�� ��᪠$"
LsE622: .dw LsE656	; "$"			       <<< 0DA05h, �� "E:" (2)
LsE624: .dw LsE657	; " 䠩� ⮫쪮 ��� �⥭��$"
LsE626: .dw LsE6C1	; #0d #0a "������� (Y/N)? $"	<<< 0DA05h, �� "E *.*"
LsE628: .dw LsE67F	; " $"
LsE62A: .dw LsE681	; "�����஢��� (Y/N)? $"
LsE62C: .dw LsE696	; " ���� 㦥 ����$"
LsE62E: .dw LsE66F	; " ��⥬�� 䠩�$"
LsE630: .dw LsE6B2	; #0d #0a "��� 䠩���" #0d #0a "$"
LsE632: .dw LsE6B2	; #0d #0a "��� 䠩���" #0d #0a "$"  <<< 0DA05h, �� "D"
LsE634: .dw LsE656	; "$"
LsE636: .dw LsE656	; "$"
;
LsE638: .db 0EFh	; <�>
	.db 0DBh	; <�>
	.db 0C9h	; <�>
	.db 0C2h	; <�>
	.db 0CBh	; <�>
	.db 0C1h	; <�>
	.db 020h	; < >
	.db 0E2h	; <�>
	.db 0F3h	; <�>
	.db 0F7h	; <�>
	.db 0F7h	; <�>
	.db 020h	; < >
	.db 0CEh	; <�>
	.db 0C1h	; <�>
	.db 020h	; < >
	.db 024h	; <$>
;
LsE647: .db 00Dh	; +++
	.db 00Ah	; +++
LsE648: .db 020h	; < >
	.db 0CFh	; <�>
	.db 0DBh	; <�>
	.db 0C9h	; <�>
	.db 0C2h	; <�>
	.db 0CBh	; <�>
	.db 0C1h	; <�>
	.db 020h	; < >
	.db 0C4h	; <�>
	.db 0C9h	; <�>
	.db 0D3h	; <�>
	.db 0CBh	; <�>
	.db 0C1h	; <�>
	.db 024h	; <$>
;
LsE657: .db 020h	; < >
	.db 0C6h	; <�>
	.db 0C1h	; <�>
	.db 0CAh	; <�>
	.db 0CCh	; <�>
	.db 020h	; < >
	.db 0D4h	; <�>
	.db 0CFh	; <�>
	.db 0CCh	; <�>
	.db 0D8h	; <�>
	.db 0CBh	; <�>
	.db 0CFh	; <�>
	.db 020h	; < >
	.db 0C4h	; <�>
	.db 0CCh	; <�>
	.db 0D1h	; <�>
	.db 020h	; < >
	.db 0DEh	; <�>
	.db 0D4h	; <�>
	.db 0C5h	; <�>
	.db 0CEh	; <�>
	.db 0C9h	; <�>
	.db 0D1h	; <�>
	.db 024h	; <$>
;
LsE66F: .db 020h	; < >
	.db 0D3h	; <�>
	.db 0C9h	; <�>
	.db 0D3h	; <�>
	.db 0D4h	; <�>
	.db 0C5h	; <�>
	.db 0CDh	; <�>
	.db 0CEh	; <�>
	.db 0D9h	; <�>
	.db 0CAh	; <�>
	.db 020h	; < >
	.db 0C6h	; <�>
	.db 0C1h	; <�>
	.db 0CAh	; <�>
	.db 0CCh	; <�>
	.db 024h	; <$>
;
LsE67F: .db 020h	; < >
LsE656:	.db 024h	; <$>
;
LsE852:	.db 02Eh	; <.> // 00Dh, 00Ah
LsE681: .db 0E9h	; <�>
	.db 0C7h	; <�>
	.db 0CEh	; <�>
	.db 0CFh	; <�>
	.db 0D2h	; <�>
	.db 0C9h	; <�>
	.db 0D2h	; <�>
	.db 0CFh	; <�>
	.db 0D7h	; <�>
	.db 0C1h	; <�>
	.db 0D4h	; <�>
	.db 0D8h	; <�>
	.db 020h	; < >
	.db 028h	; <(>
	.db 059h	; <Y>
	.db 02Fh	; </>
	.db 04Eh	; <N>
	.db 029h	; <)>
	.db 03Fh	; <?>
	.db 020h	; < >
	.db 024h	; <$>
;
LsE696: .db 020h	; < >
	.db 0E6h	; <�>
	.db 0C1h	; <�>
	.db 0CAh	; <�>
	.db 0CCh	; <�>
	.db 020h	; < >
	.db 0D5h	; <�>
	.db 0D6h	; <�>
	.db 0C5h	; <�>
	.db 020h	; < >
	.db 0C5h	; <�>
	.db 0D3h	; <�>
	.db 0D4h	; <�>
	.db 0D8h	; <�>
	.db 024h	; <$>
;
S_E6A5: .db 00Dh	; +++ << 0C706h
	.db 00Ah	; +++
L_E6A7: .db 0EEh	; <�>
	.db 0C5h	; <�>
	.db 0D7h	; <�>
	.db 0C5h	; <�>
	.db 0D2h	; <�>
	.db 0CEh	; <�>
	.db 0CFh	; <�>
	.db 0C5h	; <�>
	.db 020h	; < >
	.db 0C9h	; <�>
	.db 0CDh	; <�>
	.db 0D1h	; <�>
	.db 024h	; <$>
;
LsE6B2: .db 00Dh	; <_> << 0C706h
	.db 00Ah	; <_>
	.db 0EEh	; <�>
	.db 0C5h	; <�>
	.db 0D4h	; <�>
	.db 020h	; < >
	.db 0C6h	; <�>
	.db 0C1h	; <�>
	.db 0CAh	; <�>
	.db 0CCh	; <�>
	.db 0CFh	; <�>
	.db 0D7h	; <�>
L_E6BE: .db 00Dh	; <_>
	.db 00Ah	; <_>
	.db 024h	; <$>
;
LsE6C1: .db 00Dh	; <_> << 0C706h
	.db 00Ah	; <_>
	.db 0F5h	; <�>
	.db 0C4h	; <�>
	.db 0C1h	; <�>
	.db 0CCh	; <�>
	.db 0D1h	; <�>
	.db 0D4h	; <�>
	.db 0D8h	; <�>
	.db 020h	; < >
	.db 028h	; <(>
	.db 059h	; <Y>
	.db 02Fh	; </>
	.db 04Eh	; <N>
	.db 029h	; <)>
	.db 03Fh	; <?>
	.db 020h	; < >
	.db 024h	; <$>
;
; =======================================
;L_E6DE: LXI  D, L_E6BE	; ��ॢ�� ��ப�
L_E6E1: MVI  C, 009h	; �뢮� ��᫥����⥫쭮�� ᨬ����� (�� "$")
	JMP     00005h
;
L_E6EB:	LXI  D, A_005C	; ���� ��㬥�� �믮��塞�� ������� (���.� ���)
	MVI  C, 010h	; �����⨥ 䠩��
	JMP     00005h
;
;+++ ������� "9" +++++++++++++++++++++++++++++++++++++++
P_Ex01:	LDA     A_0080	; ��뫪� �� ��㬥��� ���������� ��ப� (<��>< ><��ப�><00h>)
	ANA  A
	JZ      LaD980	; ���室, �᫨ ��=0
	LXI  D, A_005C+1	; ��뫪� �� ��㬥��� ���������� ��ப� (����� ��᪥�� ����)
	CALL    L_E4BA	; ��ॢ�� � HEX � -> HL
	PUSH H		; � �⥪ ��࠭塞 ����� ��᪥��
LxDMAX:	LXI  D, 0FFCFh	; �� ��� �஢�ન ���ᨬ��쭮�� ���祭��, �ࠢ���� �� ���� ��⥬�
	DAD  D
	JC      La9ERR	; �뢮� "����୮� ���" � RET
	LDA     A_005C	; ��뫪� �� ��㬥��� ���������� ��ப� (����� ��᪥�� � ��⥬�)
	ANA  A
	JNZ     LaD931	; �᫨ �� =0 (��� �����)
	LDA     A_0004	; ���뢠�� ����� ⥪�饣� ��᪠
	INR  A		; +1
LaD931: DCR  A		; -1
	CPI     002h	; �᫨ �� >= �:
	JNC     La9ERR	; �뢮� "����୮� ���" � RET
	PUSH PSW
	CALL    L_WBUF	; ��� ��᪮���� ����, �᫨ �ॡ������� ������
	POP  PSW	; �����. � (����� ��᪠)
	MOV  E, A	; ��࠭塞 ����� ��᪠ -> E
	CMA		; �������
	ANI     001h	; �뤥�塞 ���� ���
; ����, �� �ᯮ�짮���� �� 㦥 ������ ��᪥�?
	CALL    LaD9B2	; ����祭�� ��뫪� �� ⠡���� ������ ��᪥�� �� ����
	POP  B		; �����. ����� ��᪥��
	MOV  A, M
	CMP  C
	JNZ     LaD954	; �� ᮢ����
	INX  H
	MOV  A, M
	SUB  B		; ���⠭�� ����� CMP, �⮡� ���㫨�� � � ��砥 ᮢ�������
	JNZ     LaD954	; �� ᮢ����
	MOV  M, A	; ���㫥��� �����, �᫨ �ᯮ�짮����
	DCX  H		; --
	MOV  M, A	; --
LaD954: MOV  A, E	; ����⠭�������� ����� ��᪠
	CALL    LaD9B2	; ����砥� ��뫪� �� �㦭�� ⠡����
	MOV  M, C
	INX  H
	MOV  M, B
	INX  H		; ������ � ⠡���� ����� ��᪥�� ����
	PUSH H		; ���.� �⥪
	LXI  H, 0F3BEh	; = 2 - 0622h * 2
	MVI  A, 0FFh
	INX  B
LaD96A: LXI  D, 00622h	; �㬬�୮� ������⢮ ᥪ�஢ �� ����� ��᪥�
	DAD  D
	ACI     000h
	DCX  B
	MOV  D, A
	MOV  A, B
	ORA  C
	MOV  A, D
	JNZ     LaD96A
	XCHG
	POP  H		; �⠥� �� �⥪� ���� ⠡����
	MOV  M, E	; ���. ��. ����
	INX  H
	MOV  M, D	; ���. ��. ����
	INX  H
	MOV  M, A	; ���. ��.24 ����
LaDONE:	LXI  D, L_E6BE	; ��ॢ�� ��ப�
	JMP     L_E6E1	; �뢮� ��᫥����⥫쭮�� ᨬ����� (�� "$") � RET
;
; �� �뢮�� ⥪�饩 ���䨣��樨
LaD980:	PUSH PSW	; ���. ����� ��᪠
	ADI     041h	; A = A + 41h('A')
	STA     SaOUT1	; ���. �㪢� ��᪠ � ��ப�
	LXI  D, SaOUT0	; ��ப� <��>"A: $"
	CALL    L_E6E1	; �뢮� ��᫥����⥫쭮�� ᨬ����� (�� "$")
	POP  PSW
	PUSH PSW
	CALL    LaD9B2	; ����砥� ��뫪� �� �㦭�� ⠡����
	PUSH H
	INX  H
	CALL    LaDCB1	; �뢮� ���� �� �࠭ �� M(HL)
	POP  H
	CALL    LaDCB1	; �뢮� ���� �� �࠭ �� M(HL)
	POP  PSW
	INR  A		; ������騩 ���
	CPI     002h
	JNZ     LaD980	; 横�...
	JMP     LaDONE	; �뢮� ��ॢ��� ��ப� � RET
;
SaOUT0:	.db 00Dh
	.db 00Ah
SaOUT1:	.db "A: $"
;
LaDCB1:	MOV  A, M
	JMP     B_F815	; �뢮� ���� �� �࠭ 16-�筮� ���� � RET
;	RET
;
LaD9B2: LXI  H, T_DrvA	; �� ����祭�� ��뫪� �� ⠡���� ������ ��᪥�� �� ����
	ANA  A
	RZ
	LXI  H, T_DrvB
	RET
;
La9ERR: POP  B		; �����⪠ �⥪�
	JMP      L_E457	; �뢮� "����୮� ���" � RET
;
;============== ����ணࠬ�� ��� ���� + ���� =========
#ifndef NoFDD
L_E709: MVI  C, 008h
L_E70B: PUSH B
	CALL    L_E8DF	; ������ ᥪ�� ???
	POP  B
	RZ
	DCR  C
	JNZ     L_E70B
	RET
#endif
; ��� ���� ���� �� ���
L_IFHD:
#ifndef NoFDD
	LDA     L_E9A6	; �⥭��(04h)/������(06h)
	ORA  A
	CNZ     L_E709	; ��� ���� �� 䫮���, �᫨ �� 0
	MVI  A, 0E2h
	STA     L_E99F	; �।��騩 ���
	XRA  A
	STA     L_E9A6	; �⥭��(04h)/������(06h) / 0 ???
#endif
;============== ����ணࠬ�� ��� ���� ================
; ��� ���� ���� �� ���
L_WBUF:
#ifndef NoHDD
	LDA     L_RWD	; ᬮ�ਬ ���� "�ॡ���� ������ ����"
	ANA  A		; �ਧ���� �� �, A<>0 -- �ॡ���� ������.
	RZ      	; ������ �᫨ ���, ���� ���饭�� � ���� � �।��騬� ��⠭������
#else
	RET
#endif
#ifndef NoHDD
;
; === �� �⥭��/����� ᥪ�� ���� ===
; �室:	L_E86F -- (ᥪ�� ���� - 1)/4
;	L_1SEC -- ��뫪� �� ⠡���� ���� +2 (����� ��ࢮ�� ᥪ�� �����)
;	L_E86D -- ��஦�� ����
;	L_RWD  -- �⥭��(=0)/������(=FFh)
; ���.:	A � �ਧ��� Z -- ��� �訡��
;	L_BDR -- ��஦��, ��⠭��� � ����
;	L_BSC -- (ᥪ��-1)/4, ��⠭�� � ����
;	L_BDS -- ����� ��᪥�� � ����
;	L_E873 -- ��� ������
;	
L_RWHD:
	LHLD    L_E86D	; ��஦��, = FFh �� ���樠����樨 ���� (�⥭�� 1-�� ᥪ��)
	MOV  D, H
	MOV  E, L
	DAD  H
	DAD  H
	DAD  D
	DAD  H
	XCHG		; DE = ��஦�� * 10
	LHLD    L_E86F	; HL = (ᥪ��-1)/4, = 0 �� ���樠����樨 ���� (�⥭�� 1-�� ᥪ��)
	DAD  D		; HL = ��஦�� * 10 + ((ᥪ��-1)/4) (= 09F6h)
	LDA     L_E86D	; ��஦��, = FFh �� ���樠����樨 ���� (�⥭�� 1-�� ᥪ��)
	CPI     008h
	JNC     L_D85F	; ���室 �᫨ ��஦�� >= 08h (����⥬��� �������)
	LXI  D, 00002h
	XRA  A
	JMP     L_D86C
;
L_D853:	CPI     0FFh
	LXI  D, 0F60Ah	; = -09F6h
	JZ      L_D86C
	JMP     L_D9F8	; ����祭�� ���� �訡�� � RET
;
L_D85F:	CPI     0A5h	; ���ᨬ���� ����� ��஦�� 0A4h
	JNC     L_D853
	PUSH H		; � �⥪ HL = ��஦�� * 10 + (ᥪ��-1)/4
	LHLD    L_1SEC	; ����㧪� � HL ��뫪� �� ⠡���� ���� +2
	MOV  E, M
	INX  H
	MOV  D, M
	INX  H
	MOV  A, M	; (A,DE)=(����� ��ࢮ�� ᥪ�� ��᪥��)
	POP  H		; HL = (����� ᥪ��) = ��஦�� * 10 + (ᥪ��-1)/4
L_D86C:	DAD  D
	ACI     000h	; (A,HL) = (����� ᥪ��) + (����� ��ࢮ�� ᥪ�� ��᪥��) = 00 0000h
	OUT     055h	; LBA [23..16]
	MOV  A, L
	OUT     053h	; LBA [7..0]
	MOV  A, H
	OUT     054h	; LBA [15..8]
	MVI  A, 0E0h	; 1110 0000
	OUT     056h	; ०�� � LBA[27..24]
	MVI  A, 001h	; ������⢮ �⥬��/�����뢠���� ᥪ�஢
	OUT     052h	; ���稪 �᫠ ᥪ�஢ ��� ����樨 �⥭��/�����
	LDA     L_RWD	; �⥭��(=0)/������(=FFh)
	MOV  E, A	; ���.०�� � �
	ANA  A		; ��⠭���� �ਧ���� Z �� �
	MVI  A, 020h	; 2xH = ᥪ�� �⥭�� (x = retry and ECC-read)
	JZ      L_D8A9	; -> �᫨ �⥭��
	MVI  A, 030h	; 3xH = ᥪ�� ����� (x = retry and ECC-read)
L_D8A9:	OUT     057h	; ������:	ॣ���� �������
	LXI  H, D_EB00	; ���� ���� ��� �⥭��/����� ������
	CALL    L_D9D9	; �஢�ઠ ��⮢���� ����
	ANI     008h	; 0000 1000 :	����� ������. ���� ���� ������ (�����)
	JZ      L_D9F9	; ����祭�� ���� �訡�� 2 � RET
	MVI  D, 000h	; D=0
	INR  E		; ���� ��⠭���� �ਧ���� Z �� ���祭�� E
	DCR  E
	JNZ     L_D8CF	; -> ������ ᥪ��
			; �⥭�� ᥪ�� ����
L_D8C1:	IN      050h	; ������� ������. �⥭�� ������ � ����
	MOV  M, A
	INX  H
	IN      058h	; ������� ������. �⥭�� ������ � ����
	MOV  M, A
	INX  H
L_D8Cx:	DCR  D		; ����稪
	JNZ     L_D8C1	; 横�
	JMP     L_D8DC	; ��室 �� �⥭��
;
L_D8CF:	MOV  E, M	; ������ ᥪ��
	INX  H
	MOV  A, M
	OUT     058h	; ������� ������. ������ ������ �� ����
	MOV  A, E
	OUT     050h	; ������� ������. ������ ������ �� ����
	INX  H		; 横� �����
L_D8D8:	DCR  D		; ����稪
	JNZ     L_D8CF	; 横�
L_D8DC:	CALL    L_D9D9	; �஢�ઠ ��⮢���� ����
	ANI     0DDh	; 1101 1101 -- ��᪨�㥬 ���쭥�
	MOV  C, A	; ��࠭塞 ��� ������ � C
	ANI     008h	; 0000 1000 :	���� ���� ������ (�����)
	JZ      L_D8xx	; �᫨ �� �����
	MVI  A, 010h	; 1xH = ��� �� 樫���� 0 (x = step rate)
	OUT     057h	; ������:	ॣ���� �������
L_D8xx:	MOV  A, C
	ANI	0D5h	; 1101 0101 -- ��᪨�㥬 "���� ���� ������ (�����)"
	SUI     050h	; ����� ���. ��� ������
	JNZ     L_D9F9	; (<> 50h) & (<> 58h) -> ����祭�� ���� �訡�� 2 � RET
	STA     L_E873	; ��࠭塞 ��� ������ (=0)
	STA     L_RWD	; ��⪠ "�ॡ���� ������ ����" (�ᥣ�� ��� = 0)
	LDA     L_E86D
	STA     L_BDR	; ��஦�� � ����
	LDA     L_E86F
	STA     L_BSC	; (ᥪ��-1)/4 � ����
	LHLD    L_DSKT
	SHLD    L_BDS	; ��࠭塞 ����� ��᪥��
	RET		; >>>>>>>>>> ��室 �� �� c Z=1
;
; �� �஢�ન ��⮢���� ����
L_D9D9:	PUSH D
	PUSH B
	MVI  D, 005h	; ���� ࠧ...
L_D9DD:	IN      057h	; ॣ���� �����
	ANI     0C0h	; 1100 0000
	CPI     040h	; 0100 0000 ���ன�⢮ ��⮢� � ����樨
	JZ      L_D9F2	; >> ��室 �� 横��, �� ��室� A=40h
	DCX  B
	MOV  A, B
	ORA  C
	JNZ     L_D9DD	; 横� �� 65536 ����⮪
	DCR  D
	JNZ     L_D9DD	; 横� �� 5*65536 ����⮪, �� ��室� A,B,C,D=0
L_D9F2:	ANA  A		; ��⠭�������� �ਧ���� �� �
	POP  B
	POP  D
	JZ      L_D9F8	; ����祭�� ���� �訡�� � RET
	IN      057h	; ॣ���� �����
	RET
;
; �� �⥭�� �訡��
L_D9F8:	POP  PSW	; ��⪠ �⥪�
L_D9F9:	IN      057h	; ॣ���� �����
	RRC		; ᤢ�� ��ࠢ�, ��� 0 �������� � �ਧ��� �.
	IN      051h	; �⥭��:	������� �訡��. ����ন� �ਧ���� ��᫥���� �訡��.
	JC      L_DA02	; �᫨ �।���� ������� �����稫��� � �訡���
	XRA  A		; �訡�� ���
L_DA02:	MOV  B, A	; � = ��� �訡��
	IN      057h	; ॣ���� �����
	MOV  C, A	; ��࠭塞 १����
	ANI     020h	; �뤥�塞 �訡�� "ᡮ� �����"
	ORA  B
	MOV  B, A	; ������塞 ��� �訡�� � �
	MOV  A, C	; �����. ������� ������.
	ANI     0C0h	; �뤥����� ᨣ����� "���ன�⢮ ��⮢�" � "�����"
	CPI     040h	; ���.Z �᫨ "��⮢�"
	MOV  A, B	; ��� �訡�� � �
	JZ      L_E6AB	; ���室, �᫨ ᨣ��� "��⮢�" (?�뫮 �� L_DA15)
	MVI  A, 010h	; 1xH = ��� �� 樫���� 0 (x = step rate) (?�뫮 ORI)
xxDA15:	OUT     05Fh	; ���⥬�� ��� (���� �� ���짮������, �室�⢮ � 57� ��� ���㫥��� �����奬 ���⪮�� ��᪠).
L_E6AB:	STA     L_E873	; ��࠭塞 ��� �訡��
	ANA  A		; ��⠭�������� �ਧ���� �� �訡��
	RET
#endif
;
;============== ����ணࠬ�� ��� 䫮��� ================
L_E716:
#ifdef NoFDD
	ORI  0FFh
	RET		; ��� �ࠩ��� 䫮������� -- �����.�訡��
#else
	LDA     L_E98C	; �⥭��(04h)/������(06h)
	CPI     004h	; ���饭�� � 䫮�����: �⥭��(04h)/������(06h)
	JZ      L_E775	; �⥭�� ᥪ�� �� � ��᪮�� ����
	LDA     L_E990+1	; ���� ���� ��᪮��� ����樨, ��.����
	CPI     0EAh	; ��᪮�� ���� � 0EAxxh?
	JZ      L_E775	; �⥭�� ᥪ�� �� � ��᪮�� ����
	LHLD    L_E9A3	; ��� ����� (��஦�� * 256 + ((�����-1)/8)) � ��諮� �����
	LDA     L_E98F	; ᥪ��
	DCR  A		; -1
	ANI     0F8h	; 1111 1000
	RRC
	RRC
	RRC
	MOV  E, A	; (ᥪ��-1)/8
	CMP  L
	LDA     L_E98E	; ��஦��
	MOV  D, A	; DE = (��஦�� * 256 + ((�����-1)/8))
	JNZ     L_E74E	; �᫨ (����� <> L)
	CMP  H
	JNZ     L_E74E	; �᫨ (��஦�� <> H)
	LDA     L_E98A	; ���
	MOV  C, A
	LDA     L_E99F	; ��� � ��諮� �����
	CMP  C
L_E74E:	XCHG
	SHLD    L_E9A3	; ��࠭塞 (��஦�� * 256 + ((�����-1)/8))
	JNZ     L_E775	; �⥭�� ᥪ�� �� � ��᪮�� ����
	LDA     L_E9A2	; ����稪 ᥪ�஢ ???
	ANA  A
	JZ      L_E77D	; = 0 ? >>
	DCR  A		; ����稪-1
	STA     L_E9A2	; ����稪 ᥪ�஢ ???
	JNZ     L_E77D	; <> 0 ? >>
	STA     L_E9A5	; ����稪 ᥪ�஢ ???
	JMP     L_E77D	; >>
;
L_E775: MVI  A, 010h	; �� �⥭�� ᥪ�� �� � ��᪮�� ����
	STA     L_E9A2	; ����稪 ᥪ�஢ ???
	STA     L_E9A5	; ����稪 ᥪ�஢ ???
	LDA     L_E98F	; ᥪ��
	DCR  A		; -1
	ANI     0F8h	; 1111 1000
	RRC
	RRC
	RRC
	MOV  L, A
L_E77D:	MOV  A, L
	STA     L_E9A7	; (ᥪ��-1)/8
	LXI  H, L_E9A1	; (ᥪ��-1)/8 � ���� (?)
	CMP  M
	JNZ     L_E7AE	; �� ᮢ���� >>
	LDA     L_E98E	; ��஦��
	LXI  H, L_E9A0	; ��஦�� � ���� (?)
	CMP  M
	JNZ     L_E7AE	; �� ᮢ���� >>
	LDA     L_E98A	; ���
	LXI  H, L_E99F	; ��� � ��諮� �����
	CMP  M
	JNZ     L_E7AE	; �� ᮢ���� >>
	LDA     L_E9AB	; RC
	ANA  A
	JZ      L_E7D6	; >>
	JMP     L_E7BC	; >>
;
L_E7AE: LDA     L_E9A6	; �⥭��(04h)/������(06h)
	ORA  A
	JZ      L_E7BC	; �᫨ �⥭��/������ = 0
	CALL    L_E8DF	; ������ ᥪ�� ???
	RNZ		; RET>>
	STA     L_E9A6	; �⥭��(04h)/������(06h), ��������?
L_E7BC: LDA     L_E98A	; ���
	STA     L_E99F	; ��࠭塞 ��� ��� ᫥���饩 ����樨
	LHLD    L_E98E	; ��஦��
	SHLD    L_E9A0	; ��஦�� � ���� (?)
	LDA     L_E9A7	; (ᥪ��-1)/8
	STA     L_E9A1	; (ᥪ��-1)/8 � ���� (?)
	LDA     L_E9A5
	ANA  A
	CNZ     L_E8A7	; �⥭�� ᥪ�� ???
	RNZ		; RET>>
L_E7D6:	LXI  D, D_FD_B	;0EB00h	; ------------
	LDA     L_E98F	; ᥪ��
	DCR  A
	ANI     007h
	RAR
	MOV  H, A
	MVI  A, 000h
	RAR
	MOV  L, A
	DAD  D		; HL -- ��砫� ������ � ���� ��� ��ॡ�᪨
	LDA     L_E98C	; �⥭��(04h)/������(06h)
	CPI     006h
	JNZ     L_E7F8	; �� ������
	STA     L_E9A6	; ���.�⥭��(04h)/������(06h)
L_E7F8: CALL    L_MBUF	; ��ॡ�᪠ ������ ��/� ��᪮�� ���� ����
	LDA     L_E9AB	; RC
	ANA  A
	RET
;
; =============================     ===========
L_E826: LDA     L_E99F	; ��� � ��諮� �����
	ANI     003h
	MOV  C, A
	LDA     L_E9A0	; ��஦�� � ���� (?)
	RRC
	MVI  A, 004h
	JNC     L_E836
	XRA  A
L_E836: ORA  C
	MOV  B, A
	ORI     030h
	STA     L_E9AA
	MVI  E, 004h	; ���⠢�塞 ����稪 �� ������⢨� ��᪥��
L_E83E: IN      01Bh	; ॣ���� ���ﭨ� (IN)
	RLC
	JNC     L_E853	; >>
	MOV  A, B
	OUT     01Ch	; ॣ���� �ࠢ�����
	LXI  H, 00000h	; XXX <<-- ������� !!!
L_E84A: DCX  H
	MOV  A, H
	ORA  L
	JNZ     L_E84A	; 横� ��������, 65536 ࠧ.
	DCR  E
	JNZ     L_E83E	; �����, �᫨ 横� �� ����� 4 ࠧ
LeE852:	PUSH B
	LXI  D, LsE647	; <��>" �訡�� ��᪠"
	CALL    L_E6E1	; �뢮� ��᫥����⥫쭮�� ᨬ����� (�� "$")
	LXI  D, LsE852	; �����...
	CALL    L_E6E1	; �뢮� ��᫥����⥫쭮�� ᨬ����� (�� "$")
	MVI  C, 001h
	CALL    00005h	; ���� ������ ᨬ����
	POP  B
	CPI     04Eh	; == 'N'?
	JZ      O_C003	; ���
	CPI     059h	; == 'Y'?
	JZ      L_E83E	; �����
	JMP     LeE852	; �� ���� �⢥�...
;
L_E853: MOV  A, B
	OUT     01Ch	; ॣ���� �ࠢ�����
	LXI  H, L_E9A8
	LDA     L_E99F	; ��� � ��諮� �����
	ANI     001h
	JZ      L_E862
	INX  H
L_E862: MOV  A, M
	RAR
	OUT     01Ah	; ॣ���� ��஦��
	LDA     L_E9A0	; ��஦�� � ���� (?)
	MOV  M, A
	ANA  A
	RAR
L_E86C: DI
	OUT     018h	; ॣ���� ������
LxE86F: MVI  A, 010h	; 0001 0000 = ���� <--- ������� ���
	OUT     01Bh	; ॣ���� ������ (OUT)
	CALL    L_E884
L_E876: MOV  A, B
	OUT     01Ch	; ॣ���� �ࠢ�����
	IN      01Bh	; ॣ���� ���ﭨ� (IN)
	RRC
	JC      L_E876
	LDA     L_E9AA
	OUT     01Ch	; ॣ���� �ࠢ�����
L_E884: MVI  A, 0FAh
	MVI  C, 002h
L_E888: SUB  C
	JNZ     L_E888
	RET
;
L_E88D: XRA  A		; 0000 0000 = ���
	OUT     01Bh	; ॣ���� ������ (OUT)
	CALL    L_E884
L_E893: MOV  A, B
	OUT     01Ch	; ॣ���� �ࠢ�����
	IN      01Bh	; ॣ���� ���ﭨ� (IN)
	RRC
	JC      L_E893
	CALL    L_E884
	LDA     L_E9A0	; ��஦�� � ���� (?)
	ANA  A
	RAR
	JMP     L_E86C
;
; ======== �� �⥭�� ᥪ�� ===========================
L_E8A7: CALL    L_E826	; >> �஢�ઠ ��⮢���� � ��⠭���� ��஦��
	LDA     L_E9A1	; (ᥪ��-1)/8 � ���� (?)
	INR  A
	OUT     019h	; ॣ���� ᥪ��
	MVI  A, 080h	; 1000 0000 = ���� ���� ᥪ��, ������ ��஭�
	OUT     01Bh	; ॣ���� ������ (OUT)
	LXI  D, D_FD_B	;0EB00h	; ---------------
	LXI  H, L_E8CE	; ���� ������ �� 横��
	PUSH H
	LXI  H, L_E8C1	; = PCHL (2) =
	CALL    L_E884	; >>
L_E8C1: IN      01Bh	; ॣ���� ���ﭨ� (IN)
	RRC
	RNC		; ��室 �� 横�� > L_E8CE
	RRC
	JNC     L_E8C1
	IN      018h	; ॣ���� ������
	STAX D
	INX  D
	PCHL		; (2) >>> L_E8C1
;
L_E8CE: LDA     L_E9AA	; <<<
	OUT     01Ch	; ॣ���� �ࠢ�����
	IN      01Bh	; ॣ���� ���ﭨ� (IN)
	ANI     0DFh	; 1101 1111
L_E8Cz:	STA     L_E9AB	; RC
	ANA  A
	EI
	RZ		; ��室 >>--
	ANI     010h	; ��ࠡ�⪠ �訡��...
	CNZ     L_E88D
	LDA     L_E9AB	; RC
	ANA  A
	RET
;
; ======== �� ����� ᥪ�� =============================
L_E8DF: CALL    L_E826	; �஢�ઠ ��⮢���� ????
	LXI  H, L_E91E	; ���� ������ �� 横��
	PUSH H		;
	LXI  H, L_E8F9	; = PCHL (3) =
	LXI  D, D_FD_B	;0EB00h	; -------------
	LDA     L_E9A1	; (ᥪ��-1)/8 � ���� (?)
	INR  A
	OUT     019h	; ॣ���� ᥪ��
	MVI  A, 0A0h	; 1010 0000 = ����� ���� ᥪ��, ������ ��஭�
	OUT     01Bh	; ॣ���� ������ (OUT)
	CALL    L_E884
L_E8F9: IN      01Bh	; ॣ���� ���ﭨ� (IN)
	ANA  C
	JNZ     L_E919
	IN      01Bh	; ॣ���� ���ﭨ� (IN)
	ANA  C
	JNZ     L_E919
	IN      01Bh	; ॣ���� ���ﭨ� (IN)
	ANA  C
	JNZ     L_E919
	IN      01Bh	; ॣ���� ���ﭨ� (IN)
	ANA  C
	JNZ     L_E919
	IN      01Bh	; ॣ���� ���ﭨ� (IN)
	RRC
	RNC		; >>>> ------
	RRC
	JZ      L_E8F9
L_E919: LDAX D
	OUT     018h	; ॣ���� ������
	INX  D
	PCHL		; (3) >>> L_E8F9
;
L_E91E: LDA     L_E9AA	; <<< �� 横��
	OUT     01Ch	; ॣ���� �ࠢ�����
	IN      01Bh	; ॣ���� ���ﭨ� (IN)
	JMP     L_E8Cz	; ��ࠡ�⪠ �訡�� � ��室
;
#endif
; =============== ����� �� ��� 䫮��� ===============
;
;<< ���饭�� �� 0D6DEh (2)
D_E935: .dw 00028h	; SPT - ������⢮ ᥪ�஢ (�� 128 ����) �� ��஦��;
	.db 004h	; BSH - ������⢮ ���, �� ���஥ ����室��� ᤢ����� ࠧ��� �����᪮�� ᥪ��, �⮡� ������� ࠧ��� ������
	.db 00Fh	; BLM - ��᪠ ������ - (ࠧ���_������/128)-1;
	.db 000h	; ��� - ��᪠ ��४�୮� �����: �᫨ ���=0, � ���ᨬ���� ࠧ���, ����㥬� ����� ��४�୮� �������, ࠢ�� 16�; �᫨ ���=1, � - 32� � �.�.
	.dw 00187h	; DSM - ��ꥬ ����� �� ��᪥ � ������ ����� 1 (�� ���� ��⥬��� ��஦��)
	.dw 0007Fh	; DRM - ������⢮ �室�� � ��४��� -1
	.db 0C0h	; AL0,1 - ��⮢�� 誠�� ������� BLS ��४�ਥ�. ��砫� 誠�� - ��� 7 AL0, ����� - ��� 0 AL1. ������⢮ ������, ���������� AL0,1 (�� ��砫� 誠��) - (DRM+BLS/32)/(BLS/32).
	.db 000h	; // ��।����, ����� ����� ��१�ࢨ஢���
			; // ��� ��४���. �����  ��� AL0,AL1, 
			; // ��稭�� � ���襣� ��� AL0 � ����� 
			; // ����訬 ��⮬ AL1, ���祭��� 1 १�ࢨ���
			; // ���� ���� ������ ��� ��४�ਨ. �㦭�
			; // १�ࢨ஢��� ����室���� �᫮ ������
			; // ��� �࠭���� �室�� � ��४���: 32*DRM/BLS
	.dw 00020h	; CKS - ࠧ��� ������ CSV � DPH. ��� ᬥ���� ��᪮� - (DRM+1)/4, ��� �� ᬥ���� - 0.
	.dw 00008h	; OFF - ������⢮ ��१�ࢨ஢����� ��஦�� �� ��᪥ (� ��⥬�� ���ਬ��). 
;
D_E953: .dw 00008h	; SPT	; << ���饭�� �� 0D6DEh (��)
	.db 003h	; BSH
	.db 007h	; BLM
	.db 000h	; EXM
	.dw 000EBh	; DSM	; = 236 �����஢, 2�� = 472 (001D7h)
	.dw 0003Fh	; DRM	; = 64 �����, 2�� = 128 (0007Fh)
	.db 0C0h	; AL0
	.db 000h	; AL1
	.dw 00000h	; CKS
	.dw 00000h	; OFF
;
; � ��������� ����⥫� ��᪮��� ����樨 �� DDFOh (䫮��/����/��):
L_E98A: .db 000h	; ����� ��᪠ (��� �� >= 2)
	.db 000h	; ?? =80h
L_E98C: .db 000h	; �⥭��(04h)/������(06h)
	.db 000h	; ?? =01h
L_E98E: .db 000h	; ����� ��஦�� ��᪠
L_E98F: .db 000h	; ����� ᥪ�� ��᪠
L_E990: .dw 00000h	; ���� ���� ��� ��᪮��� ����権
;
L_E992: .dw 00000h	; << ���� ᥪ�� ��
L_E994: .db 000h	; ���䨣.��
L_E995: .dw 00000h	; << ���� ����஫쭮� �㬬� ᥪ�� ��
;
; ����:
#ifndef NoHDD
L_DSKT:	.dw 00000h	; ��᪥� ���� (�����)
L_1SEC:	.dw T_DrvA+2	; ��뫪� �� ����� ��ࢮ�� ᥪ�� ��᪥�� �� ⠡���� ����
L_E86D:	.dw 00000h	; ��஦��, = FFh �� ���樠����樨 ���� (�⥭�� 1-�� ᥪ��)
L_E86F:	.dw 00000h	; (ᥪ��-1)/4, = 0 �� ���樠����樨 ���� (�⥭�� 1-�� ᥪ��)
L_BDS:	.dw 0FF00h	; ��᪥�	(������ � ����)
L_BDR:	.db 000h	; ��஦��	(������ � ����)
L_BSC:	.db 000h	; (ᥪ��-1)/4	(������ � ����)
L_RWD:	.db 000h	; �⥭��(=0)/������(=FFh); ��⪠ "�ॡ���� ������ ����", �� =FFh
L_E873:	.db 000h	; ��� �訡�� �� ��室� �� �� �⥭��/�����
#endif
;
; (䫮��):
#ifndef NoFDD
L_E99F: .db 000h	; ��� � ��諮� ����� -- �2
L_E9A0: .db 000h	; ��஦��
L_E9A1: .db 000h	; (ᥪ��-1)/8
L_E9A2: .db 010h	; <_> - |   �    |
L_E9A3: .dw 00000h	; ⥪�饥 ���祭�� (��஦�� * 256 + ((�����-1)/8))
L_E9A5: .db 010h	; <_> - |   �    |
L_E9A6: .db 000h	; �⥭��(04h)/������(06h)
L_E9A7: .db 000h	; (ᥪ��-1)/8
L_E9A8: .db 001h	; <_> - |       �|
	.db 004h	; <_> - |     �  |
L_E9AA: .db 000h	; <_> - |        |
L_E9AB: .db 000h	; १���� �믮������ ������� ????
#endif
;
; ������� ��� ����
T_DrvA: .dw 00001h	; ����� ��᪥�� � HEX
	.dw 00002h	; ����� ��ࢮ�� ᥪ�� � HEX, ��.ࠧ�� 24bit
	.db 000h	; ����� ��ࢮ�� ᥪ�� � HEX, ��.ࠧ�� 24bit
T_DrvB: .dw 00005h	; ����� ��᪥�� � HEX
	.dw 0188Ah	; ����� ��ࢮ�� ᥪ�� � HEX, ��.ࠧ�� 24bit
	.db 000h	; ����� ��ࢮ�� ᥪ�� � HEX, ��.ࠧ�� 24bit
;
; ����� ���� ��᪮�� ����� (������ �� define � ��砫�)
; ������ ���� <= 0EA06h+512 = 0EC06h
D_E9AC:	.db 000h
#if ($ > (S_FONT-0367h))
	; �뤠�� �訡�� � ��砥 �ॢ�襭�� �����⨬��� ࠧ���
	.ECHO "������������ !!! "
	!!!
#endif
;	.dw S_FONT-(D_EB00+512)	; >=0 -- ��� �஢�ન
	.END