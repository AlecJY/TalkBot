INCLUDE fuzzySystem.inc 


exp PROC,
    x:REAL4
    
    movzx eax, 256
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
    
    movzx eax, 1
    push eax
    fild dword ptr[esp]
    fdiv
    fst dword ptr[esp]
    
    call exp
    pop
    ret
GuassMFunc ENDP

.data
medianArray REAL4  0,3,5
LOW = 0
MID = 1
HIGH = 2

.code
FuzzySystem PROC USES ebx ecx edi esi,
    emotions:DWORD
    LOCAL strArray[15]:REAL4, sum:REAL4, tstr:REAL4, ans:DWORD

    xor esi, esi
    xor ebx, ebx

    movzx ecx, 5
L1: push ecx
    movzx ecx, 3
    xor esi, esi
L2: push ecx
    
    INVOKE GuassMFunc, REAL4 PTR emotions[ebx*4], medianArray[esi]

    mov strArray[edi], eax
    
    inc esi
    inc edi
    loop L2
    pop ecx

    inc ebx    
    loop L1
    pop ecx

    xor eax, eax
    mov tstr, eax
    mov sum, eax

;RULE 1 cae
    movzx ecx, 5
    xor esi, esi
    movzx ebx, 2
L3: push ecx
    xor edi, edi
    fld1
L4: push ecx
    
    .IF esi == edi
        fmul strArray[esi * 3 + HIGH]kk
    .ELSE 
        fmul strArray[esi * 3 + LOW]
    .ENDIF

    inc edi
    loop L4
    fst st(1)
    fild ebx
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
    movzx ecx, 5
    xor esi, esi
    movzx ebx, 1
L5: push ecx
    xor edi, edi
    fld1
L6: push ecx
    
    .IF esi == edi
        fmul strArray[esi * 3 + MID]
    .ELSE 
        fmul strArray[esi * 3 + LOW]
    .ENDIF

    inc edi
    loop L6
    fst st(1)
    fild ebx
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
    movzx ecx, 5
    xor esi, esi
    movzx ebx, 1
L7: push ecx
    xor edi, edi
    fld1
L8: push ecx
    
    .IF esi == edi
        fmul strArray[esi * 3 + HIGH]
    .ELSE 
        fmul strArray[esi * 3 + MID]
    .ENDIF

    inc edi
    loop L8
    fst st(1)
    fild ebx
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
