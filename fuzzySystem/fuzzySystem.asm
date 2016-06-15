INCLUDE fuzzySystem.inc 
INCLUDE get_score.inc

exp PROC USES ecx,
    x:REAL4
    
    mov eax, 65536
    push eax
    fld x
    fild dword ptr[esp]
    fdiv
    fld1
    fadd

    mov ecx, 16
L9:
    fst st(1)
    fmul
    loop L9
    
    fstp dword ptr[esp]
    pop eax
    ret
exp ENDP

GuassMFunc PROC,
    x:REAL4,
    median:REAL4

    
	fld x
    fld median
    fsub
    fst st(1)
    fmul
    fchs
    
    mov eax, 4
    push eax
    fild dword ptr[esp]
    fmul
    fstp dword ptr[esp]
    
    call exp
    add esp, 4
    ret
GuassMFunc ENDP

.data
medianArray REAL4  0.0, 2.5, 5.0
LOW_MOOD = 0
MID_MOOD = 1
HIGH_MOOD = 2

.code
MYDECODE PROC USES esi edx ebx ecx, num:DWORD, deArray:DWORD
    
    mov eax, num
    mov ebx, 3
	mov esi, [deArray]
    mov ecx, 8
L10:
	xor edx, edx
	div ebx
	
    mov BYTE PTR [esi], dl
    inc esi
    loop L10
    ret
MYDECODE ENDP

MYCHECK PROC USES esi edx ecx ebx, deArray:DWORD
    LOCAL maxVar:DWORD, minVar:DWORD, count:DWORD, res:DWORD
    mov eax, 5
    mov minVar, eax
    xor eax, eax
    mov maxVar, eax
    mov count, eax
	
    mov ecx, 5
	mov esi, [deArray]
L13:

    movzx eax, BYTE PTR [esi]
	
    .IF maxVar < eax
        mov maxVar, eax
    .ENDIF
    .IF minVar > eax
        mov minVar, eax
    .ENDIF

    inc esi

    loop L13

    mov ecx, 5
    mov esi, [deArray]
L14:
    movzx eax, BYTE PTR [esi]
    .IF eax == maxVar
		mov eax, esi
		sub eax, [deArray]
		inc eax
		mov res, eax
		
        inc count
    .ENDIF
	inc esi
    loop L14
    
	mov eax, count
	mov esi, maxVar
	mov ebx, minVar
	mov ecx, res
	
	
    .IF count == 1
        mov eax, maxVar
        sub eax, minVar
		mul res
    .ELSE
        xor eax, eax
    .ENDIF

	
	
	ret

MYCHECK ENDP 



FuzzySystem PROC USES ebx ecx edi esi,
    input:DWORD
	LOCAL emotions[5]:REAL4
    LOCAL strArray[15]:REAL4, sum:REAL8, tstr:REAL8, ans:DWORD, tmpArray[5]:BYTE

	mov eax, input
	mov edi, [eax].EMOTION.happiness
	mov [emotions + 0], edi 
	mov edi, [eax].EMOTION.anger
	mov [emotions + 4], edi 
	mov edi, [eax].EMOTION.sadness
	mov [emotions + 8], edi
	mov edi, [eax].EMOTION.fear
	mov [emotions + 12], edi 
	mov edi, [eax].EMOTION.disgust
	mov [emotions + 16], edi

	
	.IF emotions[0] == 0 && emotions[4] == 0 && emotions[8] == 0 && emotions[12] == 0 && emotions[16] == 0
		xor eax, eax
		ret
	.ENDIF
	
	
    xor edi, edi
    xor ebx, ebx

    mov ecx, 5
L1: 
	push ecx
	mov ecx, 3
    xor esi, esi
L2: 
	
    INVOKE GuassMFunc, REAL4 PTR emotions[ebx * 4], medianArray[esi * 4]
    mov strArray[edi*4], eax
    
    inc esi
    inc edi
    loop L2
    pop ecx

    inc ebx
    loop L1

    xor eax, eax
    mov DWORD PTR [tstr + 0], eax
	mov DWORD PTR [tstr + 4], eax
    mov DWORD PTR [sum + 0], eax
	mov DWORD PTR [sum + 4], eax

    mov ecx, 243
	xor ebx, ebx
L11:
	lea eax, tmpArray
	INVOKE MYDECODE, ebx, eax
	
    push ecx
    mov ecx, 5
    xor esi, esi
    xor edi, edi
    fld1
L12:
    movzx edi, BYTE PTR tmpArray[esi]
	
	push esi
    imul esi, 3
    add esi, edi
    fmul REAL4 PTR strArray[esi*4]
    
    pop esi
	
    inc esi
    loop L12
	
	
	fst st(1)
    fadd tstr
    fstp tstr
	

	lea eax, tmpArray
	INVOKE MYCHECK, eax
   
	push eax
    fimul DWORD PTR [esp]
    pop eax
	
    fadd sum
    fstp sum
    
	
	pop ecx
	inc ebx
	
	
	loop L11

	.IF (DWORD PTR [sum + 0]) == 0 && (DWORD PTR [SUM + 4]) == 0 && (DWORD PTR [tstr + 0]) == 0 && (DWORD PTR [tstr + 4]) == 0
		xor eax, eax
	.ELSE 
		fld sum
		fld tstr

		fdiv
		fld1
		fld1
		fld1
		fadd
		fdiv
		fadd
		fistp ans

		mov eax, ans
	.ENDIF
	
    ret

FuzzySystem ENDP
END
