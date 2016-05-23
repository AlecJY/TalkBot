.386
.model flat, stdcall
option casemap:none

include \masm32\include\kernel32.inc
include \masm32\include\windows.inc
include \masm32\include\masm32.inc
include \masm32\include\wsock32.inc
include miglib.inc

includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\wsock32.lib
includelib \masm32\lib\miglib.lib

SeperateMessage PROTO :DWORD, :DWORD
GetLine PROTO :DWORD, :DWORD, :DWORD
ReadINIString PROTO :DWORD, :DWORD
CfgConcat PROTO :DWORD, :DWORD


.data
wsadata WSADATA <>
sin sockaddr_in <>

iniPath DB ".\account.ini", 0
AppName DB "account", 0
NickKeyName DB "nick", 0
PassKeyName DB "pass", 0
ChannelKeyName DB "channel", 0
DefaultVal DB "NULL", 0
NickCmd DB "NICK ", 0
PassCmd DB "PASS ", 0
ChannelCmd DB "JOIN ", 0

loadCFG DB "Loading account.ini...", 13, 10, 0

cfgReadError DB "Error: Cannot Read account.cfg", 13, 10, 0
mallocFailed DB "Error: Memory Allocate failed", 13, 10, 0
sockStartError DB "Initialize socket failed", 13, 10, 0
sockError DB "Send Package failed", 13, 10, 0
serverLog DB "ServerInfo: ", 0

IPAddr DB "52.24.191.57", 0
Port DD 6667

charStr DB 2 dup(?)

.data?
fileBuffer DD ?
hwnd DD ?
sock DD ?
hMemory DD ?
buffer DD ?
available_data DD ?
actual_data_read DD ?
fileLen DD ?
Pass DD ?
PassSize DD ?
Nick DD ?
NickSize DD ?
Channel DD ?
ChannelSize DD ?
hMemoryKey DD ?
keyLength DD ?
keyBuffer DD ?

.code
start:

call ReadConfig
invoke WSAStartup, 101h, addr wsadata
.if eax != NULL
    invoke StdOut, ADDR sockStartError
.else
    invoke socket, AF_INET, SOCK_STREAM, 0
    .if eax != INVALID_SOCKET
        mov sock, eax
    .else
        invoke WSAGetLastError
        invoke StdOut, ADDR sockStartError
        invoke ExitProcess, -1
    .endif
    mov sin.sin_family, AF_INET
	invoke htons, Port
	mov sin.sin_port, ax
	invoke inet_addr, ADDR IPAddr
	mov sin.sin_addr, eax
	invoke connect, sock, ADDR sin, SIZEOF sin
	.if eax == SOCKET_ERROR
		invoke WSAGetLastError
		.if eax != WSAEWOULDBLOCK
			invoke StdOut, ADDR sockStartError
			invoke ExitProcess, -1
		.endif
	.endif
	invoke send, sock, Pass, PassSize, 0
	.if eax == SOCKET_ERROR
		invoke StdOut, ADDR sockError
	.endif
	invoke send, sock, Nick, NickSize, 0
	.if eax == SOCKET_ERROR
		invoke StdOut, ADDR sockError
	.endif
	invoke send, sock, Channel, ChannelSize, 0
	.if eax == SOCKET_ERROR
		invoke StdOut, ADDR sockError
	.endif
	
Receive:
	invoke ioctlsocket, sock, FIONREAD, ADDR available_data
	.if eax == NULL
		invoke GlobalAlloc, GHND, available_data
		mov hMemory, eax
		invoke GlobalLock, eax
		mov buffer, eax
		invoke recv, sock, buffer, available_data, 0
		mov actual_data_read, eax
		.if eax > 0
			invoke SeperateMessage, buffer, actual_data_read
		.endif
		invoke GlobalUnlock, buffer
		invoke GlobalFree, hMemory
	.endif
	jmp Receive
	
.endif
invoke ExitProcess, 0

ReadConfig PROC USES ebx ecx edx esi edi
	invoke StdOut, ADDR loadCFG
	invoke filesize, ADDR iniPath
	.if eax < 0
		invoke StdOut, ADDR cfgReadError
		invoke ExitProcess, -1
	.endif
	mov fileLen, eax
	invoke ReadINIString, fileLen, ADDR NickKeyName
	mov Nick, eax
	mov NickSize, ecx
	invoke CfgConcat, ADDR NickCmd, Nick
	invoke ReadINIString, fileLen, ADDR PassKeyName
	mov Pass, eax
	mov PassSize, ecx
	invoke CfgConcat, ADDR PassCmd, Pass
	invoke ReadINIString, fileLen, ADDR ChannelKeyName
	mov Channel, eax
	mov ChannelSize, ecx
	invoke CfgConcat, ADDR ChannelCmd, Channel
	ret
	
	
ReadConfig ENDP

ReadINIString PROC USES ebx edx esi edi, fleng:DWORD, KeyName:DWORD
	invoke GlobalAlloc, GHND, fleng
	mov hMemory, eax
	invoke GlobalLock, eax
	mov buffer, eax
	invoke GetPrivateProfileString, ADDR AppName, KeyName, ADDR DefaultVal, buffer, fleng, ADDR iniPath
	mov keyLength, eax
	add eax, 8
	invoke GlobalAlloc, GHND, eax
	mov hMemoryKey, eax
	invoke GlobalLock, eax
	mov keyBuffer, eax
	mov ecx, keyLength
	mov esi, buffer
	mov edi, keyBuffer
	add edi, 5
	rep movsb
	mov bl, 13
	mov [edi], bl
	inc edi
	mov bl, 10
	mov [edi], bl
	inc edi
	mov bl, 0
	mov [edi], bl
	invoke GlobalUnlock, buffer
	invoke GlobalFree, hMemory
	mov eax, keyBuffer
	mov ecx, keyLength
	add ecx, 7
	ret
ReadINIString ENDP

CfgConcat PROC USES ebx ecx edx esi edi, fStr:DWORD, mStr:DWORD
	mov esi, fStr
	mov edi, mStr
	mov ecx, 5
	rep movsb
	ret
CfgConcat ENDP

GetLine PROC USES ebx ecx edx esi edi, message:DWORD, leng:DWORD, ln:DWORD
	
	mov ecx, leng
	mov esi, message
	mov ebx, 0		; line counter
	mov edx, 1
	
CharLoop:
	mov dl, [esi]
	.if dl == 13
		inc ebx
	.elseif ecx == 1
		inc ebx
	.endif
	mov edi, ln
	.if ebx == ln
		
	.endif
	inc edx
	loop CharLoop
	ret

	
GetLine ENDP

SeperateMessage PROC USES ebx ecx edx esi edi, message:DWORD, leng:DWORD
	mov esi, message
	mov edi, OFFSET charStr
	mov bh, 0
	mov [edi], bh
	mov ecx, leng
LMsg:
	push ecx
	mov bl, [esi]
	mov [edi], bl
	invoke StdOut, ADDR charStr
	inc esi
	pop ecx
	loop LMsg
	ret
SeperateMessage ENDP
END start