.data
EMOTION STRUCT
	happiness REAL4 ?
	anger REAL4 ?
	sadness REAL4 ?
	fear REAL4 ?
	disgust REAL4 ?
EMOTION ENDS

.code
; input : a null terminated string, emo : a pointer to the emotion struct
GetEmoScore PROTO input : DWORD, emo : DWORD
