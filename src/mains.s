    .include "p24Fxxxx.inc"
    
# Data
    
    .data      
    
    .bss
    buffer: .space 16 * 2
    
    .global buffer
    
# Code  
    
    .text
    .global _mains    
    
_mains: 
    inc w0, w0
    call mk41xxWrite0
    
    bra _mains
    