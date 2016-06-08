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
ReadChannelString PROTO :DWORD, :DWORD
CfgConcat PROTO :DWORD, :DWORD
GetLineNumber PROTO :DWORD, :DWORD
GetUsername PROTO :DWORD
GetCommandResponse PROTO :DWORD
GetMsg PROTO :DWORD
EchoMsg PROTO :DWORD
PingPong PROTO :DWORD

.data
; basicData
CopyRight DB "TalkBot Nightly 2016-06-08", 13, 10, "https://github.com/petercommand/TalkBot",13, 10, "(C) 2016 TalkBot Team", 13, 10, 13, 10, 0
SendCRLF DB 13, 10, 0
SendSpace DB " ", 0

; testData
newLine DB "==========================================", 13, 10, 0

; WinSock
wsadata WSADATA <>
sin sockaddr_in <>

; ini Read
iniPath DB ".\account.ini", 0
AppName DB "account", 0
NickKeyName DB "nick", 0
PassKeyName DB "pass", 0
ChannelKeyName DB "channel", 0
DefaultVal DB "NULL", 0
NickCmd DB "NICK ", 0
PassCmd DB "PASS ", 0
ChannelCmd DB "JOIN ", 0
PrivMsgCmd DB "PRIVMSG ", 0


; Server logs
loadCFG DB "Loading account.ini...", 13, 10, 0

; Error Messages
cfgReadError DB "Error: Cannot Read account.cfg", 13, 10, 0
mallocFailed DB "Error: Memory Allocate failed", 13, 10, 0
sockStartError DB "Initialize socket failed", 13, 10, 0
sockError DB "Send Package failed", 13, 10, 0

; IRC Server arguments
IPAddr DB "52.24.191.57", 0
Port DD 6667

; IRC Messages
twitchAddr DB ":tmi.twitch.tv ", 0
PING DB "PING ", 0
PONG DB "PONG ", 0
Seperator DB " :@", 0

charStr DB 2 dup(?)
dwString DD 100 dup(?)

.data?
fileBuffer DD ?
hwnd DD ?
sock DD ?
hMemory DD ?
buffer DD ?
available_data DD ?
actual_data_read DD ?

; ini Read
fileLen DD ?
Pass DD ?
PassSize DD ?
Nick DD ?
NickSize DD ?
Channel DD ?
ChannelSize DD ?
ChannelName DD ?
ChannelNameSize DD ?
hMemoryKey DD ?
keyLength DD ?
keyBuffer DD ?

username DD ?
usernameHandle DD ?
RetrivedMsg DD ?
RetrivedMsgHandle DD ?
RetrivedMsgSize DD ?

.code
start:

invoke StdOut, ADDR CopyRight
call ReadConfig	; read config file

; socket
invoke WSAStartup, 101h, addr wsadata	; start winsock 1.1
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
	
	; send pass, nick and channel info
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
	
	; receive messages
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
			invoke GetLineNumber, buffer, actual_data_read
			mov ecx, eax
			mov ebx, 0
		LineProcess:
			call LineProcessProc
			loop LineProcess
			
		.endif
		invoke GlobalUnlock, hMemory
		invoke GlobalFree, hMemory
	.endif
	jmp Receive
	
.endif
invoke ExitProcess, 0

LineProcessProc PROC
	push ecx
	invoke GetLine, buffer, actual_data_read, ebx
	.if eax != -1
		push ecx
		push eax
		invoke PingPong, eax
		.if eax != 0
			pop eax
			push eax
			invoke GetUsername, eax
			pop eax
			push eax
			invoke GetCommandResponse, eax
			pop eax
			push eax
			invoke InString, 1, eax, ADDR PrivMsgCmd
			.if eax > 0
				pop eax
				invoke GetMsg, eax
				invoke EchoMsg, eax
				mov RetrivedMsg, eax
				push eax
				invoke szLen, RetrivedMsg
				mov RetrivedMsgSize, eax
				invoke GetLineNumber, RetrivedMsg, RetrivedMsgSize
				mov ecx, eax
				mov edx, 0
				
			LineMsgLoop:
				push ecx
				call SendMsg
				pop ecx
				loop LineMsgLoop
			.endif
			invoke GlobalUnlock, usernameHandle
			invoke GlobalFree, usernameHandle
			
		.endif
		pop eax
		pop ecx
		push ecx
		invoke GlobalUnlock, ecx
		pop ecx
		invoke GlobalFree, ecx
	.endif
	inc ebx
	pop ecx
	ret
LineProcessProc ENDP

SendMsg PROC

	push edx
	invoke GetLine, RetrivedMsg, RetrivedMsgSize, edx
	push ecx
	push eax
	invoke send, sock, ADDR PrivMsgCmd, 8, 0
	invoke StdOut, ADDR PrivMsgCmd
	invoke send, sock, ChannelName, ChannelNameSize, 0
	invoke StdOut, ChannelName
	invoke send, sock, ADDR Seperator, 3, 0
	invoke StdOut, ADDR Seperator
	invoke szLen, username
	invoke send, sock, username, eax, 0
	invoke StdOut, username
	invoke send, sock, ADDR SendSpace, 1, 0
	invoke StdOut, ADDR SendSpace
	pop eax
	push eax
	invoke szLen, eax
	mov ebx, eax
	pop eax
	push eax
	invoke send, sock, eax, ebx, 0
	pop eax
	invoke StdOut, eax
	invoke send, sock, ADDR SendCRLF, 2, 0
	invoke StdOut, ADDR SendCRLF
	pop ecx
	invoke GlobalUnlock, ecx
	invoke GlobalFree, ecx
	pop edx
	inc edx
	ret

SendMsg ENDP

ReadConfig PROC USES ebx ecx edx esi edi
	;read config
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
	invoke ReadChannelString, fileLen, ADDR ChannelKeyName
	mov ChannelName, eax
	mov ChannelNameSize, ecx
	ret
ReadConfig ENDP

ReadINIString PROC USES ebx edx esi edi, fleng:DWORD, KeyName:DWORD
	; read config from ini file
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
	
	; add CRLF to the end of the string and five blank bytes at the initial of the string for command
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

ReadChannelString PROC USES ebx edx esi edi, fleng:DWORD, KeyName:DWORD
	; read config from ini file
	invoke GlobalAlloc, GHND, fleng
	mov hMemory, eax
	invoke GlobalLock, eax
	mov buffer, eax
	invoke GetPrivateProfileString, ADDR AppName, KeyName, ADDR DefaultVal, buffer, fleng, ADDR iniPath
	mov keyLength, eax
	add eax, 1
	invoke GlobalAlloc, GHND, eax
	mov hMemoryKey, eax
	invoke GlobalLock, eax
	mov keyBuffer, eax
	mov ecx, keyLength
	mov esi, buffer
	mov edi, keyBuffer
	
	; add CRLF to the end of the string and five blank bytes at the initial of the string for command
	rep movsb
	mov bl, 0
	mov [edi], bl
	invoke GlobalUnlock, buffer
	invoke GlobalFree, hMemory
	mov eax, keyBuffer
	mov ecx, keyLength
	ret
ReadChannelString ENDP

CfgConcat PROC USES ebx ecx edx esi edi, fStr:DWORD, mStr:DWORD
	; add command to string
	mov esi, fStr
	mov edi, mStr
	mov ecx, 5
	rep movsb
	ret
CfgConcat ENDP

GetLineNumber PROC USES ebx ecx edx esi edi, message:DWORD, leng:DWORD

	mov ecx, leng
	mov esi, message
	mov eax, 1		; line counter
	
CharLoop:
	mov bl, [esi]
	.if bl == 13
		inc eax
	.endif
	inc esi
	loop CharLoop
	ret
GetLineNumber ENDP

GetLine PROC USES ebx edx esi edi, message:DWORD, leng:DWORD, ln:DWORD
	
	mov ecx, leng
	mov esi, message
	mov eax, 0		; line counter
	mov edx, 0		; line size counter
	
CharLoop:
	mov bl, [esi]
	.if bl == 13
		.if eax == ln
			jmp LineToMemory
		.else
			inc eax
			add esi, 2
			sub ecx, 2
			.if ecx == 0
				jmp LineEnd
			.endif
			jmp CharLoop
		.endif
	.elseif eax == ln
		inc edx
		.if ecx == 1
			jmp LineToMemory
		.endif
	.endif
	inc esi
	loop CharLoop
	
LineEnd: 
	mov eax, -1
	ret
	
LineToMemory:
	inc edx
	push edx
	invoke GlobalAlloc, GHND, edx
	pop edx
	push eax
	push edx
	invoke GlobalLock, eax
	pop edx
	push eax
	dec edx
	mov esi, message
	mov edi, eax
	mov ecx, edx
	rep movsb
	mov bl, 0
	mov [edi], bl
	pop eax
	pop ecx
	ret
	
GetLine ENDP

GetUsername PROC USES ebx ecx edx esi edi, message:DWORD
	
	mov esi, message
	inc esi
	mov edx, 1 ; counter
	
CharLoop:
	mov bl, [esi]
	.if bl == 33
		jmp LoopEnd
	.elseif bl == 32
		jmp LoopEnd
	.endif
	inc edx
	inc esi
	jmp CharLoop
	
LoopEnd:
	inc edx
	mov eax, eax
	invoke GlobalAlloc, GHND, edx
	mov usernameHandle, eax
	invoke GlobalLock, eax
	mov username, eax
	mov esi, message
	inc esi
	mov edi, message
	
CharCopy:
	mov bl, [esi]
	.if bl == 33
		mov ecx, 0
		inc esi
		jmp MSGDelete
	.elseif bl == 32
		mov ecx, 1
		inc esi
		jmp MSGDelete
	.endif
	mov [eax], bl
	inc esi
	inc eax
	jmp CharCopy
	
MSGDelete:
	mov bl, [esi]
	mov [edi], bl
	.if bl == 0
		mov bl, 0
		inc eax
		mov [eax], bl
		mov ecx, eax
		ret
	.endif
	inc esi
	inc edi
	jmp MSGDelete
	
GetUsername ENDP

GetCommandResponse PROC USES ebx ecx edx esi edi, message:DWORD

	mov esi, message
	mov eax, 0
	mov ecx, 4
	
NumLoop:
	mov bl, [esi]
	.if bl >= 48
		.if bl <= 57
			sub bl, 48
			imul eax, 10
			movzx edx, bl
			add eax, edx
			inc esi
			loop NumLoop
		.endif
	.elseif bl == 32
		mov esi, message
		add esi, 4
		mov edi, message
		jmp CharDel
	.endif
	mov eax, -1
	ret
	
CharDel:
	mov bl, [esi]
	mov [edi], bl
	.if bl != 0
		inc esi
		inc edi
		jmp CharDel
	.endif
	ret

GetCommandResponse ENDP

GetMsg PROC USES ebx ecx edx edi edi, message:DWORD
	
	mov esi, message
	mov eax, -1

CharLoop:
	mov bl, [esi]
	.if bl == 58
		mov edi, message
		inc esi
		jmp CharDel
	.elseif bl == 0
		ret
	.endif
	inc esi
	jmp CharLoop
	
CharDel:
	mov bl, [esi]
	mov [edi], bl
	.if bl == 0
		mov eax, message
		ret
	.endif
	inc esi
	inc edi
	jmp CharDel
	
GetMsg ENDP

PingPong PROC USES ebx ecx edx esi edi, message:DWORD
	
	mov esi, message
	mov edi, OFFSET PING
	mov ecx, 5
	
CheckPing:
	mov bl, [esi]
	mov bh, [edi]
	.if bl != bh
		mov eax, -1
		ret
	.endif
	inc esi
	inc edi
	loop CheckPing
	
	mov ecx, 5
	mov esi, OFFSET PONG
	mov edi, message
	rep movsb
	invoke StdOut, message
	invoke StdOut, ADDR SendCRLF
	invoke szLen, message
	invoke send, sock, message, eax, 0
	invoke send, sock, ADDR SendCRLF, 2, 0
	mov eax, 0
	ret
	
PingPong ENDP

EchoMsg PROC USES ebx ecx edx esi edi, message:DWORD
	
	mov eax, message
	ret
	
EchoMsg ENDP

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