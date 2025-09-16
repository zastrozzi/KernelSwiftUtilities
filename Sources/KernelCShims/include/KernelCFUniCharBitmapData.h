//
//  Header.h
//  
//
//  Created by Jonathan Forbes on 23/05/2023.
//

#ifndef KernelCFUniCharBitmapData_h
#define KernelCFUniCharBitmapData_h

#include "KernelCStdLib.h"

typedef struct {
    uint32_t _numPlanes;
    uint8_t const * const * const  _planes;
} __KernelCFUniCharBitmapData;

#endif /* KernelCFUniCharBitmapData_h */
