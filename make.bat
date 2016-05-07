@echo off
SET ENTRY=main
SET INCLUDELIBS="Kernel32.lib user32.lib"
SET ASEMBLER=ML.exe
SET ASEMBLERPARAM="/c /coff /Zi /Fl"
SET LINKER=LINK.exe
SET LINKERPARAM="/debug /subsystem:console /entry:%ENTRY% /out:%ENTRY%.exe %INCLUDELIBS%"

REM submodule sentiment_analysis
sentiment_analysis/make.bat
