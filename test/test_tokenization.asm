INCLUDE tokenization.inc
INCLUDE crt.inc
.data
test_token_str BYTE "This is a test",0
TokenListNewFailedMsg BYTE "TokenListNew failed", 0	
.code

test_main PROC
	INVOKE TokenListNew
	.IF eax != 0
		INVOKE Tokenize, eax, ADDR test_token_str
	.ELSE
		INVOKE printf, ADDR TokenListNewFailedMsg
	.ENDIF
test_main ENDP


END
