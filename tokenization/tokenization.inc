.386
.MODEL flat
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

TOKEN_LIST_CURSOR STRUCT
	list DWORD ?
	pos DWORD ?
TOKEN_LIST_CURSOR ENDS
	
.code
; Tokenize accepts a string with space separated words, then 
; list: a pointer to TOKEN_LIST that is returned by the TokenListNew() function
; str: a null terminated string
;	
Tokenize PROTO, list : DWORD, str : PTR BYTE

; TokenListNew allocates a TOKEN_LIST
TokenListNew PROTO
; TokenListDelete deallocates a TOKEN_LIST, if list is a NULL pointer, no operation is performed
TokenListDelete PROTO, list : DWORD
; TokenListCursorNew returns a TOKEN_LIST_CURSOR that points to the beginning of the list
TokenListCursorNew PROTO, list : DWORD
; TokenListCursorDelete deallocates the cursor ptr, if cursor is a NULL pointer, no operation is performed
TokenListCursrDelete PROTO, cursor : DWORD
; TokenListCursorGetItem : return the token ptr that the cursor is pointing to
TokenListCursorGetItem PROTO, cursor : DWORD
; TokenListCursorPriv : return a pointer to TOKEN_LIST_CURSOR that points to the previous item in the TOKEN_LIST. If the previous item does not exist, than a NULL ptr is returned
TokenListCursorPriv PROTO, cursor : DWORD
; TokenListCursorNext : return a PTR TOKEN_LIST_CURSOR that points to the next item in the TOKEN_LIST. If the next item does not exist, than a NULL ptr is returned
TokenListCursorNext PROTO, cursor : DWORD
