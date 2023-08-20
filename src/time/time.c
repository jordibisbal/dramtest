#include "../../mcc_generated_files/tmr1.h"

long  ticks = 0;
long  TIME_miliseconds = 0;

typedef struct {
    short TIME_OVERFLOW: 1;
} status_t;

status_t TIME_status = {
    0
};

void timeCallBack(void) 
{       
    ticks = ticks + 1;
    
    if (ticks == 0) {
        TIME_status.TIME_OVERFLOW = 1;
    }
}

long timeTicks() {
    return ticks;
}

void timeInitialize(void) 
{
    TMR1_SetInterruptHandler(&timeCallBack);
}