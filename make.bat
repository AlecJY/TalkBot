@echo off
SET TOOLKITPATH=%1
SET ENTRY=main
SET TESTENTRY=test_main
SET INCLUDELIBS=Kernel32.lib user32.lib msvcrt1.lib
SET ASSEMBLER=%TOOLKITPATH%\ML.exe
SET ASSEMBLERPARAM=/c /coff /Zi /Fl
SET LINKER=%TOOLKITPATH%\LINK.exe
SET LINKERPARAM=/debug /subsystem:console /entry:%ENTRY% /out:%ENTRY%.exe /LIBPATH:%TOOLKITPATH% %INCLUDELIBS%
SET TESTLINKERPARAM=/debug /subsystem:console /entry:%TESTENTRY% /out:%TESTENTRY%.exe /LIBPATH:%TOOLKITPATH% %INCLUDELIBS%
SET COMPILEPATH=%~dp0
SET OUTPUTPATH=%~dp0
SET COMMONINCLUDE=/I%COMPILEPATH%\common
echo submodule tokenization
cmd /C tokenization\make.bat
echo submodule sentiment_analysis
cmd /C sentiment_analysis\make.bat
echo submoudle get_score
cmd /C get_score\make.bat
echo Running tests
cmd /C test\make.bat
