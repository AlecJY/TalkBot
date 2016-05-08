.386
.MODEL flat, stdcall
.data

TOKEN_LIST_BODY STRUCT
	prev DWORD ?
	next DWORD ?
	item DWORD ?
TOKEN_LIST_BODY ENDS


TOKEN_LIST STRUCT
	head DWORD ?
	tail DWORD ?
TOKEN_LIST ENDS

TOKEN STRUCT
        tokWord DWORD ?
	len DWORD ?
TOKEN ENDS

TOKEN_LIST_CURSOR STRUCT
	list DWORD ?
	pos DWORD ?
TOKEN_LIST_CURSOR ENDS
	
.code
; Tokenize accepts a string with space separated words that is a null-terminated char array.
; list: a pointer to TOKEN_LIST that is returned by the TokenListNew() function
; input: a null terminated string
;	
Tokenize PROTO, list : DWORD, input : PTR BYTE

; TokenListNew allocates a TOKEN_LIST
TokenListNew PROTO
; TokenListDelete deallocates a TOKEN_LIST, if list is a NULL pointer, no operation is performed
TokenListDelete PROTO, list : DWORD
; TokenListAppend appends a TOKEN to the end of the TOKEN_LIST. If the operation succeeded, 0 is returned, otherwise, a non-zero value is returned
TokenListAppend PROTO, list : DWORD, item : DWORD
; TokenNew allocates and initializes a new TOKEN, input is a null-terminated byte array, len is the length of the byte array, excluding the null terminator
TokenNew PROTO, input : DWORD, len : DWORD
; TokenDelete deallocates a TOKEN
TokenDelete PROTO, tok : DWORD
; TokenListCursorNew returns a TOKEN_LIST_CURSOR that points to the beginning of the list
TokenListCursorNew PROTO, list : DWORD
; TokenListCursorDelete deallocates the cursor ptr, if cursor is a NULL pointer, no operation is performed
TokenListCursorDelete PROTO, cursor : DWORD
; TokenListCursorGetItem : return the token ptr that the cursor is pointing to
TokenListCursorGetItem PROTO, cursor : DWORD
; TokenListCursorPriv : No return value. Destructively modify the pointer to TOKEN_LIST_CURSOR to the previous item. If the previous item does not exist, then the content to which cursor points to does not change at all.
TokenListCursorPriv PROTO, cursor : DWORD
; TokenListCursorNext :  No return value. Destructively modify the pointer to TOKEN_LIST_CURSOR to the next item. If the next item does not exist, then the content to which cursor points to does not change at all.
TokenListCursorNext PROTO, cursor : DWORD
