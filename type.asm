;;; UNTESTED
;;; this is an early draft, DO NOT RELY ON IT


;;; parse tree binary format

	

ENG_PARSE_TREE STRUCT
	;; to be determined
ENG_PARSE_TREE ENDS
	
ENG_PARSE_RESULT STRUCT
	confidence DWORD ?	; confidence of this parse tree: 0-100 (0: not confident at all, 100: totally confident)
	probability DWORD ? 	; probability that this is the correct parse tree
	tree ENG_PARSE_TREE PTR ? ; the parse tree
ENG_PARSE_RESULT ENDS

ENG_PARSE_ARRAY STRUCT
	len DWORD ? 		; length of the array
	arr ENG_PARSE_RESULT PTR ? ; ptr of the array
ENG_PARSE_ARRAY ENDS

;;; sentiment analysis
	
EMODATA STRUCT
	happiness double ?
	anger double ?
	sadness double ?
	fear double ?
	disgust double ?
EMODATA ENDS	
	

