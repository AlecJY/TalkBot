INCLUDE tokenization.inc
INCLUDE ../common/crt.inc	
.code
TokenListNew PROC
	INVOKE malloc, SIZEOF TOKEN_LIST
	push eax
	INVOKE memset, eax, 0, SIZEOF TOKEN_LIST
	pop eax
	ret
TokenListNew ENDP

TokenListDelete PROC list : PTR TOKEN_LIST
	mov eax, list
	mov eax, [eax]
	mov eax, eax.head
TokenListDelete ENDP
