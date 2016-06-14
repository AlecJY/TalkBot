INCLUDE fuzzySystem.inc 


exp PROC,
    x:REAL4
    
    mov eax, 256
    push eax
    fld x
    fild dword ptr[esp]
    fdiv
    fld1
    fadd

    mov ecx, 8
L9:
    fst st(1)
    fmul
    loop L9
    
    fst dword ptr[esp]
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
    
    mov eax, 1
    push eax
    fild dword ptr[esp]
    fdiv
    fst dword ptr[esp]
    
    call exp
    add esp, 4
    ret
GuassMFunc ENDP

.data
medianArray REAL4  0.0, 3.0, 5.0
LOW_MOOD = 0
MID_MOOD = 1
HIGH_MOOD = 2

.code
FuzzySystem PROC USES ebx ecx edi esi,
    emotions:DWORD
    LOCAL strArray[15]:REAL4, sum:REAL4, tstr:REAL4, ans:DWORD

    xor edi, edi
    xor ebx, ebx

    mov ecx, 5
L1: 
	push ecx
	mov ecx, 3
    xor esi, esi
L2: 
	push ecx
    INVOKE GuassMFunc, REAL4 PTR emotions[ebx*4], medianArray[esi]
	pop ecx
	
    mov strArray[edi*4], eax
    
    inc esi
    inc edi
    loop L2
    pop ecx

    inc ebx
    loop L1

    xor eax, eax
    mov tstr, eax
    mov sum, eax

;RULE 1 cae
    mov ecx, 5
    xor esi, esi
    mov ebx, 2
L3: 
    xor edi, edi
    fld1
	push ecx
L4: 
    
    .IF esi == edi
        push esi
        imul esi, 12
        add esi, HIGH_MOOD * 4
        fmul strArray[esi]
        pop esi
    .ELSE 
        push esi
        imul esi, 12
        add esi, LOW_MOOD * 4
        fmul strArray[esi]
        pop esi
    .ENDIF

    inc edi
    loop L4
    fst st(1)
    push ebx
    fild DWORD PTR [esp]
    pop ebx
    fld sum
    fadd
    fstp sum
    fld tstr
    fadd
    fstp tstr

    add ebx, 2
    pop ecx
    inc esi
    loop L3
    
;RULE 2 case
    mov ecx, 5
    xor esi, esi
    mov ebx, 1
L5: 
    xor edi, edi
    fld1
	push ecx
L6: 
    
    .IF esi == edi
        push esi
        imul esi, 12
        add esi, MID_MOOD * 4
        fmul strArray[esi]
        pop esi
    .ELSE 
        push esi
        imul esi, 12
        add esi, LOW_MOOD * 4
        fmul strArray[esi]
        pop esi
    .ENDIF

    inc edi
    loop L6
    fst st(1)
    push ebx
    fild DWORD PTR [esp]
    pop ebx
    fld sum
    fadd
    fstp sum
    fld tstr
    fadd
    fstp tstr

    add ebx, 2
    pop ecx
    inc esi
    loop L5

;RULE 3 case
    mov ecx, 5
    xor esi, esi
    mov ebx, 1
L7: 
    xor edi, edi
    fld1
	push ecx
L8: 
    
    .IF esi == edi
        push esi
        imul esi, 12
        add esi, HIGH_MOOD * 4
        fmul strArray[esi]
        pop esi
    .ELSE 
        push esi
        imul esi, 12
        add esi, MID_MOOD * 4
        fmul strArray[esi]
        pop esi
    .ENDIF

    inc edi
    loop L8
    fst st(1)
    push ebx
    fild DWORD PTR [esp]
    pop ebx
    fld sum
    fadd
    fstp sum
    fld tstr
    fadd
    fstp tstr

    add ebx, 2
    pop ecx
    inc esi
    loop L7

    fld sum
    fld tstr

    fdiv
    fistp ans

    mov eax, ans
    ret

FuzzySystem ENDP
END
