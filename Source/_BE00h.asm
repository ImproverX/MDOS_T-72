	#include "equates.inc"
	.ORG    S_MDOS	;0BE6Ch
;
	#DEFINE M_E049 0E049h	; БУФ / дескриптор операции расширенной БДОС (31 байт)
	#DEFINE M_E06A 0E06Ah
	#DEFINE M_E06B 0E06Bh
	#DEFINE M_E06C 0E06Ch
	#DEFINE M_E06D 0E06Dh
	#DEFINE M_E0ED 0E0EDh
	#DEFINE M_E10E 0E10Eh
	#DEFINE M_E10F 0E10Fh
	#DEFINE M_E110 0E110h
	#DEFINE M_E111 0E111h
	#DEFINE M_E112 0E112h
	#DEFINE M_E114 0E114h
	#DEFINE M_E117 0E117h
	#DEFINE M_E11A 0E11Ah	; тут сохраняется указатель стека
	#DEFINE M_E176 0E176h	; SP
	#DEFINE M_E1BC 0E1BCh	; SP
	#DEFINE M_E1BD 0E1BDh
	#DEFINE M_E1С9 0E1C9h	; SP
	#DEFINE M_E1D3 0E1D3h	; SP
;
	#DEFINE B_E21E 0E21Eh	; запуск патча для B_E212
;
	#DEFINE L_DE74 L_DE67+13
	#DEFINE L_DE80 L_DE67+25
	#DEFINE L_DE81 L_DE80+001h
	#DEFINE L_DE82 L_DE80+002h
	#DEFINE L_DE8C L_DE80+00Ch	; описатель дисковой операции ???
	#DEFINE L_DE96 L_DE80+016h	; сюда и далее заносятся некоторые константы по дискам из БСВВ
	#DEFINE L_DEB8 L_DE80+038h
	#DEFINE L_DEBA L_DE80+03Ah	; тут сохраняется адрес для PCHL(1)
	#DEFINE L_DEBC L_DE80+03Ch
	#DEFINE L_DEBE L_DE80+03Eh
	#DEFINE L_DEBF L_DE80+03Fh
	#DEFINE L_DEC1 L_DE80+041h
	#DEFINE L_DEC3 L_DE80+043h
	#DEFINE L_DEC5 L_DE80+045h
	#DEFINE L_DEC7 L_DE80+047h
	#DEFINE L_DEC9 L_DE80+049h
	#DEFINE L_DECB L_DE80+04Bh
	#DEFINE L_DECD L_DE80+04Dh
	#DEFINE L_DECF L_DE80+04Fh
	#DEFINE L_DED1 L_DE80+051h
	#DEFINE L_DED3 L_DE80+053h
	#DEFINE L_DED4 L_DE80+054h
	#DEFINE L_DED5 L_DE80+055h
	#DEFINE L_DED6 L_DE80+056h
	#DEFINE L_DED8 L_DE80+058h
	#DEFINE L_DEDA L_DE80+05Ah
	#DEFINE L_DEDC L_DE80+05Ch
	#DEFINE L_DEE0 L_DE80+060h
	#DEFINE L_DEE2 L_DE80+062h
	#DEFINE L_DEE3 L_DE80+063h
	#DEFINE L_DEE4 L_DE80+064h
	#DEFINE L_DEE5 L_DE80+065h
	#DEFINE L_DEE6 L_DE80+066h
	#DEFINE L_DEE7 L_DE80+067h
	#DEFINE L_DEE8 L_DE80+068h
	#DEFINE L_DEE9 L_DE80+069h
	#DEFINE L_DEEA L_DE80+06Ah
	#DEFINE L_DEEB L_DE80+06Bh
	#DEFINE L_DEEC L_DE80+06Ch
	#DEFINE L_DEED L_DE80+06Dh
	#DEFINE L_DEEE L_DE80+06Eh
	#DEFINE L_DEEF L_DE80+06Fh
	#DEFINE L_DEF1 L_DE80+071h
	#DEFINE L_DEF3 L_DE80+073h
	#DEFINE L_DEF5 L_DE80+075h
	#DEFINE L_DEF6 L_DE80+076h
	#DEFINE L_DEF7 L_DE80+077h
	#DEFINE L_DEF9 L_DE80+079h
	#DEFINE L_DEFB L_DE80+07Bh
	#DEFINE L_DEFC L_DE80+07Ch
	#DEFINE L_DEFE L_DE80+07Eh
	#DEFINE L_DF00 L_DE80+080h
	#DEFINE L_DF02 L_DE80+082h
	#DEFINE L_DF04 L_DE80+084h
	#DEFINE L_DF06 L_DE80+086h
	#DEFINE L_DF08 L_DE80+088h
	#DEFINE L_DF09 L_DE80+089h
	#DEFINE L_DF0A L_DE80+08Ah
	#DEFINE L_DF0B L_DE80+08Bh
	#DEFINE L_DF0C L_DE80+08Ch
	#DEFINE L_DF0E L_DE80+08Eh
	#DEFINE L_DF0F L_DE80+08Fh
	#DEFINE L_DF11 L_DE80+091h
	#DEFINE L_DF12 L_DE80+092h
	#DEFINE L_DF13 L_DE80+093h
	#DEFINE L_DF14 L_DE80+094h	; начало командной строки ???
	#DEFINE L_DF15 L_DE80+095h
	#DEFINE L_DF79 L_DE80+0F9h
	#DEFINE L_DF94 L_DE80+114h
	#DEFINE L_DF95 L_DE80+115h
	#DEFINE L_DF96 L_DE80+116h
	#DEFINE L_DF99 L_DE80+119h
	#DEFINE L_DF9D L_DE80+11Dh
	#DEFINE L_DFB4 L_DE80+134h
	#DEFINE L_DFB5 L_DE80+135h
	#DEFINE L_DFB8 L_DE80+138h
	#DEFINE L_DFBA L_DE80+13Ah
	#DEFINE L_DFBC L_DE80+13Ch
	#DEFINE L_DFBE L_DE80+13Eh
	#DEFINE L_DFC0 L_DE80+140h
	#DEFINE L_DFC2 L_DE80+142h
	#DEFINE L_DFC4 L_DE80+144h
	#DEFINE L_DFC6 L_DE80+146h
	#DEFINE L_DFC8 L_DE80+148h
	#DEFINE L_DFC9 L_DE80+149h
;
L_BE00: LXI  H, 00000h	; очистка памяти L_DE67..0E1FFh
	LXI  SP,B_E200
	LXI  B, (B_E200-L_DE67)/2  ; сколько (01CCh)
L_BE07: PUSH H
	DCX  B
	MOV  A, B
	ORA  C
	JNZ     L_BE07	; цикл очистки
	LXI  SP,M_E176	; <<<<<<
	CALL    B_E200	; <<< инициализация БСВВ
	PUSH PSW	; в стек код возврата
	MVI  A, 07Fh
	STA     L_DF13
	MVI  A, 0F7h	;
	STA     00003h	; << 0003: RST 6
	LXI  H, 0C302h	; << заносим 2 в ячейку 0004 -- диск по умолчанию (0=A...15=P) и
	SHLD    A_0004	; << 0005: JMP ...
	LXI  H, L_C000	; ...
	SHLD    00006h	; << 0005: ... L_C000
	LXI  H, 0233Eh	;
	SHLD    00030h	; << 0030: MVI A, 023h
	LXI  H, 010D3h	;
	SHLD    00032h	; << 0032: OUT 010h	; включаем КД
	MVI  A, 0E9h	;
	STA     00034h	; << 0034: PCHL
	MVI  C, 000h	; определение количества дисков в системе перебором от нуля
L_BE45: PUSH B
	CALL    B_E20F	; выдаёт некие таблицы со ссылками на буферы для дисковых операций
	MOV  A, L
	ORA  H
	POP  B
	JZ      L_BE6B	; выход, если вернуло HL=0000
	PUSH B
	LXI  B, 0000Ah
	DAD  B
	MOV  A, M
	INX  H
	MOV  H, M
	MOV  L, A
	LXI  B, 0000Dh
	DAD  B
	MOV  E, M
	INX  H
	MOV  D, M
	POP  B
	MOV  A, C
	CALL    L_C2D7	; >> HL = L_DE96 + 2*A
	MOV  M, E
	INX  H
	MOV  M, D	; по адресу L_DE96+2*А заносятся константы по дискам из БСВВ
	INR  C
	JMP     L_BE45
;
L_BE6B: MOV  A, C	; количество дисков +1
	CALL    L_C2D7	; >> HL = L_DE96 + 2*A
	MVI  M, 0FFh
	INX  H
	MVI  M, 0FFh	; забиваем FFFF (метка, что "расчёт окончен")
	MOV  A, C
	CPI     004h
	JNC     L_BE6X	; переход, если число дисков 4 и больше
	LXI  H, LsBF42	;
	MVI  M, 02Dh	; ставим прочерк на диске Д в заставке
L_BE6X:	LXI  H, L_BF42	; >> надпись Т-72...
	CALL    B_F818	; вывод сообщения на экран (заставка)
	LXI  H, L_C000	; начало МДОС
	MOV  A, H
	ANI     0FCh
	RRC
	RRC		; А = 48
	CALL    L_CB83	; вывод числа килобайт (?)
	LXI  B, L_BED8	; строка с версией системы
	CALL    L_C703
;
	MVI  C, 00Dh	; Сброс дисковой системы
	CALL    00005h	; <<<<<<
	CALL    B_E21E	; запуск отмены патча для B_E212 //патч нужен для запуска без дискеты
	LXI  H, L_BF02	; ссылка на данные для БУФ
	LXI  D, M_E049	; куда копировать
	PUSH D		; сохр.в стек
L_BE6Y:	MOV  A, M
	STAX D
	INX  H
	INX  D
	ANA  A		; признаки по А
	JNZ     L_BE6Y	; цикл, пока А не обнулится
	POP  D		; адрес БУФ из стека (ищем INITIALС.SUB на диске С:)
L_BEXX:	PUSH D
	MVI  C, 011h	; Поиск первого файла
	CALL    00005h	; <<<<<<
	INR  A
	POP  H		; адрес БУФ из стека
	JNZ     L_ISUB	; если нашли (А<>FFh), то выполняем
	CMP  M		; (A=0)
	JZ      L_BE9C  ; ничего не найдено, пропускаем
	INR  A
	MOV  M, A	; меняем номер диска на первый (А:)
	XCHG
	LXI  H, 00008h	; положение в имени символа "С"
	DAD  D		; БУФ + 8
	MVI  M, 020h	; меняем в имени "С" на пробел
	POP  PSW	; загружаем из стека код возврата при иниц.НЖМД
	JZ      L_BEXX	; повторяем, если не было ошибок жёсткого диска
	JMP     L_BE9C	; на выход
;
L_ISUB:	LXI  D, L_BEFF	; параметр вызова БДОС
	MVI  C, 032h	; исполнение операций расширенной БДОС   
	CALL    00005h	; <<<<<<
L_BE9C:	MVI  A, 0FFh
	STA     L_DE80
	JMP     L_DA4D	; >>>> запуск МДОС
;
L_BED8: .db "K MicroDOS  Vers. 3.1m04"
	.db 00Dh, 00Ah
	.db "    25.02.21$"
;
L_BEFF: .db 083h	; номер операции расширенной БДОС
	.dw M_E049	; адрес дескриптора операции ???
;
L_BF02: .db 003h		; байт, определяющий диск (3 == C:)
	.db "INITIALCSUB"	; имя файла
	.db 000h
;
L_BF42: .db 01Bh, 045h	; Очистить экран и установить латинский набор символов знакогенератора
	.db 01Bh, 062h	; Установить режим вывода символов в негативе
	.db 00Dh, 00Ah	; перевод строки
	.db "  *     "
	.db 0F0h	; <Ё> - П
	.db 0EBh	; <ы> - К
	.db " "
	.db 0F7h	; <ў> - В
	.db 0C5h	; <┼> - е
	.db 0CBh	; <╦> - к
	.db 0D4h	; <╘> - т
	.db 0CFh	; <╧> - о
	.db 0D2h	; <╥> - р
	.db 02Dh	; <-> - -
	.db 030h	; <0> - 0
	.db 036h	; <6> - 6
	.db 0E3h	; <у> - Ц
	.db "     *  "
	.db 00Dh, 00Ah	; перевод строки
	.db "  * "
#ifdef NoFDD
	.db " "
#endif
#ifdef NoHDD
	.db " "
#endif
	.db 0E2h	; <т> - Б
	.db 0F3h	; <є> - С
	.db 0F7h	; <ў> - В
	.db 0F7h	; <ў> - В
	.db " "
;	.db 0D7h	; <╫> - в
;	.db 0C5h	; <┼> - е
;	.db 0D2h	; <╥> - р
;	.db 0D3h	; <╙> - с
;	.db 0C9h	; <╔> - и
;	.db 0D1h	; <╤> - я
;	.db " "
	.db 0F4h	; <Ї> - Т
	.db "-72 "
#ifdef NoFDD
  #ifdef NoHDD
	.db "    "
  #else
	.db " HDD, "
  #endif
#else
  #ifdef NoHDD
	.db " FDD, "
  #else
	.db "HDD+FDD,"
  #endif
#endif
	.db "2"
	.db 0EBh	; <ы> - К
	.db 0E4h	; <ф> - Д
#ifdef NoFDD
	.db " "
#endif
#ifdef NoHDD
	.db " "
#endif
	.db " *  "
	.db 00Dh, 00Ah	; перевод строки
	.db "  *  "
	.db 0E4h	; <ф> - Д
	.db 0CFh	; <╧> - о
	.db 0D3h	; <╙> - с
	.db 0D4h	; <╘> - т
	.db 0D5h	; <╒> - у
	.db 0D0h	; <╨> - п
	.db 0CEh	; <╬> - н
	.db 0D9h	; <┘> - ы
	.db " "
	.db 0C4h	; <─> - д
	.db 0C9h	; <╔> - и
	.db 0D3h	; <╙> - с
	.db 0CBh	; <╦> - к
	.db 0C9h	; <╔> - и
	.db " ABC"
LsBF42:	.db "D  *  "
	.db 00Dh, 00Ah	; перевод строки
	.db "  *   "
	.db 0EBh	; <ы> - К
	.db 0EFh	; <я> - О
	.db 0E9h	; <щ> - И
	.db "-8, "
	.db 0C1h	; <┴> - а
	.db 0CCh	; <╠> - л
	.db 0D8h	; <╪> - ь
	.db 0D4h	; <╘> - т
	.db ". "
	.db 0E7h	; <ч> - Г
	.db 0EFh	; <я> - О
	.db 0F3h	; <є> - С
	.db 0F4h	; <Ї> - Т
	.db "   *  "
	.db 01Bh, 061h	; Установить режим вывода символов в позитиве
	.db 00Dh, 00Ah	; перевод строки
	.db 000h
;
	.ORG    0C000h
L_C000: JMP     L_C430	; Холодный старт.
L_C003: JMP     L_DA31	; Горячий старт.
L_C006: JMP     L_DC88	; Запрос статуса консоли. В регистре А возвращается статус:0FFh - есть символ для ввода с консоли, 0 - нет символа. 
L_C009: JMP     L_DD31	; Чтение символа с консоли. Введенный символ помещается в регистр А. Возврат из этой функции выполняется только после ввода символа. 
L_C00C: JMP     L_DD85	; Вывод символа на консоль. Символ для вывода должен быть помещен в регистр С. 
L_C00F: JMP     L_DC72	; Вывод символа на принтер.
L_C012: JMP     L_C6B9	; (?) Вывод символа на доп.устройство
L_C015: JMP     L_C6B0	; (?) Чтение символа с доп.устройства
L_C018: JMP     L_DC27	; Выполняется позиционирование текущего выбранного диска на 0 дорожку. 
L_C01B: JMP     L_DC1A	; Выбор диска. В регистре С передается номер диска (0 - диск А, 1 - диск В и т.д.). 0 бит регистра Е будет установлен если этот диск уже был выбран со времени последнего сброса дисковой системы.
			; Функция должна вернуть в регистрах HL адрес таблицы DPH (см. ниже), или 0 в случае отсутствия требуемого диска.
L_C01E: JMP     L_DC29	; Установить дорожку. В регистрах ВС передается номер дорожки диска (0 - начальная дорожка) для последующих операций чтения и записи на диск.
L_C021: JMP     L_DC2E	; Установить сектор. В регистрах ВС передается номер сектора диска (1 - начальный сектор) для последующих операций чтения и записи на диск.
L_C024: JMP     L_CE93	; Установить адрес буфера для обмена с диском. В регистрах ВС передается адрес буфера для последующих операций чтения и записи на диск. 
L_C027: JMP     L_DC3F	; Чтение сектора. Читается сектор с диска, определенный предыдущими вызовами SELDSK, SETTRK и SETSEC, в RAM по адресу, определенному предыдущим вызовом SETDMA.
L_C02A: JMP     L_DC3A	; Запись сектора. Адресация и ошибки обрабатываются аналогично функции READ. При вызове этой функции в регистре С передается дополнительный флаг, обозначающий
			; тип записываемого сектора: 0 - обычный сектор, 1 -сектор из области директория, 2 - первый сектор нового блока данных (начальное значение данного блока неважно).
L_C02D: JMP     L_DC78	; (?) Запрос статуса принтера
L_C030: JMP     L_DC33	; трансляция логических секторов в физические
L_C033: CALL    L_CB41
	LDA     M_E117	; <<<<<<
	INR  A
	JNZ     L_C042
	MVI  A, 03Eh	; = ">"
	CALL    L_CBF6	; печать символа из А
L_C042: LDA     L_DE60
	ORA  A
	CNZ     L_CB83
	LDA     L_DE5A
	ADI     041h
	CALL    L_CBF6	; печать символа из А
	MVI  A, 03Eh	; = ">"
	CALL    L_CBF6	; печать символа из А
	LXI  H, L_DF13
	SHLD    L_DE5B
LxC05C: CALL    L_C713	; <<<<<< меняется на L_DF79
	LXI  H, L_DF14
L_C062: MOV  A, M
	ORA  A
	RZ
	MOV  B, A
	INX  H
	MOV  A, M
	CPI     03Bh
	RZ
	CPI     03Ah
	JNZ     L_C079
	LDA     L_DE2D
	INR  A
	RZ
	DCR  B
	RZ
	INX  H
	MOV  A, M
L_C079: CPI     02Dh
	JNZ     L_C086
	DCR  B
	RZ
	MVI  A, 0FFh
	STA     L_DE81
	INX  H
L_C086: SHLD    L_DF04
	DCX  H
L_C08A: INX  H
	MOV  A, M
	CALL    L_C121
	MOV  M, A
	DCR  B
	JNZ     L_C08A
	INX  H
	MVI  M, 000h
	LXI  H, L_DF94
	CALL    L_C134
	JNZ     L_C147	; выдаёт ошибку вида "<параметр>?"
	LXI  H, L_DF95
	MOV  A, M
	CPI     020h
	JNZ     L_C0BD
	DCX  H
	MOV  A, M
	ORA  A
	JZ      L_C0B9
	DCR  A
	CALL    L_D546
	LDA     L_DE5A
	STA     A_0004	; номер текущего диска (А=0, В=1...)
L_C0B9: CALL    L_C399
	RET
;
L_C0BD: LDA     M_E117	; <<<<<<
	ORA  A
	JZ      L_C316
	LDA     L_DF94
	ORA  A
	JNZ     L_C313
	LXI  H, L_DF96
	MOV  A, M
	CPI     020h
	JNZ     L_C0FC
	DCX  H
	MOV  A, M
	CALL    L_C429
	JC      L_C0E5
	PUSH PSW
	CALL    L_C348
	POP  PSW
	MOV  D, A
	JMP     B_E218
;
L_C0E5: MOV  C, M
	LXI  H, L_C165
	CALL    L_C3FF
	LXI  H, L_C16C
	JNC     L_C0FC
	PUSH PSW
	PUSH H
	CALL    L_C399
	POP  H
	POP  PSW
	JMP     L_C4D1
;
L_C0FC: CALL    L_C12A
	LDA     L_DF99
	CPI     020h
	JNZ     L_C316
	LDA     L_DEBE
	ORA  A
	JZ      L_C316
	LHLD    L_DF06
	XCHG
	LXI  B, L_DF94
	LHLD    L_DEBA	; считать ссылку
	CALL    L_C307	; >> PCHL (1)
	JZ      L_C316
	JMP     L_C147	; выдаёт ошибку вида "<параметр>?"
;
L_C121: CPI     061h
	RC
	CPI     07Bh
	RNC
	ANI     05Fh
	RET
;
L_C12A: LDA     M_E117	; <<<<<<
	INR  A
	RNZ
	POP  H
	CALL    L_C147	; выдаёт ошибку вида "<параметр>?"
	RET
;
L_C134: PUSH H
	XRA  A
	CALL    L_D934
	POP  H
	JMP     L_D69B
;
L_C13D: LDA     L_DF0F
	PUSH PSW
	CALL    L_D52B
	POP  PSW
	INR  A
	RET
;
L_C147: CALL    L_CB41	; ПП выдачи ошибки вида "<параметр>?"
	LHLD    L_DF06
L_C14D: MOV  A, M
	CALL    L_C924
	JZ      L_C15F
	ORA  A
	JZ      L_C15F
	CALL    L_CBF6	; печать символа из А
	INX  H
	JMP     L_C14D
;
L_C15F: MVI  A, 03Fh	;= "?"
	CALL    L_CBF6	; печать символа из А
	RET
;
L_C165: .db 041h	; <A>
	.db 042h	; <B>
	.db 044h	; <D>
	.db 045h	; <E>
	.db 04Bh	; <K>
	.db 04Fh	; <O>
	.db 055h	; <U>
	.db 000h	; -- конец перебора
;
L_C16C: .dw P_C30D	; 00 -- ещё ссылки для PCHL (2)
	.dw P_C2DE	; 01
	.dw P_C17A	; 02
	.dw P_C23B	; 03
	.dw P_C308	; 04
	.dw P_C280	; 05
	.dw P_C262	; 06
;
P_C17A: LXI  H, L_DF94	; вызов из PCHL (2)
	CALL    L_C134
	LXI  H, L_DF95
	MOV  A, M
	CPI     020h
	JNZ     L_C192
	MVI  B, 00Bh
L_C18B: MVI  M, 03Fh
	INX  H
	DCR  B
	JNZ     L_C18B
L_C192: MVI  E, 000h
	PUSH D
	LXI  H, L_DF94
	SHLD    L_DE5B
	XCHG
	CALL    P_D6B7
	LDA     L_DF0F
	INR  A
	POP  D
	JZ      L_C25A
	PUSH D
L_C1A8: LDA     L_DEF5
	MOV  C, A
	POP  D
	MOV  A, E
	INR  E
	PUSH D
	ANI     003h
	JNZ     L_C1C0
	PUSH B
	CALL    L_CB41
	CALL    L_C22E
	POP  B
	JMP     L_C1C6
;
L_C1C0: CALL    L_C229
	CALL    L_C236
L_C1C6: MVI  B, 001h
L_C1C8: MOV  A, B
	CALL    L_C220
	ANI     07Fh
	CALL    L_CBF6	; печать символа из А
	INR  B
	MOV  A, B
	CPI     00Ch
	JNC     L_C1E5
	CPI     009h
	JNZ     L_C1C8
	MVI  A, 02Eh	; = "."
	CALL    L_CBF6	; печать символа из А
	JMP     L_C1C8
;
L_C1E5: CALL    L_C229
	MVI  A, 009h
	CALL    L_C220
	ANI     080h
	MVI  A, 052h
	JNZ     L_C1F6
	MVI  A, 020h	; = " "
L_C1F6: CALL    L_CBF6	; печать символа из А
	MVI  A, 00Ah
	CALL    L_C220
	ANI     080h
	MVI  A, 053h
	JNZ     L_C207
	MVI  A, 020h	; = " "
L_C207: CALL    L_CBF6	; печать символа из А
	CALL    L_C937
	ORA  A
	JNZ     L_C21B
	CALL    L_D6ED
	LDA     L_DF0F
	INR  A
	JNZ     L_C1A8
L_C21B: CALL    L_D52B
	POP  D
	RET
;
L_C220: LHLD    L_DE58
	ADD  C
	CALL    L_CE0F
	MOV  A, M
	RET
;
L_C229: MVI  A, 020h	; = " "
	JMP     L_CBF6	; печать символа из А
;
L_C22E: LDA     L_DE5A
L_C231: ADI     041h
	CALL    L_CBF6	; печать символа из А
L_C236: MVI  A, 03Ah	; = ":"
	JMP     L_CBF6	; печать символа из А
;
P_C23B: LXI  H, L_DF94	; вызов из PCHL (2)
	CALL    L_C134
	CPI     00Bh
	JNZ     L_C24C
	MVI  A, 004h
	CALL    L_CB64
	RNZ
L_C24C: LXI  H, L_DF94
	SHLD    L_DE5B
	CALL    P_D6F3
	LDA     L_DF0F
	INR  A
	RNZ
L_C25A: MVI  A, 00Ah
	CALL    L_D9FE
	JMP     L_D52B
;
P_C262: LXI  H, L_DF94	; вызов из PCHL (2)
	CALL    L_D932
	LXI  H, L_DF95
	CALL    L_C410
	JC      L_C147	; выдаёт ошибку вида "<параметр>?"
	MOV  A, H
	ORA  A
	JNZ     L_C147	; выдаёт ошибку вида "<параметр>?"
	MOV  A, L
	CPI     010h
	JNC     L_C147	; выдаёт ошибку вида "<параметр>?"
	STA     L_DE60
	RET
;
P_C280: LXI  H, L_DF94	; вызов из PCHL (2)
	CALL    L_D932
	LXI  H, L_DF94
	SHLD    L_DE5B
	CALL    L_D4E2
	LXI  H, L_DF95
	MOV  A, M
	CPI     020h
	JZ      L_C2AB
	CALL    L_C410
	XCHG
	JC      L_C147	; выдаёт ошибку вида "<параметр>?"
	CALL    L_C2D4
	MOV  M, E
	INX  H
	MOV  M, D
	CALL    L_CDFC
	JMP     L_D52B
;
L_C2AB: LXI  H, L_DE96
	XRA  A
L_C2AF: PUSH PSW
	PUSH H
	CALL    L_CB41
	POP  H
	MOV  E, M
	INX  H
	MOV  D, M
	INX  D
	MOV  A, E
	ORA  D
	JZ      L_C2D2
	DCX  D
	POP  PSW
	PUSH PSW
	CALL    L_C231
	CALL    L_C229
	PUSH H
	CALL    L_CB86
	POP  H
	INX  H
	POP  PSW
	INR  A
	JMP     L_C2AF
;
L_C2D2: POP  PSW
	RET
;
L_C2D4: LDA     L_DE5A
L_C2D7: ADD  A		; ПП делает HL = L_DE96 + 2*A
	LXI  H, L_DE96
	JMP     L_CE0F
;
P_C2DE: LDA     M_E117	; вызов из PCHL (2) -- команда "B"
	CPI     001h
	RNZ
	LXI  H, L_DF94
	CALL    L_C134
	LDA     L_DF95
	CPI     020h
	JZ      L_C24C	;- (патч, переход в Е с выводом "нет файлов")
;	JNZ     L_C2F8	;+ переход, если есть параметры
;	CALL    L_CB01	; вот оттуда сыпется мусор...
;	NOP
	NOP
	NOP
;	JMP     L_DAAA	;+ а до этой команды вообще не доходит.
	NOP		;-
	NOP		;-
	NOP		;-
;
L_C2F8: CALL    L_DAF2	; >> подготовка параметров...
	JNZ     L_C147	; выдаёт ошибку вида "<параметр>?"
	LXI  D, 00000h
	MOV  B, D
	MOV  C, E	; BC = DE = 0
	CALL    L_C307	; >> PCHL (1), в HL адрес загруженной программы (0A400h)
	RET
;
L_C307: PCHL	; (1)
;
P_C308: XRA  A		; вызов из PCHL (2)
	STA     L_DE80
	RET
;
P_C30D: MVI  A, 0FFh	; вызов из PCHL (2)
	STA     L_DE80
	RET
;
L_C313: CALL    L_C12A
L_C316: LXI  H, L_DF9D
	MOV  A, M
	CPI     020h
	JNZ     L_C147	; выдаёт ошибку вида "<параметр>?"
	MVI  M, 043h	; = "C"
	INX  H
	MVI  M, 04Fh	; = "O"
	INX  H
	MVI  M, 04Dh	; = "M"
	CALL    L_DAD8
	CPI     001h
	JZ      L_C147	; выдаёт ошибку вида "<параметр>?"
	CPI     002h
	JNZ     L_C3F1
	CALL    L_C348
	CALL    L_CB41
	XRA  A
	STA     M_E117	; <<<<<<
	LXI  SP,M_E1D3	; <<<<<<
	LXI  H, 00000h
	PUSH H
	JMP     00100h	; <<<<<<
;
L_C348: LXI  H, 0005Ch	; <<<<<<
	CALL    L_C134
	LXI  H, 0006Ch	; <<<<<<
	CALL    L_C134
	LXI  H, L_DF15
	XRA  A
	STA     0007Ch	; <<<<<<
L_C35B: MOV  A, M
	ORA  A
	JZ      L_C369
	CPI     020h
	JZ      L_C369
	INX  H
	JMP     L_C35B
;
L_C369: MVI  B, 000h
	LXI  D, 00081h	; <<<<<<
L_C36E: MOV  A, M
	STAX D
	ORA  A
	JZ      L_C38D
	MOV  C, A
	LDA     L_DE81
	INR  A
	MOV  A, C
	JZ      L_C387
	CPI     03Ch	; "<"
	JZ      L_C38D
	CPI     03Eh	; ">"
	JZ      L_C38D
L_C387: INR  B
	INX  H
	INX  D
	JMP     L_C36E
;
L_C38D: XRA  A
	STAX D
	LXI  H, 00080h	; <<<<<<
	MOV  M, B
	SHLD    L_DE58
	CALL    L_CE87
L_C399: LDA     L_DE81
	INR  A
	RZ
	LHLD    L_DF04
	XCHG
L_C3A2: CALL    L_D923
	RZ
	INX  D
	CPI     03Eh
	JZ      L_C3C7
	CPI     03Ch	; "<"
	JNZ     L_C3A2
	XCHG
	SHLD    L_DF04
	LXI  H, M_E049	; <<<<<<
	CALL    L_C134
	JNZ     L_C147	; выдаёт ошибку вида "<параметр>?"
	CALL    L_C5D3
	JZ      L_C147	; выдаёт ошибку вида "<параметр>?"
	JMP     L_C399
;
L_C3C7: LDAX D
	CPI     03Eh
	JNZ     L_C3CE
	INX  D
L_C3CE: XCHG
	SHLD    L_DF04
	PUSH PSW
	LXI  H, M_E0ED	; <<<<<<
	CALL    L_C134
	JNZ     L_C147	; выдаёт ошибку вида "<параметр>?"
	POP  PSW
	JZ      L_C3E9
	CALL    L_C613
L_C3E3: JZ      L_C147	; выдаёт ошибку вида "<параметр>?"
	JMP     L_C399
;
L_C3E9: CALL    L_C3EF
	JMP     L_C3E3
;
L_C3EF: XRA  A
	RET
;
L_C3F1: LXI  B, L_C3F7
	JMP     L_DA08
;
L_C3F7: .db 03Eh	; <>> - |  ■■■■■ | (offset 06F7h)
	.db 03Eh	; <>> - |  ■■■■■ | (offset 06F8h)
	.db 020h	; < > - |  ■     | (offset 06F9h)
	.db 020h	; < > - |  ■     | (offset 06FAh)
	.db 03Fh	; <?> - |  ■■■■■■| (offset 06FBh)
	.db 03Fh	; <?> - |  ■■■■■■| (offset 06FCh)
	.db 021h	; <!> - |  ■    ■| (offset 06FDh)
	.db 024h	; <$> - |  ■  ■  | (offset 06FEh)
;
L_C3FF: MVI  B, 000h
L_C401: MOV  A, M
	ORA  A
	RZ
	CMP  C
	JZ      L_C40D
	INX  H
	INR  B
	JMP     L_C401
;
L_C40D: MOV  A, B
	STC
	RET
;
L_C410: XCHG
	LXI  H, 00000h
L_C414: LDAX D
	CPI     020h
	RZ
	CALL    L_C429
	RC
	DAD  H
	MOV  B, H
	MOV  C, L
	DAD  H
	DAD  H
	DAD  B
	CALL    L_CE0F
	INX  D
LxC426: JMP     L_C414
;
L_C429: SUI     030h
	RC
	CPI     00Ah
	CMC
	RET
;
L_C430: XCHG
	SHLD    L_DE5B
	XCHG
	MOV  A, C
	STA     L_DE5F
	CPI     00Eh
	JC      L_C491	; переход, если < 0Eh
	LDA     L_DE66
	DCR  A
	JZ      L_C491
	LXI  H, L_C483
	CALL    L_C3FF
	JNC     L_C491
	LXI  H, 00000h
	DAD  SP
	SHLD    M_E1BD	; <<<<<<
	LXI  SP,M_E1С9	; <<<<<<
	LXI  H, H_C565	; ссылка на подпрограмму
	PUSH H
	CALL    L_D71F
	CALL    L_D7AB
	LDA     L_DE66
L_C465: PUSH PSW
	STA     M_E1BC	; <<<<<<
	CALL    L_C489
	ORA  A
	JNZ     L_C57A
	LDA     L_DE5F
	CPI     021h
	CNC     L_D7A0
	CALL    L_D726
	POP  PSW
	DCR  A
	JNZ     L_C465
	MOV  L, A
	MOV  H, A
	RET
;
L_C483: .db 014h	; <_> - |   ■ ■  | (offset 0783h)
	.db 015h	; <_> - |   ■ ■ ■| (offset 0784h)
	.db 021h	; <!> - |  ■    ■| (offset 0785h)
	.db 022h	; <"> - |  ■   ■ | (offset 0786h)
	.db 028h	; <(> - |  ■ ■   | (offset 0787h)
	.db 000h	; <_> - |        | (offset 0788h)
;
L_C489: LDA     L_DE5F
	MOV  C, A
	LHLD    L_DE5B
	XCHG
L_C491: MOV  A, E
	STA     L_DEE6
	LXI  H, 00000h
	SHLD    L_DF0F
	DAD  SP
	SHLD    L_DF0C
	LXI  SP,M_E1BC	; <<<<<<
	XRA  A
	STA     L_DF08
	STA     L_DE5D
	LXI  H, H_C558	; ссылка на подпрограмму
	PUSH H
	LDA     L_DEE6
	MOV  E, A
	MOV  A, C
	MOV  C, E
	CPI     098h
	LXI  H, L_C4DE+03Ch+03Ch-098h-098h	; =C426h
	JZ      L_C4D1	; если А=98h, то выполняем А=3Ch
	CPI     080h
	JNC     L_CFDC
	CPI     071h
	RNC
	CPI     06Ch
	LXI  H, L_C4DE+037h+037h-06Ch-06Ch	; =0C474h
	JNC     L_C4D1	; если А>=6Ch, то выполняем А=37h-3Ch
	CPI     033h
	RNC
	LXI  H, L_C4DE
L_C4D1: MOV  E, A
	MVI  D, 000h
	DAD  D
	DAD  D
	MOV  E, M
	INX  H
	MOV  D, M
	LHLD    L_DE5B
	XCHG
	PCHL	; (2)
; -- ссылки для PCHL (2), выполнение операций МДОС по CALL 5:
L_C4DE: .dw L_DA31	; 00	Сброс системы
	.dw P_C685	; 01	Ввод с консоли
	.dw L_C69C	; 02	Вывод на консоль
	.dw L_C6B0	; 03	Ввод с дополнительного устройства ввода
	.dw L_C6B9	; 04	Вывод на дополнительное устройство вывода
	.dw L_DC72	; 05	Вывод на печать
	.dw P_C6C9	; 06	Прямой обмен с консолью
	.dw P_C6FB	; 07	Опрос состояния дополнительного устройства ввода
	.dw P_C88F	; 08 (сразу RET)	Опрос состояния дополнительного устройства вывода
	.dw P_C701	; 09	Вывод последовательности символов (до $)
	.dw L_C713	; 0A	Ввод последовательности символов
	.dw P_C889	; 0B	Получение состояния консоли
	.dw P_C890	; 0C	Возврат версии системы
	.dw P_D512	; 0D	Сброс дисковой системы
	.dw L_D543	; 0E	Выбор диска
	.dw L_D0AC	; 0F	Открытие файла
	.dw L_D154	; 10	Закрытие файла
	.dw P_D6B7	; 11	Поиск первого файла
	.dw P_D6E4	; 12	Поиск следующего входа (ФС)
	.dw P_D6F3	; 13	Удаление файла
	.dw L_D28C	; 14	Последовательное чтение
	.dw L_D2E3	; 15	Последовательная запись
	.dw L_D1D7	; 16	Создание файла
	.dw P_D6FF	; 17	Переименование файла
	.dw P_D708	; 18	Получение вектора состояния дисков
	.dw P_D70E	; 19	Получение текущего диска
	.dw L_D718	; 1A	Установка адреса буфера ПДП
	.dw P_D730	; 1B	Получить адрес вектора распределения
	.dw L_D736	; 1C	Установка защиты записи
	.dw P_D74E	; 1D	Получение вектора защиты записи
	.dw L_D754	; 1E	Установка атрибутов файла
	.dw L_D75D	; 1F	Получение адреса блока параметров диска
	.dw P_D764	; 20	Получение/установка кода пользователя
	.dw P_D775	; 21	Произвольное чтение
	.dw P_D781	; 22	Произвольная запись
	.dw P_D4A3	; 23	Получение размера файла
	.dw P_D78D	; 24	Установка номера произвольной записи
	.dw P_D7C0	; 25	Сброс диска
	.dw P_C88F	; 26 (сразу RET)
	.dw P_C88F	; 27 (сразу RET)
	.dw P_D7E1	; 28	Произвольная запись с заполнением нулями
	.dw L_CFDC	; 29	???
	.dw P_C88F	; 2A (сразу RET)
	.dw P_C88F	; 2B (сразу RET)
	.dw P_D844	; 2C	Установка мультиселекторного счетчика
	.dw P_D852	; 2D	Установка режима обработки ошибок
	.dw P_D7F2	; 2E	Получение свободного места на диске
	.dw P_D87E	; 2F	Замена программы
	.dw P_C88F	; 30 (сразу RET)
	.dw P_D857	; 31	Получение/установка параметров БУС
	.dw P_C583	; 32	Вызов операций БСВВ или операций расширенной БДОС
	.dw P_D8A1	; 33	???
	.dw P_D8A8	; 34	???
	.dw P_C88F	; 35 (сразу RET)
	.dw P_C88F	; 36 (сразу RET)
	.dw P_D8B8	; 37	???
	.dw P_D8C7	; 38	???
	.dw P_D8CD	; 39	???
	.dw P_D8DB	; 3A	???
	.dw P_D8DB	; 3B	???
	.dw P_D9DF	; 3C	???
;
H_C558: CALL    L_D52B
	LHLD    L_DF0C
	SPHL
	LHLD    L_DF0F
	MOV  A, L
	MOV  B, H
	RET
;
H_C565: PUSH H
	CALL    L_D714
	LDA     L_DE5F
	CPI     021h
	CNC     L_D7B7
	POP  D
	LHLD    M_E1BD	; >>>>>
	SPHL
	XCHG
	MOV  A, L
	MOV  B, H
	RET
;
L_C57A: POP  B
	INR  A
	RZ
	LDA     L_DE66
	SUB  B
	MOV  H, A
	RET
;
P_C583: LHLD    L_DE5B	; вызов из PCHL (2)
	MOV  A, M
	RAL
	JNC     L_C66B
	RAR
	ANI     07Fh
	INX  H
	MOV  E, M
	INX  H
	MOV  D, M
	XCHG
	SHLD    L_DE5B
	MOV  C, L
	LXI  H, L_C5A7	; -- ссылки для PCHL (2)
	CPI     070h
	JC      L_C4D1
	SBI     070h
	LXI  H, L_C5B3	; -- ссылки для PCHL (2)
	JMP     L_C4D1
;
L_C5A7: .dw P_D68F	; 00 -- ссылки для PCHL (2)
	.dw L_D5CB	; 01
	.dw P_D6AD	; 02
	.dw P_C5CB	; 03
	.dw P_C600	; 04
	.dw P_C605	; 05
L_C5B3: .dw P_C65F	; 00 -- ссылки для PCHL (2)
	.dw P_C65B	; 01
	.dw L_CAD0	; 02
	.dw L_CB86	; 03
	.dw P_C5BF	; 04
	.dw P_C5C5	; 05
;
P_C5BF: LXI  H, L_DF0C
	JMP     L_D760
;
P_C5C5: LXI  H, M_E1BC	; <<<<<<
	JMP     L_D760
;
P_C5CB: LXI  H, M_E049	; <<<<<<
	MVI  C, 020h
	CALL    L_D6DA
L_C5D3: LXI  H, M_E049	; <<<<<<
	SHLD    L_DE5B
	CALL    L_C652
	XCHG
	CALL    L_D0AC
	CALL    L_C13D
	STA     M_E06A	; <<<<<<
	RZ
	MVI  A, 0FFh
	STA     M_E06A	; <<<<<<
	STA     L_DE11
	LDA     L_DE60
	STA     M_E06B	; <<<<<<
L_C5F5: MVI  A, 000h
	LHLD    L_DE5B
	LXI  D, 00020h
	DAD  D
	MOV  M, A
	RET
;
P_C600: XRA  A
	STA     M_E06A	; <<<<<<
	RET
;
P_C605: XCHG
	MVI  A, 0FFh
	STA     M_E110	; <<<<<<
	SHLD    M_E112	; <<<<<<
	INR  A
	STA     M_E111	; <<<<<<
	RET
;
L_C613: LXI  H, M_E0ED	; <<<<<<
	SHLD    L_DE5B
	CALL    L_C652
	XCHG
	CALL    L_D1D7
	CALL    L_C13D
	STA     M_E10E	; <<<<<<
	RZ
	LXI  H, M_E06D	; <<<<<<
	CALL    L_C63F
	XRA  A
	STA     L_DE16
	CALL    L_C5F5
	DCR  A
	STA     M_E10E	; <<<<<<
	LDA     L_DE60
	STA     M_E10F	; <<<<<<
	RET
;
L_C63F: LXI  B, 00080h
	MVI  E, 01Ah
	JMP     L_C649
;
	.db 01Eh	; <_> - |   ■■■■ | (offset 0947h)
	.db 000h	; <_> - |	| (offset 0948h)
;
L_C649: MOV  M, E
	INX  H
	DCX  B
	MOV  A, B
	ORA  C
	JNZ     L_C649
	RET
;
L_C652: MOV  A, M
	ORA  A
	RNZ
	LDA     L_DE5A
	INR  A
	MOV  M, A
	RET
;
P_C65B: MOV  A, E
	JMP     L_CBE0
;
P_C65F: MOV  C, E
	MOV  B, D
	CALL    L_C703
	CALL    L_CB67
	RZ
	JMP     L_CFD9
;
L_C66B: RAR
	MOV  E, A
	MVI  D, 000h
	INX  H
	MOV  C, M
	INX  H
	MOV  B, M
	LXI  H, L_C000
	DAD  D		; HL:= 0C000h + 3*A
	DAD  D
	DAD  D
	XCHG		; HL <-> DE
	LXI  H, L_C681
	PUSH H		; заносим адрес возврата в стек ???
	XCHG		; HL <-> DE
	MOV  D, B
	PCHL		; >>>>> (3)
;
L_C681: SHLD L_DF0F
	RET
;
P_C685: CALL    L_C916	; вызов из PCHL (2)
	JMP     L_C88C
;
L_C68B: MOV  A, C	; ПП печатает символ из С
	CALL    L_C924
	JNC     L_C69C
	PUSH PSW
	MVI  C, 05Eh
	CALL    L_C83C
	POP  PSW
	ORI     040h
	MOV  C, A
L_C69C: MOV  A, C
	CPI     009h
	JNZ     L_C83C
L_C6A2: MVI  C, 020h
	CALL    L_C83C
	LDA     L_DE37
	ANI     007h
	JNZ     L_C6A2
	RET
;
L_C6B0: LHLD    L_DE42
	CALL    L_DCAF
	JMP     L_C88C
;
L_C6B9: LHLD    L_DE44
L_C6BC: LXI  D, 0000Ch
L_C6BF: DAD  H
	JC      B_E20C
	INR  D
	DCR  E
	RZ
	JMP     L_C6BF
;
P_C6C9: MOV  A, C	; вызов из PCHL (2)
	INR  A
	JZ      L_C6DC
	INR  A
	JZ      L_C6F1
	INR  A
	JNZ     L_DD85
	CALL    L_DD31
	JMP     L_C88C
;
L_C6DC: CALL    L_C937
	ORA  A
	RZ
	LXI  H, L_DF0B
	MOV  A, M
	MVI  M, 000h
	ORA  A
	JNZ     L_C88C
	CALL    L_DD31
	JMP     L_C88C
;
L_C6F1: CALL    L_C937
	ORA  A
	JNZ     L_CFDC
	JMP     L_C88C
;
P_C6FB: LHLD    L_DE42	; вызов из PCHL (2)
	JMP     L_DC8F
;
P_C701: MOV  C, E	; вызов из PCHL (2)
	MOV  B, D
L_C703: LXI  H, L_DE53
	LDAX B
	CMP  M
	RZ
	INX  B
	PUSH B
	MOV  C, A
	CALL    L_C69C
	POP  B
	JMP     L_C703
;
L_C713: LHLD    L_DE5B
L_C716: LDA     L_DE37
	STA     L_DF0A
	MOV  C, M
	INX  H
	PUSH H
	MVI  B, 000h
L_C721: PUSH B
	PUSH H
L_C723: CALL    L_C896
	POP  H
	POP  B
	CPI     00Dh
	JZ      L_C838
	CPI     00Ah
	JZ      L_C838
	CPI     008h
	JZ      L_C73C
	CPI     07Fh
	JNZ     L_C74B
L_C73C: MOV  A, B
	ORA  A
	JZ      L_C721
L_C741: DCR  B
	LDA     L_DE37
	STA     L_DF09
	JMP     L_C78D
;
L_C74B: CPI     005h
	JNZ     L_C75C
	PUSH B
	PUSH H
	CALL    L_CB41
	XRA  A
	STA     L_DF0A
	JMP     L_C723
;
L_C75C: CPI     010h
	JNZ     L_C76D
	PUSH B
	PUSH H
	LXI  H, L_DE54
	MVI  A, 001h
	SUB  M
	MOV  M, A
	JMP     L_C723
;
L_C76D: CPI     018h
	JNZ     L_C77C
	POP  H
L_C773: CALL    L_C873
	JNC     L_C713
	JMP     L_C773
;
L_C77C: CPI     015h
	JNZ     L_C788
	CALL    L_C8F9
	POP  H
	JMP     L_C713
;
L_C788: CPI     012h
	JNZ     L_C7BF
L_C78D: PUSH B
	CALL    L_C8F9
	POP  B
	POP  H
	PUSH H
	PUSH B
L_C795: MOV  A, B
	ORA  A
	JZ      L_C7A3
	INX  H
	MOV  A, M
	DCR  B
	CALL    L_CBF6	; печать символа из А
	JMP     L_C795
;
L_C7A3: PUSH H
	LDA     L_DF09
	ORA  A
	JZ      L_C723
	LXI  H, L_DE37
	SUB  M
	STA     L_DF09
L_C7B2: CALL    L_C8EC
	LXI  H, L_DF09
	DCR  M
	JNZ     L_C7B2
	JMP     L_C723
;
L_C7BF: CPI     017h
	JNZ     L_C7DC
	MOV  E, A
	MOV  A, B
	ORA  A
	MOV  A, E
	JNZ     L_C7DC
	MOV  B, M
	MOV  E, B
	INR  E
L_C7CE: DCR  E
	JZ      L_C721
	INX  H
	MOV  A, M
	PUSH D
	CALL    L_CBF6	; печать символа из А
	POP  D
	JMP     L_C7CE
;
L_C7DC: CPI     01Eh
	JNZ     L_C822
L_C7E1: INR  B
	DCR  B
	JZ      L_C721
	MOV  A, M
	CPI     020h
	JC      L_C741
	JNZ     L_C7F8
	CALL    L_C873
	JNC     L_C721
	JMP     L_C7E1
;
L_C7F8: CALL    L_D903
	JZ      L_C741
L_C7FE: INR  B
	DCR  B
	JZ      L_C721
	MOV  A, M
	CALL    L_D903
	JZ      L_C721
	CPI     00Eh
	JZ      L_C819
	CPI     00Fh
	JZ      L_C819
	CPI     020h
	JC      L_C721
L_C819: CALL    L_C873
	JNC     L_C721
	JMP     L_C7FE
;
L_C822: INX  H
	MOV  M, A
	INR  B
	CALL    L_CBF6	; печать символа из А
	MOV  A, M
	CPI     003h
	MOV  A, B
	JNZ     L_C834
	CPI     001h
	JZ      00000h	; >>>>>>>>>
L_C834: CMP  C
	JC      L_C721
L_C838: POP  H
	MOV  M, B
	MVI  C, 00Dh
L_C83C: LDA     L_DF09
	ORA  A
	JNZ     L_C856
	PUSH B
	CALL    L_C937
	POP  B
	PUSH B
	CALL    L_DD85
	POP  B
	PUSH B
	LDA     L_DE54
	ORA  A
	CNZ     L_DC72
	POP  B
L_C856: MOV  A, C
	LXI  H, L_DE37
	CPI     07Fh
	RZ
	INR  M
	CPI     020h
	RNC
	DCR  M
	MOV  A, M
	ORA  A
	RZ
	MOV  A, C
	CPI     008h
	JNZ     L_C86D
	DCR  M
	RET
;
L_C86D: CPI     00Ah
	RNZ
	MVI  M, 000h
	RET
;
L_C873: DCR  B
	DCX  H
	PUSH B
	PUSH H
	LDA     L_DF0A
	LXI  H, L_DE37
	CMP  M
	JNC     L_C886
	DCR  M
	CALL    L_C8EC
	STC
L_C886: POP  H
	POP  B
	RET
;
P_C889: CALL    L_C937	; вызов из PCHL (2)
L_C88C: STA     L_DF0F
P_C88F: RET		; вызов из PCHL (2)
;
P_C890: LDA     L_DE21	; вызов из PCHL (2)
	JMP     L_C88C
;
L_C896: CALL    L_DC7E
	JZ      L_C8A4
	LXI  H, L_DF0B
	MOV  A, M
	MVI  M, 000h
	ORA  A
	RNZ
L_C8A4: CALL    L_C009
	CPI     004h
	RNZ
	LXI  H, M_E117	; <<<<<<
	MOV  A, M
	ORA  A
	JNZ     L_C8A4
	MVI  M, 0FFh
	LDA     L_DF0A
	PUSH PSW
	LDA     L_DE37
	PUSH PSW
	LHLD    L_DE5B
	PUSH H
	LXI  H, 00000h
	DAD  SP
	SHLD    M_E11A	; <<<<<<
	LXI  SP,M_E176	; <<<<<<
	CALL    L_C033
L_C8CD: CALL    L_CB41
	MVI  A, 03Eh	; = ">"
	CALL    L_CBF6	; печать символа из А
	XRA  A
	STA     M_E117	; <<<<<<
	LHLD    M_E11A	; <<<<<<
	SPHL
	POP  H
	SHLD    L_DE5B
	POP  PSW
	STA     L_DE37
	POP  PSW
	STA     L_DF0A
	JMP     L_C8A4
;
L_C8EC: CALL    L_C8F4
	MVI  C, 020h
	CALL    L_DD85
L_C8F4: MVI  C, 008h
	JMP     L_DD85
;
L_C8F9: MVI  C, 023h
	CALL    L_C83C
	CALL    L_CB41
L_C901: LDA     L_DE37
	LXI  H, L_DF0A
	CMP  M
	RNC
	MVI  C, 020h
	CALL    L_C83C
	JMP     L_C901
;
L_C911: MVI  A, 001h
	JMP     L_C88C
;
L_C916: CALL    L_C896
	CALL    L_C924
	RC
	PUSH PSW
	MOV  C, A
	CALL    L_C69C
	POP  PSW
	RET
;
L_C924: CALL    L_C931
	RZ
	CPI     009h
	RZ
	CPI     008h
	RZ
	CPI     020h
	RET
;
L_C931: CPI     00Dh
	RZ
	CPI     00Ah
	RET
;
L_C937: LDA     L_DF0B
	ORA  A
	JNZ     L_C98B
	CALL    L_DC8C
	ANI     001h
	RZ
	CALL    L_DCAC
L_C947: CPI     013h
	JNZ     L_C988
L_C94C: CALL    L_DCAC
	CPI     003h
	JZ      00000h	; >>>>>>>
	CPI     011h
	JZ      L_C96F
	CPI     006h
	JNZ     L_C971
	LDA     M_E10E	; <<<<<<
	INR  A
	CZ      L_DDB5
	LDA     M_E06A	; <<<<<<
	INR  A
	JNZ     L_C96F
	STA     M_E06A	; <<<<<<
L_C96F: XRA  A
	RET
;
L_C971: CPI     010h
	JNZ     L_C980
	LXI  H, L_DE54
	MVI  A, 001h
	SUB  M
	MOV  M, A
	JMP     L_C96F
;
L_C980: MVI  C, 007h
	CALL    L_DD85
	JMP     L_C94C
;
L_C988: STA     L_DF0B
L_C98B: MVI  A, 001h
	RET
;
L_C98E: XRA  A
L_C98F: STA     L_DE1B
	MOV  A, M
	CPI     080h
	JC      L_C9A6
	PUSH H
	PUSH B
	CALL    L_C9BB
	POP  B
	POP  H
	LDA     L_DF0F
	ORA  A
	RNZ
	XRA  A
	MOV  M, A
L_C9A6: INR  M
	INX  H
	MOV  E, M
	INX  H
	MOV  D, M
	XCHG
	CALL    L_CE0F
	LDA     L_DE1B
	INR  A
	JZ      L_C9B9
	XRA  A
	MOV  A, M
	RET
;
L_C9B9: MOV  M, C
	RET
;
L_C9BB: INX  H
	MOV  C, M
	INX  H
	MOV  B, M
	PUSH B
	INX  H
	MOV  E, M
	INX  H
	MOV  D, M
	LHLD    L_DE58
	PUSH H
	CALL    L_CE93
	XRA  A
	STA     L_DF0F
	PUSH D
	LXI  H, L_DE8C
	CALL    L_DC63
	POP  H
	SHLD    L_DE5B
	XCHG
	LDA     L_DE1B
	INR  A
	JZ      L_CA02
	LDA     L_DE60
	PUSH PSW
	LDA     M_E06B	; <<<<<<
	STA     L_DE60
	CALL    L_D28C
	POP  PSW
	STA     L_DE60
	POP  H
	XTHL
L_C9F5: CALL    L_D52B
	LXI  H, L_DE8C
	CALL    L_DC69
	POP  B
	JMP     L_CE93
;
L_CA02: LDA     L_DE60
	PUSH PSW
	LDA     M_E10F	; <<<<<<
	STA     L_DE60
	CALL    L_D2E3
	POP  PSW
	STA     L_DE60
	POP  H
	XTHL
	CALL    L_C63F
	JMP     L_C9F5
;
L_CA1B: MVI  A, 0FFh
	JMP     L_C98F
;
L_CA20: LDA     L_DE5F
	CPI     02Eh
	JZ      L_CA32
	CPI     00Fh
	JC      L_CA32
	MVI  A, 0FFh
	STA     L_DF08
L_CA32: MVI  A, 001h
	CALL    L_CAFC
	LXI  B, L_CB4B
	CALL    L_DA08
	LDA     L_DF11
	CALL    L_CBE0
	CALL    L_CB5D
	LXI  B, L_CB4C
	CALL    L_DA08
	LDA     L_DDF4
	CALL    L_CB83
	CALL    L_CB5D
	LXI  B, L_CB50
	CALL    L_DA08
	LDA     L_DDF5
	CALL    L_CB83
	CALL    L_CB41
	LDA     M_E117	; <<<<<<
	INR  A
	JZ      L_C8CD
	LDA     L_DDED
	ORA  A
	MVI  A, 0FFh
	STA     L_DDED
	JZ      00000h	; >>>>>>>>>
	JMP     L_CAA6
;
L_CA7A: MVI  A, 0FFh
	STA     L_DF08
	MVI  A, 008h
	CALL    L_CAFC
	JMP     L_CA92
;
L_CA87: MVI  A, 002h
	CALL    L_CAFC
	LDA     L_DF0E
	STA     L_DE5A
L_CA92: LDA     M_E117	; <<<<<<
	INR  A
	JNZ     L_DA31
	JMP     L_C8CD
;
L_CA9C: MVI  A, 0FFh
	STA     L_DF08
	MVI  A, 003h
	CALL    L_CAFC
L_CAA6: LDA     L_DE5A
	MOV  C, A
	LXI  H, 00001h
	CALL    L_CDB1
	CALL    L_D7C3
	CALL    L_CB62
	JNZ     00000h	; >>>>>>
	CALL    L_CB41
	RET
;
L_CABD: LDA     L_DF11
	ORA  A
	JNZ     L_CAD0
	LHLD    L_DEC9
	LDA     L_DEF5
	CALL    L_CE0F
	JMP     L_CAD3
;
L_CAD0: LHLD    L_DE5B
L_CAD3: MVI  C, 008h
	INX  H
	CALL    L_CAED
	INR  C
L_CADA: DCR  C
	JZ      L_CAE2
	INX  H
	JMP     L_CADA
;
L_CAE2: MOV  A, M
	CPI     020h
	RZ
	MVI  A, 02Eh	; = "."
	CALL    L_CBF6	; печать символа из А
	MVI  C, 003h
L_CAED: MOV  A, M
	CPI     020h
	RZ
	ANI     07Fh
	CALL    L_CBF6	; печать символа из А
	INX  H
	DCR  C
	JNZ     L_CAED
	RET
;
L_CAFC: PUSH PSW
	CALL    L_CB41
	XRA  A
L_CB01: CALL    L_D9FE
	CALL    L_C22E
	LDA     L_DF08
	INR  A
	CZ      L_CABD
	POP  PSW
	CALL    L_D9FE
	CALL    L_CB41
	LDA     M_E117	; <<<<<<
	INR  A
	RZ
	CPI     002h
	RZ
	LXI  B, L_CB54
	CALL    L_DA08
	LDA     L_DE5F
	CALL    L_CB83
	CALL    L_CB5D
	LXI  B, L_CB58
	CALL    L_DA08
	LHLD    L_DF0C
	MOV  A, M
	INX  H
	MOV  H, M
	MOV  L, A
	CALL    L_CBDB
	MVI  A, 048h	; = "H"
	CALL    L_CBF6	; печать символа из А
L_CB41: MVI  C, 00Dh
	CALL    L_C83C
	MVI  C, 00Ah
	JMP     L_C83C
;
L_CB4B: .db "S"
L_CB4C: .db "T= $"
L_CB50: .db "S= $"
L_CB54: .db "O= $"
L_CB58: .db "PC= $"
;
L_CB5D: MVI  A, 009h
	JMP     L_CBF6	; печать символа из А
;
L_CB62: MVI  A, 006h
L_CB64: CALL    L_D9FE
L_CB67: LXI  H, L_DF13
	MVI  M, 002h
	CALL    L_C716
	LXI  H, L_DF13
	MVI  M, 07Fh
	INX  H
	MOV  A, M
	CPI     001h
	RNZ
	INX  H
	MOV  A, M
	ANI     0DFh
	CPI     059h
	RZ
	CPI     0C4h
	RET
;
L_CB83: MVI  D, 000h
	MOV  E, A
L_CB86: PUSH D
	MVI  B, 085h
	LXI  H, L_CBD1
L_CB8C: MOV  E, M
	INX  H
	MOV  D, M
	INX  H
	XTHL
	MVI  C, 030h
L_CB93: MOV  A, L
	SUB  E
	MOV  L, A
	MOV  A, H
	SBB  D
	MOV  H, A
	JC      L_CBA0
	INR  C
	JMP     L_CB93
;
L_CBA0: DAD  D
	MOV  A, B
	ORA  A
	JP      L_CBB7
	PUSH PSW
	MOV  A, C
	CPI     030h
	JZ      L_CBBE
	CALL    L_CBF6	; печать символа из А
	POP  PSW
	ANI     07Fh
	MOV  B, A
	JMP     L_CBCA
;
L_CBB7: MOV  A, C
	CALL    L_CBF6	; печать символа из А
	JMP     L_CBCA
;
L_CBBE: POP  PSW
	ANI     07Fh
	CPI     001h
	JNZ     L_CBCA
	MOV  B, A
	JMP     L_CBB7
;
L_CBCA: XTHL
	DCR  B
	JNZ     L_CB8C
	POP  D
	RET
;
L_CBD1: .dw 02710h	; ????
	.db 0E8h	; <ш> - |■■■ ■   | (offset 0ED3h)
	.db 003h	; <_> - |      ■■| (offset 0ED4h)
	.db 064h	; <d> - | ■■  ■  | (offset 0ED5h)
	.db 000h	; <_> - |	| (offset 0ED6h)
	.db 00Ah	; <_> - |    ■ ■ | (offset 0ED7h)
	.db 000h	; <_> - |	| (offset 0ED8h)
	.db 001h	; <_> - |       ■| (offset 0ED9h)
	.db 000h	; <_> - |	| (offset 0EDAh)
;
L_CBDB: MOV  A, H
	CALL    L_CBE0
	MOV  A, L
L_CBE0: PUSH PSW
	RAR
	RAR
	RAR
	RAR
	ANI     00Fh
	CALL    L_CBED
	POP  PSW
	ANI     00Fh
L_CBED: ADI     030h
	CPI     03Ah
	JC      L_CBF6	; печать символа из А
	ADI     007h
L_CBF6: PUSH H		; ПП печатает символ из А
	PUSH B
	PUSH D
	MOV  C, A
	CALL    L_C68B	; печать символа из С
	POP  D
	POP  B
	POP  H
	RET
;
L_CC01: LDA     L_DE5A
	MOV  C, A
	CALL    L_DC1A
	MOV  A, H
	ORA  L
	RZ
	MOV  E, M
	INX  H
	MOV  D, M
	INX  H
	SHLD    L_DEC3
	INX  H
	INX  H
	SHLD    L_DEC5
	INX  H
	INX  H
	SHLD    L_DEC7
	INX  H
	INX  H
	XCHG
	SHLD    L_DEE0
	LXI  H, L_DEC9
	MVI  C, 008h
	CALL    L_D6DA
	LHLD    L_DECB
	XCHG
	LXI  H, L_DED1
	MVI  C, 00Fh
	CALL    L_D6DA
	LHLD    L_DED6
	MOV  A, H
	LXI  H, L_DEE9
	MVI  M, 0FFh
	ORA  A
	JZ      L_CC45
	MVI  M, 000h
L_CC45: MVI  A, 0FFh
	ORA  A
	RET
;
L_CC49: CALL    L_DC27
	XRA  A
	LHLD    L_DEC5
	MOV  M, A
	INX  H
	MOV  M, A
	LHLD    L_DEC7
	MOV  M, A
	INX  H
	MOV  M, A
	RET
;
L_CC5A: CALL    L_DC3F
	JMP     L_CC63
;
L_CC60: CALL    L_DC3A
L_CC63: ORA  A
	STA     L_DF11
	RZ
	LDA     L_DF12
	ORA  A
	JZ      L_CA20
	DCR  A
	STA     L_DF12
	RET
;
L_CC74: LHLD    L_DE61
	MVI  C, 002h
	CALL    L_CD97
	SHLD    L_DEF1
	SHLD    L_DEF7
L_CC82: LXI  H, L_DEF1
	MOV  C, M
	INX  H
	MOV  B, M
	LHLD    L_DEC7
	MOV  E, M
	INX  H
	MOV  D, M
	LHLD    L_DEC5
	MOV  A, M
	INX  H
	MOV  H, M
	MOV  L, A
L_CC95: MOV  A, C
	SUB  E
	MOV  A, B
	SBB  D
	JNC     L_CCAB
	PUSH H
	LHLD    L_DED1
	MOV  A, E
	SUB  L
	MOV  E, A
	MOV  A, D
	SBB  H
	MOV  D, A
	POP  H
	DCX  H
	JMP     L_CC95
;
L_CCAB: PUSH H
	LHLD    L_DED1
	DAD  D
	JC      L_CCC0
	MOV  A, C
	SUB  L
	MOV  A, B
	SBB  H
	JC      L_CCC0
	XCHG
	POP  H
	INX  H
	JMP     L_CCAB
;
L_CCC0: POP  H
	PUSH B
	PUSH D
	PUSH H
	XCHG
	CALL    L_C2D4
	MOV  A, M
	INX  H
	MOV  H, M
	MOV  L, A
	DAD  D
	MOV  B, H
	MOV  C, L
	CALL    L_DC29
	POP  D
	LHLD    L_DEC5
	MOV  M, E
	INX  H
	MOV  M, D
	POP  D
	LHLD    L_DEC7
	MOV  M, E
	INX  H
	MOV  M, D
	POP  B
	MOV  A, C
	SUB  E
	MOV  C, A
	MOV  A, B
	SBB  D
	MOV  B, A
	LHLD    L_DEE0
	MOV  A, L
	ORA  H
	INX  B
	JZ      L_DC2E
	DCX  B
	XCHG
	CALL    L_DC33
	MOV  C, L
	MOV  B, H	; это не обязательно делать, т.к. старший байт далее не используется
	JMP     L_DC2E
;
L_CCFA: LXI  H, L_DED3
	MOV  C, M
	LDA     L_DEEF
L_CD01: ORA  A
	RAR
	DCR  C
	JNZ     L_CD01
	MOV  B, A
	MVI  A, 008h
	SUB  M
	MOV  C, A
	LDA     L_DEEE
L_CD0F: DCR  C
	JZ      L_CD18
	ORA  A
	RAL
	JMP     L_CD0F
;
L_CD18: ADD  B
	RET
;
L_CD1A: LHLD    L_DE5B
	LXI  D, 00010h
	DAD  D
	DAD  B
	LDA     L_DEE9
	ORA  A
	JZ      L_CD2D
	MOV  L, M
	MVI  H, 000h
	RET
;
L_CD2D: DAD  B
L_CD2E: MOV  E, M
	INX  H
	MOV  D, M
	XCHG
	RET
;
L_CD33: CALL    L_CCFA
	MOV  C, A
	MVI  B, 000h
	CALL    L_CD1A
	SHLD    L_DEF1
	RET
;
L_CD40: LHLD    L_DEF1
	MOV  A, L
	ORA  H
	RET
;
L_CD46: LDA     L_DED3
	LHLD    L_DEF1
L_CD4C: DAD  H
	DCR  A
	JNZ     L_CD4C
	SHLD    L_DEF3
	LDA     L_DED4
	MOV  C, A
	LDA     L_DEEF
	ANA  C
	ORA  L
	MOV  L, A
	SHLD    L_DEF1
	RET
;
L_CD62: LHLD    L_DE5B
	LXI  D, 0000Ch
	DAD  D
	RET
;
L_CD6A: LHLD    L_DE5B
	XCHG
	LXI  H, 00021h
	DAD  D
	RET
;
L_CD73: LHLD    L_DE5B
	LXI  D, 0000Fh
	DAD  D
	XCHG
	LXI  H, 00011h
	DAD  D
	RET
;
L_CD80: CALL    L_CD73
	MOV  A, M
	STA     L_DEEF
	XCHG
	MOV  A, M
	STA     L_DEED
	CALL    L_CD62
	LDA     L_DED5
	ANA  M
	STA     L_DEEE
	RET
;
L_CD97: INR  C
L_CD98: DCR  C
	RZ
	MOV  A, H
	ORA  A
	RAR
	MOV  H, A
	MOV  A, L
	RAR
	MOV  L, A
	JMP     L_CD98
;
L_CDA4: LHLD    L_DEC9
	XRA  A
	MVI  C, 080h
L_CDAA: ADD  M
	INX  H
	DCR  C
	JNZ     L_CDAA
	RET
;
L_CDB1: INR  C
L_CDB2: DCR  C
	RZ
	DAD  H
	ADC  A
	JMP     L_CDB2
;
L_CDB9: PUSH B
	LDA     L_DE5A
	MOV  C, A
	LXI  H, 00001h
	CALL    L_CDB1
	POP  B
	MOV  A, C
	ORA  L
	MOV  L, A
	MOV  A, B
	ORA  H
	MOV  H, A
	RET
;
L_CDCC: LHLD    L_DEBF
	LDA     L_DE5A
	MOV  C, A
	CALL    L_CD97
	MOV  A, L
	ANI     001h
	RET
;
L_CDDA: CALL    L_CE09
L_CDDD: LXI  D, 0000Ah
	DAD  D
	MOV  A, M
	RAL
	JC      L_CA7A
	DCX  H
	MOV  A, M
	RAL
	RNC
	PUSH H
	CALL    L_CA9C
	POP  H
	MOV  A, M
	ANI     07Fh
	MOV  M, A
	RET
;
L_CDF4: CALL    L_CDCC
	RZ
	LDA     L_DE5A
	MOV  C, A
L_CDFC: LXI  H, 00001h
	CALL    L_CDB1
	CALL    L_D7C3
	CALL    L_D552
	RET
;
L_CE09: LHLD    L_DEC9
	LDA     L_DEF5
L_CE0F: ADD  L
	MOV  L, A
	RNC
	INR  H
	RET
;
L_CE14: LHLD    L_DE5B
	LXI  D, 0000Eh
	DAD  D
	MOV  A, M
	RET
;
L_CE1D: CALL    L_CE14
	MVI  M, 000h
	RET
;
L_CE23: LHLD    L_DE61
	XCHG
	LHLD    L_DEC3
	MOV  A, E
	SUB  M
	INX  H
	MOV  A, D
	SBB  M
	RET
;
L_CE30: CALL    L_CE23
	RC
	INX  D
	MOV  M, D
	DCX  H
	MOV  M, E
	RET
;
L_CE39: MOV  A, E
	SUB  L
	MOV  L, A
	MOV  A, D
	SBB  H
	MOV  H, A
	RET
;
L_CE40: MVI  C, 0FFh
L_CE42: LHLD    L_DEF7
	XCHG
	LHLD    L_DEDC
	CALL    L_CE39
	RNC
	PUSH B
	CALL    L_CDA4
	LHLD    L_DECD
	XCHG
	LHLD    L_DEF7
	DAD  D
	POP  B
	INR  C
	JZ      L_CE68
	CMP  M
	RZ
	CALL    L_CE23
	RNC
	CALL    L_D736
	RET
;
L_CE68: MOV  M, A
	RET
;
L_CE6A: XRA  A
	STA     L_DDED
	CALL    L_CE40
	CALL    L_CE8D
	MVI  C, 001h
	CALL    L_CC60
	MVI  A, 0FFh
	STA     L_DDED
	JMP     L_CE87
;
L_CE81: CALL    L_CE8D
	CALL    L_CC5A
L_CE87: LXI  H, L_DE58
	JMP     L_CE90
;
L_CE8D: LXI  H, L_DEC9
L_CE90: MOV  C, M
	INX  H
	MOV  B, M
L_CE93: MOV  L, C
	MOV  H, B
	SHLD    L_DDF6
	RET
;
L_CE99: LXI  H, L_DE61
	MOV  A, M
	INX  H
	CMP  M
	RNZ
	INR  A
	RET
;
L_CEA2: LHLD    L_DED8
	XCHG
	LHLD    L_DE61
	INX  H
	SHLD    L_DE61
	CALL    L_CE39
	JNC     L_CEBA
L_CEB3: LXI  H, 0FFFFh	; <<<<<<
	SHLD    L_DE61
	RET
;
L_CEBA: LDA     L_DE61
	ANI     003h
	RRC
	RRC
	RRC
	STA     L_DEF5
	ORA  A
	RNZ
	PUSH B
	CALL    L_CC74
	CALL    L_CE81
	POP  B
	JMP     L_CE42
;
L_CED2: MOV  A, C
	ANI     007h
	INR  A
	MOV  E, A
	MOV  D, A
	MOV  A, C
	RRC
	RRC
	RRC
	ANI     01Fh
	MOV  C, A
	MOV  A, B
	ADD  A
	ADD  A
	ADD  A
	ADD  A
	ADD  A
	ORA  C
	MOV  C, A
	MOV  A, B
	RRC
	RRC
	RRC
	ANI     01Fh
	MOV  B, A
	LHLD    L_DECF
	DAD  B
	MOV  A, M
L_CEF3: RLC
	DCR  E
	JNZ     L_CEF3
	RET
;
L_CEF9: PUSH D
	CALL    L_CED2
	ANI     0FEh
	POP  B
	ORA  C
L_CF01: RRC
	DCR  D
	JNZ     L_CF01
	MOV  M, A
	RET
;
L_CF08: CALL    L_CE09
	LXI  D, 00010h
	DAD  D
	PUSH B
	MVI  C, 011h
L_CF12: POP  D
	DCR  C
	RZ
	PUSH D
	LDA     L_DEE9
	ORA  A
	JZ      L_CF25
	PUSH B
	PUSH H
	MOV  C, M
	MVI  B, 000h
	JMP     L_CF2B
;
L_CF25: DCR  C
	PUSH B
	MOV  C, M
	INX  H
	MOV  B, M
	PUSH H
L_CF2B: MOV  A, C
	ORA  B
	JZ      L_CF3A
	LHLD    L_DED6
	MOV  A, L
	SUB  C
	MOV  A, H
	SBB  B
	CNC     L_CEF9
L_CF3A: POP  H
	INX  H
	POP  B
	JMP     L_CF12
;
L_CF40: LHLD    L_DED6
	MVI  C, 003h
	CALL    L_CD97
	INX  H
	RET
;
L_CF4A: PUSH B
	PUSH PSW
	LDA     L_DED5
	CMA
	MOV  B, A
	MOV  A, C
	ANA  B
	MOV  C, A
	POP  PSW
	ANA  B
	SUB  C
	ANI     01Fh
	POP  B
	RET
;
L_CF5B: MVI  C, 00Fh
L_CF5D: MVI  A, 0FFh
	STA     L_DEE4
	LXI  H, L_DEE8
	MOV  M, C
	LHLD    L_DE5B
	SHLD    L_DE63
	CALL    L_CEB3
	CALL    L_CC49
L_CF72: MVI  C, 000h
	CALL    L_CEA2
	CALL    L_CE99
	JZ      L_CFD9
	LHLD    L_DE63
	XCHG
	LDAX D
	CPI     0E5h
	JZ      L_CF8F
	PUSH D
	CALL    L_CE23
	POP  D
	JNC     L_CFD9
L_CF8F: CALL    L_CE09
	LDA     L_DEE8
	MOV  C, A
	MVI  B, 000h
L_CF98: MOV  A, C
	ORA  A
	JZ      L_CFC8
	LDAX D
	CPI     03Fh
	JZ      L_CFC1
	MOV  A, B
	CPI     00Dh
	JZ      L_CFC1
	CPI     00Ch
	LDAX D
	JZ      L_CFB8
	SUB  M
	ANI     07Fh
	JNZ     L_CF72
	JMP     L_CFC1
;
L_CFB8: PUSH B
	MOV  C, M
	CALL    L_CF4A
	POP  B
	JNZ     L_CF72
L_CFC1: INX  D
	INX  H
	INR  B
	DCR  C
	JMP     L_CF98
;
L_CFC8: LDA     L_DE61
	ANI     003h
	STA     L_DF0F
	LXI  H, L_DEE4
	MOV  A, M
	RAL
	RNC
	XRA  A
	MOV  M, A
	RET
;
L_CFD9: CALL    L_CEB3
L_CFDC: MVI  A, 0FFh
	MOV  B, A
	INR  B
	JMP     L_C88C
;
L_CFE3: CALL    L_CDF4
	MVI  C, 00Ch
	CALL    L_CF5D
L_CFEB: CALL    L_CE99
	RZ
	CALL    L_CDDA
	CALL    L_CE09
	MVI  M, 0E5h
	MVI  C, 000h
	CALL    L_CF08
	CALL    L_CE6A
	CALL    L_CF72
	JMP     L_CFEB
;
L_D005: MOV  D, B
	MOV  E, C
L_D007: MOV  A, C
	ORA  B
	JZ      L_D018
	DCX  B
	PUSH D
	PUSH B
	CALL    L_CED2
	RAR
	JNC     L_D033
	POP  B
	POP  D
L_D018: LHLD    L_DED6
	MOV  A, E
	SUB  L
	MOV  A, D
	SBB  H
	JNC     L_D03B
	INX  D
	PUSH B
	PUSH D
	MOV  B, D
	MOV  C, E
	CALL    L_CED2
	RAR
	JNC     L_D033
	POP  D
	POP  B
	JMP     L_D007
;
L_D033: RAL
	INR  A
	CALL    L_CF01
	POP  H
	POP  D
	RET
;
L_D03B: MOV  A, C
	ORA  B
	JNZ     L_D007
	LXI  H, 00000h
	RET
;
L_D044: MVI  E, 020h
L_D046: MVI  C, 000h
L_D048: PUSH D
	MVI  B, 000h
	LHLD    L_DE5B
	DAD  B
	XCHG
	CALL    L_CE09
	POP  B
	CALL    L_D6DA
L_D057: CALL    L_CC74
	JMP     L_CE6A
;
L_D05D: CALL    L_CDF4
	LHLD    L_DE5B
	PUSH H
	MOV  A, M
	LXI  D, 00010h
	DAD  D
	SHLD    L_DE5B
	MOV  M, A
	MVI  C, 00Ch
	CALL    L_CF5D
	POP  H
	SHLD    L_DE5B
	CALL    L_CE99
	MVI  A, 0FFh
	STA     L_DEE4
	RNZ
	MVI  C, 00Ch
	CALL    L_CF5D
L_D084: CALL    L_CE99
	RZ
	CALL    L_CDDA
	MVI  C, 010h
	MVI  E, 00Ch
	CALL    L_D048
	CALL    L_CF72
	JMP     L_D084
;
L_D098: MVI  C, 00Ch
	CALL    L_CF5D
L_D09D: CALL    L_CE99
	RZ
	MVI  E, 00Ch
	CALL    L_D046
	CALL    L_CF72
	JMP     L_D09D
;
L_D0AC: CALL    L_CE1D
	CALL    L_D4E2
L_D0B2: CALL    L_CF5B
	CALL    L_CE99
	CZ      L_D0F6
	RZ
L_D0BC: CALL    L_CD62
	MOV  A, M
	PUSH PSW
	PUSH H
	CALL    L_CE09
	XCHG
	LHLD    L_DE5B
	MVI  C, 020h
	PUSH D
	CALL    L_D6DA
	CALL    L_D285
	POP  D
	LXI  H, 0000Ch
	DAD  D
	MOV  C, M
	LXI  H, 0000Fh
	DAD  D
	MOV  B, M
	POP  H
	POP  PSW
	MOV  M, A
	MOV  A, C
	CMP  M
	MOV  A, B
	JZ      L_D0ED
	MVI  A, 000h
	JC      L_D0ED
	MVI  A, 080h
L_D0ED: LHLD    L_DE5B
	LXI  D, 0000Fh
	DAD  D
	MOV  M, A
	RET
;
L_D0F6: LDA     L_DE60
	ORA  A
	JZ      L_D108
	LHLD    L_DE5B
	MOV  A, M
	ANI     0E0h
	MOV  M, A
	CALL    L_D133
	RNZ
L_D108: LDA     L_DE5A
	ORA  A
	RZ
	STA     L_DEEB
	XRA  A
	CALL    L_D546
	CALL    L_D133
	PUSH PSW
	LDA     L_DEEB
	CALL    L_D546
	POP  PSW
	JZ      L_CFDC
	LDA     L_DEEA
	ANI     0E0h
	ORI     001h
	STA     L_DEEA
	LDA     L_DEEB
	STA     L_DEEC
	RET
;
L_D133: CALL    L_CF5B
	CALL    L_CE99
	RZ
	CALL    L_CE09
	MVI  A, 00Ah
	CALL    L_CE0F
	MOV  A, M
	ANI     080h
	RET
;
L_D146: MOV  A, M
	INX  H
	ORA  M
	DCX  H
	RNZ
	LDAX D
	MOV  M, A
	INX  D
	INX  H
	LDAX D
	MOV  M, A
	DCX  D
	DCX  H
	RET
;
L_D154: CALL    L_D4E2
L_D157: XRA  A
	STA     L_DF0F
	STA     L_DE61
	STA     L_DEF6
	CALL    L_CDCC
	RNZ
	CALL    L_CE14
	ANI     080h
	RNZ
	CALL    L_CF5B
	CALL    L_CE99
	RZ
	LXI  B, 00010h
	CALL    L_CE09
	DAD  B
	XCHG
	LHLD    L_DE5B
	DAD  B
	MVI  C, 010h
L_D180: LDA     L_DEE9
	ORA  A
	JZ      L_D19B
	MOV  A, M
	ORA  A
	LDAX D
	JNZ     L_D18E
	MOV  M, A
L_D18E: ORA  A
	JNZ     L_D194
	MOV  A, M
	STAX D
L_D194: CMP  M
	JNZ     L_D1D2
	JMP     L_D1B0
;
L_D19B: CALL    L_D146
	XCHG
	CALL    L_D146
	XCHG
	LDAX D
	CMP  M
	JNZ     L_D1D2
	INX  D
	INX  H
	LDAX D
	CMP  M
	JNZ     L_D1D2
	DCR  C
L_D1B0: INX  D
	INX  H
	DCR  C
	JNZ     L_D180
	LXI  B, 0FFECh	; <<<<<<
	DAD  B
	XCHG
	DAD  B
	LDAX D
	CMP  M
	JC      L_D1CA
	MOV  M, A
	LXI  B, 00003h
	DAD  B
	XCHG
	DAD  B
	MOV  A, M
	STAX D
L_D1CA: MVI  A, 0FFh
	STA     L_DEE2
	JMP     L_D057
;
L_D1D2: LXI  H, L_DF0F
	DCR  M
	RET
;
L_D1D7: CALL    L_CE1D
	CALL    L_D4E2
	MVI  C, 00Ch
	CALL    L_CF5D
	CALL    L_CE99
	MVI  A, 0FFh
	JNZ     L_C88C
L_D1EA: CALL    L_CDF4
	LHLD    L_DE5B
	PUSH H
	LXI  H, L_DDEC
	SHLD    L_DE5B
	MVI  C, 001h
	CALL    L_CF5D
	CALL    L_CE99
	POP  H
	SHLD    L_DE5B
	RZ
	XCHG
	LXI  H, 0000Fh
	DAD  D
	MVI  C, 011h
	XRA  A
L_D20C: MOV  M, A
	INX  H
	DCR  C
	JNZ     L_D20C
	LXI  H, 0000Dh
	DAD  D
	MOV  M, A
	CALL    L_CE30
	CALL    L_D044
	JMP     L_D285
;
L_D220: XRA  A
	STA     L_DEE2
	CALL    L_D157
	CALL    L_CE99
	RZ
	LHLD    L_DE5B
	LXI  B, 0000Ch
	DAD  B
	MOV  A, M
	INR  A
	ANI     01Fh
	MOV  M, A
	JZ      L_D249
	MOV  B, A
	LDA     L_DED5
	ANA  B
	LXI  H, L_DEE2
	ANA  M
	JZ      L_D254
	JMP     L_D272
;
L_D249: LXI  B, 00002h
	DAD  B
	INR  M
	MOV  A, M
	ANI     00Fh
	JZ      L_D282
L_D254: MVI  C, 00Fh
	CALL    L_CF5D
	CALL    L_CE99
	JNZ     L_D272
	LDA     L_DEE3
	INR  A
	JZ      L_D27C
	CALL    L_D1EA
	CALL    L_CE99
	JZ      L_D282
	JMP     L_D275
;
L_D272: CALL    L_D0BC
L_D275: CALL    L_CD80
	XRA  A
	JMP     L_C88C
;
L_D27C: CALL    L_D0F6
	JNZ     L_D272
L_D282: CALL    L_C911
L_D285: CALL    L_CE14
	ORI     080h
	MOV  M, A
	RET
;
L_D28C: CALL    L_D4E2
	MVI  A, 001h
	STA     L_DEE5
L_D294: MVI  A, 0FFh
	STA     L_DEE3
	CALL    L_CD80
	LDA     L_DEEF
	LXI  H, L_DEED
	CMP  M
	JC      L_D2B9
	CPI     080h
	JNZ     L_C911
	CALL    L_D220
	XRA  A
	STA     L_DEEF
	LDA     L_DF0F
	ORA  A
	JNZ     L_C911
L_D2B9: CALL    L_CD33
	CALL    L_CD40
	JZ      L_C911
	CALL    L_CD46
	CALL    L_CC82
	CALL    L_CC5A
L_D2CB: CALL    L_CD73
	LDA     L_DEE5
	CPI     002h
	JNZ     L_D2D7
	XRA  A
L_D2D7: MOV  C, A
	LDA     L_DEEF
	ADD  C
	MOV  M, A
	XCHG
	LDA     L_DEED
	MOV  M, A
	RET
;
L_D2E3: CALL    L_D4E2
	MVI  A, 001h
	STA     L_DEE5
L_D2EB: MVI  A, 000h
	STA     L_DEE3
	CALL    L_CDF4
	LHLD    L_DE5B
	CALL    L_CDDD
	CALL    L_CD80
	LDA     L_DEEF
	CPI     080h
	JNC     L_C911
	CALL    L_CD33
	CALL    L_CD40
	MVI  C, 000h
	JNZ     L_D356
	CALL    L_CCFA
	STA     L_DEE7
	LXI  B, 00000h
	ORA  A
	JZ      L_D323
	MOV  C, A
	DCX  B
	CALL    L_CD1A
	MOV  B, H
	MOV  C, L
L_D323: CALL    L_D005
	MOV  A, L
	ORA  H
	JNZ     L_D330
	MVI  A, 002h
	JMP     L_C88C
;
L_D330: SHLD    L_DEF1
	XCHG
	LHLD    L_DE5B
	LXI  B, 00010h
	DAD  B
	LDA     L_DEE9
	ORA  A
	LDA     L_DEE7
	JZ      L_D34C
	CALL    L_CE0F
	MOV  M, E
	JMP     L_D354
;
L_D34C: MOV  C, A
	MVI  B, 000h
	DAD  B
	DAD  B
	MOV  M, E
	INX  H
	MOV  M, D
L_D354: MVI  C, 002h
L_D356: LDA     L_DF0F
	ORA  A
	RNZ
	PUSH B
	CALL    L_CD46
	LDA     L_DEE5
	DCR  A
	DCR  A
	JNZ     L_D3A3
	POP  B
	PUSH B
	MOV  A, C
	DCR  A
	DCR  A
	JNZ     L_D3A3
	PUSH H
	LHLD    L_DEC9
	MOV  D, A
L_D374: MOV  M, A
	INX  H
	INR  D
	JP      L_D374
	CALL    L_CE8D
	LHLD    L_DEF3
	MVI  C, 002h
L_D382: SHLD    L_DEF1
	PUSH B
	CALL    L_CC82
	POP  B
	CALL    L_CC60
	LHLD    L_DEF1
	MVI  C, 000h
	LDA     L_DED4
	MOV  B, A
	ANA  L
	CMP  B
	INX  H
	JNZ     L_D382
	POP  H
	SHLD    L_DEF1
	CALL    L_CE87
L_D3A3: CALL    L_CC82
	POP  B
	PUSH B
	CALL    L_CC60
	POP  B
	LDA     L_DEEF
	LXI  H, L_DEED
	CMP  M
	JC      L_D3BA
	MOV  M, A
	INR  M
	MVI  C, 002h
L_D3BA: DCR  C
	DCR  C
	JNZ     L_D3C7
	PUSH PSW
	CALL    L_CE14
	ANI     07Fh
	MOV  M, A
	POP  PSW
L_D3C7: CPI     07Fh
	JNZ     L_D3E8
	LDA     L_DEE5
	CPI     001h
	JNZ     L_D3E8
	CALL    L_D2CB
	CALL    L_D220
	LXI  H, L_DF0F
	MOV  A, M
	ORA  A
	JNZ     L_D3E6
	DCR  A
	STA     L_DEEF
L_D3E6: MVI  M, 000h
L_D3E8: JMP     L_D2CB
;
L_D3EB: XRA  A
	STA     L_DEE5
L_D3EF: PUSH B
	CALL    L_CD6A
	MOV  A, M
	ANI     07Fh
	PUSH PSW
	MOV  A, M
	RAL
	INX  H
	MOV  A, M
	RAL
	ANI     01Fh
	MOV  C, A
	MOV  A, M
	RAR
	RAR
	RAR
	RAR
	ANI     00Fh
	MOV  B, A
	POP  PSW
	INX  H
	MOV  L, M
	INR  L
	DCR  L
	MVI  L, 006h
	JNZ     L_D46E
	LXI  H, 00020h
	DAD  D
	MOV  M, A
	LXI  H, 0000Ch
	DAD  D
	MOV  A, C
	SUB  M
	JNZ     L_D42A
	LXI  H, 0000Eh
	DAD  D
	MOV  A, B
	SUB  M
	ANI     07Fh
	JZ      L_D462
L_D42A: PUSH B
	PUSH D
	CALL    L_D157
	POP  D
	POP  B
	MVI  L, 003h
	LDA     L_DF0F
	INR  A
	JZ      L_D467
	LXI  H, 0000Ch
	DAD  D
	MOV  M, C
	LXI  H, 0000Eh
	DAD  D
	MOV  M, B
	CALL    L_D0B2
	LDA     L_DF0F
	INR  A
	JNZ     L_D462
	POP  B
	PUSH B
	MVI  L, 004h
	INR  C
	JZ      L_D467
	CALL    L_D1EA
	MVI  L, 005h
	LDA     L_DF0F
	INR  A
	JZ      L_D467
L_D462: POP  B
	XRA  A
	JMP     L_C88C
;
L_D467: PUSH H
	CALL    L_CE14
	MVI  M, 0C0h
	POP  H
L_D46E: POP  B
	MOV  A, L
	STA     L_DF0F
	JMP     L_D285
;
L_D476: XCHG
	DAD  D
	MOV  C, M
	MVI  B, 000h
	LXI  H, 0000Ch
	DAD  D
	MOV  A, M
	RRC
	ANI     080h
	ADD  C
	MOV  C, A
	MVI  A, 000h
	ADC  B
	MOV  B, A
	MOV  A, M
	RRC
	ANI     00Fh
	ADD  B
	MOV  B, A
	LXI  H, 0000Eh
	DAD  D
	MOV  A, M
	ADD  A
	ADD  A
	ADD  A
	ADD  A
	PUSH PSW
	ADD  B
	MOV  B, A
	PUSH PSW
	POP  H
	MOV  A, L
	POP  H
	ORA  L
	ANI     001h
	RET
;
P_D4A3: CALL    L_D4E2	; вызов из PCHL (2)
	MVI  C, 00Ch
	CALL    L_CF5D
	LHLD    L_DE5B
	LXI  D, 00021h
	DAD  D
	PUSH H
	MOV  M, D
	INX  H
	MOV  M, D
	INX  H
	MOV  M, D
L_D4B8: CALL    L_CE99
	JZ      L_D4E0
	CALL    L_CE09
	LXI  D, 0000Fh
	CALL    L_D476
	POP  H
	PUSH H
	MOV  E, A
	MOV  A, C
	SUB  M
	INX  H
	MOV  A, B
	SBB  M
	INX  H
	MOV  A, E
	SBB  M
	JC      L_D4DA
	MOV  M, E
	DCX  H
	MOV  M, B
	DCX  H
	MOV  M, C
L_D4DA: CALL    L_CF72
	JMP     L_D4B8
;
L_D4E0: POP  H
	RET
;
L_D4E2: XRA  A
	STA     L_DEEA
	DCR  A
	STA     L_DE5D
	LHLD    L_DE5B
	MOV  A, M
	ANI     01Fh
	DCR  A
	STA     L_DEE6
	CPI     01Eh
	JNC     L_D509
	LDA     L_DE5A
	STA     L_DEEC
	MOV  A, M
	STA     L_DEEA
	ANI     0E0h
	MOV  M, A
	CALL    L_D543
L_D509: LDA     L_DE60
	LHLD    L_DE5B
	ORA  M
	MOV  M, A
	RET
;
P_D512: LXI  H, 00000h	; вызов из PCHL (2)
	SHLD    L_DEBF
	SHLD    L_DEC1
	XRA  A
	STA     L_DE5A
	LXI  H, 00080h
	SHLD    L_DE58
	CALL    L_CE87
	JMP     L_D552
;
L_D52B: LXI  H, L_DE5D
	MOV  A, M
	ORA  A
	RZ
	XRA  A
	MOV  M, A
	LHLD    L_DE5B
	MOV  M, A
	LDA     L_DEEA
	ORA  A
	RZ
	MOV  M, A
	LDA     L_DEEC
	STA     L_DEE6
L_D543: LDA     L_DEE6
L_D546: LXI  H, L_DE5A
	CMP  M
	RZ
	PUSH PSW
	MOV  A, M
	STA     L_DF0E
	POP  PSW
	MOV  M, A
L_D552: LHLD    L_DEC1
	LDA     L_DE5A
	MOV  C, A
	CALL    L_CD97
	PUSH H
	XCHG
	CALL    L_CC01
	POP  H
	CZ      L_CA87
	MOV  A, L
	RAR
	RC
	LHLD    L_DEC1
	MOV  C, L
	MOV  B, H
	CALL    L_CDB9
	SHLD    L_DEC1
	CALL    L_CF40
	MOV  B, H
	MOV  C, L
	LHLD    L_DECF
L_D57B: MVI  M, 000h
	INX  H
	DCX  B
	MOV  A, B
	ORA  C
	JNZ     L_D57B
	LHLD    L_DEDA
	XCHG
	LHLD    L_DECF
	MOV  M, E
	INX  H
	MOV  M, D
	CALL    L_CC49
	LHLD    L_DEC3
	MVI  M, 003h
	INX  H
	MVI  M, 000h
	CALL    L_CEB3
L_D59C: MVI  C, 0FFh
	CALL    L_CEA2
	CALL    L_CE99
	RZ
	CALL    L_CE09
	MVI  A, 0E5h
	CMP  M
	JZ      L_D59C
	LDA     L_DE60
	CMP  M
	JNZ     L_D5C0
	INX  H
	MOV  A, M
	SUI     024h
	JNZ     L_D5C0
	DCR  A
	STA     L_DF0F
L_D5C0: MVI  C, 001h
	CALL    L_CF08
	CALL    L_CE30
	JMP     L_D59C
;
L_D5CB: CALL    L_D679
	CALL    L_D698
	MVI  A, 009h
	JNZ     L_C88C
	LHLD    L_DE5B
	XCHG
	CALL    L_D0AC
	CALL    L_C13D
	JNZ     L_D600
	LDA     L_DEFB
	INR  A
	JZ      L_D5EF
	MVI  A, 001h
	JMP     L_C88C
;
L_D5EF: STA     L_DF0F
	CALL    L_D1D7
L_D5F5: MVI  A, 001h
	JZ      L_C88C
	CALL    L_C13D
	JZ      L_D5F5
L_D600: XRA  A
	STA     L_DF0F
	CALL    L_D71F
	LHLD    L_DEFE
	LXI  D, 0FF80h	; <<<<<<
	DAD  D
	SHLD    L_DEFE
	LDA     L_DEFB
	INR  A
	JZ      L_D622
	LXI  D, 0FF80h	; <<<<<<
	LHLD    L_DF00
	DAD  D
	SHLD    L_DF00
L_D622: LHLD    L_DEFE
	LXI  D, 00080h
	DAD  D
	SHLD    L_DEFE
	XCHG
	LHLD    L_DF00
	CALL    L_CE39
	MVI  A, 000h
	JNC     L_D64A
	CALL    L_D718
	CALL    L_D66F
	CALL    L_D52B
	LDA     L_DF0F
	ORA  A
	JZ      L_D622
	MVI  A, 002h
L_D64A: PUSH PSW
	LHLD    L_DEFE
	XCHG
	LHLD    L_DEF9
	INX  H
	INX  H
	INX  H
	MOV  M, E
	INX  H
	MOV  M, D
	CALL    L_D714
	POP  PSW
	MOV  C, A
	STA     L_DF0F
	LDA     L_DEFB
	INR  A
	RNZ
	MOV  A, C
	PUSH PSW
	CALL    L_D157
	POP  PSW
	STA     L_DF0F
	RET
;
L_D66F: LDA     L_DEFB
	INR  A
	JZ      L_D2E3
	JMP     L_D28C
;
L_D679: LHLD    L_DE5B
	SHLD    L_DEF9
	XCHG
	LXI  H, L_DEFB
	MVI  C, 007h
	CALL    L_D6DA
	LHLD    L_DEFC
	SHLD    L_DE5B
	RET
;
P_D68F: CALL    L_D679
	CALL    L_D4E2
	JMP     L_D600
;
L_D698: LHLD    L_DE5B
L_D69B: LXI  B, 0000Bh
L_D69E: INX  H
	MOV  A, M
	CPI     03Fh
	JNZ     L_D6A6
	INR  B
L_D6A6: DCR  C
	JNZ     L_D69E
	MOV  A, B
	ORA  A
	RET
;
P_D6AD: LHLD    L_DF0C
	SPHL
	LHLD    L_DE5B
	JMP     B_E212	; дисковые операции БДОС
;
P_D6B7: MVI  C, 000h	; вызов из PCHL (2)
	XCHG
	MOV  A, M
	CPI     03Fh
	JZ      L_D6CE
	CALL    L_CD62
	MOV  A, M
	CPI     03Fh
	CNZ     L_CE1D
	CALL    L_D4E2
	MVI  C, 00Fh
L_D6CE: CALL    L_CF5D
L_D6D1: LHLD    L_DEC9
	XCHG
	LHLD    L_DE58
	MVI  C, 080h
L_D6DA: INR  C
L_D6DB: DCR  C
	RZ
	LDAX D
	MOV  M, A	; отсюда обращается к 0E935h, 0E944h, 0E953h
	INX  H
	INX  D
	JMP     L_D6DB
;
P_D6E4: LHLD    L_DE63	; вызов из PCHL (2)
	SHLD    L_DE5B
	CALL    L_D4E2
L_D6ED: CALL    L_CF72
	JMP     L_D6D1
;
P_D6F3: CALL    L_D4E2	; вызов из PCHL (2)
	CALL    L_CFE3
L_D6F9: LDA     L_DEE4
	JMP     L_C88C
;
P_D6FF: CALL    L_D4E2	; вызов из PCHL (2)
	CALL    L_D05D
	JMP     L_D6F9
;
P_D708: LHLD    L_DEC1	; вызов из PCHL (2)
	JMP     L_D760
;
P_D70E: LDA     L_DE5A	; вызов из PCHL (2)
	JMP     L_C88C
;
L_D714: LHLD    L_DF02
	XCHG
L_D718: XCHG
L_D719: SHLD    L_DE58
	JMP     L_CE87
;
L_D71F: LHLD    L_DE58
	SHLD    L_DF02
	RET
;
L_D726: LHLD    L_DE58
	LXI  D, 00080h
	DAD  D
	JMP     L_D719
;
P_D730: LHLD    L_DECF	; вызов из PCHL (2)
	JMP     L_D760
;
L_D736: LXI  H, L_DEBF
	MOV  C, M
	INX  H
	MOV  B, M
	CALL    L_CDB9
	SHLD    L_DEBF
	LHLD    L_DED8
	INX  H
	XCHG
	LHLD    L_DEC3
L_D74A: MOV  M, E
	INX  H
	MOV  M, D
	RET
;
P_D74E: LHLD    L_DEBF	; вызов из PCHL (2)
	JMP     L_D760
;
L_D754: CALL    L_D4E2
	CALL    L_D098
	JMP     L_D6F9
;
L_D75D: LHLD    L_DECB
L_D760: SHLD    L_DF0F
	RET
;
P_D764: MOV  A, E	; вызов из PCHL (2)
	LXI  H, L_DE60
	CPI     0FFh
	JNZ     L_D771
	MOV  A, M
	JMP     L_C88C
;
L_D771: ANI     01Fh
	MOV  M, A
	RET
;
P_D775: CALL    L_D4E2	; вызов из PCHL (2)
	MVI  C, 0FFh
	CALL    L_D3EB
	CZ      L_D294
	RET
;
P_D781: CALL    L_D4E2	; вызов из PCHL (2)
	MVI  C, 000h
	CALL    L_D3EB
	CZ      L_D2EB
	RET
;
P_D78D: LHLD    L_DE5B	; вызов из PCHL (2)
	LXI  D, 00020h
	CALL    L_D476
	LXI  H, 00021h
	DAD  D
	MOV  M, C
	INX  H
	MOV  M, B
	INX  H
	MOV  M, A
	RET
;
L_D7A0: CALL    L_CD6A
	INR  M
	RNZ
	INX  H
	INR  M
	RNZ
	INX  H
	INR  M
	RET
;
L_D7AB: CALL    L_CD6A
	XCHG
	LXI  H, L_DFB5
L_D7B2: MVI  C, 003h
	JMP     L_D6DA
;
L_D7B7: CALL    L_CD6A
	LXI  D, L_DFB5
	JMP     L_D7B2
;
P_D7C0: LHLD    L_DE5B	; вызов из PCHL (2)
L_D7C3: MOV  A, L
	CMA
	MOV  E, A
	MOV  A, H
	CMA
	LHLD    L_DEC1
	ANA  H
	MOV  D, A
	MOV  A, L
	ANA  E
	MOV  E, A
	LHLD    L_DEBF
	XCHG
	SHLD    L_DEC1
	MOV  A, L
	ANA  E
	MOV  L, A
	MOV  A, H
	ANA  D
	MOV  H, A
	SHLD    L_DEBF
	RET
;
P_D7E1: CALL    L_D4E2	; вызов из PCHL (2)
	MVI  A, 002h
	STA     L_DEE5
	MVI  C, 000h
	CALL    L_D3EF
	CZ      L_D2EB
	RET
;
P_D7F2: MOV  A, E	; вызов из PCHL (2)
	INR  A
	STA     L_DEF9
	MOV  C, A
	LXI  H, 00001h
	CALL    L_CDB1
	CALL    L_D7C3
	LXI  H, L_DEF9
	SHLD    L_DE5B
	CALL    L_D4E2
	LHLD    L_DECF
	XCHG
	CALL    L_CF40
	LXI  B, 00000h
L_D814: LDAX D
L_D815: ORA  A
	JZ      L_D821
L_D819: RAR
	JNC     L_D819
	INX  B
	JMP     L_D815
;
L_D821: INX  D
	DCX  H
	MOV  A, L
	ORA  H
	JNZ     L_D814
	LHLD    L_DED6
	INX  H
	MOV  A, L
	SUB  C
	MOV  L, A
	MOV  A, H
	SBB  B
	MOV  H, A
	LDA     L_DED3
	MOV  C, A
	XRA  A
	CALL    L_CDB1
	XCHG
	LHLD    L_DE58
	MOV  M, E
	INX  H
	MOV  M, D
	INX  H
	MOV  M, A
	RET
;
P_D844: MOV  A, E	; вызов из PCHL (2)
	ORA  A
	JZ      L_CFDC
	CPI     081h
	JNC     L_CFDC
	STA     L_DE66
	RET
;
;
P_D852: MOV  A, E	; вызов из PCHL (2)
	STA     L_DE67
	RET
;
P_D857: XCHG		; вызов из PCHL (2)
	MOV  A, M
	CPI     063h
	RNC
	XCHG
	LXI  H, L_DE1C
	CALL    L_CE0F
	XCHG
	INX  H
	MOV  A, M
	CPI     0FEh
	JNC     L_D873
	XCHG
	MOV  E, M
	INX  H
	MOV  D, M
	XCHG
	JMP     L_D760
;
L_D873: MOV  B, A
	INX  H
	MOV  A, M
	STAX D
	INR  B
	RZ
	INX  H
	INX  D
	MOV  A, M
	STAX D
	RET
;
P_D87E: LXI  H, 00080h	; вызов из PCHL (2)
	LXI  D, L_DF15
	LXI  B, 0007Eh
L_D887: MOV  A, M
	STAX D
	ORA  A
	JZ      L_D897
	INR  B
	DCR  C
	JZ      L_DA31
	INX  H
	INX  D
	JMP     L_D887
;
L_D897: LXI  H, L_DF14
	MOV  M, B
	CALL    L_C062
	JMP     L_DA31
;
P_D8A1: LXI  H, L_DE74	; вызов из PCHL (2)
	CALL    L_D8B3
	RET
;
;
P_D8A8: LXI  H, L_DE74	; вызов из PCHL (2)
	XCHG
	CALL    L_D8B3
	LDAX D
	JMP     L_C88C
;
L_D8B3: MVI  C, 004h
	JMP     L_D6DA
;
;
P_D8B8: LXI  H, L_DE2C	; вызов из PCHL (2)
L_D8BB: MOV  A, D
	ANA  E
	INR  A
	JNZ     L_D74A
	CALL    L_CD2E
	JMP     L_D760
;
P_D8C7: LXI  H, L_DE4F	; вызов из PCHL (2)
	JMP     L_D8BB
;
P_D8CD: MOV  A, E	; вызов из PCHL (2)
	LXI  H, L_DE53
	INR  A
	JNZ     L_D8D9
	MOV  A, M
	JMP     L_C88C
;
L_D8D9: MOV  M, E
	RET
;
P_D8DB: XCHG		; вызов из PCHL (2)
	MOV  E, M
	INX  H
	MOV  D, M
	INX  H
	MOV  C, M
	INX  H
	MOV  B, M
	XCHG
L_D8E4: MOV  A, B
	ORA  C
	RZ
	PUSH H
	PUSH B
	MOV  C, M
	LDA     L_DE5F
	CPI     06Fh
	JZ      L_D8F8
	CALL    L_DC72
	JMP     L_D8FB
;
L_D8F8: CALL    L_C69C
L_D8FB: POP  B
	POP  H
	INX  H
	DCX  B
	JMP     L_D8E4
;
L_D902: LDAX D
L_D903: ORA  A
	RZ
	CPI     020h
	RC
	RZ
	CPI     03Dh
	RZ
	CPI     05Fh
	RZ
	CPI     02Eh
	RZ
	CPI     02Ch
	RZ
	CPI     03Ah
	RZ
	CPI     03Bh
	RZ
	CPI     03Ch
	RZ
	CPI     03Eh
	RZ
	ORA  A
	RET
;
L_D923: LDAX D
	ORA  A
	RZ
	CPI     020h
	JZ      L_D92E
	CPI     009h
	RNZ
L_D92E: INX  D
	JMP     L_D923
;
L_D932: MVI  A, 000h
L_D934: CALL    L_CE0F
	PUSH H
	LHLD    L_DF04
	XCHG
	CALL    L_D923
	XCHG
	SHLD    L_DF06
	XCHG
	POP  H
	PUSH H
	LDAX D
	CALL    L_C121
	SUI     040h
	MOV  B, A
	INX  D
	LDAX D
	CPI     03Ah
	JZ      L_D95A
	DCX  D
	XRA  A
	MOV  M, A
	JMP     L_D95C
;
L_D95A: MOV  M, B
	INX  D
L_D95C: MVI  B, 008h
L_D95E: CALL    L_D902
	JZ      L_D985
	JC      L_D985
	INX  H
	CPI     02Ah
	JNZ     L_D972
	MVI  M, 03Fh
	JMP     L_D974
;
L_D972: MOV  M, A
	INX  D
L_D974: DCR  B
	JNZ     L_D95E
L_D978: CALL    L_D902
	JZ      L_D98C
	JC      L_D98C
	INX  D
	JMP     L_D978
;
L_D985: INX  H
	MVI  M, 020h
	DCR  B
	JNZ     L_D985
L_D98C: MVI  B, 003h
	CPI     02Eh
	JNZ     L_D9B8
	INX  D
L_D994: CALL    L_D902
	JZ      L_D9B8
	INX  H
	CPI     02Ah
	JNZ     L_D9A5
	MVI  M, 03Fh
	JMP     L_D9A7
;
L_D9A5: MOV  M, A
	INX  D
L_D9A7: DCR  B
	JNZ     L_D994
L_D9AB: CALL    L_D902
	JZ      L_D9BF
	JC      L_D9BF
	INX  D
	JMP     L_D9AB
;
L_D9B8: INX  H
	MVI  M, 020h
	DCR  B
	JNZ     L_D9B8
L_D9BF: MVI  B, 004h
L_D9C1: INX  H
	MVI  M, 000h
	DCR  B
	JNZ     L_D9C1
	XCHG
	SHLD    L_DF04
	POP  H
	MVI  C, 00Bh
L_D9CF: INX  H
	MOV  A, M
	CPI     061h
	JC      L_D9D9
	ANI     05Fh
	MOV  M, A
L_D9D9: DCR  C
	JNZ     L_D9CF
	ORA  A
	RET
;
P_D9DF: LDAX D		; вызов из PCHL (2)
	MOV  L, A
	INX  D
	LDAX D
	MOV  H, A
	SHLD    L_DF04
	INX  D
	LDAX D
	MOV  L, A
	INX  D
	LDAX D
	MOV  H, A
	CALL    L_D932
	LHLD    L_DF04
	MOV  A, M
	ORA  A
	JMP     L_D760
;
	.db 021h	; <!> - |  ■    ■| (offset 1CF8h)
	.db 0FFh	; < > - |■■■■■■■■| (offset 1CF9h)
	.db 0FFh	; < > - |■■■■■■■■| (offset 1CFAh)
	.db 0C3h	; <├> - |■■    ■■| (offset 1CFBh)
	.db 060h	; <`> - | ■■     | (offset 1CFCh)
	.db 0D7h	; <╫> - |■■ ■ ■■■| (offset 1CFDh)
;
L_D9FE: ADD  A
	CALL    B_E215
	CALL    L_CE0F
	MOV  C, M
	INX  H
	MOV  B, M
L_DA08: LDA     L_DE53
	PUSH PSW
	MVI  A, 024h
	STA     L_DE53
	CALL    L_C703
	POP  PSW
	STA     L_DE53
	RET
;
L_DA19: LHLD    L_DEBA
	XCHG
	LHLD    L_DEBC
	MOV  B, H
	MOV  C, L
	LXI  H, 00000h
L_DA25: LDAX D
	CALL    L_CE0F
	INX  D
	DCX  B
	MOV  A, B
	ORA  C
	JNZ     L_DA25
	RET
;
; ********* Это есть главный цикл ??? ***********
L_DA31: LXI  SP,M_E176	; <<< тут меняется команда и адрес (или не меняется?)
L_DA34: LDA     L_DEBE
	ORA  A
	JZ      L_DA4D
	CALL    L_DA19
	XCHG
	LHLD    L_DEB8
	CALL    L_CE39
	MOV  A, L
	ORA  H
	JZ      L_DA4D
	CALL    L_DA94
L_DA4D: LXI  SP,M_E176	; <<<<<<
	CALL    B_E203
	CALL    L_DDB5
	DI
	MVI  A, 024h
	STA     L_DE53
	LXI  H, 00080h
	SHLD    L_DE58
	CALL    L_CE87
	MVI  A, 0C3h	; ==JMP
	STA     00005h	; << 0005: JMP ...
	LXI  H, L_C003	;
	SHLD    00001h	; << 0001: .dw L_C003
	LXI  H, L_C000	;
	SHLD    00006h	; << 0005: ... L_C000
	MOV  H, L	; HL = 0000h
	MVI  M, 021h	; << 0000: LXI H, ...
	XRA  A
	STA     M_E114	; <<<<<<
	STA     L_DE81
	INR  A
	STA     M_E117	; <<<<<<
	STA     L_DE66
	LDA     A_0004	; номер текущего диска (А=0, В=1...)
	CALL    L_D546
	EI
	CALL    L_C033
	JMP     L_DA31
; ***********************************************
;
L_DA94: MVI  A, 0C3h	; ==JMP
	STA     00005h	;
	LXI  H, L_C000	; << адрес перехода
	SHLD    00006h	; << 0005: JMP L_C000
	LXI  H, L_C430	; << адрес перехода
	SHLD    L_C000+1; << C000: JMP L_C430 
	MVI  C, 00Dh	; Сброс дисковой системы
	CALL    00005h	; <<<<<<
L_DAAA: LXI  D, L_DE01	; откуда
	LXI  H, L_DF94	; куда
	MVI  C, 010h	; сколько
	CALL    L_D6DA	; переброска
	CALL    L_DAF2
	JNZ     L_DAD3
	SHLD    L_DEBA	; записать HL
	PUSH H
	LXI  D, 00005h
	DAD  D
	MOV  C, M
	INX  H
	MOV  B, M
	POP  D
	CALL    L_DA19
	SHLD    L_DEB8
	MVI  A, 0FFh
	STA     L_DEBE
	RET
;
L_DAD3: XRA  A
	STA     L_DEBE
	RET
;
L_DAD8: XRA  A
	STA     L_DFB4
	LXI  H, 00100h	; <<<<<<
	SHLD    L_DDFD
	LXI  H, L_DDFA
	SHLD    L_DE5B
	CALL    L_D5CB
	CALL    L_D52B
	LDA     L_DF0F
	RET
;
L_DAF2: LXI  H, L_DF9D
	MOV  A, M
	CPI     020h	; <> " "?
	JNZ     L_C147	; выдаёт ошибку вида "<параметр>?"
	MVI  M, 053h	; = "S"
	INX  H
	MVI  M, 050h	; = "P"
	INX  H
	MVI  M, 052h	; = "R"
	LXI  D, L_DF94
	XRA  A
	STA     L_DFB4
	LHLD    00006h	; <<<<<< = L_C000
	MVI  L, 000h
	SHLD    L_DFB8
	XCHG
	SHLD    L_DFBA	; заносим DE=L_DF94 (сылка на имя файла)
	LXI  H, 0FF80h	; = -80h ?
	DAD  D
	SHLD    L_DFBC
	MOV  B, H
	MOV  C, L
	LHLD    L_DE58
	SHLD    L_DFBE
	CALL    L_CE93
	LHLD    L_DE5B
	SHLD    L_DFC0
	LHLD    L_DFBA
	SHLD    L_DE5B
	XCHG
	CALL    L_D0AC
	CALL    L_C13D
	JZ      L_DC0B
	LHLD    L_DFBC
	MOV  B, H
	MOV  C, L
	LHLD    L_DE58
	SHLD    L_DFBE
	CALL    L_CE93
	CALL    L_DC10
	JZ      L_DC0B
	LHLD    L_DFBC
	INX  H
	MOV  E, M
	INX  H
	MOV  D, M
	INX  H
	INX  H
	MOV  C, M
	INX  H
	MOV  B, M
	XCHG
	SHLD    L_DFC2
	DAD  B
	XCHG
	LHLD    L_DFB8
	XCHG
	XRA  A
	SUB  L
	MOV  L, A
	MVI  A, 000h
	SBB  H
	MOV  H, A
	DAD  D
	MVI  L, 000h
	SHLD    L_DFC4
	XCHG
	LXI  H, 0FF80h	; <<<<<<
	DAD  D
	SHLD    L_DFBC
	CALL    L_DC10
	JZ      L_DC0B
	LHLD    L_DFC2
	LXI  D, 0007Fh	; <<<<<<
	DAD  D
	DAD  H
	MOV  A, H
	LHLD    L_DFC4
L_DB8F: STA     L_DFC8
	SHLD    L_DFC6
	MOV  B, H
	MOV  C, L
	CALL    L_CE93
	CALL    L_DC10
	JZ      L_DC0B
	LHLD    L_DFC6
	LXI  D, 00080h	; <<<<<<
	DAD  D
	LDA     L_DFC8
	DCR  A
	JNZ     L_DB8F
	LHLD    L_DFBC
	MOV  B, H
	MOV  C, L
	CALL    L_CE93
	LHLD    L_DFC2
	MOV  C, L
	MOV  B, H
	XCHG
	LHLD    L_DFC4
	XCHG
	DAD  D
	PUSH H
	MOV  H, D
L_DBC3: MOV  A, C
	ORA  B
	JZ      L_DBF6
	DCX  B
	MOV  A, E
	ANI     007h
	JNZ     L_DBE9
	XTHL
	MOV  A, L
	ANI     07Fh
	JNZ     L_DBE5
	PUSH B
	PUSH D
	PUSH H
	CALL    L_DC10
	POP  H
	POP  D
	POP  B
	LHLD    L_DFBC
	JZ      L_DC0A
L_DBE5: MOV  A, M
	INX  H
	XTHL
	MOV  L, A
L_DBE9: MOV  A, L
	RAL
	MOV  L, A
	JNC     L_DBF2
	LDAX D
	ADD  H
	STAX D
L_DBF2: INX  D
	JMP     L_DBC3
;
L_DBF6: POP  D
L_DBF7: LHLD    L_DFBE
	MOV  B, H
	MOV  C, L
	CALL    L_CE93
	LHLD    L_DFC0
	SHLD    L_DE5B
	XRA  A
	LHLD    L_DFC4
	RET
;
L_DC0A: POP  D
L_DC0B: CALL    L_DBF7
	DCR  A
	RET
;
L_DC10: XRA  A
	STA     L_DF0F
	CALL    L_D28C
	JMP     L_C13D
;
L_DC1A: PUSH B
	CALL    B_E20F	; выдаёт некие таблицы со ссылками на буферы для дисковых операций
	POP  B
	MOV  A, L
	ORA  A
	RZ
	MOV  A, C
	STA     L_DDF0
	RET
;
L_DC27: MVI  C, 000h
L_DC29: LXI  H, L_DDF4	; Установка номера дорожки
	MOV  M, C
	RET
;
L_DC2E: LXI  H, L_DDF5	; Установка номера сектора
	MOV  M, C
	RET
;
L_DC33: MVI  B, 000h	; ПП трансляции логических секторов в физические
	XCHG
	DAD  B
	MOV  A, M	; отсюда обращается к таблице 0E962h-0E989h
	MOV  L, A
	RET
;
L_DC3A: MVI  A, 006h	; Запись сектора диска
	JMP     L_DC41
;
L_DC3F: MVI  A, 004h	; Чтение сектора диска
L_DC41: STA     L_DDF2
	MVI  C, 00Ah
L_DC46: PUSH B
	LXI  H, L_DE82
	CALL    L_DC63
	LXI  H, L_DDF0	; ссылка на описание операции
	CALL    B_E212	; дисковые операции БДОС
	PUSH PSW
	LXI  H, L_DE82
	CALL    L_DC69
	POP  PSW
	POP  B
	ORA  A
	RZ
	DCR  C
	JNZ     L_DC46
	RET
;
L_DC63: LXI  D, L_DDF0
	JMP     L_DC6D
;
L_DC69: LXI  D, L_DDF0
	XCHG
L_DC6D: MVI  C, 00Ah
	JMP     L_D6DA
;
L_DC72: LHLD    L_DE46
	JMP     L_C6BC
;
L_DC78: LHLD    L_DE46
	JMP     L_DC8F
;
L_DC7E: LXI  H, M_E06A	; <<<<<<
	LDA     M_E110	; <<<<<<
	ORA  M
	CPI     0FFh
	RET
;
L_DC88: CALL    L_DC7E
	RZ
L_DC8C: LHLD    L_DE3E
L_DC8F: LXI  D, 0000Ch
L_DC92: DAD  H
	JC      B_E206	; запрос статуса клавиатуры
	INR  D
	DCR  C
	JNZ     L_DC92
	MVI  A, 000h
	RET
;
L_DC9E: LDA     M_E110	; <<<<<<
	INR  A
	JZ      L_DD0D
	LDA     M_E06A	; <<<<<<
	INR  A
	JZ      L_DCBE
L_DCAC: LHLD    L_DE3E
L_DCAF: LXI  D, 0000Ch
L_DCB2: DAD  H
	JC      B_E209
	INR  D
	DCR  E
	JNZ     L_DCB2
	MVI  A, 01Ah
	RET
;
L_DCBE: CALL    L_DC8C
	ORA  A
	JZ      L_DCD0
	CALL    L_DCAC
	CPI     003h
	JZ      L_DD02
	CALL    L_C947
L_DCD0: LXI  H, M_E06C	; <<<<<<
	MOV  A, M
	MVI  M, 000h
	ORA  A
	JNZ     L_DD03
	LXI  H, L_DE11
	CALL    L_C98E
	MOV  L, A
	JNZ     L_DD06
	CALL    L_C931
	JNZ     L_DD03
	PUSH PSW
	LXI  H, L_DE11
	CALL    L_C98E
	LXI  H, M_E06C	; <<<<<<
	MVI  M, 01Ah
	JNZ     L_DD02
	MVI  M, 000h
	CALL    L_C931
	JZ      L_DD02
	MOV  M, A
L_DD02: POP  PSW
L_DD03: CPI     01Ah
	RNZ
L_DD06: XRA  A
	STA     M_E06A	; <<<<<<
	JMP     L_DC9E
;
L_DD0D: LXI  H, M_E111	; <<<<<<
	MOV  A, M
	CPI     080h
	JNC     L_DD1C
	CALL    L_C98E
	MOV  L, A
	ORA  A
	RNZ
L_DD1C: XRA  A
	STA     M_E110	; <<<<<<
	JMP     L_DC9E
;
L_DD23: STA     L_DDEF
	LDA     L_DE80
	INR  A
	LDA     L_DDEF
	RZ
	CALL    L_DD78
L_DD31: CALL    L_DC9E
	MOV  C, A
	MOV  L, A
	CALL    L_DC7E
	MOV  A, C
	RZ
	CALL    L_DD72
	JZ      L_DD23
	LDA     L_DE80
	INR  A
	MOV  A, C
	RZ
	CPI     040h
	RC
	LXI  H, L_DDEE
	LDA     L_DDEF
	CMP  M
	CNZ     L_DD5F
	CPI     00Eh
	MVI  A, 080h
	JZ      L_DD5C
	XRA  A
L_DD5C: ORA  C
	MOV  L, A
	RET
;
L_DD5F: MOV  A, C
	ANI     020h
	JZ      L_DD6A
	CMA
	ANA  C
	JMP     L_DD6D
;
L_DD6A: MVI  A, 020h
	ORA  C
L_DD6D: MOV  C, A
	LDA     L_DDEF
	RET
;
L_DD72: CPI     00Eh
	RZ
	CPI     00Fh
	RET
;
L_DD78: LXI  H, L_DDEE
	CMP  M
	MOV  M, A
	RZ
	PUSH B
	MOV  C, A
	CALL    L_DDA3
	POP  B
	RET
;
L_DD85: LDA     L_DE80
	INR  A
	MOV  A, C
	JZ      L_DDA3
	CALL    L_DD72
	JZ      L_DD78
	CPI     040h
	JC      L_DDA3
	RAL
	MVI  A, 00Eh
	JC      L_DDA0
	MVI  A, 00Fh
L_DDA0: CALL    L_DD78
L_DDA3: PUSH B
	MVI  D, 000h
	CALL    B_E20C
	POP  B
	LDA     M_E10E
	INR  A
	LXI  H, L_DE16
	CZ      L_CA1B
	RZ
L_DDB5: LDA     M_E10E	; <<<<<<
	INR  A
	RNZ
	LDA     L_DE60
	PUSH PSW
	LDA     M_E10F	; <<<<<<
	STA     L_DE60
	MVI  A, 0FFh
	STA     L_DE1B
	LXI  H, L_DE16
	MOV  A, M
	CPI     000h
	CNZ     L_C9BB
	XRA  A
	STA     L_DF0F
	LXI  H, M_E0ED	; <<<<<<
	SHLD    L_DE5B
	XCHG
	CALL    L_D154
	CALL    L_C13D
	XRA  A
	STA     M_E10E	; <<<<<<
	POP  PSW
	STA     L_DE60
	RET
;
	.ORG 0DDECh
L_DDEC: .db 0E5h	; <х> - |■■■  ■ ■| (offset 20ECh)
L_DDED: .db 0FFh	; < > - |■■■■■■■■| (offset 20EDh)
L_DDEE: .db 00Fh	; <_> - |    ■■■■| (offset 20EEh)
L_DDEF: .db 00Fh	; <_> - |    ■■■■| (offset 20EFh)
;
; для выполнения дисковых операций:
L_DDF0: .db 000h	; номер устройства (диска)
	.db 080h	; <А> - |■       | (offset 20F1h)
L_DDF2: .db 004h	; чтение(04h)/запись(06h)
	.db 001h	; <_> - |       ■| (offset 20F3h)
L_DDF4: .db 008h	; дорожка диска
L_DDF5: .db 001h	; сектор диска
L_DDF6: .dw 00080h	; адрес буфера для обмена с диском
;
	.db 000h	; <_> - |        | (offset 20F8h)
	.db 000h	; <_> - |        | (offset 20F9h)
L_DDFA: .db 000h	; <_> - |        | (offset 20FAh)
	.dw L_DF94
L_DDFD: .dw 00100h	; <_> - |        | (offset 20FDh)
	.db 000h	; <_> - |        | (offset 20FFh)
L_DE00:	.db 0C0h	; <└> - |■■      | (offset 2100h)
L_DE01: .db 000h	; <_> - |        | (offset 2101h)
	.db 043h	; <C> - | ■    ■■| (offset 2102h)
	.db 043h	; <C> - | ■    ■■| (offset 2103h)
	.db 050h	; <P> - | ■ ■    | (offset 2104h)
	.db 020h	; < > - |  ■     | (offset 2105h)
	.db 020h	; < > - |  ■     | (offset 2106h)
	.db 020h	; < > - |  ■     | (offset 2107h)
	.db 020h	; < > - |  ■     | (offset 2108h)
	.db 020h	; < > - |  ■     | (offset 2109h)
	.db 020h	; < > - |  ■     | (offset 210Ah)
	.db 020h	; < > - |  ■     | (offset 210Bh)
	.db 020h	; < > - |  ■     | (offset 210Ch)
	.db 000h	; <_> - |        | (offset 210Dh)
	.db 000h	; <_> - |        | (offset 210Eh)
	.db 000h	; <_> - |        | (offset 210Fh)
	.db 000h	; <_> - |        | (offset 2110h)
L_DE11: .db 000h	; <_> - |        | (offset 2111h)
	.dw L_DFC9
	.dw M_E049
L_DE16: .db 000h	; <_> - |        | (offset 2116h)
	.dw M_E06D
	.dw M_E0ED
L_DE1B: .db 000h	; <_> - |        | (offset 211Bh)
L_DE1C: .db 000h	; <_> - |        | (offset 211Ch)
	.db 000h	; <_> - |        | (offset 211Dh)
	.db 000h	; <_> - |        | (offset 211Eh)
	.db 000h	; <_> - |        | (offset 211Fh)
	.db 000h	; <_> - |        | (offset 2120h)
L_DE21: .db 031h	; <1> - |  ■■   ■| (offset 2121h)
	.db 000h	; <_> - |        | (offset 2122h)
	.db 000h	; <_> - |        | (offset 2123h)
	.db 000h	; <_> - |        | (offset 2124h)
	.db 000h	; <_> - |        | (offset 2125h)
	.db 000h	; <_> - |        | (offset 2126h)
	.db 000h	; <_> - |        | (offset 2127h)
	.db 000h	; <_> - |        | (offset 2128h)
	.db 000h	; <_> - |        | (offset 2129h)
	.db 000h	; <_> - |        | (offset 212Ah)
	.db 000h	; <_> - |        | (offset 212Bh)
L_DE2C: .db 000h	; <_> - |        | (offset 212Ch)
L_DE2D: .db 000h	; <_> - |        | (offset 212Dh)
	.db 000h	; <_> - |        | (offset 212Eh)
	.db 000h	; <_> - |        | (offset 212Fh)
	.db 000h	; <_> - |        | (offset 2130h)
	.db 000h	; <_> - |        | (offset 2131h)
	.db 000h	; <_> - |        | (offset 2132h)
	.db 000h	; <_> - |        | (offset 2133h)
	.db 000h	; <_> - |        | (offset 2134h)
	.db 000h	; <_> - |        | (offset 2135h)
	.db 050h	; <P> - | ■ ■    | (offset 2136h)
L_DE37: .db 000h	; <_> - |        | (offset 2137h)
	.db 019h	; <_> - |   ■■  ■| (offset 2138h)
	.db 000h	; <_> - |        | (offset 2139h)
	.db 000h	; <_> - |        | (offset 213Ah)
	.db 000h	; <_> - |        | (offset 213Bh)
	.db 000h	; <_> - |        | (offset 213Ch)
	.db 000h	; <_> - |        | (offset 213Dh)
L_DE3E: .dw 08000h
	.db 000h	; <_> - |        | (offset 2140h)
	.db 080h	; <А> - |■       | (offset 2141h)
L_DE42: .dw 02000h
L_DE44: .dw 02000h
L_DE46: .dw 04000h
	.db 000h	; <_> - |        | (offset 2148h)
	.db 000h	; <_> - |        | (offset 2149h)
	.db 000h	; <_> - |        | (offset 214Ah)
	.db 000h	; <_> - |        | (offset 214Bh)
	.db 000h	; <_> - |        | (offset 214Ch)
	.db 000h	; <_> - |        | (offset 214Dh)
	.db 000h	; <_> - |        | (offset 214Eh)
L_DE4F: .db 000h	; <_> - |        | (offset 214Fh)
	.db 000h	; <_> - |        | (offset 2150h)
	.db 000h	; <_> - |        | (offset 2151h)
	.db 000h	; <_> - |        | (offset 2152h)
L_DE53: .db 024h	; <$> - |  ■  ■  | (offset 2153h)
L_DE54: .db 000h	; <_> - |        | (offset 2154h)
	.db 000h	; <_> - |        | (offset 2155h)
	.dw L_DE1C
L_DE58: .dw L_DE00
L_DE5A: .db 000h	; <_> - |        | (offset 215Ah)
L_DE5B: .dw A_005C
L_DE5D: .db 0FFh	; тип команды, выполняемой по CALL 5
	.db 000h	; <_> - |        | (offset 215Eh)
L_DE5F: .db 015h	; <_> - |   ■ ■ ■| (offset 215Fh)
L_DE60: .db 000h	; <_> - |        | (offset 2160h)
L_DE61: .dw 00010h
L_DE63: .dw L_DDEC
	.db 000h	; <_> - |        | (offset 2165h)
L_DE66: .db 001h	; <_> - |       ■| (offset 2166h)
L_DE67: .db 000h	; <_> - |        | (offset 2167h)
	.db 000h
	.END
