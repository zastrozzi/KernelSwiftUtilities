//
//  Header.h
//  
//
//  Created by Jonathan Forbes on 23/05/2023.
//

#ifndef KernelCShimsTargetConditionals_h
#define KernelCShimsTargetConditionals_h

#if __has_include(<TargetConditionals.h>)
#include <TargetConditionals.h>
#endif

#if (defined(__APPLE__) && defined(__MACH__))
#define TARGET_OS_MAC 1
#else
#define TARGET_OS_MAC 0
#endif

#if defined(__linux__)
#define TARGET_OS_LINUX 1
#else
#define TARGET_OS_LINUX 0
#endif

#if defined(__unix__)
#define TARGET_OS_BSD 1
#else
#define TARGET_OS_BSD 0
#endif

#if defined(_WIN32)
#define TARGET_OS_WINDOWS 1
#else
#define TARGET_OS_WINDOWS 0
#endif

#if defined(__wasi__)
#define TARGET_OS_WASI 1
#else
#define TARGET_OS_WASI 0
#endif


#endif /* KernelCShimsTargetConditionals_h */
