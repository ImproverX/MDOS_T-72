	#include "equates.inc"
	#DEFINE F_EEFF S_FONT-1	; ��砫� ⠡���� �࠭���� ���� -1
;
	.ORG    S_FONT
	#include "_EF00h.fnt"
;
	; (0F664h)
L_F600:	PUSH PSW	; � �ਫ��� �� ��ࢮ� ���뢠���
	PUSH D
	PUSH H
	LHLD    L_FFBF	; ����㦠�� 梥� 䮭� � L � 梥� ⥪�� � H
	LXI  D, 0100Fh
L_F609:	MOV  A, E
	OUT     002h	; ������ -- �롮� ��⥬���᪮�� 梥�
	ANI     006h
	MOV  A, L	; A = L, �᫨ (䨧.梥� & 06) = 0
	JZ      L_F613	; 
	MOV  A, H	; � A = H, �᫨ (䨧.梥� & 06) <> 0
L_F613:	OUT     00Ch	; ������ -- ��⠭���� 䨧��᪮�� 梥�
	PUSH PSW
	POP  PSW
	PUSH PSW
	POP  PSW
	DCR  E
	DCR  D		; (����稪 -1)
	OUT     00Ch	; ������ -- ��⠭���� 䨧��᪮�� 梥�, ��� ࠧ
	JNZ     L_F609	; 横� ��⠭���� �������, 16 ࠧ
	LXI  H, L_FFC2
	DCR  M
LxF624:	JNZ     L_F62D	; << ������� �� JMP
	LXI  H, L_F630
	SHLD    00039h	; ��襬 � ���� �� ���뢠���
L_F62D:	POP  H
	POP  D
	POP  PSW
L_F630:	PUSH PSW	; � �ਫ��� �� ᫥����� ���뢠����
	LDA     L_FFC7
	INR  A
	STA     L_FFC7
	ANI     008h
	JZ      L_F640
	STA     L_FFC6	; ����� ???
L_F640:	MVI  A, 08Ah	; ࠡ�⠥� � ��������ன
	OUT     000h	; ��⠭���� ��� ��55
	XRA  A
	OUT     003h
	IN      002h
	INR  A
	JZ      L_F762	; > ������ �� ������
	PUSH B
	LXI  B, 000FEh	; C=1111 1110
	MOV  A, C
L_F652:	OUT     003h
	IN      002h
	CPI     0FFh
	JNZ     L_F666	; > �뫠 ����� ������, � � �⮫���, � � ��ப�
	INR  B
	MOV  A, C
	RLC
	MOV  C, A
	JC      L_F652
	POP  B
L_F762:	CALL    L_F708	; ���ࠢ�塞 ����ன�� ��55
;+++++++++++++++++++++++
	IN      001h	; �⥭�� ���� �
	ANI     080h	; �஢��塞 ����⨥ ���/���
	JZ      L_NRUS	; >> �᫨ ������ �����
	LDA     L_FFB3	; �஢��塞 ���� �����筮�� ������
	ANA  A		; =0?
	CZ      L_URUS	; >> ���/��� ���������� ����, ॠ���㥬
	XRA  A
	STA     L_FFAE	; =00 -- �ਧ��� ��室� ��⠭���� L_FFB3
;+++++++++++++++++++++++
L_F7XX:	;XRA  A		; (��祣� �� �뫮 �����)
	STA     L_FFB0
	CMA
	STA     L_FFB2
L_F7ZZ:	POP  PSW
	EI
	RET
;
;+++++++++++++++++++++++
L_NRUS:	LDA     L_FFAE	; �ਧ��� ��� ��室� ��⠭���� ��⪨
	ANA  A		; <>0?
	JNZ     L_NR1
	STA     L_FFB3	; �⠢�� ���� (=00)
	CMA
	STA     L_FFAE
L_NR1:	LDA     L_FFB2
	INR  A		; =FF?
	JZ      L_F7ZZ	; >> ��㣨� ������ �� ����������, ��室.
	STA     L_FFB3	; ���. ���㫥��� ���祭�� -- ���뢠�� ����
	XRA  A
	JMP     L_F7XX	; >> �� ��室
;+++++++++++++++++++++++
;
L_F666:	PUSH D
	PUSH H
	MVI  C, 0FFh
L_F66A:	INR  C
	RRC
	JC      L_F66A	; � � ����� ��ப�
	IN      001h	; �⥭�� ���� �
	MOV  E, A
	CALL    L_F708	; ���ࠢ�塞 ����ன�� ��55
	MOV  A, B
	ADD  A
	ADD  A
	ADD  A		; �⮫��� * 8
	ADD  C		; + ��ப�
	MOV  C, A	; �= ��� ������
	CPI     010h
	JC      L_F71B	; > ��५��, �1..�5, ��, ��, ��, ��2, ���, ���
	ADI     020h	; + 020h
	MOV  C, A	; �= ��� ᨬ����
	CPI     040h
	JC      L_F745	; > ����� "�/@" (���� � �����)
	CPI     05Fh
	JZ      L_F75D	; > �஡��
	MVI  A, 040h
	ANA  E
	JZ      L_F757	; > ����� ��
	MVI  A, 05Fh
	ORA  E
	CMA		; �뤥�塞 ���/��� � �� (�0�0 0000, 1=��.�����)
	RRC
	RRC		; (00�0 �000)
	XRA  E		; �=(�1�1 0000) => � = 20h, �᫨ ���/��� � �� �����६���� ������ (��� �� ������)
	LXI  H, L_FFC1	; < ��� ���/���+CC: ���=000h,���=020h,lat=080h,LAT=0A0h
	XRA  M
	ANI     0A0h	; 1010 0000
	ORA  C
L_F69E:	ANA  A		; ��� ��稭����� �뢮� ᨬ���� ����⮩ ������
LxF69F:	JMP     L_F6A6	; << ������� �� JP
	MOV  C, A
	MVI  B, 0F7h	; 0F7h ��� ���� ��砫�� ���� 0F7xx (ZzF780)
	LDAX B
L_F6A6:	MOV  C, A
;	CALL    L_F708	; >>
	LDA     L_FFB2
	CPI     0FFh
	JZ      L_F6CE	; >
	CMP  C
	JNZ     L_F6F0	; > �� ��室
	LXI  H, L_FFB0
	MOV  A, M
	CPI     018h
	JZ      L_F6C3	; >
L_F6BF:	INR  M
	JMP     L_F6F0	; > �� ��室
;
L_F6C3:	LXI  H, L_FFAF
	MOV  A, M
	CPI     002h
	JNZ     L_F6BF	; >
	MVI  M, 000h
L_F6CE:	CALL    L_F6F6	; ��� ����⮩ ������ ???
	MOV  A, C
	STA     L_FFB2
	LXI  H, L_FFB4
	MOV  A, M
	CPI     008h
	JNC     L_F6F0	; > �� ��室
	INR  M
	LDA     L_FFB5
	MOV  E, A
	MVI  D, 000h
	LXI  H, L_FFB7
	DAD  D
	INR  A
	ANI     007h
	STA     L_FFB5
	MOV  M, C
L_F6F0:	POP  H		; <
	POP  D
	POP  B
	POP  PSW
	EI
	RET
;
L_F745:	MVI  B, 010h	; ��ࠡ�⪠ ������� ������� (���� � �����)
	CPI     03Ch
	JC      L_F74E
	MVI  B, 000h
L_F74E:	MVI  A, 020h
	ANA  E
	RRC
	XRA  B
	XRA  C
	JMP     L_F69E	; >
;
L_F757:	MVI  A, 0C0h	; ��ࠡ�⪠ ������ ��
	ADD  C		; � = <��� ᨬ����> + 0C0h
	JMP     L_F69E	; >
;
L_F75D:	MVI  A, 020h	; ��ࠡ�⪠ ������ �஡���
	JMP     L_F69E	; >
;
; ����� ⠡��� ��४���஢�� ᨬ����� � ������ 80h-FFh, �ᯮ������ � L_F8E6 � L_F69E
	.ORG    0F7AFh
ZzF780:
;	.db 0C0h	; <�> (offset 80h) +40h
;	.db 0C1h	; <�> (offset 81h)    |
;	.db 0C2h	; <�> (offset 82h)    |
;	.db 0C3h	; <�> (offset 83h)    |
;	.db 0C4h	; <�> (offset 84h)    |
;	.db 0C5h	; <�> (offset 85h)    |
;	.db 0C6h	; <�> (offset 86h)    |
;	.db 0C7h	; <�> (offset 87h)    |
;	.db 0C8h	; <�> (offset 88h)    |
;	.db 0C9h	; <�> (offset 89h)    |
;	.db 0CAh	; <�> (offset 8Ah)    |
;	.db 0CBh	; <�> (offset 8Bh)    |
;	.db 0CCh	; <�> (offset 8Ch)    |
;	.db 0CDh	; <�> (offset 8Dh)    |
;	.db 0CEh	; <�> (offset 8Eh)    |
;	.db 0CFh	; <�> (offset 8Fh)    |
;	.db 0D0h	; <�> (offset 90h)    |
;	.db 0D1h	; <�> (offset 91h)    |
;	.db 0D2h	; <�> (offset 92h)    |
;	.db 0D3h	; <�> (offset 93h)    |
;	.db 0D4h	; <�> (offset 94h)    |
;	.db 0D5h	; <�> (offset 95h)    |
;	.db 0D6h	; <�> (offset 96h)    |
;	.db 0D7h	; <�> (offset 97h)    |
;	.db 0D8h	; <�> (offset 98h)    |
;	.db 0D9h	; <�> (offset 99h)    |
;	.db 0DAh	; <�> (offset 9Ah)    |
;	.db 0DBh	; <�> (offset 9Bh)    |
;	.db 0DCh	; <�> (offset 9Ch)    |
;	.db 0DDh	; <�> (offset 9Dh)    |
;	.db 0DEh	; <�> (offset 9Eh)    |
;	.db 0DFh	; <�> (offset 9Fh) +40h
;	.db 0F0h	; <�> (offset A0h) +50h
;	.db 0F1h	; <�> (offset A1h)    |
;	.db 0F2h	; <�> (offset A2h)    |
;	.db 0F3h	; <�> (offset A3h)    |
;	.db 0F4h	; <�> (offset A4h)    |
;	.db 0F5h	; <�> (offset A5h)    |
;	.db 0F6h	; <�> (offset A6h)    |
;	.db 0F7h	; <�> (offset A7h)    |
;	.db 0F8h	; <�> (offset A8h)    |
;	.db 0F9h	; <�> (offset A9h)    |
;	.db 0FAh	; <�> (offset AAh)    |
;	.db 0FBh	; <�> (offset ABh)    |
;	.db 0FCh	; <�> (offset ACh)    |
;	.db 0FDh	; <�> (offset ADh)    |
;	.db 0FEh	; <�> (offset AEh) +50h
	.db 09Ah	; <�> (offset AFh)
	.db 0B0h	; <�> (offset B0h) ====
	.db 0B1h	; <�> (offset B1h)    |
	.db 0B2h	; <�> (offset B2h)    |
	.db 0B3h	; <�> (offset B3h)    |
	.db 0B4h	; <�> (offset B4h)    |
	.db 0B5h	; <�> (offset B5h)    |
	.db 0B6h	; <�> (offset B6h)    |
	.db 0B7h	; <�> (offset B7h)    |
	.db 0B8h	; <�> (offset B8h)    |
	.db 0B9h	; <�> (offset B9h)    |
	.db 0BAh	; <�> (offset BAh)    |
	.db 0BBh	; <�> (offset BBh)    |
	.db 0BCh	; <�> (offset BCh)    |
	.db 0BDh	; <�> (offset BDh)    |
	.db 0BEh	; <�> (offset BEh)    |
	.db 0BFh	; <�> (offset BFh) ====
	.db 0EEh	; <�> (offset C0h)
	.db 0A0h	; <�> (offset C1h)
	.db 0A1h	; <�> (offset C2h)
	.db 0E6h	; <�> (offset C3h)
	.db 0A4h	; <�> (offset C4h)
	.db 0A5h	; <�> (offset C5h)
	.db 0E4h	; <�> (offset C6h)
	.db 0A3h	; <�> (offset C7h)
	.db 0E5h	; <�> (offset C8h)
	.db 0A8h	; <�> (offset C9h) +21h
	.db 0A9h	; <�> (offset CAh)    |
	.db 0AAh	; <�> (offset CBh)    |
	.db 0ABh	; <�> (offset CCh)    |
	.db 0ACh	; <�> (offset CDh)    |
	.db 0ADh	; <�> (offset CEh)    |
	.db 0AEh	; <�> (offset CFh)    |
	.db 0AFh	; <�> (offset D0h) +21h
	.db 0EFh	; <�> (offset D1h)
	.db 070h	; <p> (offset D2h)
	.db 0E1h	; <�> (offset D3h)
	.db 0E2h	; <�> (offset D4h)
	.db 0E3h	; <�> (offset D5h)
	.db 0A6h	; <�> (offset D6h)
	.db 0A2h	; <�> (offset D7h)
	.db 0ECh	; <�> (offset D8h)
	.db 0EBh	; <�> (offset D9h)
	.db 0A7h	; <�> (offset DAh)
	.db 0E8h	; <�> (offset DBh)
	.db 0EDh	; <�> (offset DCh)
	.db 0E9h	; <�> (offset DDh)
	.db 0E7h	; <�> (offset DEh)
	.db 0EAh	; <�> (offset DFh)
	.db 09Eh	; <�> (offset E0h)
	.db 080h	; <�> (offset E1h)
	.db 081h	; <�> (offset E2h)
	.db 096h	; <�> (offset E3h)
	.db 084h	; <�> (offset E4h)
	.db 085h	; <�> (offset E5h)
	.db 094h	; <�> (offset E6h)
	.db 083h	; <�> (offset E7h)
	.db 095h	; <�> (offset E8h)
	.db 088h	; <�> (offset E9h)
	.db 089h	; <�> (offset EAh)
	.db 08Ah	; <�> (offset EBh)
	.db 08Bh	; <�> (offset ECh)
	.db 08Ch	; <�> (offset EDh)
	.db 048h	; <H> (offset EEh)
	.db 08Eh	; <�> (offset EFh)
	.db 08Fh	; <�> (offset F0h)
	.db 09Fh	; <�> (offset F1h)
	.db 090h	; <�> (offset F2h)
	.db 091h	; <�> (offset F3h)
	.db 092h	; <�> (offset F4h)
	.db 093h	; <�> (offset F5h)
	.db 086h	; <�> (offset F6h)
	.db 082h	; <�> (offset F7h)
	.db 09Ch	; <�> (offset F8h)
	.db 09Bh	; <�> (offset F9h)
	.db 087h	; <�> (offset FAh)
	.db 098h	; <�> (offset FBh)
	.db 09Dh	; <�> (offset FCh)
	.db 099h	; <�> (offset FDh)
	.db 097h	; <�> (offset FEh)
	.db 0FFh	; <�> (offset FFh) ====
;=================================================
L_F800:	JMP     L_F81E	; 宫����� ����㧪� ��⥬�
L_F803:	JMP     L_FE2A	; ���� ᨬ���� � ����������
L_F806:	JMP     L_F8D5	; ���� ���� � �/� -- �ࠧ� RET
L_F809:	JMP     L_F8B9	; �뢮� ᨬ���� �� �࠭
L_F80C:	JMP     L_F8D5	; �뢮� ���� �� �/� -- �ࠧ� RET
L_F80F:	JMP     L_F87C	; �뢮� ᨬ���� �� �ਭ��
L_F812:	JMP     L_FE57	; ����� ����������
L_F815:	JMP     L_F8A4	; �뢮� ���� �� �࠭ 16-�筮� ����
L_F818:	JMP     L_F894	; �뢮� ᮮ�饭�� �� �࠭ (������ ����稢����� 0 ���⮬)
L_F81B:	JMP     L_FE33	; ���� ᨬ���� � ���������� ��� �������� ������
;
;===================== 宫����� ����㧪� ��⥬�
L_F81E:	MVI  A, 023h	; 0010 0011b -- ���� 0 ��� ��� A000-DFFFh
	OUT     010h	; --- ��������
L_F822:	MVI  A, 0C3h
	STA     00038h	; �� ���� ���뢠��� ��襬 JMP ...
	LXI  H, L_F600
	SHLD    00039h	; ... F600h
	XRA  A
	STA     L_FFC2	; ����塞 ��� �祩�� ???
	EI
	RET
;
	.db 008h	; <_> - |    �   | (offset 0333h) 00
	.db 018h	; <_> - |   ��   | (offset 0334h) 01
	.db 019h	; <_> - |   ��  �| (offset 0335h) 02
	.db 01Ah	; <_> - |   �� � | (offset 0336h) 03
	.db 016h	; <_> - |   � �� | (offset 0337h) 04
	.db 00Bh	; <_> - |    � ��| (offset 0338h) 05
	.db 01Fh	; <_> - |   �����| (offset 0339h) 06
	.db 00Ch	; <_> - |    ��  | (offset 033Ah) 07
	.db 007h	; <_> - |     ���| (offset 033Bh) 08
	.db 009h	; <_> - |    �  �| (offset 033Ch) 09
	.db 00Ah	; <_> - |    � � | (offset 033Dh) 0A
	.db 00Dh	; <_> - |    �� �| (offset 033Eh) 0B
L_F83F:	.db 01Bh	; <_> - |   �� ��| (offset 033Fh) 0C ^^^
;
	.db 05Ah	; <Z> 00 ��⠭����� ����� ���-8
	.db 05Ch	; <\> 01 ��⠭����� ����� ����ୠ⨢��� ���� (CP866)
	.db 04Eh	; <N> 02 ����祭�� ����䥪⨢���� ���� ���������� � ��⠭����� 梥⮢�� ������� �ਪ����� ���뢠��� (�।�ᬮ�७� ��� �����४⭮ ����ᠭ��� �ணࠬ�, ��� ��⠭���� 梥� �����⢫���� �� �ࠢ���饩 ��᫥����⥫쭮����)
	.db 04Fh	; <O> 03 ����祭�� ���� ���������� � �⪫�祭��� ����� ⠡���� 梥⮢ �� ���뢠����. ���������� �� 5% �६��� ��. ����� ��⠭����� � ��� �� 㬮�砭��.
	.db 045h	; <E> 04 ������ �࠭ � ��⠭����� ��⨭᪨� ����� ᨬ����� ������������
	.db 061h	; <a> 05 ��⠭����� ०�� �뢮�� ᨬ����� � ����⨢�
	.db 037h	; <7> 06 ��⠭����� ०�� �뢮�� ᨬ����� � ����⨢�
	.db 062h	; <b> 07 ��⠭����� ०�� �뢮�� ᨬ����� � ����⨢�
	.db 036h	; <6> 08 ��⠭����� ०�� �뢮�� ᨬ����� � ����⨢�
	.db 044h	; <D> 09 ����� ᬥ頥��� �� ������ �����
	.db 043h	; <C> 0A ����� ᬥ頥��� �� ������ ��ࠢ�
	.db 041h	; <A> 0B ����� ᬥ頥��� �� ������ �����
	.db 042h	; <B> 0C ����� ᬥ頥��� �� ������ ����
	.db 04Bh	; <K> 0D ������� ���� ��ப�,  ��稭�� � ���樨 ����� � �� ����
	.db 048h	; <H> 0E ����� ����頥��� � ���� ���孨� 㣮�
L_F84F:	.db 04Ah	; <J> 0F ������ �࠭ ^^^
;
L_F850:	.dw P_FCB2	; 00 <<< ��� ��뫪� ��� PCHL
	.dw P_FCBD	; 02
	.dw P_FCA7	; 04
	.dw P_FCA2	; 06
	.dw P_FCAF	; 08
	.dw P_FCC8	; 0A
	.dw P_FCC8	; 0C
	.dw P_FCCC	; 0E
	.dw P_FCCC	; 10
;
L_F862:	.dw P_FB72	; 00 <<< ��뫪� ��� PCHL
	.dw P_FB88	; 02
	.dw P_FB92	; 04
	.dw P_FBAA	; 06
	.dw P_FBC3	; 08
	.dw P_FB5F	; 0A
	.dw P_FB2D	; 0C
	.dw P_FB2D	; 0E
	.dw P_FBF5	; 10
	.dw P_FBB4	; 12
	.dw P_FADA	; 14
	.dw P_FAEF	; 16
	.dw P_FC09	; 18
;
;======================
L_F87C:	PUSH PSW	; �뢮� ᨬ���� �� �ਭ��
	MVI  A, 0FFh
	OUT     005h
L_F881:	IN      005h
	RRC
	JC      L_F881
	MOV  A, C
	OUT     007h
	MVI  A, 0EFh
	OUT     005h
	MVI  A, 0FFh
	OUT     005h
	POP  PSW
	RET
;
;======================
L_F894:	PUSH B		; �뢮� ᮮ�饭�� �� �࠭ (������ ����稢����� 0 ���⮬)
L_F895:	MOV  A, M
	ANA  A
	JZ      L_F8A2
	MOV  C, A
	CALL    L_F8B9
	INX  H
	JMP     L_F895
;
L_F8A2:	POP  B
	RET
;
;======================
L_F8A4:	MOV  B, A	; �뢮� ���� �� �࠭ 16-�筮� ����
	RRC
	RRC
	RRC
	RRC
	CALL    L_F8AD
	MOV  A, B
L_F8AD:	ANI     00Fh
	CPI     00Ah
	JM      L_F8B6
	ADI     007h
L_F8B6:	ADI     030h
	MOV  C, A
;======================= �뢮� ᨬ���� �� �࠭
L_F8B9:	PUSH H
	LXI  H, 00000h
	DAD  SP
	LXI  SP,00000h
	PUSH PSW
	XRA  A	; � = 0 -- �⪫�砥� ��
	OUT     010h	; --- ��������
	PUSH B
	PUSH D
	PUSH H
	CALL    L_F8E6
	POP  H
	POP  D
	POP  B
	MVI  A, 023h	; 0010 0011b -- ���� 0 ��� ��� A000-DFFFh
	OUT     010h	; --- ��������
	POP  PSW
	SPHL
	POP  H
L_F8D5:	RET
;
; ����� ᨬ����� �� �࠭� � �������� 1, 2, 3, 4, 5, 6, 7, 8 � ������ ����.
L_F8D6:	.dw P_F931	; 00 <<< ��뫪� ��� PCHL
	.dw P_F958	; 02
	.dw P_F97F	; 04
	.dw P_F9D2	; 06
	.dw P_F9F9	; 08
	.dw P_FA20	; 0A
	.dw P_FA73	; 0C
	.dw P_FA9A	; 0E
;
L_F8E6:	LDA     L_FFC8	; ��४���஢�� ᨬ�����
	ANA  A
	CNZ     L_FE8C
	ORA  C
	CPI     020h
LxF8F0:	JNC     L_F904	; ���室, �᫨ >=20h <<-- �����塞� ����! �� "JMP XXXX"(�. P_FC09)
L_F8F3:	LXI  H, L_F83F
	LXI  D, L_F862
	MVI  B, 00Ch
L_F8FB:	CMP  M
	JZ      L_FC43
	DCX  H
	DCR  B
	JP      L_F8FB
L_F904:	ANA  A
LxF905:	JP      L_F90C	; ���室, �᫨ � < 80h	<< ������� �� JMP
;+++++++++++++++++++++++++++++++++++++++++++++
	CPI     0AFh
	JNC     L_F908  ; ���室, �᫨ A >= AFh, ���� �� ⠡����
	ADI     040h
	CPI     0E0h	; 0A0h+040h
	JC      L_F90B  ; ���室, �᫨ A < A0h, ���祭�� �㤥� +40h
	ADI     010h	; � ��⠫��� ����� +50h
	JMP     L_F90B
;+++++++++++++++++++++++++++++++++++++++++++++
L_F908:	MVI  B, 0F7h	; 0F7h ��� ���� ��砫�� ���� 0F7xx (ZzF780)
	LDAX B		; ���� �᫮ �� ⠡����
L_F90B:	MOV  C, A
L_F90C:	MOV  L, C
	MVI  H, 000h
	MOV  B, H
	DAD  H
	DAD  B
	DAD  H
	DAD  B		; HL= A * 7
	LXI  D, F_EEFF	; �� � ���� ��뫪� �� ����
	DAD  D
	MOV  B, H
	MOV  C, L	; BC = HL + F_EEFF = A*7+F_EEFF -- ���� ᨬ����
L_F91A:	LXI  H, L_FFAD
	MOV  A, M
	INR  M
	ANI     007h
	ADD  A
	LXI  D, L_F8D6	; ��뫪� ��� PCHL
L_F925:	MVI  H, 000h
	MOV  L, A
	DAD  D
	MOV  E, M
	INX  H
	MOV  D, M
	LHLD    L_FFA9
	XCHG
	PCHL		; ================
;
P_F931:	XCHG		; ����� ᨬ���� � ������� �1, 9, 17...
	LXI  D, 0E007h	; <<<<<
L_F935:	INX  B
	INR  L
	LDAX B
X_F938:	NOP		; ������� �� CMA
	XRA  M
	ANA  D
	XRA  M
	MOV  M, A
	DCR  E
	JNZ     L_F935
	MVI  A, 020h
	ADD  H
	MOV  H, A
	MVI  E, 007h
L_F947:	LDAX B
X_F948:	NOP		; ������� �� CMA
	RLC
	RLC
	RLC
	RLC
	XRA  M
	ANA  D
	XRA  M
	MOV  M, A
	DCX  B
	DCR  L
	DCR  E
	JNZ     L_F947
	RET
;
P_F958:	XCHG		; ����� ᨬ���� � ������� �2, 10, 18...
	LXI  D, 01C07h	; <<<<<
L_F95C:	INX  B
	INR  L
	LDAX B
X_F95F:	NOP		; ������� �� CMA
	RRC
	RRC
	RRC
	XRA  M
	ANA  D
	XRA  M
	MOV  M, A
	DCR  E
	JNZ     L_F95C
	MVI  A, 020h
	ADD  H
	MOV  H, A
	MVI  E, 007h
L_F971:	LDAX B
X_F972:	NOP		; ������� �� CMA
	RLC
	XRA  M
	ANA  D
	XRA  M
	MOV  M, A
	DCX  B
	DCR  L
	DCR  E
	JNZ     L_F971
	RET
;
P_F97F:	XCHG		; ����� ᨬ���� � ������� �3, 11, 19...
	LXI  D, 00307h	; <<<<<
L_F983:	INX  B
	INR  L
	LDAX B
X_F986:	NOP		; ������� �� CMA
	RLC
	RLC
	XRA  M
	ANA  D
	XRA  M
	MOV  M, A
	DCR  E
	JNZ     L_F983
	MVI  A, 020h
	ADD  H
	MOV  H, A
	MVI  E, 007h
L_F997:	LDAX B
X_F998:	NOP		; ������� �� CMA
	RRC
	RRC
	XRA  M
	ANA  D
	XRA  M
	MOV  M, A
	DCX  B
	DCR  L
	DCR  E
	JNZ     L_F997
	MVI  A, 0E1h
	ADD  H
	STA     L_FFAA
	MOV  H, A
	LXI  D, 08007h	; <<<<<
L_F9AF:	INX  B
	INR  L
	LDAX B
X_F9B2:	NOP		; ������� �� CMA
	RLC
	RLC
	XRA  M
	ANA  D
	XRA  M
	MOV  M, A
	DCR  E
	JNZ     L_F9AF
	MVI  A, 020h
	ADD  H
	MOV  H, A
	MVI  E, 007h
L_F9C3:	LDAX B
X_F9C4:	NOP		; ������� �� CMA
	RRC
	RRC
	XRA  M
	ANA  D
	XRA  M
	MOV  M, A
	DCX  B
	DCR  L
	DCR  E
	JNZ     L_F9C3
	RET
;
P_F9D2:	XCHG		; ����� ᨬ���� � ������� �4, 12, 20...
	LXI  D, 07007h	; <<<<<
L_F9D6:	INX  B
	INR  L
	LDAX B
X_F9D9:	NOP		; ������� �� CMA
	RRC
	XRA  M
	ANA  D
	XRA  M
	MOV  M, A
	DCR  E
	JNZ     L_F9D6
	MVI  A, 020h
	ADD  H
	MOV  H, A
	MVI  E, 007h
L_F9E9:	LDAX B
X_F9EA:	NOP		; ������� �� CMA
	RLC
	RLC
	RLC
	XRA  M
	ANA  D
	XRA  M
	MOV  M, A
	DCX  B
	DCR  L
	DCR  E
	JNZ     L_F9E9
	RET
;
P_F9F9:	XCHG		; ����� ᨬ���� � ������� �5, 13, 21...
	LXI  D, 00E07h	; <<<<<
L_F9FD:	INX  B
	INR  L
	LDAX B
X_FA00:	NOP		; ������� �� CMA
	RRC
	RRC
	RRC
	RRC
	XRA  M
	ANA  D
	XRA  M
	MOV  M, A
	DCR  E
	JNZ     L_F9FD
	MVI  A, 020h
	ADD  H
	MOV  H, A
	MVI  E, 007h
L_FA13:	LDAX B
X_FA14:	NOP		; ������� �� CMA
	XRA  M
	ANA  D
	XRA  M
	MOV  M, A
	DCX  B
	DCR  L
	DCR  E
	JNZ     L_FA13
	RET
;
P_FA20:	XCHG		; ����� ᨬ���� � ������� �6, 14, 22...
	LXI  D, 00107h	; <<<<<
L_FA24:	INX  B
	INR  L
	LDAX B
X_FA27:	NOP		; ������� �� CMA
	RLC
	XRA  M
	ANA  D
	XRA  M
	MOV  M, A
	DCR  E
	JNZ     L_FA24
	MVI  A, 020h
	ADD  H
	MOV  H, A
	MVI  E, 007h
L_FA37:	LDAX B
X_FA38:	NOP		; ������� �� CMA
	RRC
	RRC
	RRC
	XRA  M
	ANA  D
	XRA  M
	MOV  M, A
	DCX  B
	DCR  L
	DCR  E
	JNZ     L_FA37
	MVI  A, 0E1h
	ADD  H
	STA     L_FFAA
	MOV  H, A
	LXI  D, 0C007h	; <<<<<
L_FA50:	INX  B
	INR  L
	LDAX B
X_FA53:	NOP		; ������� �� CMA
	RLC
	XRA  M
	ANA  D
	XRA  M
	MOV  M, A
	DCR  E
	JNZ     L_FA50
	MVI  A, 020h
	ADD  H
	MOV  H, A
	MVI  E, 007h
L_FA63:	LDAX B
X_FA64:	NOP		; ������� �� CMA
	RRC
	RRC
	RRC
	XRA  M
	ANA  D
	XRA  M
	MOV  M, A
	DCX  B
	DCR  L
	DCR  E
	JNZ     L_FA63
	RET
;
P_FA73:	XCHG		; ����� ᨬ���� � ������� �7, 15, 23...
	LXI  D, 03807h	; <<<<<
L_FA77:	INX  B
	INR  L
	LDAX B
X_FA7A:	NOP		; ������� �� CMA
	RRC
	RRC
	XRA  M
	ANA  D
	XRA  M
	MOV  M, A
	DCR  E
	JNZ     L_FA77
	MVI  A, 020h
	ADD  H
	MOV  H, A
	MVI  E, 007h
L_FA8B:	LDAX B
X_FA8C:	NOP		; ������� �� CMA
	RLC
	RLC
	XRA  M
	ANA  D
	XRA  M
	MOV  M, A
	DCX  B
	DCR  L
	DCR  E
	JNZ     L_FA8B
	RET
;
P_FA9A:	XCHG		; ����� ᨬ���� � ������� �8, 16, 24...
	LXI  D, 00707h	; <<<<<
L_FA9E:	INX  B
	INR  L
	LDAX B
X_FAA1:	NOP		; ������� �� CMA
	RLC
	RLC
	RLC
	XRA  M
	ANA  D
LxFAA7:	XRA  M
	MOV  M, A
	DCR  E
	JNZ     L_FA9E
	MVI  A, 020h
	ADD  H
	MOV  H, A
	MVI  E, 007h
L_FAB3:	LDAX B
X_FAB4:	NOP		; ������� �� CMA
	RRC
	XRA  M
	ANA  D
	XRA  M
	MOV  M, A
	DCX  B
	DCR  L
	DCR  E
	JNZ     L_FAB3
	MVI  A, 0E1h
	ADD  H
	STA     L_FFAA
	CPI     0BFh
LxFAC8:	RNZ		; <<< ������� �� RET
	DCR  A
	STA     L_FFAA
	LDA     L_FE13
	STA     L_FFAD
	ANA  A
	RNZ
	MVI  A, 0A1h
	STA     L_FFAA
P_FADA:	LDA     L_FFAC
	CPI     018h
	JZ      L_FAF9
	INR  A
	STA     L_FFAC
	LDA     L_FFA9
	SUI     00Ah
	STA     L_FFA9
	RET
;
P_FAEF:	XRA  A
	STA     L_FFAD
	MVI  A, 0A1h
	STA     L_FFAA
	RET
;
L_FAF9:	LDA     L_FFAB	; ᤢ�� �࠭�
	MOV  C, A
	MVI  A, 0E0h
	MVI  H, 0A0h
	CALL    L_FB10
	MOV  A, L
	STA     L_FFAB	; ᤢ�� �࠭�
	OUT     003h
	ADI     006h
	STA     L_FFA9
	RET
;
L_FB10:	MVI  B, 000h
L_FB12:	MOV  L, C
	MOV  M, B
	DCR  L
	MOV  M, B
	DCR  L
	MOV  M, B
	DCR  L
	MOV  M, B
	DCR  L
	MOV  M, B
	DCR  L
	MOV  M, B
	DCR  L
	MOV  M, B
	DCR  L
	MOV  M, B
	DCR  L
	MOV  M, B
	DCR  L
	MOV  M, B
	DCR  L
	INR  H
	CMP  H
	JNZ     L_FB12
	RET
;
P_FB2D:	DI
	LXI  H, 00000h
	DAD  SP
	SHLD    LxFB5C+1
	MVI  A, 0FFh
	STA     L_FFAB	; ᤢ�� �࠭�
	LXI  SP,0E000h	; <<<<<
	LXI  H, 00200h	; <<<<<
	LXI  B, 00000h
L_FB43:	PUSH B
	PUSH B
	PUSH B
	PUSH B
	PUSH B
	PUSH B
	PUSH B
	PUSH B
	PUSH B
	PUSH B
	PUSH B
	PUSH B
	PUSH B
	PUSH B
	PUSH B
	PUSH B
	DCR  L
	JNZ     L_FB43
	DCR  H
	JNZ     L_FB43
LxFB5C:	LXI  SP,00000h	; << ������� ����
	EI
P_FB5F:	LXI  H, 00000h
	SHLD    L_FFAC
	LXI  H, L_FFA9
	LDA     L_FFAB	; ᤢ�� �࠭�
	SUI     00Ah
	MOV  M, A
	INX  H
	MVI  M, 0A1h
	RET
;
P_FB72:	LDA     L_FFAD
	DCR  A
	RM
L_FB77:	STA     L_FFAD
	MOV  C, A
	ADD  A
	ADD  C
	ANI     0F8h
	RRC
	RRC
	RRC
	ADI     0A1h
	STA     L_FFAA
	RET
;
P_FB88:	LDA     L_FFAD
	CPI     04Fh
	RZ
	INR  A
	JMP     L_FB77
;
P_FB92:	LDA     L_FFAC
	DCR  A
	RM
L_FB97:	STA     L_FFAC
	ADD  A
	MOV  C, A
	ADD  A
	ADD  A
	ADD  C
	MOV  C, A
	LDA     L_FFAB	; ᤢ�� �࠭�
	SUI     00Ah
	SUB  C
	STA     L_FFA9
	RET
;
P_FBAA:	LDA     L_FFAC
	CPI     018h
	RZ
	INR  A
	JMP     L_FB97
;
P_FBB4:	LXI  B, F_EEFF+0E0h	; 0EFDFh <<< (�� ���ᠬ 0EF00h-0F5FFh ᨬ���� ������������)
	CALL    L_F91A
	LDA     L_FFAD
	ANI     007h
	JNZ     P_FBB4
	RET
;
P_FBC3:	LDA     L_FFAD
	STA     LxFBF0+1
	MVI  A, 0C9h	; == RET
	STA     LxFAC8
	CALL    P_FBB4
	LDA     L_FFAA
	MOV  H, A
	LDA     L_FFA9
	ADI     00Ah
	MOV  C, A
	MVI  A, 0C0h
	CALL    L_FB10
	LDA     L_FFAA
	ADI     020h
	MOV  H, A
	MVI  A, 0E0h
	CALL    L_FB10
	MVI  A, 0C0h	; == RNZ
	STA     LxFAC8
LxFBF0:	MVI  A, 000h
	JMP     L_FB77
;
P_FBF5:	LXI  H, 00C02h	; <<<<<
L_FBF8:	EI
	HLT
	DCR  H
	MVI  A, 036h
	OUT     008h
	MOV  A, L
	OUT     00Bh
	MOV  A, H
	OUT     00Bh
	JNZ     L_FBF8
	RET
;-------------------------- ����� ��稭����� ����... ----------------
P_FC09:	MVI  A, 0C3h	; JMP ...
	STA     LxF8F0	; ����ᨬ � ��� �祩��
	LXI  H, L_FC15	; � ���� ���室�
	SHLD    LxF8F0+1	; � ᫥���騥
	RET
;
L_FC15:	ANA  A		; <<<<<< ���� ���室 �� 0 00ff p
	JM      L_FC48	; ���室, �᫨ >= 80h
	CPI     059h	; "Y"
	JZ      L_FC4D	; ��ﬠ�  ������  �����
	CPI     054h	; "T"
	JZ      L_FC4D	; ��ﬠ�  ������  �����
	CPI     050h	; "P"
	JZ      L_FC81	; ��������� 梥� 䮭� � ⥪��
	CPI     05Bh	; "["
	JZ      L_FCDD	; ��⠭����� ����� ���-8 (�᭮����)
	CALL    L_FC75
	MOV  A, C
	LXI  H, L_F84F	; ᯨ᮪ ������
	LXI  D, L_F850	; ⠡��� ��뫮�
	MVI  B, 00Fh	; ������⢮ ������
L_FC39:	CMP  M
	JZ      L_FC43	; >> ���室, �᫨ ᮢ����
	DCX  H
	DCR  B
	JP      L_FC39
	RET
;
L_FC43:	MOV  A, B
	ADD  A		; � = "����� �������" * 2
	JMP     L_F925	; ⠬ ����� PCHL...
;
L_FC48:	SUI     060h
	JMP     L_FC54
;
L_FC4D:	LXI  H, L_FC54	; �����뢠�� ��� ����
	SHLD    LxF8F0+1	; � ����⢥ ���室�
	RET
;
L_FC54:	LXI  H, L_FC62	; �����뢠�� ��� ����
	SHLD    LxF8F0+1	; � ����⢥ ���室�
	SUI     020h
L_FC5C:	CPI     019h
	JC      L_FB97
	RET
;
L_FC62:	CALL    L_FC75
	MOV  A, C
	CPI     080h
	JC      L_FC6D
	SUI     060h
L_FC6D:	SUI     020h
L_FC6F:	CPI     050h
	JC      L_FB77
	RET
;
L_FC75:	MVI  A, 0D2h	; ����⠭�������� JNC ...
	STA     LxF8F0
	LXI  H, L_F904	; ... L_F904
	SHLD    LxF8F0+1	; ����ᨬ �����
	RET
;
L_FC81:	LXI  H, L_FC88	; �����뢠�� ��� ����
	SHLD    LxF8F0+1	; � ����⢥ ���室�
	RET
;
L_FC88:	LXI  H, L_FC92	; �����뢠�� ��� ����
	SHLD    LxF8F0+1	; � ����⢥ ���室�
	STA     L_FFBF	; ��࠭塞 梥� 䮭�
	RET
;
L_FC92:	STA     L_FFC0	; ��࠭塞 梥� ⥪��
	XRA  A
	STA     L_FFC2
	LXI  H, L_F600	; �����뢠�� ��� ����
	SHLD    00039h	; � ���� ���뢠���
	JMP     L_FC75
;
P_FCA2:	MVI  A, 0C2h	; == JNZ
	JMP     L_FCA9
;
P_FCA7:	MVI  A, 0C3h	; == JMP
L_FCA9:	STA     LxF624	; ���塞 ⠬...
	JMP     L_F822
;
P_FCAF:	CALL    P_FB2D
P_FCB2:	MVI  A, 0C3h	; == JMP
	STA     LxF69F
	MVI  A, 0F2h	; == JP
	STA     LxF905	; ��� �⪫�砥��� �ᯮ�짮����� ⠡���� ��४���஢�� ᨬ�����
	RET
;
P_FCBD:	MVI  A, 0F2h	; == JP
	STA     LxF69F
	MVI  A, 0C3h	; == JMP
	STA     LxF905
	RET
;
P_FCC8:	XRA  A
	JMP     L_FCCE
;
P_FCCC:	MVI  A, 02Fh	; == CMA (������� �)
L_FCCE:	LXI  H, L_FED5
	MVI  B, 014h
L_FCD3:	MOV  E, M
	INX  H
	MOV  D, M
	INX  H
	STAX D		; ����ᨬ �� ���ᠬ �� ⠡���� L_FED5
	DCR  B
	JNZ     L_FCD3
	RET
;
L_FCDD:	LXI  H, L_FCF0	; �����뢠�� ��� ����
	SHLD    LxF8F0+1	; � ����⢥ ���室�
	XRA  A
	LXI  H, L_FE14
	MVI  B, 005h
L_FCE9:	MOV  M, A
	INX  H
	DCR  B
	JNZ     L_FCE9
	RET
;
L_FCF0:	CPI     030h
	JC      L_FCFA
	CPI     03Ah
	JC      L_FD41
L_FCFA:	CPI     03Bh
	JZ      L_FD54
	CPI     03Dh
	RZ
	CALL    L_FC75
	MOV  A, C
	LXI  H, L_FD26
	LXI  D, L_FD27	; ��뫪� �� ⠡���� ��� PCHL
	MVI  B, 00Ch
L_FD0E:	CMP  M
	JZ      L_FC43	; ⠡��� L_FD27 �ᯮ������ ���.
	DCX  H
	DCR  B
	JP      L_FD0E
	JMP     L_F8F3
;
	.db 04Ah	; <J> - | �  � � | (offset 081Ah) 00
	.db 04Bh	; <K> - | �  � ��| (offset 081Bh) 01
	.db 048h	; <H> - | �  �   | (offset 081Ch) 02
	.db 066h	; <f> - | ��  �� | (offset 081Dh) 03
	.db 041h	; <A> - | �     �| (offset 081Eh) 04
	.db 042h	; <B> - | �    � | (offset 081Fh) 05
	.db 043h	; <C> - | �    ��| (offset 0820h) 06
	.db 044h	; <D> - | �   �  | (offset 0821h) 07
	.db 073h	; <s> - | ���  ��| (offset 0822h) 08
	.db 075h	; <u> - | ��� � �| (offset 0823h) 09
	.db 068h	; <h> - | �� �   | (offset 0824h) 0A
	.db 06Ch	; <l> - | �� ��  | (offset 0825h) 0B
L_FD26:	.db 06Dh	; <m> - | �� �� �| (offset 0826h) 0C ^^^
;
L_FD27:	.dw P_FB2D	; 00 -- � ��� ���� ⠡��� ��� PCHL
	.dw P_FBC3	; 01
	.dw P_FD5D	; 02
	.dw P_FD5D	; 03
	.dw P_FD6B	; 04
	.dw P_FD76	; 05
	.dw P_FD80	; 06
	.dw P_FD8A	; 07
	.dw P_FD95	; 08
	.dw P_FDA9	; 09
	.dw P_FDC1	; 0A
	.dw P_FDCC	; 0B
	.dw P_FDD8	; 0C
;
L_FD41:	SUI     030h
	MOV  C, A
	LXI  H, L_FE14
	MOV  E, M
	MVI  D, 000h
	INX  H
	DAD  D
	MOV  A, M
	ADD  A
	ADD  A
	ADD  M
	ADD  A
	ADD  C
	MOV  M, A
	RET
;
L_FD54:	LXI  H, L_FE14
	MOV  A, M
	INR  A
	ANI     003h
	MOV  M, A
	RET
;
P_FD5D:	LDA     L_FE15
	DCR  A
	CALL    L_FC5C
	LDA     L_FE16
	DCR  A
	JMP     L_FC6F
;
P_FD6B:	LXI  H, L_FE15
	LDA     L_FFAC
	SUB  M
	RM
	JMP     L_FC5C
;
P_FD76:	LXI  H, L_FE15
	LDA     L_FFAC
	ADD  M
	JMP     L_FC5C
;
P_FD80:	LXI  H, L_FE15
	LDA     L_FFAD
	ADD  M
	JMP     L_FC6F
;
P_FD8A:	LXI  H, L_FE15
	LDA     L_FFAD
	SUB  M
	RM
	JMP     L_FC6F
;
P_FD95:	LXI  H, L_FE19
	MOV  E, M
	MVI  D, 000h
	INR  M
	INX  H
	DAD  D
	DAD  D
	LDA     L_FFAC
	MOV  M, A
	INX  H
	LDA     L_FFAD
	MOV  M, A
	RET
;
P_FDA9:	LXI  H, L_FE19
	MOV  A, M
	ANA  A
	RZ
	ADD  A
	MOV  E, A
	MVI  D, 000h
	DCR  M
	INX  H
	DAD  D
	MOV  A, M
	PUSH H
	CALL    L_FB97
	POP  H
	INX  H
	MOV  A, M
	JMP     L_FB77
;
P_FDC1:	LDA     L_FE15
	CPI     007h
	RNZ
	XRA  A
	STA     L_FE13
	RET
;
P_FDCC:	LDA     L_FE15
	CPI     007h
	RNZ
	MVI  A, 04Fh
	STA     L_FE13
	RET
;
P_FDD8:	LDA     L_FE14
	INR  A
	LXI  H, L_FE15
L_FDDF:	PUSH PSW
	PUSH H
	MOV  A, M
	LXI  H, L_FDFA
	PUSH H
	ANA  A
	JZ      P_FCC8
	CPI     007h
	JZ      P_FCCC
	CPI     001h
	JZ      L_FE01
	CPI     004h
	JZ      L_FE01
	POP  H
L_FDFA:	POP  H
	POP  PSW
	DCR  A
	JNZ     L_FDDF
	RET
;
L_FE01:	RET
;
;	.db 021h	; <!> - |  �    �| (offset 0902h) <== XXX
;	.db 009h	; <_> - |    �  �| (offset 0903h) <== XXX
;	.db 0FEh	; <�> - |������� | (offset 0904h) <== XXX
;	.db 022h	; <"> - |  �   � | (offset 0905h) <== XXX
;	.db 0F1h	; <�> - |����   �| (offset 0906h) <== XXX
;	.db 0F8h	; <�> - |�����   | (offset 0907h) <== XXX
;	.db 0C9h	; <�> - |��  �  �| (offset 0908h) <== XXX
;	.db 0FEh	; <�> - |������� | (offset 0909h) <== XXX
;	.db 022h	; <"> - |  �   � | (offset 090Ah) <== XXX
;	.db 0C0h	; <�> - |��      | (offset 090Bh) <== XXX
;	.db 021h	; <!> - |  �    �| (offset 090Ch) <== XXX
;	.db 0F0h	; <�> - |����    | (offset 090Dh) <== XXX
;	.db 0FCh	; <�> - |������  | (offset 090Eh) <== XXX
;	.db 022h	; <"> - |  �   � | (offset 090Fh) <== XXX
;	.db 0F1h	; <�> - |����   �| (offset 0910h) <== XXX
;	.db 0F8h	; <�> - |�����   | (offset 0911h) <== XXX
;	.db 0C9h	; <�> - |��  �  �| (offset 0912h) <== XXX
;
L_FE13:	.db 000h	; <_> - |        | (offset 0913h)
L_FE14:	.db 000h	; <_> - |        | (offset 0914h) 05 vvv
L_FE15:	.db 000h	; <_> - |        | (offset 0915h) 04
L_FE16:	.db 000h	; <_> - |        | (offset 0916h) 03
	.db 000h	; <_> - |        | (offset 0917h) 02
	.db 000h	; <_> - |        | (offset 0918h) 01
L_FE19:	.db 000h	; <_> - |        | (offset 0919h)    vvv
	.db 000h	; <_> - |        | (offset 091Ah)
	.db 000h	; <_> - |        | (offset 091Bh)
;
;	.db 000h	; <_> - |        | (offset 091Ch)
;	.db 000h	; <_> - |        | (offset 091Dh)
;	.db 000h	; <_> - |        | (offset 091Eh)
;	.db 000h	; <_> - |        | (offset 091Fh)
;	.db 000h	; <_> - |        | (offset 0920h)
;	.db 000h	; <_> - |        | (offset 0921h)
;	.db 000h	; <_> - |        | (offset 0922h)
;	.db 000h	; <_> - |        | (offset 0923h)
;	.db 000h	; <_> - |        | (offset 0924h)
;	.db 000h	; <_> - |        | (offset 0925h)
;	.db 000h	; <_> - |        | (offset 0926h)
;	.db 000h	; <_> - |        | (offset 0927h)
;	.db 000h	; <_> - |        | (offset 0928h)
;	.db 000h	; <_> - |        | (offset 0929h)
;
;======================== ���� ᨬ���� � ����������
L_FE2A:	CALL    L_FE33	; ���� ᨬ���� � ����������
	CPI     0FFh
	JZ      L_FE2A
	RET
;
L_FE33:	PUSH B		; ���� ᨬ���� � ���������� ��� �������� ������
	PUSH H
	CALL    L_FE57
	LXI  H, L_FFB4
	JNZ     L_FE42
	DCR  A
	POP  H
	POP  B
	RET
;
L_FE42:	DCR  M
	LXI  H, L_FFB7
	LDA     L_FFB6
	MOV  C, A
	MVI  B, 000h
	DAD  B
	INR  A
	ANI     007h
	STA     L_FFB6
	MOV  A, M
	POP  H
	POP  B
	RET
;
;======================
L_FE57:	EI		; ����� ����������
	LDA     L_FFC6
	ANA  A
	CNZ     L_FE67
	LDA     L_FFB4
	ANA  A
	RZ
	MVI  A, 0FFh
	RET
;
L_FE67:	PUSH H
	PUSH D
	PUSH PSW
	LXI  H, 00000h
	DAD  SP
	LXI  SP,00000h
	PUSH H
	XRA  A		; � = 0 -- �⪫�砥� ��
	OUT     010h	; --- ��������
	STA     L_FFC6
	STA     L_FFC7
	LDA     L_FFC8
	CMA
	CALL    L_FE90
	MVI  A, 023h	; 0010 0011b -- ���� 0 ��� ��� A000-DFFFh
	OUT     010h	; --- ��������
	POP  H
	SPHL
	POP  PSW
	POP  D
	POP  H
	RET
;
L_FE8C:	XRA  A
	STA     L_FFC7
L_FE90:	STA     L_FFC8
	PUSH B
	LHLD    L_FFA9
	DCR  L
	XCHG
	LDA     L_FFAD
	ANI     007h
	MOV  C, A
	MVI  B, 000h
	LXI  H, L_FECD
	DAD  B
	MOV  C, M
	LXI  H, 02000h	; <<<<<
	DAD  D
	CALL    L_FEC2
	MOV  A, C
	RRC
	MOV  C, A
	CC      L_FECA
	CALL    L_FEC2
	MOV  A, C
	RRC
	MOV  C, A
	CC      L_FECA
	CALL    L_FEC2
	POP  B
	XRA  A
	RET
;
L_FEC2:	MOV  A, C
	XRA  M
	MOV  M, A
	XCHG
	MOV  A, C
	XRA  M
	MOV  M, A
	RET
;
L_FECA:	INR  D
	INR  H
	RET
;
L_FECD:	.db 080h	; <�> - |�       | (offset 09CDh)
	.db 010h	; <_> - |   �    | (offset 09CEh)
	.db 002h	; <_> - |      � | (offset 09CFh)
	.db 040h	; <@> - | �      | (offset 09D0h)
	.db 008h	; <_> - |    �   | (offset 09D1h)
	.db 001h	; <_> - |       �| (offset 09D2h)
	.db 020h	; < > - |  �     | (offset 09D3h)
	.db 004h	; <_> - |     �  | (offset 09D4h)
;
L_FED5:	.dw X_F938	; 01 (offset 09D5h)
	.dw X_F948	; 02 (offset 09D7h)
	.dw X_F95F	; 03 (offset 09D9h)
	.dw X_F972	; 04 (offset 09dbh)
	.dw X_F986	; 05 (offset 09DDh)
	.dw X_F998	; 06 (offset 09DFh)
	.dw X_F9B2	; 07 (offset 09E1h)
	.dw X_F9C4	; 08 (offset 09E3h)
	.dw X_F9D9	; 09 (offset 09E5h)
	.dw X_F9EA	; 0A (offset 09E7h)
	.dw X_FA00	; 0B (offset 09E9h)
	.dw X_FA14	; 0C (offset 09EBh)
	.dw X_FA27	; 0D (offset 09EDh)
	.dw X_FA38	; 0E (offset 09EFh)
	.dw X_FA53	; 0F (offset 09F1h)
	.dw X_FA64	; 10 (offset 09F3h)
	.dw X_FA7A	; 11 (offset 09F5h)
	.dw X_FA8C	; 12 (offset 09F7h)
	.dw X_FAA1	; 13 (offset 09F9h)
	.dw X_FAB4	; 14 (offset 09FBh)
;
L_FEFD:	MOV  A, E	; ��ࠡ�⪠ ������ ��2
	CMA
	ANI     0A0h	; 1010 0000 -- �뤥�塞 ���/��� � ��
	MVI  A, 01Bh
	JZ      L_F69E	; >> ����� ⮫쪮 ��2
;	CALL    L_F708
	LDA     L_FFB2
	CPI     0FFh
	JNZ     L_F6F0	; >> ��室
	CALL    L_F6F6	; ��� ����⮩ ������ ???
;	STA     L_FFB2
	LXI  H, L_F6F0	; � �⥪ ���� ��� ������ (��室)
	PUSH H
	XRA  A
	ORA  E
	JP      P_FCB2	; �⪫�祭�� ⠡���� ��४���஢�� (���. ���-8)
	JMP     P_FCBD	; ����祭�� ⠡���� ��४���஢�� (���. ����.���� CP866) 
;
L_FF23:	MOV  A, E	; ��ࠡ�⪠ ������ �5 (䨪��� ���/��� � ��)
;	CMA
;	ANI     0E0h	; 1110 0000 ����뢠�� ���, �஬� ���, �� � ��
	ANI     020h	; 0010 0000 ����뢠�� ���, �஬� ��
	MVI  A, 004h	; (��� ������ �5)
	JNZ     L_F69E	; > ����� ⮫쪮 �5
;	CALL    L_F708	; ०�� �࠭� ???
	LDA     L_FFB2
	CPI     0FFh
	JNZ     L_F6F0	; > ��室 �� ��
	CALL    L_F6F6	; ��� ����⮩ ������ ???
;	STA     L_FFB2	; ���㫥���
;;;	MOV  A, E
;;;	ANI     020h	; 0010 0000
	MVI  A, 020h	; 0010 0000
;	MVI  A, 05Fh	; 0101 1111
;	ORA  E
;	CMA
;	JM      L_FF46	; > e᫨ s=1 (�� ����� ���/���)
;	XRI     020h
L_FF46:	LXI  H, L_FFC1	; < ��� ���/���+CC: ���=000h,���=020h,lat=080h,LAT=0A0h
	XRA  M
	MOV  M, A	; ������� ��⮢ L_FFC1
; ��४��祭�� �������� ���/���
;;	RLC		; ���訩 ࠧ�� � �ਧ��� �
;;	MVI  A, 008h
;;	JNC     L_FF52
;;	XRA  A
;;L_FF52:	STA     L_FFB1	; �������� ���/���
;	CMA
;	ADD  A
;	SBB  A		; A=0, �᫨ ��� �⪫. � �=0FFh, �᫨ ���� �������
;	LXI  H, L_FFB1	; �������� ���/���
;	XRA  M
;	ANI     008h
;	XRA  M
;	MOV  M, A	; 00/08
	JMP     L_F6F0	; > ��室 �� ��
;
;+++++++++++++++++++++++
L_URUS:	CMA
	STA     L_FFB3	; =FF -- ���뢠�� ����
			; ������� ��ࠬ��஢ ���/���
	LDA     L_FFC1	; < ��� ���/���+CC: ���=000h,���=020h,lat=080h,LAT=0A0h
	XRI  0A0h
	STA     L_FFC1	; ������塞 ���祭��
	RLC		; ���訩 ࠧ�� � �ਧ��� �
	MVI  A, 008h
	JNC     L_LAT
	XRA  A
L_LAT:	STA     L_FFB1	; �������� ���/���
	OUT     001h	; ��⠭���� �������� ���/���
	RET		; >> �� ��室
;+++++++++++++++++++++++
;
; -------------------------- �ᯮ������ RST 7 -----------------
L_F708:	MVI  A, 088h
	OUT     000h	; ��⠭���� ��� ��55
	LDA     L_FFAB
	OUT     003h	; ᤢ�� �࠭�
	MVI  A, 010h	; ��⠭���� ०��� �࠭�
	OUT     002h	; 512*256
	LDA     L_FFB1	; �������� ���/���
	OUT     001h	; ��⠭���� �������� ���/���
	RET
;
L_F6F6:	MVI  H, 030h	; ��� ������ ������ ???
	XRA  A
L_F6F9:	MVI  L, 040h
L_F6FB:	DCR  L
	JNZ     L_F6FB
	XRI     001h	; �=0000 000�, ०�� ����஢���� ��⠬�, ��⠭����/��⨥ ��� 0
	OUT     000h
	DCR  H
	JNZ     L_F6F9
	STA     L_FFB2	; ���㫥���
	RET
;
; ��ࠡ�⪠ ������ ��५���, �1..�5, ��, ��, ��, ��2, ���, ���
L_F71B:	MVI  B, 000h
	LXI  H, L_F770	; ⠡��� ��४���஢��
	DAD  B		; � = ��� ������
	MOV  A, M	; � = ��� ᨬ����
	CPI     004h
	JZ      L_FF23	; > ����� �5
	CPI     01Bh
	JZ      L_FEFD	; > ����� ��2
	CPI     07Fh
	JNZ     L_F69E	; > �� ����� �� (⮫쪮 ⠬ �㦥� ��� ᨬ����)
	MVI  A, 020h
	ANA  E		; � � �, �� ���㫮 �� IN 001h
	MVI  A, 07Fh
	JNZ     L_F69E	; > ����� �� ��� ��, ��࠭�� ᨬ����
	MVI  C, 05Fh
	LDA     L_FFC1	; < ��� ���/���+CC: ���=000h,���=020h,lat=080h,LAT=0A0h
	XRA  E		; � � ��� ��� �, �� ���㫮 �� IN 001h
	ANI     080h
	XRA  C
	JMP     L_F69E	; > ��+��="_" (A=05Fh), ��� ��+��="�" (�=0DFh)
;
; ⠡��� ��४���஢�� "��� ������" -- "��� ᨬ����"
L_F770:	.db 009h	; ���
	.db 00Ah	; ��
	.db 00Dh	; ��
	.db 07Fh	; ��
	.db 008h	; ��५�� �����
	.db 019h	; ��५�� �����
	.db 018h	; ��५�� ��ࠢ�
	.db 01Ah	; ��५�� ����
	.db 00Ch	; ��५�� �����-�����
	.db 01Fh	; ���
	.db 01Bh	; ��2
	.db 000h	; �1
	.db 001h	; �2
	.db 002h	; �3
	.db 003h	; �4
	.db 004h	; �5
;
; ��� � ����� 䨪�஢���� �祩�� � ��ࠬ��ࠬ�
	.ORG    0FFA8h
LxFFA8:	.db 000h	; <_> - |        | (offset 0AA8h)
L_FFA9:	.db 0F5h	; <�> - |���� � �| (offset 0AA9h)
L_FFAA:	.db 0A1h	; <�> - |� �    �| (offset 0AAAh)
L_FFAB:	.db 0FFh	; ᤢ�� �࠭�
L_FFAC:	.db 000h	; <_> - |        | (offset 0AACh)
L_FFAD:	.db 000h	; <_> - |        | (offset 0AADh)
L_FFAE:	.db 000h	; +++ �ਧ��� ��� ��室� ��⠭���� L_FFB3
L_FFAF:	.db 000h	; <_> - |        | (offset 0AAFh)
L_FFB0:	.db 000h	; �ਧ��� ��� ���������� ???
L_FFB1:	.db 000h	; �������� ���/��� (00/08)
L_FFB2:	.db 0FFh	; ��� ᨬ���� ����⮩ ������ /FF-���
L_FFB3:	.db 0FFh	; +++ �ਧ��� �����筮�� ������ ���/���
L_FFB4:	.db 000h	; <_> - |        | (offset 0AB4h)
L_FFB5:	.db 002h	; <_> - |      � | (offset 0AB5h)
L_FFB6:	.db 002h	; <_> - |      � | (offset 0AB6h)
L_FFB7:	.db 020h	; < > - |  �     | (offset 0AB7h)
	.db 020h	; < > - |  �     | (offset 0AB8h)
	.db 020h	; < > - |  �     | (offset 0AB9h)
	.db 020h	; < > - |  �     | (offset 0ABAh)
	.db 020h	; < > - |  �     | (offset 0ABBh)
	.db 020h	; < > - |  �     | (offset 0ABCh)
	.db 020h	; < > - |  �     | (offset 0ABDh)
	.db 020h	; < > - |  �     | (offset 0ABEh)
L_FFBF:	.db 000h	; <_> - |        | (offset 0ABFh) ; 梥� 䮭� ��� �������
L_FFC0:	.db 028h	; <(> - |  � �   | (offset 0AC0h) ; 梥� ⥪�� ��� �������
L_FFC1:	.db 0A0h	; <�> - |� �     | (offset 0AC1h) ; ���/��� � ��
L_FFC2:	.db 000h	; <_> - |        | (offset 0AC2h)
	.db 000h	; <_> - |        | (offset 0AC3h)
M_FFC4:	.db 032h	; ᪮���� ����� �� �������� �����
M_FFC5:	.db 04Bh	; ᪮���� ���뢠��� � �����⭮� �����
L_FFC6:	.db 001h	; <_> - |       �| (offset 0AC6h)
L_FFC7:	.db 000h	; <_> - |        | (offset 0AC7h)
L_FFC8:	.db 000h	; <_> - |        | (offset 0AC8h)
;
	.END