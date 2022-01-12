@echo off
set TASMTABS=D:\Work\~TASM
set TASMOPTS=-85 -b
tasm os-t72hl.asm
if ERRORLEVEL 1 pause
tasm _BE00h.asm
if ERRORLEVEL 1 pause
lzsa -f1 -r _BE00h.obj _BE00h.pak
tasm _E200h.asm
if ERRORLEVEL 1 pause
lzsa -f1 -r _E200h.obj _E200h.pak
tasm _F600h.asm
if ERRORLEVEL 1 pause
lzsa -f1 -r _F600h.obj _F600h.pak
copy /b os-t72hl.obj+_BE00h.pak+_E200h.pak+_F600h.pak os-t72hp.rom