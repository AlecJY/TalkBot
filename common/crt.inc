
.code
EXTERNDEF _acrtused:WORD
malloc PROTO C p_size : DWORD
;extern malloc:PROC
free PROTO C p : DWORD
memset PROTO C p : DWORD, chr : DWORD, p_size : DWORD
memcpy PROTO C p1 : DWORD, p2 : DWORD, p_size : DWORD
strtok PROTO C p : DWORD, delim : DWORD
strlen PROTO C p : DWORD
printf PROTO C p : PTR BYTE, : VARARG
exit PROTO C num : DWORD