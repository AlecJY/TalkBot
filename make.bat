@echo off
SET TOOLKITPATH=%1
SET COMPILEPATH=%~dp0
SET OUTPUTPATH=%~dp0
SET ENTRY=talkbot
SET TESTENTRY=test_main
SET INCLUDELIBS=Kernel32.lib user32.lib msvcrt.lib miglib.lib
SET ASSEMBLER=%TOOLKITPATH%\ML.exe
SET ASSEMBLERPARAM=/c /coff /Zi /Fl
SET LINKER=%TOOLKITPATH%\LINK.exe
SET LINKERPARAM=/debug /subsystem:console /entry:main /out:%ENTRY%.exe /LIBPATH:%TOOLKITPATH% /LIBPATH:%COMPILEPATH%\lib %INCLUDELIBS%
SET TESTLINKERPARAM=/debug /subsystem:console /entry:main /out:%TESTENTRY%.exe /LIBPATH:%TOOLKITPATH% /LIBPATH:%COMPILEPATH%\lib %INCLUDELIBS%
SET COMMONINCLUDE=/I%COMPILEPATH%\common
echo submodule tokenization
cmd /C tokenization\make.bat
echo submoudle get_score
cmd /C get_score\make.bat
echo submodule asciiart
cmd /C asciiart\make.bat
echo Running main
cmd /C socket\make.bat
