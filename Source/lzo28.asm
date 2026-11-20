;LZO28 unpacker for 8080, 70-92 bytes
;Ivan Gorodetsky 2026-11-19
;
; lxi h,SrcAdr
; lxi d,DestAdr
; call LZO28_Decompress
;

;option -r
;#define BACKWARD
;option -w
;#define SHORT_WIN

#ifdef BACKWARD
#define NEXT_HL dcx h
#define NEXT_DE dcx d
#define OFF_2B 0000h
#define OFF_HI_1B 00h
#else
#define NEXT_HL inx h
#define NEXT_DE inx d
#define OFF_2B 0FFFFh
#define OFF_HI_1B 0FFh
#endif

LZO28_Decompress:
#ifdef BACKWARD
        xra     a
#else
        mvi     a, OFF_HI_1B
#endif
        sta     LZO28_CopyLink+2
#ifndef SHORT_WIN
        sta     LZO28_CopyLink+3
#endif
LZO28_MainLoop:
        mov     c, m
        NEXT_HL
        mvi     a, 00000111b
        ana     c
        jz      LZO28_Link
        dcr     a
        jz      LZO28_LitLong
        mov     b, a
        .db     0CAh
LZO28_LitLong:
        mov     b, m
        NEXT_HL
LZO28_LitCopy:
LZO28_LDIR1:
        mov     a, m
        stax    d
        NEXT_HL
        NEXT_DE
        dcr     b
        jnz     LZO28_LDIR1
LZO28_Link:
        mvi     a, 01111000b
        ana     c
        rrc
        rrc
        rrc
        jnz     LZO28_ReadOff
        mov     a, m
        NEXT_HL
        ora     a
        rz
LZO28_ReadOff:
        mov     b, a
        xra     a
        ora     c
        jm      LZO28_CopyLink
#ifndef SHORT_WIN
        mvi     a, OFF_HI_1B
        sta     LZO28_CopyLink+3
        mov     a, m
        NEXT_HL
        ora     a
#ifdef BACKWARD
        jm      LZO28_FarOff
#else
        jp      LZO28_FarOff
#endif
#else
        mov     a, m
        NEXT_HL
#endif
LZO28_ShortOff:
        sta     LZO28_CopyLink+2
LZO28_CopyLink:
        push    h
        lxi     h, OFF_2B
#ifdef BACKWARD
        inx     h
#endif
        dad     d
LZO28_LDIR2:
        mov     a, m
        stax    d
        NEXT_HL
        NEXT_DE
        dcr     b
        jnz     LZO28_LDIR2
        pop     h
        jmp     LZO28_MainLoop

#ifndef SHORT_WIN
LZO28_FarOff:
#ifdef BACKWARD
        ani     7Fh
#else
        ori     80h
#endif
        sta     LZO28_CopyLink+3
        mov     a, m
        NEXT_HL
        jmp     LZO28_ShortOff
#endif
