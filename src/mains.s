    .include "p24Fxxxx.inc"
    
# Data
    .data              
    
# Code  
    
    .text
    .global _mains    
    
_mains: 
    call mk41xxPrepareForWrite
    clr w0
loop:        
    call mk41xxWrite0
    inc w0, w0
    
    bra loop
    