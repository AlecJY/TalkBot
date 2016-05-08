.code 
malloc PROTO, p_size : DWORD
free PROTO, p : DWORD
memset PROTO, p : DWORD, chr : DWORD, p_size : DWORD
memcpy PROTO, p1 : DWORD, p2 : DWORD, p_size : DWORD
strtok_r PROTO, p : DWORD, delim : DWORD, saveptr : DWORD
strlen PROTO, p : DWORD