//
//  Header.h
//  
//
//  Created by Jonathan Forbes on 23/05/2023.
//

#ifndef KernelCShimsUUID_h
#define KernelCShimsUUID_h

#include "KernelCShimsTargetConditionals.h"

#if TARGET_OS_MAC
#include <sys/_types.h>
#include <sys/_types/_uuid_t.h>
#else
#include <sys/types.h>
typedef unsigned char __darwin_uuid_t[16];
typedef char __darwin_uuid_string_t[37];
#ifdef uuid_t
#undef uuid_t
#endif
typedef __darwin_uuid_t uuid_t;
#endif

#ifndef KernelCShimsUUIDStringT
#define KernelCShimsUUIDStringT
typedef __darwin_uuid_string_t uuid_string_t;
#endif

#define KernelCShimsUUIDDefine(name,u0,u1,u2,u3,u4,u5,u6,u7,u8,u9,u10,u11,u12,u13,u14,u15) \
    static const uuid_t name __attribute__ ((unused)) = {u0,u1,u2,u3,u4,u5,u6,u7,u8,u9,u10,u11,u12,u13,u14,u15}

#ifdef  __cplusplus
extern "C" {
#endif

void uuid_clear(uuid_t uu);

int uuid_compare(const uuid_t uu1, const uuid_t uu2);

void uuid_copy(uuid_t dst, const uuid_t src);

void uuid_generate(uuid_t out);
void uuid_generate_random(uuid_t out);
void uuid_generate_time(uuid_t out);

int uuid_is_null(const uuid_t uu);

int uuid_parse(const uuid_string_t in, uuid_t uu);

void uuid_unparse(const uuid_t uu, uuid_string_t out);
void uuid_unparse_lower(const uuid_t uu, uuid_string_t out);
void uuid_unparse_upper(const uuid_t uu, uuid_string_t out);


#ifdef __cplusplus
}
#endif

#endif /* KernelCShimsUUID_h */
