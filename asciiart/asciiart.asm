Title AsciiArt

include asciiart.inc
include get_score.inc
include fuzzySystem.inc

Mind PROTO, number : BYTE

.data

hello BYTE "Hi Alice",0
exam BYTE "There are many exams tomorrow",0
bye BYTE "Good bye Alice",0
onepiece BYTE "I want to be a king of pirates",0
default BYTE "ヽ(=^･ω･^=)丿",0
pic1 BYTE "█▄▄░░░░░░░░░░░░░░░░░░░░▄█▀█",0dh,0ah
	 BYTE "▌░░▀▀▄▄░░░░░░░░░░░░▄▄▀▀▀░█░",0dh,0ah
	 BYTE "█▓░░░░▀▄▄░░░░░░▄▄▓▀░░░▄▄▀░░",0dh,0ah
	 BYTE "░░▀▀▀▀▀▀░░░░░░░░░░▀▀▀▀▀░░░░",0dh,0ah
	 BYTE "░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄░░░░░░░░",0dh,0ah
	 BYTE "░░░░░░█▀▄░░▄░░▄▄░░▄█░░░░░░░",0dh,0ah
	 BYTE "░░░░▄█░░▀▄▀▀▄▀░░█░░▀█░░░░░░",0dh,0ah
	 BYTE "░░░░█▌░░░░░░░░░░░░░░█░░░░░░",0dh,0ah
	 BYTE "░░░░█░░█░░░░█▄░░█░░░░█░░░░░",0dh,0ah
	 BYTE "░░░░██▄█▄█▄▄▀ █▄▀▄█░░▀▄░░░░",0dh,0ah
	 BYTE "░░░░█▀░░░░▀▀░░▀░░░░▀▀██░░░░",0dh,0ah
	 BYTE "░░▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀░░░",0
pic2 BYTE "▄▄▄▄▄▄▄▄▄▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░",0dh,0ah
	 BYTE "███▀▀▀▀▀███▌░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░",0dh,0ah
	 BYTE "██▌░░░░░░███░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░",0dh,0ah
	 BYTE "███░░░░░░██▌░░░░██▌░░░░░░░░███░░░░▄███████▄░░░",0dh,0ah
	 BYTE "███▄▄▄▄▄▄██▀░░░░▀██▌░░░░░░██▌░░░░▄██▀░░░░░░██░",0dh,0ah
	 BYTE "████▀▀▀▀▀▀██▌▄░░░░▀██▄░░░░██▌░░░░███▄▄▄▄▄▄▄██▌",0dh,0ah
	 BYTE "███░░░░░░░░███▄░░░░███▄░░██▌░░░░████▀▀▀▀▀▀▀█▀░",0dh,0ah
	 BYTE "███░░░░░░░░███░░░░░░███▄██▌░░░░░░██▌░░░░░░░░░░",0dh,0ah
	 BYTE "███▌▄▄▄▄▄████░░░░░░░░████▌░░░░░░░░████▄▄▄███▌░",0dh,0ah
	 BYTE "█▀██▀█▀▀▀▀░░░░░░░░░░░░██▌░░░░░░░░░░▀▀██▀▀██░░░",0dh,0ah
	 BYTE "░░░░░░░░░░░░░░░░░░░░░░███░░░░░░░░░░░░░░░░░░░░░",0dh,0ah
	 BYTE "░░░░░░░░░░░░░░░░░░░░░░███░░░░░░░░░░░░░░░░░░░░░",0
pic3 BYTE "███░░░░░░███░░░░░░▄▄▄",0dh,0ah
	 BYTE "███░░░░░░███░░░░░░███",0dh,0ah
	 BYTE "███░░░░░░███░░░░░░░░░",0dh,0ah
	 BYTE "████████████░░░░░░███",0dh,0ah
	 BYTE "███░░░░░░███░░░░░░███",0dh,0ah
	 BYTE "███░░░░░░███░░░░░░███",0dh,0ah
	 BYTE "███░░░░░░███░░░░░░███",0
pic4 BYTE "░░▄▀▀▀▄░░░░░░░░░░▄▄▄▄▄▄▄▄▄░░░░░░░░░░█▀▀▄░░░",0dh,0ah
     BYTE " ▄▀░░░▀░░░░░░░▄▄▄▒▒▒▒▒▒▒▒▒▄▄▄▄▄░░░▄▀░░░░▀█░",0dh,0ah
     BYTE "█▄▄▄░░░█▄▄▓▒▒▒▒▒▄▄▄▄▄▄▄▄▄ ▒▒▒▒▓▄▄▀░▄▄█▀▀▀░░",0dh,0ah
     BYTE "░░░░▀▄░░░█▒▒▄▀▀▒▒▒▒▒▒▒▒▒▒▀▓▄ ▀░░░▄▀░░░░░░░░",0dh,0ah
     BYTE "░░░░░██▄░░█▀▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▄░▄▓▀▄░░░░░░░░",0dh,0ah
     BYTE "░░░░▄▀░░░▌▒▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▒▓░░░▀▄░░░░░░",0dh,0ah
     BYTE "░░░░▌▄▄▄█▌▓▓▓▓▀▀▀▓▓▓▓▓▓▓▀▀▀▓▓▓▓▓█▄▄▄▓░░░░░░",0dh,0ah
     BYTE "░░▄▓▀▒▒▒▄▀▀▀▀▀░░░░░░░░░░░░░▀▀▀▀▒▒▒▒▒▀▀▄░░░░",0dh,0ah
     BYTE "░░▀▓▄▄▄▓░░░░▄████▄░░░░░▄████▄ ░░▌▄▄▄▌▀░░░░░",0dh,0ah
     BYTE "░░░▒▒▒▒▓░░▐████████░░░████████░░▌▒▒▒▀░░░░░░",0dh,0ah
     BYTE "░░░░▌▒▒▒▓░░████████░░░████████░░▓▒▒▒▓░░░░░░",0dh,0ah
     BYTE "░░░░░▌▓▓▓▓░░▀████▀░░▄░░▀████▀░░▄▓▓▓▓▀░░░░░░",0dh,0ah
     BYTE "░░░░░░▌▓▓ ▌░░░░░░░░███░░░░░░░░█ ▓▓▓▀░░░░░░░",0dh,0ah
     BYTE "░░░░░░░▓▓░░▄▓▄░░░░░░░░░░░▄▓▄░░░▀▓░░░░░░░░░░",0dh,0ah
     BYTE "░░░░▄▄▓░░▄▄▓▓▓█▀▀▓▀▀▓▀▀▓▀░▓▓▓▓▄░░▀▄░░░░░░░░",0dh,0ah
     BYTE "▄▄▄▄▀░▄▄▀░░▀▀▌▄▓▀█▀▀█▀▀█▀▓▀█  ▀▄░░▀▄▄▄▄░░░░",0dh,0ah
     BYTE "▌░░░░▄▀▀░░░░░░▀▄▀▀▄▄▀▄▄▀▀▄▀░░░░░░▀▄░░░░░▓░░",0dh,0ah
     BYTE "▀▀▄░░░▓░░░░░░░░▀▄▄▄░░░▄▄▀▀░░░░░░░░▓░░░▄▀▀░░",0dh,0ah
     BYTE "░░░▀▀▀░░░░░░░░░░░░▀▀▀▀░░░░░░░░░░░░░▀▀▀▀░░░░",0
happy1 BYTE "(ﾉ>ω<)ﾉ ",0
happy2 BYTE "ヽ(✿ﾟ▽ﾟ)ノ",0
angry1 BYTE "ヽ(`Д´)ノ",0
angry2 BYTE "(#`皿´)",0
sad1   BYTE "◢▆▅▄▃崩╰(〒皿〒)╯潰▃▄▅",0
sad2   BYTE "(╥﹏╥)",0
scared1 BYTE "Σ( ° △ °|||)︴",0
scared2 BYTE "(⊙ˍ⊙)",0
mad1	BYTE "(╬ﾟдﾟ)▄︻┻┳═一",0
mad2	BYTE "(#`Д´)ﾉ",0
InputStruct EMOTION <>

.code

;parameter is StrOffset to match hello or exam or bye string
AsciiArt PROC USES ecx esi edi, StrOffset : PTR BYTE	 

mov esi, StrOffset
mov edi, OFFSET hello
mov ecx, LENGTHOF hello
cld
repe cmpsb				;examine hello string
jz L1

mov esi, StrOffset
mov edi, OFFSET exam
mov ecx, LENGTHOF exam	
cld
repe cmpsb				;examine exam string
jz L2

mov esi, StrOffset
mov edi, OFFSET bye
mov ecx, LENGTHOF bye
cld
repe cmpsb				;examine bye string
jz L3

mov esi, StrOffset
mov edi, OFFSET onepiece
mov ecx, LENGTHOF onepiece
cld
repe cmpsb				;examine bye string
jz L4

mov esi, StrOffset
INVOKE GetEmoScore, esi, ADDR InputStruct
INVOKE fuzzySystem, ADDR InputStruct
INVOKE Mind, al

jmp LEND

L1:
	mov eax, OFFSET pic3
	jmp LEND
L2:
	mov eax, OFFSET pic1
	jmp LEND
L3:
	mov eax, OFFSET pic2
	jmp LEND
L4:
	mov eax, OFFSET pic4	
LEND:
ret
AsciiArt ENDP

;parameter is number to match mind symbol
Mind PROC USES ebx, number :BYTE	

movzx ebx, number
cmp ebx, 1		;happy1
je M1			
cmp ebx, 2		;happy2
je M2
cmp ebx, 3		;angry1
je M3
cmp ebx, 4		;angry2
je M4
cmp ebx, 5		;sad1
je M5
cmp ebx, 6		;sad2
je M6
cmp ebx, 7		;scared1
je M7
cmp ebx, 8		;scared2
je M8
cmp ebx, 9		;mad1
je M9
cmp ebx, 10		;mad2
je M10
mov eax, OFFSET default
jmp MEND
M1:
	mov eax, OFFSET happy1
	jmp MEND
M2:
	mov eax, OFFSET happy2
	jmp MEND
M3:
	mov eax, OFFSET angry1
	jmp MEND
M4:
	mov eax, OFFSET angry2
	jmp MEND
M5:
	mov eax, OFFSET sad1
	jmp MEND
M6:
	mov eax, OFFSET sad2
	jmp MEND
M7:
	mov eax, OFFSET scared1
	jmp MEND
M8:
	mov eax, OFFSET scared2
	jmp MEND
M9:
	mov eax, OFFSET mad1
	jmp MEND
M10:
	mov eax, OFFSET mad2
MEND:
ret
Mind ENDP

END



