INCLUDE tokenization.inc
INCLUDE crt.inc
.data
spc BYTE ' ',0	
.code
TokenListNew PROC
	INVOKE malloc, SIZEOF TOKEN_LIST
	.IF eax != 0
		push eax
		INVOKE memset, eax, 0, SIZEOF TOKEN_LIST
		pop eax
	.ENDIF
	ret
TokenListNew ENDP

TokenListDelete PROC list : DWORD
	mov eax, list
	.WHILE eax != 0
		mov eax, [eax].TOKEN_LIST.head
		mov ecx, [eax].TOKEN_LIST_BODY.item
		INVOKE TokenDelete, ecx
		mov ecx, [eax].TOKEN_LIST_BODY.next
		INVOKE free, eax
		mov eax, ecx
	.ENDW
	ret
TokenListDelete ENDP

TokenListAppend PROC USES ebx, list : DWORD, tok : DWORD
	mov ecx, list
	.IF [ecx].TOKEN_LIST.head == 0
		push ecx
		INVOKE malloc, SIZEOF TOKEN_LIST_BODY
		.IF eax == 0
			jmp TokenListAppendError
		.ENDIF
		push eax
		INVOKE memset, eax, 0, SIZEOF TOKEN_LIST_BODY
		pop eax
		pop ecx
		mov [ecx].TOKEN_LIST.head, eax
		mov [ecx].TOKEN_LIST.tail, eax
		lea eax, [eax].TOKEN_LIST_BODY.item
		mov edx, tok
		mov [eax], edx
	.ELSE
		;; insert from tail
	
		push ecx
		INVOKE malloc, SIZEOF TOKEN_LIST_BODY
		.IF eax == 0
			jmp TokenListAppendError
		.ENDIF
		INVOKE memset, eax, 0, SIZEOF TOKEN_LIST_BODY
		pop ecx
		mov ebx, [ecx].TOKEN_LIST.tail
		mov [eax].TOKEN_LIST_BODY.prev, ebx
		mov edx, tok
		mov [eax].TOKEN_LIST_BODY.item, edx
		mov [ebx].TOKEN_LIST_BODY.next, eax
		mov [ecx].TOKEN_LIST.tail, eax
	.ENDIF
TokenListAppendExit:
	mov eax, 0
	ret
TokenListAppendError:
	mov eax, 1
	ret
TokenListAppend ENDP	

TokenNew PROC input : DWORD, len : DWORD
	INVOKE calloc, 1, SIZEOF TOKEN + 1
	.IF eax == 0
		ret
	.ENDIF
	mov ebx, eax
	INVOKE malloc, len
	.IF eax == 0
		INVOKE free, ebx
		ret
	.ENDIF
	INVOKE memcpy, eax, input, len
	mov [ebx].TOKEN.tokWord, eax
	mov eax, len
	mov [ebx].TOKEN.len, eax
	mov eax, ebx
	ret
TokenNew ENDP

TokenDelete PROC, tok : DWORD
	mov eax, tok
	mov ecx, [eax].TOKEN.tokWord
	INVOKE free, ecx
	INVOKE free, eax
	ret
TokenDelete ENDP
	
TokenListCursorNew PROC list : DWORD
	INVOKE malloc, SIZEOF TOKEN_LIST_CURSOR
	.IF eax != 0
		mov ecx, eax
		mov eax, list
		mov [ecx].TOKEN_LIST_CURSOR.list, eax
		mov eax, [eax].TOKEN_LIST.head
		mov [ecx].TOKEN_LIST_CURSOR.pos, eax
		mov eax, ecx
	.ENDIF
	ret
TokenListCursorNew ENDP

TokenListCursorDelete PROC cursor : DWORD
	INVOKE free, cursor
	ret
TokenListCursorDelete ENDP

TokenListCursorGetItem PROC cursor : DWORD
	mov eax, cursor
	mov eax, [eax].TOKEN_LIST_CURSOR.pos
	.IF eax != 0
		mov eax, [eax].TOKEN_LIST_BODY.item
	.ENDIF
	ret
TokenListCursorGetItem ENDP

TokenListCursorPriv PROC cursor : DWORD
	mov eax, cursor
	mov ecx, [eax].TOKEN_LIST_CURSOR.pos
	mov ecx, [ecx].TOKEN_LIST_BODY.prev
	mov [eax].TOKEN_LIST_CURSOR.pos, ecx
	ret
TokenListCursorPriv ENDP

TokenListCursorNext PROC cursor : DWORD
	mov eax, cursor
	mov ecx, [eax].TOKEN_LIST_CURSOR.pos
	mov ecx, [ecx].TOKEN_LIST_BODY.next
	mov [eax].TOKEN_LIST_CURSOR.pos, ecx
	ret
TokenListCursorNext ENDP

Tokenize PROC USES ebx edi, list : DWORD, input : PTR BYTE
	mov ebx, input
	.IF ebx == 0
		ret
	.ELSE
		INVOKE strtok, ebx, ADDR spc
		.WHILE eax != 0
			push eax
			INVOKE strlen, eax
			pop ebx
			INVOKE TokenNew, ebx, eax
			INVOKE TokenListAppend, list, eax
			INVOKE strtok, 0, ADDR spc
		.ENDW
	.ENDIF
	ret
Tokenize ENDP	

PrintToken PROC USES ebx, input : DWORD
	mov eax, input
	.IF eax == 0
		ret
	.ELSE
		mov ebx, [eax].TOKEN.tokWord
		mov ecx, [eax].TOKEN.len
		.WHILE ecx > 0
			push ecx
			push ebx
			mov al, [ebx]
			INVOKE putchar, al
			pop ebx
			pop ecx
			inc ebx
			dec ecx
		.ENDW
	.ENDIF
	ret
PrintToken ENDP

END
