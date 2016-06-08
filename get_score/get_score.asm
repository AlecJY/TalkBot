INCLUDE crt.inc
.data
emoDB DB "emo.ini", 0
.code

HappinessScore PROC USES ebx, input : DWORD
	INVOKE malloc, 1024
	mov ebx, eax
	INVOKE GetPrivateProfileString, input, "happiness", 0, eax, 1023, emoDB
	.IF eax != 0
		INVOKE atof, ebx
		mov edi, eax
		INVOKE free, ebx
		mov eax, edi
		ret
	.ELSE
		INFOKE free, ebx
		mov eax, 0
		ret
	.ENDIF
HappinessScore ENDP

AngerScore PROC USES ebx, input : DWORD
	INVOKE malloc, 1024
	mov ebx, eax
	INVOKE GetPrivateProfileString, input, "anger", 0, eax, 1023, emoDB
	.IF eax != 0
		INVOKE atof, ebx
		mov edi, eax
		INVOKE free, ebx
		mov eax, edi
		ret
	.ELSE
		INFOKE free, ebx
		mov eax, 0
		ret
	.ENDIF
AngerScore ENDP

SadnessScore PROC USES ebx, input : DWORD
	INVOKE malloc, 1024
	mov ebx, eax
	INVOKE GetPrivateProfileString, input, "sadness", 0, eax, 1023, emoDB
	.IF eax != 0
		INVOKE atof, ebx
		mov edi, eax
		INVOKE free, ebx
		mov eax, edi
		ret
	.ELSE
		INFOKE free, ebx
		mov eax, 0
		ret
	.ENDIF
SadnessScore ENDP

FearScore PROC USES ebx, input : DWORD
	INVOKE malloc, 1024
	mov ebx, eax
	INVOKE GetPrivateProfileString, input, "fear", 0, eax, 1023, emoDB
	.IF eax != 0
		INVOKE atof, ebx
		mov edi, eax
		INVOKE free, ebx
		mov eax, edi
		ret
	.ELSE
		INFOKE free, ebx
		mov eax, 0
		ret
	.ENDIF
FearScore ENDP

DisgustScore PROC USES ebx, input : DWORD
	INVOKE malloc, 1024
	mov ebx, eax
	INVOKE GetPrivateProfileString, input, "disgust", 0, eax, 1023, emoDB
	.IF eax != 0
		INVOKE atof, ebx
		mov edi, eax
		INVOKE free, ebx
		mov eax, edi
		ret
	.ELSE
		INFOKE free, ebx
		mov eax, 0
		ret
	.ENDIF
DisgustScore ENDP

