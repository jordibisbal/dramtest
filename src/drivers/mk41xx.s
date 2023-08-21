    .include "p24Fxxxx.inc"
    
; Constants    
    
    .equiv init,  0
    
    .equiv NRasBit,   14
    .equiv NCasBit,   13
    .equiv NWriteBit, 12  
    .equiv dataInBit, 15
    .equiv dataOutBit, 11    

    .equiv NCas,   1 << NRasBit
    .equiv NRas,   1 << NCasBit
    .equiv NWrite, 1 << NWriteBit
    .equiv dataOut, 1 << dataOutBit
    
    .equiv dis4ew0, NCas | NRas | ramLatchInit
    .equiv dis4ew1, NCas | NRas | dataOut | ramLatchInit    
    
    .equiv ramLatch,     LATB        
    .equiv ramLatchInit, 0
;; Data
    
    .data      
    .bss
    
    .equiv wewLen,     5
    
    wewPad0: .space wewLen * 2
    wewPad1: .space wewLen * 2
    
; Code  
    
    .text
    .global mk41xxWrite0    
    .global mk41xxPrepareForWrite
    
mk41xxPrepareForWrite:
    
    ; Initialize for 0
    
    mov  #wewPad0, w2
   
    mov  #dis4ew0, w1   ; Init for early write with row address (0)
    mov  w1, [w2]       
    
    bclr w1, #NRasBit	; NRas -> 0
    mov  w1, [w2 + #2]	;  
    
    mov  w1, [w2 + #4]	; Column Address (0) + Data (0)
    
    bclr w1, #NCasBit	; NCas -> 0
    mov  w1, [w2 + #6]	; 
                               
    mov  #dis4ew0, w1	; All signals -> 1
    mov  w1, [w2 + #8]
    
    ; Initialize for 1
    
    mov #wewPad1, w2
   
    mov  #dis4ew1, w1     ; Init for early write with row address (0)
    mov  w1, [w2 + #0]       
    
    bclr w1, #NRasBit	; NRas -> 0
    mov  w1, [w2 + #2]	;  
    
    mov w1, [w2 + #4]	; Column Address (0) + Data (0)
    
    bclr w1, #NCasBit	; NCas -> 0
    mov  w1, [w2 + #6]	; 
                               
    mov  #dis4ew1, w1	; All signals -> 1
    mov  w1, [w2 + #8]
    
    return
        
mk41xxWrite0:   
    ;
    ; Writes a 0
    ;
    ; Input 
    ;	    w0: address (row:7:0::column:7:0)
    ; Modifies
    ;       w1, w2, flags
    
    ; Set address and data on wewPad0
    mov    #wewPad0, w2
       
    mov.B  w0, [w2 + #0]            ; set row address
    mov.B  w0, [w2 + #2]
      
    swap.W w0
    
    mov.B  w0, [w2 + #4]
    mov.B  w0, [w2 + #6]
    
    swap.W w0
    
    ; Send pad
    
    disi #wewLen + 2
    
    mov #ramLatch, w1
    
    mov [w2++], [w1] ; Dis + Row
    mov [w2++], [w1] ; RAS
    mov [w2++], [w1] ; Column
    mov [w2++], [w1] ; Cas
    mov [w2++], [w1] ; Dis
	
    disi #0
     
    return    
    