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

TokenListAppend PROC USES ebx list : DWORD, tok : DWORD
	mov ecx, list
	.IF [ecx].TOKEN_LIST.head == 0
		INVOKE malloc, SIZEOF TOKEN_LIST_BODY
		.IF eax == 0
			jmp TokenListAppendError
		.ENDIF
		push eax
		push ecx
		INVOKE memset, eax, 0, SIZEOF TOKEN_LIST_BODY
		pop ecx
		pop eax
		mov [ecx].TOKEN_LIST.head, eax
		mov [ecx].TOKEN_LIST.tail, eax
		lea eax, [eax].TOKEN_LIST_BODY.item
		mov ecx, tok
		mov [eax], ecx
	.ELSE
		;; insert from tail
	
		mov ebx, [ecx].TOKEN_LIST.tail
		push ecx
		INVOKE malloc, SIZEOF TOKEN_LIST_BODY
		pop ecx
		.IF eax == 0
			jmp TokenListAppendError
		.ENDIF
		INVOKE memset, eax, 0, SIZEOF TOKEN_LIST_BODY
		mov [eax].TOKEN_LIST_BODY.prev, ebx
		mov [ebx].TOKEN_LIST_BODY.next, eax
		mov [ecx].TOKEN_LISt.tail, eax
	.ENDIF
TokenListAppendExit:
	mov eax, 0
	ret
TokenListAppendError:
	mov eax, 1
	ret
TokenListAppend ENDP	

TokenNew PROC input : DWORD, len : DWORD
	INVOKE malloc, SIZEOF TOKEN
	.IF eax == 0
		ret
	.ENDIF
	mov ecx, eax
	INVOKE malloc, len
	.IF eax == 0
		INVOKE free, ecx
		ret
	.ENDIF
	INVOKE memcpy, eax, input, len
	mov [ecx].TOKEN.tokWord, eax
	mov eax, len
	mov [ecx].TOKEN.len, eax
	mov eax, ecx
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
		mov [ecx].TOKEN_LISt_CURSOR.pos, eax
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

Tokenize PROC USES ebx edi list : DWORD, input : PTR BYTE
	LOCAL savedPtr
	mov ebx, input
	.IF ebx == 0
		ret
	.ELSE
		INVOKE strtok, ebx, ADDR spc
		.IF eax == 0
			;; There is only one token
			INVOKE strlen, ebx
			INVOKE TokenNew, ebx, eax
			INVOKE TokenListAppend, list, eax
			
		.ELSE
			push eax
			INVOKE strlen, ebx
			INVOKE TokenNew, ebx, eax
			INVOKE TokenListAppend, list, eax
			INVOKE strtok, 0, ADDR spc
			.WHILE eax != 0
				dec eax
				mov BYTE PTR [eax], 0
				mov edi, eax
				pop ebx
				INVOKE strlen, ebx
				INVOKE TokenNew, ebx, eax
				INVOKE TokenListAppend, list, eax
				mov eax, edi
				inc eax
				push eax
				INVOKE strtok, 0, ADDR spc
			.ENDW
			pop ebx
			INVOKE strlen, ebx
			INVOKE TokenNew, ebx, eax
			INVOKE TokenListAppend, list, eax
		.ENDIF
	.ENDIF
	ret
Tokenize ENDP	
END
