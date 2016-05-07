@echo off
SET TOOLKITPATH=%1
SET ENTRY=main
SET INCLUDELIBS=Kernel32.lib user32.lib
SET ASSEMBLER=%TOOLKITPATH%ML.exe
SET ASSEMBLERPARAM=/c /coff /Zi /Fl
SET LINKER=%TOOLKITPATH%LINK.exe
SET LINKERPARAM=/debug /subsystem:console /entry:%ENTRY% /out:%ENTRY%.exe %INCLUDELIBS%
SET COMPILEPATH=%~dp0
SET OUTPUTPATH=%~dp0
echo submodule tokenization
tokenization/make.bat
echo submodule sentiment_analysis
sentiment_analysis/make.bat
