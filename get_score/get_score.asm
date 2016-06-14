.386
INCLUDE crt.inc
INCLUDE tokenization.inc
INCLUDE get_score.inc
INCLUDE miglib.inc

.data
emoDB DB ".\emo.ini", 0
listnewfailedmsg DB "TokenListNew Failed", 0
happinessStr DB "happiness", 0
angerStr DB "anger", 0
sadnessStr DB "sadness", 0
fearStr DB "fear", 0
disgustStr DB "disgust", 0
CRLF BYTE 0dh, 0ah, 0

.code

GetEmoScore PROC input : DWORD, emo : DWORD
	LOCAL counter, score
	int 3
	mov counter, 0
	INVOKE memset, emo, 0, SIZEOF EMOTION
	INVOKE TokenListNew
	push eax
	.IF eax != 0
		INVOKE Tokenize, eax, input
	.ELSE
		pop eax
		INVOKE printf, ADDR listnewfailedmsg
		INVOKE exit, 0
	.ENDIF
	pop eax
	push eax
	INVOKE TokenListCursorNew, eax
	mov edi, eax 		; save cursor in edi
	INVOKE TokenListCursorGetItem, edi
	mov ebx, eax
	.WHILE ebx != 0
		INVOKE PrintToken, ebx
		INVOKE printf, ADDR CRLF
		INVOKE TokenListCursorNext, edi
		INVOKE TokenListCursorGetItem, edi
		mov ebx, eax
	.ENDW
	pop eax
	INVOKE TokenListCursorNew, eax
	mov edi, eax
	INVOKE TokenListCursorGetItem, edi
	mov esi, emo
	mov ebx, eax
	.WHILE ebx != 0
		mov eax, [ebx].TOKEN.tokWord
		push eax
		INVOKE HappinessScore, eax
		mov score, eax
		INVOKE AddScore, score, ADDR [esi].EMOTION.happiness, ADDR [esi].EMOTION.happiness
		INVOKE AngerScore, eax
		mov score, eax
		INVOKE AddScore, score, ADDR [esi].EMOTION.anger, ADDR [esi].EMOTION.anger
		INVOKE SadnessScore, eax
		mov score, eax
		INVOKE AddScore, score, ADDR [esi].EMOTION.sadness, ADDR [esi].EMOTION.sadness
		INVOKE FearScore, eax
		mov score, eax
		INVOKE AddScore, score, ADDR [esi].EMOTION.fear, ADDR [esi].EMOTION.fear
		INVOKE DisgustScore, eax
		mov score, eax
		INVOKE AddScore, score, ADDR [esi].EMOTION.disgust, ADDR [esi].EMOTION.disgust
		add esp, 4	;also pops out tokWrod
		inc counter
		INVOKE TokenListCursorNext, edi
		INVOKE TokenListCursorGetItem, edi
		mov ebx, eax
	
	.ENDW
	INVOKE Average, emo, counter
	ret
GetEmoScore ENDP
;;; input1, input2, output can be aliases, does not affect the result of the function
AddScore PROC input1 : DWORD, input2 : DWORD, output : DWORD
	fld REAL4 PTR [input1]
	fadd REAL4 PTR [input2]
	fstp REAL4 PTR [output]
	ret
AddScore ENDP

Average PROC input : DWORD, count : DWORD
	push count
	mov eax, input
	fld  REAL4 PTR [eax].EMOTION.happiness
	fidiv DWORD PTR [esp]
	fstp REAL4 PTR [eax].EMOTION.happiness
	
	fld REAL4 PTR [eax].EMOTION.anger
	fidiv DWORD PTR [esp]
	fstp REAL4 PTR [eax].EMOTION.anger
	
	fld REAL4 PTR [eax].EMOTION.sadness
	fidiv DWORD PTR [esp]
	fstp REAL4 PTR [eax].EMOTION.sadness
	
	fld REAL4 PTR [eax].EMOTION.fear
	fidiv DWORD PTR [esp]
	fstp REAL4 PTR [eax].EMOTION.fear
	
	fld REAL4 PTR [eax].EMOTION.disgust
	fidiv DWORD PTR [esp]
	fstp REAL4 PTR [eax].EMOTION.disgust
	
	pop count
	ret
Average ENDP	
	
HappinessScore PROC USES ebx edi, input : DWORD
	INVOKE malloc, 1024
	mov ebx, eax
	INVOKE GetPrivateProfileString, input, ADDR happinessStr, 0, ebx, 1023, ADDR emoDB
	.IF eax != 0
		INVOKE atof, ebx
		sub esp, 4
		fstp REAL4 PTR [esp]
		INVOKE free, ebx
		pop eax
		ret
	.ELSE
		INVOKE free, ebx
		mov eax, 0
		ret
	.ENDIF
HappinessScore ENDP

AngerScore PROC USES ebx edi, input : DWORD
	INVOKE malloc, 1024
	mov ebx, eax
	INVOKE GetPrivateProfileString, input, ADDR angerStr, 0, ebx, 1023, ADDR emoDB
	.IF eax != 0
		INVOKE atof, ebx
		sub esp, 4
		fstp REAL4 PTR [esp]
		INVOKE free, ebx
		pop eax
		ret
	.ELSE
		INVOKE free, ebx
		mov eax, 0
		ret
	.ENDIF
AngerScore ENDP

SadnessScore PROC USES ebx edi, input : DWORD
	INVOKE malloc, 1024
	mov ebx, eax
	INVOKE GetPrivateProfileString, input, ADDR sadnessStr, 0, ebx, 1023, ADDR emoDB
	.IF eax != 0
		INVOKE atof, ebx
		sub esp, 4
		fstp REAL4 PTR [esp]
		INVOKE free, ebx
		pop eax
		ret
	.ELSE
		INVOKE free, ebx
		mov eax, 0
		ret
	.ENDIF
SadnessScore ENDP

FearScore PROC USES ebx edi, input : DWORD
	INVOKE malloc, 1024
	mov ebx, eax
	INVOKE GetPrivateProfileString, input, ADDR fearStr, 0, ebx, 1023, ADDR emoDB
	.IF eax != 0
		INVOKE atof, ebx
		sub esp, 4
		fstp REAL4 PTR [esp]
		INVOKE free, ebx
		pop eax
		ret
	.ELSE
		INVOKE free, ebx
		mov eax, 0
		ret
	.ENDIF
FearScore ENDP

DisgustScore PROC USES ebx edi, input : DWORD
	INVOKE malloc, 1024
	mov ebx, eax
	INVOKE GetPrivateProfileString, input, ADDR disgustStr, 0, ebx, 1023, ADDR emoDB
	.IF eax != 0
		INVOKE atof, ebx
		sub esp, 4
		fstp REAL4 PTR [esp]
		INVOKE free, ebx
		pop eax
		ret
	.ELSE
		INVOKE free, ebx
		mov eax, 0
		ret
	.ENDIF
DisgustScore ENDP

END
