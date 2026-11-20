	.ORG    00100h
	#include "equates.inc"
;
;	#DEFINE L_MDOS L_01FF+1		; >>>> 0BE00h (банк 0 как ОЗУ A000-DFFFh)
	#DEFINE L_BDOS L_MDOS+LenMDOS	; >>>> 0E200h
	#DEFINE L_BIOS L_BDOS+LenBDOS	; >>>> 0EF00h
;
	#DEFINE B_E221 0E221h	; отключение второго КД в БСВВ
	#DEFINE D_FFC9 0FFC9h	; количество дисков в системе
;
	#DEFINE UNPACK LZO28_Decompress
;
L_0100: DI
	XRA     A
	OUT     010h	; отключаем КД10, если он вдруг был подключён
	OUT     011h	; и отключаем КД11
	LXI  SP,00100h
	LXI  H, L_BIOS	; откуда (L_2C00)
	LXI  D, S_FONT	; куда (0EF00h-0FFFFh)
	CALL    UNPACK	; переброска (это шрифт и БСВВ)
	LXI  H,	0A001h	; проверка наличия квази-диска 11
	MOV  D,	M	; считываем байт из памяти
	MVI  A,	23h	; 0010 0011b -- банк 0 как ОЗУ A000-DFFFh
	OUT	011h	; на КД11
	MOV  A,	D
	CMA		; инвертируем А
	MOV  M,	A	; пишем инвертированную метку на КД2 (или память, если его нет)
	XRA  A
	OUT	011h	; отключаем второй КД
	MOV  A,	M	; считываем байт
	XRA  D		; проверяем...
	MOV  M,	D	; восстанавливаем значение в памяти (на всякий случай)
	MVI  A, 004h	; число дисков
	PUSH PSW	; сохраняем в стек флаги
	CALL    0F800h	; настройка БСВВ: включение КД + прерывания
	LXI  H, L_MDOS	; откуда (L_0200)
	LXI  D, S_MDOS	; куда (0BE00h-DFFFh)(банк 0 как ОЗУ A000-DFFFh)
	CALL    UNPACK	; переброска (это МикроДОС)
;;	INX  H		;<LXI  H, L_BDOS	; откуда (L_2400)
	LXI  D, S_BDOS	; куда (0E200h-0E9FFh)
	CALL    UNPACK	; переброска (это БДОС)
	MVI  A, 0C3h	; JMP ...
	STA     00000h	; по адресу 0000
	STA     00005h	; и по адресу 0005
	LXI  H, 0F800h
	SHLD    00001h	; ... 0D800h ???????
	LXI  H, 0C000h
	SHLD    00006h	; ... 0C000h
	EI
	POP  PSW	; считываем из стека результат проверки второго КД
;	MVI  A, 004h	; число дисков
	CNZ     B_E221	; отключаем второй КД в БДОС, если он не найден
	STA	D_FFC9	; конфигурация для CO (3 или 4)
L_015X:	MVI  C, 01Fh	; = очистить экран
	CALL    0F809h	; вывод символа на экран ----
	MVI  A, 081h
	OUT     004h
	IN      001h
	ANI     040h
	CZ      0E21Bh	; форматирование КД ----
	JMP     S_MDOS	; ========>>>>>>>>>>>>
;
	#include "LZO28.asm"
;
L_MDOS:	.END
