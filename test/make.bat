@echo off
echo testing tokenization
%ASSEMBLER% %ASSEMBLERPARAM% %COMMONINCLUDE% /I%COMPILEPATH%tokenization\ %COMPILEPATH%test\test_tokenization.asm
%LINKER% %LINKERPARAMTEST% %TESTLINKERPARAM% test_tokenization.obj tokenization.obj
