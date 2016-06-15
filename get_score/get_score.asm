.386
INCLUDE crt.inc
INCLUDE tokenization.inc
INCLUDE get_score.inc
INCLUDE miglib.inc
INCLUDE emodata.inc

.data
emoDB DB "C:\msys64\home\Alec\TalkBot\emo.ini", 0
listnewfailedmsg DB "TokenListNew Failed", 0
happinessStr DB "happiness", 0
angerStr DB "anger", 0
sadnessStr DB "sadness", 0
fearStr DB "fear", 0
disgustStr DB "disgust", 0
CRLF BYTE 0dh, 0ah, 0

.code

GetEmoScore PROC USES ebx edi esi, input : DWORD, emo : DWORD
	LOCAL counter, score
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
		.IF eax == 0
			jmp cont
		.ENDIF
		mov score, eax
		INVOKE AddScore, ADDR score, ADDR [esi].EMOTION.happiness, ADDR [esi].EMOTION.happiness
		mov eax, [esp]
		INVOKE AngerScore, eax
		mov score, eax
		INVOKE AddScore, ADDR score, ADDR [esi].EMOTION.anger, ADDR [esi].EMOTION.anger
		mov eax, [esp]
		INVOKE SadnessScore, eax
		mov score, eax
		INVOKE AddScore, ADDR score, ADDR [esi].EMOTION.sadness, ADDR [esi].EMOTION.sadness
		mov eax, [esp]
		INVOKE FearScore, eax
		mov score, eax
		INVOKE AddScore, ADDR score, ADDR [esi].EMOTION.fear, ADDR [esi].EMOTION.fear
		mov eax, [esp]
		INVOKE DisgustScore, eax
		mov score, eax
		INVOKE AddScore, ADDR score, ADDR [esi].EMOTION.disgust, ADDR [esi].EMOTION.disgust
		add esp, 4	;pops out tokWrod
		inc counter
cont:
		INVOKE TokenListCursorNext, edi
		INVOKE TokenListCursorGetItem, edi
		mov ebx, eax
	
	.ENDW
	INVOKE Average, emo, counter
	ret
GetEmoScore ENDP
;;; input1, input2, output can be aliases, does not affect the result of the function
AddScore PROC USES eax ecx edx, input1 : DWORD, input2 : DWORD, output : DWORD
	mov eax, [input1]
	mov ecx, [input2]
	mov edx, [output]
	fld REAL4 PTR [eax]
	fadd REAL4 PTR [ecx]
	fstp REAL4 PTR [edx]
	ret
AddScore ENDP

Average PROC input : DWORD, count : DWORD
	.IF count == 0
		ret
	.ENDIF		
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
	INVOKE getEmotionArray, input
	.IF eax != 0
		mov eax, [eax].EMOTION.happiness
	.ENDIF
	ret
HappinessScore ENDP

AngerScore PROC USES ebx edi, input : DWORD
	INVOKE getEmotionArray, input
	.IF eax != 0
		mov eax, [eax].EMOTION.anger
	.ENDIF
	ret
AngerScore ENDP

SadnessScore PROC USES ebx edi, input : DWORD
	INVOKE getEmotionArray, input
	.IF eax != 0
		mov eax, [eax].EMOTION.sadness
	.ENDIF
	ret
SadnessScore ENDP

FearScore PROC USES ebx edi, input : DWORD
	INVOKE getEmotionArray, input
	.IF eax != 0
		mov eax, [eax].EMOTION.fear
	.ENDIF
	ret
FearScore ENDP

DisgustScore PROC USES ebx edi, input : DWORD
	INVOKE getEmotionArray, input
	.IF eax != 0
		mov eax, [eax].EMOTION.disgust
	.ENDIF
	ret
DisgustScore ENDP

END
