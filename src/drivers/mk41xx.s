    .include "p24Fxxxx.inc"
    
# Constants    
    
    .equ NCas,   0x4000
    .equ NRas,   0x2000    
    .equ NWrite, 0x1000    
    
    .equ NRasBit,   14
    .equ NCasBit,   13
    .equ NWriteBit, 12    
    
    .equ dataIn, 15
    .equ dataOut, 11
    
    .equ ramLatch, LATB        
# Data
    
    .data      
    .bss
    
# Code  
    
    .text
    .global mk41xxWrite0    
    
      
mk41xxWrite0:   
    ;
    ; Writes a 0
    ;
    ; Input 
    ;	    w0: address (row:7:0::column:7:0)
    ; Modifies
    ;       w1, flags
    
    ; Populates the stack with the stages in REVERSE ORDER (6 levels)
    .equ stages, 0
    mov ramLatch, w1
    
    mov #(NCas | NRas | NWrite), w1 ; All signals -> 1
    .equ stages, stages + 1
    push w1    
    
    clr   w1                        ; All signals -> 0
    swap.W w0                       ; Set address (column)
    mov.b w0, w1                    ; 
    .equ stages, stages + 1
    push  w1
    
    bset w1, #NCasBit		    ; CAS 1 -> 0
    .equ stages, stages + 1
    push w1
    
    swap.W w0                       ; Set address (row)
    mov.b w0, w1                    ;
    
    .equ stages, stages + 1
    push w1                         
    
    bset w1, #NWriteBit             ; Write 1 -> 0
    .equ stages, stages + 1
    push w1
    
    bset w1, #NRasBit               ; RAS 1 -> 0
    .equ stages, stages + 1
    push w1   
    
    ; Disable interrupts
    
    disi #(stages + 1)
    
    ; Send the stages    
    
    repeat #(stages - 1)
    pop ramLatch ; set Data
		 ; signal NRAS
		 ; signal NWRITE
		 ; set Column
		 ; signal NCAS
		 ; signal end
		 
    ; Enable interrupts
    
    disi #0	
     
    return
    