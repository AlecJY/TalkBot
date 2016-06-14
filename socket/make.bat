@echo off
%ASSEMBLER% %ASSEMBLERPARAM% %COMMONINCLUDE% /I%COMPILEPATH%\socket\ /I%COMPILEPATH%\asciiart\ %COMPILEPATH%\socket\socket.asm 
%LINKER% %LINKERPARAMTEST% %TESTLINKERPARAM% socket.obj asciiart.obj tokenization.obj