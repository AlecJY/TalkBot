@echo off
SET COMPILEPATH=%~dp0
SET OUTPUTPATH=%~dp0
SET TOOLKITPATH=%COMPILEPATH%\bin
SET ENTRY=talkbot
SET TESTENTRY=test_main
SET INCLUDELIBS=Kernel32.lib user32.lib msvcrt.lib miglib.lib
SET ASSEMBLER=%TOOLKITPATH%\ML.exe
SET ASSEMBLERPARAM=/c /coff /Zi /Zf /Fl
SET LINKER=%TOOLKITPATH%\LINK.exe
SET LINKERPARAM=/debug /subsystem:console /entry:main /out:%ENTRY%.exe /LIBPATH:%TOOLKITPATH% /LIBPATH:%COMPILEPATH%\lib %INCLUDELIBS%
SET TESTLINKERPARAM=/debug /subsystem:console /entry:%TESTENTRY% /out:%TESTENTRY%.exe /LIBPATH:%TOOLKITPATH% /LIBPATH:%COMPILEPATH%\lib %INCLUDELIBS%
SET COMMONINCLUDE=/I%COMPILEPATH%\common
if exist %ENTRY%.obj del %ENTRY%.obj
if exist %ENTRY%.exe del %ENTRY%.exe
if exist %ENTRY%.lst del %ENTRY%.lst
if exist %ENTRY%.ilk del %ENTRY%.ilk
if exist %ENTRY%.pdb del %ENTRY%.pdb
echo submodule tokenization
cmd /C tokenization\make.bat
echo submoudle get_score
cmd /C get_score\make.bat
echo submodule asciiart
cmd /C asciiart\make.bat
echo submodule fuzzySystem
cmd /C fuzzySystem\make.bat
echo Running main
cmd /C socket\make.bat
