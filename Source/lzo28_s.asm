;LZO28 fast stack unpacker for 8080, Ivan Gorodetsky 
;v3 2026-11-25 118-140 bytes
;
; lxi b,SrcAdr
; lxi d,DestAdr
; call LZO28_Decompress
;

;option -s
;#define SHORT_LEN
;option -w
;#define SHORT_WIN

LZO28_Decompress:
#ifndef SHORT_WIN
        lxi     h, 0FFFFh
        shld    LZO28_CopyLink+1
        inx     h
#else
        mvi     a, 0FFh
        sta     LZO28_CopyLink+1
        lxi     h, 0
#endif
        dad     sp
        shld    LZO28_SetSP+1
        mov     l, c
        mov     h, b
;;        di
        sphl
LZO28_MainLoop:
        xchg
        pop     b
        dcx     sp
        mvi     a, 00000111b
        ana     c
        jz      LZO28_Link
        dcr     a
        jnz     LZO28_LitCopy
LZO28_LitLong:
        pop     d
        dcx     sp
        ora     e
        jnz     LZO28_LitCopy
        stc
LZO28_LitCopy:
        rar
        jnc     LZO28_LDIR1
        pop     d
        dcx     sp
        mov     m, e
        inx     h
        ora     a
        jz      LZO28_Link
LZO28_LDIR1:
        pop     d
        mov     m, e
        inx     h
        mov     m, d
        inx     h
        dcr     a
        jnz     LZO28_LDIR1
LZO28_Link:
        mvi     a, 01111000b
        ana     c
#ifdef SHORT_LEN
        jnz     LZO28_SkipExit
LZO28_SetSP:
        lxi     sp, 0
;;        ei
        ret
LZO28_SkipExit:
#endif
        rrc
        rrc
        rrc
#ifndef SHORT_LEN
        jnz     LZO28_ReadOff
        pop     d
        dcx     sp
        ora     e
        jnz     LZO28_ReadOff
LZO28_SetSP:
        lxi     sp, 0
;;        ei
        ret
LZO28_ReadOff:
#endif
        mov     b, a
        xra     a
        ora     c
        xchg
        jm      LZO28_CopyLink
        pop     h
        dcx     sp
#ifndef SHORT_WIN
        xra     a
        ora     l
        jp      LZO28_FarOff
#endif
LZO28_ShortOff:
#ifdef SHORT_WIN
        mov     a, l
        sta     LZO28_CopyLink+1
#else
        mvi     h, 0FFh
        shld    LZO28_CopyLink+1
#endif
LZO28_CopyLink:
        lxi     h, 0FFFFh
        dad     d
        xra     a
        ora     b
        rar
        mov     b, a
        jnc     LZO28_LDIR2
        ora     a
        mov     a, m
        stax    d
        inx     h
        inx     d
        jz      LZO28_MainLoop
LZO28_LDIR2:
        mov     a, m
        stax    d
        inx     h
        inx     d
        mov     a, m
        stax    d
        inx     h
        inx     d
        dcr     b
        jnz     LZO28_LDIR2
        jmp     LZO28_MainLoop
#ifndef SHORT_WIN
LZO28_FarOff:
        ori     80h
        pop     h
        dcx     sp
        mov     h, a
        shld    LZO28_CopyLink+1
        jmp     LZO28_CopyLink+3
#endif
