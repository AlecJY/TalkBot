INCLUDE tokenization.inc
INCLUDE crt.inc
.data
test_token_str BYTE "This is a test",0
TokenListNewFailedMsg BYTE "TokenListNew failed", 0
CRLF BYTE 0dh, 0ah, 0	
.code

test_main PROC
	INVOKE TokenListNew
	push eax
	.IF eax != 0
		INVOKE Tokenize, eax, ADDR test_token_str
	.ELSE
		INVOKE printf, ADDR TokenListNewFailedMsg
		INVOKE exit, 0
	.ENDIF
	pop eax
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
	INVOKE exit, 0
test_main ENDP


END
