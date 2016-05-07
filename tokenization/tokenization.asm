INCLUDE tokenization.inc
INCLUDE crt.inc	
.code
TokenListNew PROC
	INVOKE malloc, SIZEOF TOKEN_LIST
	push eax
	INVOKE memset, eax, 0, SIZEOF TOKEN_LIST
	pop eax
	ret
TokenListNew ENDP

TokenListDelete PROC list : DWORD
	mov eax, list
	mov eax, [eax].TOKEN_LIST.head
TokenListDelete ENDP

TokenListCursorNew PROC list : DWORD
	INVOKE malloc, SIZEOF TOKEN_LIST_CURSOR
	.IF eax != 0
		mov ebx, eax
		mov eax, list
		mov [ebx].TOKEN_LIST_CURSOR.list, eax
		mov eax, [eax].TOKEN_LIST.head
		mov [ebx].TOKEN_LISt_CURSOR.pos, eax
		mov eax, ebx
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
	;; Not implemented
TokenListCursorPriv ENDP

TokenListCursorNext PROC cursor : DWORD
	;; Not implemented
TokenListCursorNext ENDP
	
END
