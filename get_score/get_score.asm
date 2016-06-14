INCLUDE crt.inc
INCLUDE tokenization.inc
INCLUDE get_score.inc
INCLUDE miglib.inc

.data
emoDB DB "emo.ini", 0
listnewfailedmsg DB "TokenListNew Failed", 0
happinessStr DB "happiness", 0
angerStr DB "anger", 0
sadnessStr DB "sadness", 0
fearStr DB "fear", 0
disgustStr DB "disgust", 0

.code

GetEmoScore PROC input : DWORD, emo : DWORD
	LOCAL counter
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
	INVOKE TokenListCursorNew, eax
	mov edi, eax
	INVOKE TokenListCursorGetItem, edi
	mov ebx, eax
	.WHILE ebx != 0
		mov eax, [ebx].TOKEN.tokWord
		push eax
		INVOKE HappinessScore, eax
		push eax
		INVOKE AddScore, esp, [emo].EMOTION.happiness, [emo].EMOTION.happiness
		add esp, 4
		INVOKE AngerScore, eax
		push eax
		INVOKE AddScore, esp, [emo].EMOTION.anger, [emo].EMOTION.anger
		add esp, 4
		INVOKE SadnessScore, eax
		push eax
		INVOKE AddScore, esp, [emo].EMOTION.sadness, [emo].EMOTION.sadness
		add esp, 4
		INVOKE FearScore, eax
		push eax
		INVOKE AddScore, esp, [emo].EMOTION.fear, [emo].EMOTION.fear
		add esp, 4
		INVOKE DisgustScore, eax
		push eax
		INVOKE AddScore, esp, [emo].EMOTION.disgust, [emo].EMOTION.disgust
		add esp, 8	;also pops out tokWrod
		inc counter
		INVOKE TokenListCursorNext, edi
		INVOKE TokenListCursorGetItem, edi
		mov ebx, eax
	
	.ENDW
GetEmoScore ENDP
;;; input1, input2, output can be aliases, does not affect the result of the function
AddScore PROC input1 : DWORD, input2 : DWORD, output : DWORD
	fld REAL4 PTR [input1]
	fadd REAL4 PTR [input2]
	fst REAL4 ptr [output]
	
	;movss xmm0, input1
	;mulss xmm0, input2
	;movd eax, xmm0
AddScore ENDP	
	
HappinessScore PROC USES ebx, input : DWORD
	INVOKE malloc, 1024
	mov ebx, eax
	INVOKE GetPrivateProfileString, input, ADDR happinessStr, 0, ebx, 1023, emoDB
	.IF eax != 0
		INVOKE atof, ebx
		mov edi, eax
		INVOKE free, ebx
		mov eax, edi
		ret
	.ELSE
		INVOKE free, ebx
		mov eax, 0
		ret
	.ENDIF
HappinessScore ENDP

AngerScore PROC USES ebx, input : DWORD
	INVOKE malloc, 1024
	mov ebx, eax
	INVOKE GetPrivateProfileString, input, angerStr, 0, ebx, 1023, emoDB
	.IF eax != 0
		INVOKE atof, ebx
		mov edi, eax
		INVOKE free, ebx
		mov eax, edi
		ret
	.ELSE
		INVOKE free, ebx
		mov eax, 0
		ret
	.ENDIF
AngerScore ENDP

SadnessScore PROC USES ebx, input : DWORD
	INVOKE malloc, 1024
	mov ebx, eax
	INVOKE GetPrivateProfileString, input, sadnessStr, 0, ebx, 1023, emoDB
	.IF eax != 0
		INVOKE atof, ebx
		mov edi, eax
		INVOKE free, ebx
		mov eax, edi
		ret
	.ELSE
		INVOKE free, ebx
		mov eax, 0
		ret
	.ENDIF
SadnessScore ENDP

FearScore PROC USES ebx, input : DWORD
	INVOKE malloc, 1024
	mov ebx, eax
	INVOKE GetPrivateProfileString, input, fearStr, 0, ebx, 1023, emoDB
	.IF eax != 0
		INVOKE atof, ebx
		mov edi, eax
		INVOKE free, ebx
		mov eax, edi
		ret
	.ELSE
		INVOKE free, ebx
		mov eax, 0
		ret
	.ENDIF
FearScore ENDP

DisgustScore PROC USES ebx, input : DWORD
	INVOKE malloc, 1024
	mov ebx, eax
	INVOKE GetPrivateProfileString, input, disgustStr, 0, ebx, 1023, emoDB
	.IF eax != 0
		INVOKE atof, ebx
		mov edi, eax
		INVOKE free, ebx
		mov eax, edi
		ret
	.ELSE
		INVOKE free, ebx
		mov eax, 0
		ret
	.ENDIF
DisgustScore ENDP

END
