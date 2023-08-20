#include "mcc_generated_files/system.h"
#include "src/time/time.h"
#include "src/mains.h"


void initialize() {    
    timeInitialize();
}

int main(void)
{
    // initialize the device
    SYSTEM_Initialize();
    initialize();    
    
    mains();

    return 1;
}
/**
 End of File
*/

