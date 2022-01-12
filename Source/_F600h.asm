	#include "equates.inc"
	#DEFINE F_EEFF S_FONT-1	; начало таблицы экранного шрифта -1
;
	.ORG    S_FONT
	#include "_EF00h.fnt"
;
	; (0F664h)
L_F600:	PUSH PSW	; сюда прилетит при первом прерывании
	PUSH D
	PUSH H
	LHLD    L_FFBF	; загружаем цвет фона в L и цвет текста в H
	LXI  D, 0100Fh
L_F609:	MOV  A, E
	OUT     002h	; палитра -- выбор математического цвета
	ANI     006h
	MOV  A, L	; A = L, если (физ.цвет & 06) = 0
	JZ      L_F613	; 
	MOV  A, H	; и A = H, если (физ.цвет & 06) <> 0
L_F613:	OUT     00Ch	; палитра -- установка физического цвета
	PUSH PSW
	POP  PSW
	PUSH PSW
	POP  PSW
	DCR  E
	DCR  D		; (счётчик -1)
	OUT     00Ch	; палитра -- установка физического цвета, ещё раз
	JNZ     L_F609	; цикл установки палитры, 16 раз
	LXI  H, L_FFC2
	DCR  M
LxF624:	JNZ     L_F62D	; << меняется на JMP
	LXI  H, L_F630
	SHLD    00039h	; пишем в адрес при прерывании
L_F62D:	POP  H
	POP  D
	POP  PSW
L_F630:	PUSH PSW	; сюда прилетит при следующих прерываниях
	LDA     L_FFC7
	INR  A
	STA     L_FFC7
	ANI     008h
	JZ      L_F640
	STA     L_FFC6	; курсор ???
L_F640:	MVI  A, 08Ah	; работаем с клавиатурой
	OUT     000h	; установка РУС ВВ55
	XRA  A
	OUT     003h
	IN      002h
	INR  A
	JZ      L_F762	; > клавиши не нажаты
	PUSH B
	LXI  B, 000FEh	; C=1111 1110
	MOV  A, C
L_F652:	OUT     003h
	IN      002h
	CPI     0FFh
	JNZ     L_F666	; > была нажата клавиша, в В столбец, в А строка
	INR  B
	MOV  A, C
	RLC
	MOV  C, A
	JC      L_F652
	POP  B
L_F762:	CALL    L_F708	; поправляем настройки ВВ55
;+++++++++++++++++++++++
	IN      001h	; чтение порта С
	ANI     080h	; проверяем нажатие РУС/ЛАТ
	JZ      L_NRUS	; >> если клавиша нажата
	LDA     L_FFB3	; проверяем метку одиночного нажатия
	ANA  A		; =0?
	CZ      L_URUS	; >> РУС/ЛАТ нажималась одна, реагируем
	XRA  A
	STA     L_FFAE	; =00 -- признак обхода установки L_FFB3
;+++++++++++++++++++++++
L_F7XX:	;XRA  A		; (ничего не было нажато)
	STA     L_FFB0
	CMA
	STA     L_FFB2
L_F7ZZ:	POP  PSW
	EI
	RET
;
;+++++++++++++++++++++++
L_NRUS:	LDA     L_FFAE	; признак для обхода установки метки
	ANA  A		; <>0?
	JNZ     L_NR1
	STA     L_FFB3	; ставим метку (=00)
	CMA
	STA     L_FFAE
L_NR1:	LDA     L_FFB2
	INR  A		; =FF?
	JZ      L_F7ZZ	; >> другие клавиши не нажимались, выход.
	STA     L_FFB3	; сохр. ненулевое значение -- сбрасываем метку
	XRA  A
	JMP     L_F7XX	; >> на выход
;+++++++++++++++++++++++
;
L_F666:	PUSH D
	PUSH H
	MVI  C, 0FFh
L_F66A:	INR  C
	RRC
	JC      L_F66A	; в С номер строки
	IN      001h	; чтение порта С
	MOV  E, A
	CALL    L_F708	; поправляем настройки ВВ55
	MOV  A, B
	ADD  A
	ADD  A
	ADD  A		; столбец * 8
	ADD  C		; + строка
	MOV  C, A	; С= код клавиши
	CPI     010h
	JC      L_F71B	; > стрелки, ф1..ф5, ПС, ВК, ЗБ, АР2, СТР, ТАБ
	ADI     020h	; + 020h
	MOV  C, A	; С= код символа
	CPI     040h
	JC      L_F745	; > меньше "Ю/@" (цифры и знаки)
	CPI     05Fh
	JZ      L_F75D	; > пробел
	MVI  A, 040h
	ANA  E
	JZ      L_F757	; > нажата УС
	MVI  A, 05Fh
	ORA  E
	CMA		; выделяем РУС/ЛАТ и СС (р0с0 0000, 1=кл.нажата)
	RRC
	RRC		; (00р0 с000)
	XRA  E		; Е=(р1с1 0000) => А = 20h, если РУС/ЛАТ и СС одновременно нажаты (или не нажаты)
	LXI  H, L_FFC1	; < тут РУС/ЛАТ+CC: РУС=000h,рус=020h,lat=080h,LAT=0A0h
	XRA  M
	ANI     0A0h	; 1010 0000
	ORA  C
L_F69E:	ANA  A		; отсюда начинается вывод символа нажатой клавиши
LxF69F:	JMP     L_F6A6	; << меняется на JP
	MOV  C, A
	MVI  B, 0F7h	; 0F7h тут является началом адреса 0F7xx (ZzF780)
	LDAX B
L_F6A6:	MOV  C, A
;	CALL    L_F708	; >>
	LDA     L_FFB2
	CPI     0FFh
	JZ      L_F6CE	; >
	CMP  C
	JNZ     L_F6F0	; > на выход
	LXI  H, L_FFB0
	MOV  A, M
	CPI     018h
	JZ      L_F6C3	; >
L_F6BF:	INR  M
	JMP     L_F6F0	; > на выход
;
L_F6C3:	LXI  H, L_FFAF
	MOV  A, M
	CPI     002h
	JNZ     L_F6BF	; >
	MVI  M, 000h
L_F6CE:	CALL    L_F6F6	; звук нажатой клавиши ???
	MOV  A, C
	STA     L_FFB2
	LXI  H, L_FFB4
	MOV  A, M
	CPI     008h
	JNC     L_F6F0	; > на выход
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
L_F745:	MVI  B, 010h	; обработка нажатых клавишь (цифры и знаки)
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
L_F757:	MVI  A, 0C0h	; обработка нажатия УС
	ADD  C		; А = <код символа> + 0C0h
	JMP     L_F69E	; >
;
L_F75D:	MVI  A, 020h	; обработка нажатия пробела
	JMP     L_F69E	; >
;
; далее таблица перекодировки символов с кодами 80h-FFh, используется в L_F8E6 и L_F69E
	.ORG    0F7AFh
ZzF780:
;	.db 0C0h	; <└> (offset 80h) +40h
;	.db 0C1h	; <┴> (offset 81h)    |
;	.db 0C2h	; <┬> (offset 82h)    |
;	.db 0C3h	; <├> (offset 83h)    |
;	.db 0C4h	; <─> (offset 84h)    |
;	.db 0C5h	; <┼> (offset 85h)    |
;	.db 0C6h	; <╞> (offset 86h)    |
;	.db 0C7h	; <╟> (offset 87h)    |
;	.db 0C8h	; <╚> (offset 88h)    |
;	.db 0C9h	; <╔> (offset 89h)    |
;	.db 0CAh	; <╩> (offset 8Ah)    |
;	.db 0CBh	; <╦> (offset 8Bh)    |
;	.db 0CCh	; <╠> (offset 8Ch)    |
;	.db 0CDh	; <═> (offset 8Dh)    |
;	.db 0CEh	; <╬> (offset 8Eh)    |
;	.db 0CFh	; <╧> (offset 8Fh)    |
;	.db 0D0h	; <╨> (offset 90h)    |
;	.db 0D1h	; <╤> (offset 91h)    |
;	.db 0D2h	; <╥> (offset 92h)    |
;	.db 0D3h	; <╙> (offset 93h)    |
;	.db 0D4h	; <╘> (offset 94h)    |
;	.db 0D5h	; <╒> (offset 95h)    |
;	.db 0D6h	; <╓> (offset 96h)    |
;	.db 0D7h	; <╫> (offset 97h)    |
;	.db 0D8h	; <╪> (offset 98h)    |
;	.db 0D9h	; <┘> (offset 99h)    |
;	.db 0DAh	; <┌> (offset 9Ah)    |
;	.db 0DBh	; <█> (offset 9Bh)    |
;	.db 0DCh	; <▄> (offset 9Ch)    |
;	.db 0DDh	; <▌> (offset 9Dh)    |
;	.db 0DEh	; <▐> (offset 9Eh)    |
;	.db 0DFh	; <▀> (offset 9Fh) +40h
;	.db 0F0h	; <Ё> (offset A0h) +50h
;	.db 0F1h	; <ё> (offset A1h)    |
;	.db 0F2h	; <Є> (offset A2h)    |
;	.db 0F3h	; <є> (offset A3h)    |
;	.db 0F4h	; <Ї> (offset A4h)    |
;	.db 0F5h	; <ї> (offset A5h)    |
;	.db 0F6h	; <Ў> (offset A6h)    |
;	.db 0F7h	; <ў> (offset A7h)    |
;	.db 0F8h	; <°> (offset A8h)    |
;	.db 0F9h	; <∙> (offset A9h)    |
;	.db 0FAh	; <·> (offset AAh)    |
;	.db 0FBh	; <√> (offset ABh)    |
;	.db 0FCh	; <№> (offset ACh)    |
;	.db 0FDh	; <¤> (offset ADh)    |
;	.db 0FEh	; <■> (offset AEh) +50h
	.db 09Ah	; <Ъ> (offset AFh)
	.db 0B0h	; <░> (offset B0h) ====
	.db 0B1h	; <▒> (offset B1h)    |
	.db 0B2h	; <▓> (offset B2h)    |
	.db 0B3h	; <│> (offset B3h)    |
	.db 0B4h	; <┤> (offset B4h)    |
	.db 0B5h	; <╡> (offset B5h)    |
	.db 0B6h	; <╢> (offset B6h)    |
	.db 0B7h	; <╖> (offset B7h)    |
	.db 0B8h	; <╕> (offset B8h)    |
	.db 0B9h	; <╣> (offset B9h)    |
	.db 0BAh	; <║> (offset BAh)    |
	.db 0BBh	; <╗> (offset BBh)    |
	.db 0BCh	; <╝> (offset BCh)    |
	.db 0BDh	; <╜> (offset BDh)    |
	.db 0BEh	; <╛> (offset BEh)    |
	.db 0BFh	; <┐> (offset BFh) ====
	.db 0EEh	; <ю> (offset C0h)
	.db 0A0h	; <а> (offset C1h)
	.db 0A1h	; <б> (offset C2h)
	.db 0E6h	; <ц> (offset C3h)
	.db 0A4h	; <д> (offset C4h)
	.db 0A5h	; <е> (offset C5h)
	.db 0E4h	; <ф> (offset C6h)
	.db 0A3h	; <г> (offset C7h)
	.db 0E5h	; <х> (offset C8h)
	.db 0A8h	; <и> (offset C9h) +21h
	.db 0A9h	; <й> (offset CAh)    |
	.db 0AAh	; <к> (offset CBh)    |
	.db 0ABh	; <л> (offset CCh)    |
	.db 0ACh	; <м> (offset CDh)    |
	.db 0ADh	; <н> (offset CEh)    |
	.db 0AEh	; <о> (offset CFh)    |
	.db 0AFh	; <п> (offset D0h) +21h
	.db 0EFh	; <я> (offset D1h)
	.db 070h	; <p> (offset D2h)
	.db 0E1h	; <с> (offset D3h)
	.db 0E2h	; <т> (offset D4h)
	.db 0E3h	; <у> (offset D5h)
	.db 0A6h	; <ж> (offset D6h)
	.db 0A2h	; <в> (offset D7h)
	.db 0ECh	; <ь> (offset D8h)
	.db 0EBh	; <ы> (offset D9h)
	.db 0A7h	; <з> (offset DAh)
	.db 0E8h	; <ш> (offset DBh)
	.db 0EDh	; <э> (offset DCh)
	.db 0E9h	; <щ> (offset DDh)
	.db 0E7h	; <ч> (offset DEh)
	.db 0EAh	; <ъ> (offset DFh)
	.db 09Eh	; <Ю> (offset E0h)
	.db 080h	; <А> (offset E1h)
	.db 081h	; <Б> (offset E2h)
	.db 096h	; <Ц> (offset E3h)
	.db 084h	; <Д> (offset E4h)
	.db 085h	; <Е> (offset E5h)
	.db 094h	; <Ф> (offset E6h)
	.db 083h	; <Г> (offset E7h)
	.db 095h	; <Х> (offset E8h)
	.db 088h	; <И> (offset E9h)
	.db 089h	; <Й> (offset EAh)
	.db 08Ah	; <К> (offset EBh)
	.db 08Bh	; <Л> (offset ECh)
	.db 08Ch	; <М> (offset EDh)
	.db 048h	; <H> (offset EEh)
	.db 08Eh	; <О> (offset EFh)
	.db 08Fh	; <П> (offset F0h)
	.db 09Fh	; <Я> (offset F1h)
	.db 090h	; <Р> (offset F2h)
	.db 091h	; <С> (offset F3h)
	.db 092h	; <Т> (offset F4h)
	.db 093h	; <У> (offset F5h)
	.db 086h	; <Ж> (offset F6h)
	.db 082h	; <В> (offset F7h)
	.db 09Ch	; <Ь> (offset F8h)
	.db 09Bh	; <Ы> (offset F9h)
	.db 087h	; <З> (offset FAh)
	.db 098h	; <Ш> (offset FBh)
	.db 09Dh	; <Э> (offset FCh)
	.db 099h	; <Щ> (offset FDh)
	.db 097h	; <Ч> (offset FEh)
	.db 0FFh	; < > (offset FFh) ====
;=================================================
L_F800:	JMP     L_F81E	; холодная загрузка системы
L_F803:	JMP     L_FE2A	; ввод символа с клавиатуры
L_F806:	JMP     L_F8D5	; ввод байта с м/л -- сразу RET
L_F809:	JMP     L_F8B9	; вывод символа на экран
L_F80C:	JMP     L_F8D5	; вывод байта на м/л -- сразу RET
L_F80F:	JMP     L_F87C	; вывод символа на принтер
L_F812:	JMP     L_FE57	; статус клавиатуры
L_F815:	JMP     L_F8A4	; вывод байта на экран 16-ричном виде
L_F818:	JMP     L_F894	; вывод сообщения на экран (должно оканчиваться 0 байтом)
L_F81B:	JMP     L_FE33	; ввод символа с клавиатуры без ожидания нажатия
;
;===================== холодная загрузка системы
L_F81E:	MVI  A, 023h	; 0010 0011b -- банк 0 как ОЗУ A000-DFFFh
	OUT     010h	; --- квазидиск
L_F822:	MVI  A, 0C3h
	STA     00038h	; на адрес прерывания пишем JMP ...
	LXI  H, L_F600
	SHLD    00039h	; ... F600h
	XRA  A
	STA     L_FFC2	; обнуляем эту ячейку ???
	EI
	RET
;
	.db 008h	; <_> - |    ■   | (offset 0333h) 00
	.db 018h	; <_> - |   ■■   | (offset 0334h) 01
	.db 019h	; <_> - |   ■■  ■| (offset 0335h) 02
	.db 01Ah	; <_> - |   ■■ ■ | (offset 0336h) 03
	.db 016h	; <_> - |   ■ ■■ | (offset 0337h) 04
	.db 00Bh	; <_> - |    ■ ■■| (offset 0338h) 05
	.db 01Fh	; <_> - |   ■■■■■| (offset 0339h) 06
	.db 00Ch	; <_> - |    ■■  | (offset 033Ah) 07
	.db 007h	; <_> - |     ■■■| (offset 033Bh) 08
	.db 009h	; <_> - |    ■  ■| (offset 033Ch) 09
	.db 00Ah	; <_> - |    ■ ■ | (offset 033Dh) 0A
	.db 00Dh	; <_> - |    ■■ ■| (offset 033Eh) 0B
L_F83F:	.db 01Bh	; <_> - |   ■■ ■■| (offset 033Fh) 0C ^^^
;
	.db 05Ah	; <Z> 00 Установить набор КОИ-8
	.db 05Ch	; <\> 01 Установить набор Альтернативная ГОСТ (CP866)
	.db 04Eh	; <N> 02 Включение неэффективного опроса клавиатуры с установкой цветовой палитры прикаждом прерывании (предусмотрена для некорректно написанных программ, где установка цвета осуществляется не управляющей последовательностью)
	.db 04Fh	; <O> 03 Включение опроса клавиатуры с отключением записи таблицы цветов при прерываниях. Экономится до 5% времени ЦП. Режим установлен в ДОС по умолчанию.
	.db 045h	; <E> 04 Очистить экран и установить латинский набор символов знакогенератора
	.db 061h	; <a> 05 Установить режим вывода символов в позитиве
	.db 037h	; <7> 06 Установить режим вывода символов в позитиве
	.db 062h	; <b> 07 Установить режим вывода символов в негативе
	.db 036h	; <6> 08 Установить режим вывода символов в негативе
	.db 044h	; <D> 09 Курсор смещается на позицию влево
	.db 043h	; <C> 0A Курсор смещается на позицию вправо
	.db 041h	; <A> 0B Курсор смещается на позицию вверх
	.db 042h	; <B> 0C Курсор смещается на позицию вниз
	.db 04Bh	; <K> 0D Удалить часть строки,  начиная с позции курсора и до конца
	.db 048h	; <H> 0E Курсор помещается в левый верхний угол
L_F84F:	.db 04Ah	; <J> 0F Очистить экран ^^^
;
L_F850:	.dw P_FCB2	; 00 <<< ещё ссылки для PCHL
	.dw P_FCBD	; 02
	.dw P_FCA7	; 04
	.dw P_FCA2	; 06
	.dw P_FCAF	; 08
	.dw P_FCC8	; 0A
	.dw P_FCC8	; 0C
	.dw P_FCCC	; 0E
	.dw P_FCCC	; 10
;
L_F862:	.dw P_FB72	; 00 <<< ссылки для PCHL
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
L_F87C:	PUSH PSW	; вывод символа на принтер
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
L_F894:	PUSH B		; вывод сообщения на экран (должно оканчиваться 0 байтом)
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
L_F8A4:	MOV  B, A	; вывод байта на экран 16-ричном виде
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
;======================= вывод символа на экран
L_F8B9:	PUSH H
	LXI  H, 00000h
	DAD  SP
	LXI  SP,00000h
	PUSH PSW
	XRA  A	; А = 0 -- отключаем КД
	OUT     010h	; --- квазидиск
	PUSH B
	PUSH D
	PUSH H
	CALL    L_F8E6
	POP  H
	POP  D
	POP  B
	MVI  A, 023h	; 0010 0011b -- банк 0 как ОЗУ A000-DFFFh
	OUT     010h	; --- квазидиск
	POP  PSW
	SPHL
	POP  H
L_F8D5:	RET
;
; печать символов на экране в колонках 1, 2, 3, 4, 5, 6, 7, 8 и даллее повт.
L_F8D6:	.dw P_F931	; 00 <<< ссылки для PCHL
	.dw P_F958	; 02
	.dw P_F97F	; 04
	.dw P_F9D2	; 06
	.dw P_F9F9	; 08
	.dw P_FA20	; 0A
	.dw P_FA73	; 0C
	.dw P_FA9A	; 0E
;
L_F8E6:	LDA     L_FFC8	; перекодировка символов
	ANA  A
	CNZ     L_FE8C
	ORA  C
	CPI     020h
LxF8F0:	JNC     L_F904	; переход, если >=20h <<-- изменяемый адрес! на "JMP XXXX"(см. P_FC09)
L_F8F3:	LXI  H, L_F83F
	LXI  D, L_F862
	MVI  B, 00Ch
L_F8FB:	CMP  M
	JZ      L_FC43
	DCX  H
	DCR  B
	JP      L_F8FB
L_F904:	ANA  A
LxF905:	JP      L_F90C	; переход, если А < 80h	<< меняется на JMP
;+++++++++++++++++++++++++++++++++++++++++++++
	CPI     0AFh
	JNC     L_F908  ; переход, если A >= AFh, берём из таблицы
	ADI     040h
	CPI     0E0h	; 0A0h+040h
	JC      L_F90B  ; переход, если A < A0h, значение будет +40h
	ADI     010h	; в остальных случаях +50h
	JMP     L_F90B
;+++++++++++++++++++++++++++++++++++++++++++++
L_F908:	MVI  B, 0F7h	; 0F7h тут является началом адреса 0F7xx (ZzF780)
	LDAX B		; берём число из таблицы
L_F90B:	MOV  C, A
L_F90C:	MOV  L, C
	MVI  H, 000h
	MOV  B, H
	DAD  H
	DAD  B
	DAD  H
	DAD  B		; HL= A * 7
	LXI  D, F_EEFF	; это и есть ссылка на шрифт
	DAD  D
	MOV  B, H
	MOV  C, L	; BC = HL + F_EEFF = A*7+F_EEFF -- адрес символа
L_F91A:	LXI  H, L_FFAD
	MOV  A, M
	INR  M
	ANI     007h
	ADD  A
	LXI  D, L_F8D6	; ссылки для PCHL
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
P_F931:	XCHG		; печать символа в колонке №1, 9, 17...
	LXI  D, 0E007h	; <<<<<
L_F935:	INX  B
	INR  L
	LDAX B
X_F938:	NOP		; меняется на CMA
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
X_F948:	NOP		; меняется на CMA
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
P_F958:	XCHG		; печать символа в колонке №2, 10, 18...
	LXI  D, 01C07h	; <<<<<
L_F95C:	INX  B
	INR  L
	LDAX B
X_F95F:	NOP		; меняется на CMA
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
X_F972:	NOP		; меняется на CMA
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
P_F97F:	XCHG		; печать символа в колонке №3, 11, 19...
	LXI  D, 00307h	; <<<<<
L_F983:	INX  B
	INR  L
	LDAX B
X_F986:	NOP		; меняется на CMA
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
X_F998:	NOP		; меняется на CMA
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
X_F9B2:	NOP		; меняется на CMA
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
X_F9C4:	NOP		; меняется на CMA
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
P_F9D2:	XCHG		; печать символа в колонке №4, 12, 20...
	LXI  D, 07007h	; <<<<<
L_F9D6:	INX  B
	INR  L
	LDAX B
X_F9D9:	NOP		; меняется на CMA
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
X_F9EA:	NOP		; меняется на CMA
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
P_F9F9:	XCHG		; печать символа в колонке №5, 13, 21...
	LXI  D, 00E07h	; <<<<<
L_F9FD:	INX  B
	INR  L
	LDAX B
X_FA00:	NOP		; меняется на CMA
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
X_FA14:	NOP		; меняется на CMA
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
P_FA20:	XCHG		; печать символа в колонке №6, 14, 22...
	LXI  D, 00107h	; <<<<<
L_FA24:	INX  B
	INR  L
	LDAX B
X_FA27:	NOP		; меняется на CMA
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
X_FA38:	NOP		; меняется на CMA
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
X_FA53:	NOP		; меняется на CMA
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
X_FA64:	NOP		; меняется на CMA
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
P_FA73:	XCHG		; печать символа в колонке №7, 15, 23...
	LXI  D, 03807h	; <<<<<
L_FA77:	INX  B
	INR  L
	LDAX B
X_FA7A:	NOP		; меняется на CMA
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
X_FA8C:	NOP		; меняется на CMA
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
P_FA9A:	XCHG		; печать символа в колонке №8, 16, 24...
	LXI  D, 00707h	; <<<<<
L_FA9E:	INX  B
	INR  L
	LDAX B
X_FAA1:	NOP		; меняется на CMA
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
X_FAB4:	NOP		; меняется на CMA
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
LxFAC8:	RNZ		; <<< меняется на RET
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
L_FAF9:	LDA     L_FFAB	; сдвиг экрана
	MOV  C, A
	MVI  A, 0E0h
	MVI  H, 0A0h
	CALL    L_FB10
	MOV  A, L
	STA     L_FFAB	; сдвиг экрана
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
	STA     L_FFAB	; сдвиг экрана
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
LxFB5C:	LXI  SP,00000h	; << меняется адрес
	EI
P_FB5F:	LXI  H, 00000h
	SHLD    L_FFAC
	LXI  H, L_FFA9
	LDA     L_FFAB	; сдвиг экрана
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
	LDA     L_FFAB	; сдвиг экрана
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
P_FBB4:	LXI  B, F_EEFF+0E0h	; 0EFDFh <<< (по адресам 0EF00h-0F5FFh символы знакогенератора)
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
;-------------------------- здесь начинается трэш... ----------------
P_FC09:	MVI  A, 0C3h	; JMP ...
	STA     LxF8F0	; заносим в эту ячейку
	LXI  H, L_FC15	; и адрес перехода
	SHLD    LxF8F0+1	; в следующие
	RET
;
L_FC15:	ANA  A		; <<<<<< есть переход при 0 00ff p
	JM      L_FC48	; переход, если >= 80h
	CPI     059h	; "Y"
	JZ      L_FC4D	; Прямая  адресация  курсора
	CPI     054h	; "T"
	JZ      L_FC4D	; Прямая  адресация  курсора
	CPI     050h	; "P"
	JZ      L_FC81	; изменение цвета фона и текста
	CPI     05Bh	; "["
	JZ      L_FCDD	; Установить набор КОИ-8 (основной)
	CALL    L_FC75
	MOV  A, C
	LXI  H, L_F84F	; список команд
	LXI  D, L_F850	; таблица ссылок
	MVI  B, 00Fh	; количество команд
L_FC39:	CMP  M
	JZ      L_FC43	; >> переход, если совпало
	DCX  H
	DCR  B
	JP      L_FC39
	RET
;
L_FC43:	MOV  A, B
	ADD  A		; А = "номер команды" * 2
	JMP     L_F925	; там дальше PCHL...
;
L_FC48:	SUI     060h
	JMP     L_FC54
;
L_FC4D:	LXI  H, L_FC54	; записываем этот адрес
	SHLD    LxF8F0+1	; в качестве перехода
	RET
;
L_FC54:	LXI  H, L_FC62	; записываем этот адрес
	SHLD    LxF8F0+1	; в качестве перехода
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
L_FC75:	MVI  A, 0D2h	; восстанавливаем JNC ...
	STA     LxF8F0
	LXI  H, L_F904	; ... L_F904
	SHLD    LxF8F0+1	; заносим далее
	RET
;
L_FC81:	LXI  H, L_FC88	; записываем этот адрес
	SHLD    LxF8F0+1	; в качестве перехода
	RET
;
L_FC88:	LXI  H, L_FC92	; записываем этот адрес
	SHLD    LxF8F0+1	; в качестве перехода
	STA     L_FFBF	; сохраняем цвет фона
	RET
;
L_FC92:	STA     L_FFC0	; сохраняем цвет текста
	XRA  A
	STA     L_FFC2
	LXI  H, L_F600	; записываем этот адрес
	SHLD    00039h	; в адрес прерывания
	JMP     L_FC75
;
P_FCA2:	MVI  A, 0C2h	; == JNZ
	JMP     L_FCA9
;
P_FCA7:	MVI  A, 0C3h	; == JMP
L_FCA9:	STA     LxF624	; меняем там...
	JMP     L_F822
;
P_FCAF:	CALL    P_FB2D
P_FCB2:	MVI  A, 0C3h	; == JMP
	STA     LxF69F
	MVI  A, 0F2h	; == JP
	STA     LxF905	; тут отключается использование таблицы перекодировки символов
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
P_FCCC:	MVI  A, 02Fh	; == CMA (инверсия А)
L_FCCE:	LXI  H, L_FED5
	MVI  B, 014h
L_FCD3:	MOV  E, M
	INX  H
	MOV  D, M
	INX  H
	STAX D		; заносим по адресам из таблицы L_FED5
	DCR  B
	JNZ     L_FCD3
	RET
;
L_FCDD:	LXI  H, L_FCF0	; записываем этот адрес
	SHLD    LxF8F0+1	; в качестве перехода
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
	LXI  D, L_FD27	; ссылка на таблицу для PCHL
	MVI  B, 00Ch
L_FD0E:	CMP  M
	JZ      L_FC43	; таблица L_FD27 используется тут.
	DCX  H
	DCR  B
	JP      L_FD0E
	JMP     L_F8F3
;
	.db 04Ah	; <J> - | ■  ■ ■ | (offset 081Ah) 00
	.db 04Bh	; <K> - | ■  ■ ■■| (offset 081Bh) 01
	.db 048h	; <H> - | ■  ■   | (offset 081Ch) 02
	.db 066h	; <f> - | ■■  ■■ | (offset 081Dh) 03
	.db 041h	; <A> - | ■     ■| (offset 081Eh) 04
	.db 042h	; <B> - | ■    ■ | (offset 081Fh) 05
	.db 043h	; <C> - | ■    ■■| (offset 0820h) 06
	.db 044h	; <D> - | ■   ■  | (offset 0821h) 07
	.db 073h	; <s> - | ■■■  ■■| (offset 0822h) 08
	.db 075h	; <u> - | ■■■ ■ ■| (offset 0823h) 09
	.db 068h	; <h> - | ■■ ■   | (offset 0824h) 0A
	.db 06Ch	; <l> - | ■■ ■■  | (offset 0825h) 0B
L_FD26:	.db 06Dh	; <m> - | ■■ ■■ ■| (offset 0826h) 0C ^^^
;
L_FD27:	.dw P_FB2D	; 00 -- и ещё одна таблица для PCHL
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
;	.db 021h	; <!> - |  ■    ■| (offset 0902h) <== XXX
;	.db 009h	; <_> - |    ■  ■| (offset 0903h) <== XXX
;	.db 0FEh	; <■> - |■■■■■■■ | (offset 0904h) <== XXX
;	.db 022h	; <"> - |  ■   ■ | (offset 0905h) <== XXX
;	.db 0F1h	; <ё> - |■■■■   ■| (offset 0906h) <== XXX
;	.db 0F8h	; <°> - |■■■■■   | (offset 0907h) <== XXX
;	.db 0C9h	; <╔> - |■■  ■  ■| (offset 0908h) <== XXX
;	.db 0FEh	; <■> - |■■■■■■■ | (offset 0909h) <== XXX
;	.db 022h	; <"> - |  ■   ■ | (offset 090Ah) <== XXX
;	.db 0C0h	; <└> - |■■      | (offset 090Bh) <== XXX
;	.db 021h	; <!> - |  ■    ■| (offset 090Ch) <== XXX
;	.db 0F0h	; <Ё> - |■■■■    | (offset 090Dh) <== XXX
;	.db 0FCh	; <№> - |■■■■■■  | (offset 090Eh) <== XXX
;	.db 022h	; <"> - |  ■   ■ | (offset 090Fh) <== XXX
;	.db 0F1h	; <ё> - |■■■■   ■| (offset 0910h) <== XXX
;	.db 0F8h	; <°> - |■■■■■   | (offset 0911h) <== XXX
;	.db 0C9h	; <╔> - |■■  ■  ■| (offset 0912h) <== XXX
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
;======================== ввод символа с клавиатуры
L_FE2A:	CALL    L_FE33	; ввод символа с клавиатуры
	CPI     0FFh
	JZ      L_FE2A
	RET
;
L_FE33:	PUSH B		; ввод символа с клавиатуры без ожидания нажатия
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
L_FE57:	EI		; статус клавиатуры
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
	XRA  A		; А = 0 -- отключаем КД
	OUT     010h	; --- квазидиск
	STA     L_FFC6
	STA     L_FFC7
	LDA     L_FFC8
	CMA
	CALL    L_FE90
	MVI  A, 023h	; 0010 0011b -- банк 0 как ОЗУ A000-DFFFh
	OUT     010h	; --- квазидиск
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
L_FECD:	.db 080h	; <А> - |■       | (offset 09CDh)
	.db 010h	; <_> - |   ■    | (offset 09CEh)
	.db 002h	; <_> - |      ■ | (offset 09CFh)
	.db 040h	; <@> - | ■      | (offset 09D0h)
	.db 008h	; <_> - |    ■   | (offset 09D1h)
	.db 001h	; <_> - |       ■| (offset 09D2h)
	.db 020h	; < > - |  ■     | (offset 09D3h)
	.db 004h	; <_> - |     ■  | (offset 09D4h)
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
L_FEFD:	MOV  A, E	; обработка нажатия АР2
	CMA
	ANI     0A0h	; 1010 0000 -- выделяем РУС/ЛАТ и СС
	MVI  A, 01Bh
	JZ      L_F69E	; >> нажата только АР2
;	CALL    L_F708
	LDA     L_FFB2
	CPI     0FFh
	JNZ     L_F6F0	; >> выход
	CALL    L_F6F6	; звук нажатой клавиши ???
;	STA     L_FFB2
	LXI  H, L_F6F0	; в стек адрес для возврата (выход)
	PUSH H
	XRA  A
	ORA  E
	JP      P_FCB2	; отключение таблицы перекодировки (Уст. КОИ-8)
	JMP     P_FCBD	; включение таблицы перекодировки (Уст. Альт.ГОСТ CP866) 
;
L_FF23:	MOV  A, E	; обработка нажатия Ф5 (фиксация РУС/ЛАТ и СС)
;	CMA
;	ANI     0E0h	; 1110 0000 отбрасываем всё, кроме РУС, УС и СС
	ANI     020h	; 0010 0000 отбрасываем всё, кроме СС
	MVI  A, 004h	; (код клавиши Ф5)
	JNZ     L_F69E	; > нажата только Ф5
;	CALL    L_F708	; режим экрана ???
	LDA     L_FFB2
	CPI     0FFh
	JNZ     L_F6F0	; > выход из ПП
	CALL    L_F6F6	; звук нажатой клавиши ???
;	STA     L_FFB2	; обнуление
;;;	MOV  A, E
;;;	ANI     020h	; 0010 0000
	MVI  A, 020h	; 0010 0000
;	MVI  A, 05Fh	; 0101 1111
;	ORA  E
;	CMA
;	JM      L_FF46	; > eсли s=1 (НЕ нажата РУС/ЛАТ)
;	XRI     020h
L_FF46:	LXI  H, L_FFC1	; < тут РУС/ЛАТ+CC: РУС=000h,рус=020h,lat=080h,LAT=0A0h
	XRA  M
	MOV  M, A	; инверсия битов L_FFC1
; переключение индикатора РУС/ЛАТ
;;	RLC		; старший разряд в признак С
;;	MVI  A, 008h
;;	JNC     L_FF52
;;	XRA  A
;;L_FF52:	STA     L_FFB1	; индикатор РУС/ЛАТ
;	CMA
;	ADD  A
;	SBB  A		; A=0, если РУС откл. и А=0FFh, если надо включить
;	LXI  H, L_FFB1	; индикатор РУС/ЛАТ
;	XRA  M
;	ANI     008h
;	XRA  M
;	MOV  M, A	; 00/08
	JMP     L_F6F0	; > выход из ПП
;
;+++++++++++++++++++++++
L_URUS:	CMA
	STA     L_FFB3	; =FF -- сбрасываем метку
			; инверсия параметров РУС/ЛАТ
	LDA     L_FFC1	; < тут РУС/ЛАТ+CC: РУС=000h,рус=020h,lat=080h,LAT=0A0h
	XRI  0A0h
	STA     L_FFC1	; обновляем значение
	RLC		; старший разряд в признак С
	MVI  A, 008h
	JNC     L_LAT
	XRA  A
L_LAT:	STA     L_FFB1	; индикатор РУС/ЛАТ
	OUT     001h	; установка индикатора РУС/ЛАТ
	RET		; >> на выход
;+++++++++++++++++++++++
;
; -------------------------- используется RST 7 -----------------
L_F708:	MVI  A, 088h
	OUT     000h	; установка РУС ВВ55
	LDA     L_FFAB
	OUT     003h	; сдвиг экрана
	MVI  A, 010h	; установка режима экрана
	OUT     002h	; 512*256
	LDA     L_FFB1	; индикатор РУС/ЛАТ
	OUT     001h	; установка индикатора РУС/ЛАТ
	RET
;
L_F6F6:	MVI  H, 030h	; звук нажатия клавиши ???
	XRA  A
L_F6F9:	MVI  L, 040h
L_F6FB:	DCR  L
	JNZ     L_F6FB
	XRI     001h	; А=0000 000х, режим оперирования битами, установка/снятие бита 0
	OUT     000h
	DCR  H
	JNZ     L_F6F9
	STA     L_FFB2	; обнуление
	RET
;
; обработка нажатия стрелкок, ф1..ф5, ПС, ВК, ЗБ, АР2, СТР, ТАБ
L_F71B:	MVI  B, 000h
	LXI  H, L_F770	; таблица перекодировки
	DAD  B		; С = код клавиши
	MOV  A, M	; А = код символа
	CPI     004h
	JZ      L_FF23	; > нажата Ф5
	CPI     01Bh
	JZ      L_FEFD	; > нажата АР2
	CPI     07Fh
	JNZ     L_F69E	; > НЕ нажат ЗБ (только там нужен код символа)
	MVI  A, 020h
	ANA  E		; в Е то, что вернуло по IN 001h
	MVI  A, 07Fh
	JNZ     L_F69E	; > нажат ЗБ без СС, стирание символа
	MVI  C, 05Fh
	LDA     L_FFC1	; < тут РУС/ЛАТ+CC: РУС=000h,рус=020h,lat=080h,LAT=0A0h
	XRA  E		; в Е всё ещё то, что вернуло по IN 001h
	ANI     080h
	XRA  C
	JMP     L_F69E	; > СС+ЗБ="_" (A=05Fh), РУС СС+ЗБ="ъ" (А=0DFh)
;
; таблица перекодировки "код клавиши" -- "код символа"
L_F770:	.db 009h	; ТАБ
	.db 00Ah	; ПС
	.db 00Dh	; ВК
	.db 07Fh	; ЗБ
	.db 008h	; стрелка влево
	.db 019h	; стрелка вверх
	.db 018h	; стрелка вправо
	.db 01Ah	; стрелка вниз
	.db 00Ch	; стрелка влево-вверх
	.db 01Fh	; СТР
	.db 01Bh	; АР2
	.db 000h	; Ф1
	.db 001h	; Ф2
	.db 002h	; Ф3
	.db 003h	; Ф4
	.db 004h	; Ф5
;
; отсюда и далее фиксированные ячейки с параметрами
	.ORG    0FFA8h
LxFFA8:	.db 000h	; <_> - |        | (offset 0AA8h)
L_FFA9:	.db 0F5h	; <ї> - |■■■■ ■ ■| (offset 0AA9h)
L_FFAA:	.db 0A1h	; <б> - |■ ■    ■| (offset 0AAAh)
L_FFAB:	.db 0FFh	; сдвиг экрана
L_FFAC:	.db 000h	; <_> - |        | (offset 0AACh)
L_FFAD:	.db 000h	; <_> - |        | (offset 0AADh)
L_FFAE:	.db 000h	; +++ признак для обхода установки L_FFB3
L_FFAF:	.db 000h	; <_> - |        | (offset 0AAFh)
L_FFB0:	.db 000h	; признак для клавиатуры ???
L_FFB1:	.db 000h	; индикатор РУС/ЛАТ (00/08)
L_FFB2:	.db 0FFh	; код символа нажатой клавиши /FF-нет
L_FFB3:	.db 0FFh	; +++ признак одиночного нажатия РУС/ЛАТ
L_FFB4:	.db 000h	; <_> - |        | (offset 0AB4h)
L_FFB5:	.db 002h	; <_> - |      ■ | (offset 0AB5h)
L_FFB6:	.db 002h	; <_> - |      ■ | (offset 0AB6h)
L_FFB7:	.db 020h	; < > - |  ■     | (offset 0AB7h)
	.db 020h	; < > - |  ■     | (offset 0AB8h)
	.db 020h	; < > - |  ■     | (offset 0AB9h)
	.db 020h	; < > - |  ■     | (offset 0ABAh)
	.db 020h	; < > - |  ■     | (offset 0ABBh)
	.db 020h	; < > - |  ■     | (offset 0ABCh)
	.db 020h	; < > - |  ■     | (offset 0ABDh)
	.db 020h	; < > - |  ■     | (offset 0ABEh)
L_FFBF:	.db 000h	; <_> - |        | (offset 0ABFh) ; цвет фона для палитры
L_FFC0:	.db 028h	; <(> - |  ■ ■   | (offset 0AC0h) ; цвет текста для палитры
L_FFC1:	.db 0A0h	; <а> - |■ ■     | (offset 0AC1h) ; РУС/ЛАТ и СС
L_FFC2:	.db 000h	; <_> - |        | (offset 0AC2h)
	.db 000h	; <_> - |        | (offset 0AC3h)
M_FFC4:	.db 032h	; скорость записи на магнитную ленту
M_FFC5:	.db 04Bh	; скорость считывания с магнитной ленты
L_FFC6:	.db 001h	; <_> - |       ■| (offset 0AC6h)
L_FFC7:	.db 000h	; <_> - |        | (offset 0AC7h)
L_FFC8:	.db 000h	; <_> - |        | (offset 0AC8h)
;
	.END