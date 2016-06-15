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
MYDECODE PROC USES esi edx ebx ecx, num:DWORD, deArray:PTR DWORD
    
    mov eax, num
    mov ebx, 3
    xor esi, esi
    mov ecx, 5
L10:idiv ebx
    mov DWORD PTR deArray[esi], edx
    add esi, TYPE DWORD
    loop L10
    ret
MYDECODE ENDP

MYCHECK PROC USES esi edx ecx ebx, deArray:PTR DWORD
    LOCAL maxVar:DWORD, minVar:DWORD, count:DWORD
    mov eax, 5
    mov minVar, eax
    xor eax, eax
    mov maxVar, eax
    mov count, eax
    mov ecx, 5
    xor esi, esi
L13:

    mov eax, DWORD PTR deArray[esi]
    .IF maxVar < eax
        mov maxVar, eax
    .ENDIF
    .IF minVar > eax
        mov minVar, eax
    .ENDIF

    add esi, TYPE DWORD

    loop L13

    mov ecx, 5
    xor esi, esi
L14:
    mov eax,DWORD PTR deArray[esi]
    .IF eax == maxVar
        inc count
    .ENDIF
    loop L14
    
    .IF count == 1
        mov eax, maxVar
        sub eax, minVar
        ret
    .ELSE
        xor eax, eax
        ret
    .ENDIF

MYCHECK ENDP 



FuzzySystem PROC USES ebx ecx edi esi,
    emotions:DWORD
    LOCAL strArray[15]:REAL4, sum:REAL4, tstr:REAL4, ans:DWORD, tmpArray[5]:DWORD

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


    mov ecx, 243
L11:INVOKE MYDECODE, ecx, ADDR tmpArray
    push ecx
    mov ecx, 5
    xor esi, esi
    xor edi, edi
    fld1
L12:
    push esi
    mov edi, tmpArray[esi*4]
    imul esi, 3
    add esi, edi
    fmul strArray[esi*4]
    fst st(1)
    fadd tstr
    fstp tstr
    

    INVOKE MYCHECK, ADDR tmpArray
    push eax
    fimul DWORD PTR [esp]
    pop eax
    fadd sum
    fstp sum
    
    pop esi

    inc esi
    loop L12
    pop ecx
	loop L11


    fld sum
    fld tstr

    fdiv
    fistp ans

    mov eax, ans
    ret

FuzzySystem ENDP
END
