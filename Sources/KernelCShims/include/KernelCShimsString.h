//
//  Header.h
//  
//
//  Created by Jonathan Forbes on 23/05/2023.
//

#ifndef KernelCShimsString_h
#define KernelCShimsString_h

#include <locale.h>
#include <stddef.h>

#if __has_include(<xlocale.h>)
#include <xlocale.h>
#endif

#if defined(_WIN32)
#define locale_t _locale_t
#endif

int _kernel_cshims_strncasecmp_l(const char * _Nullable s1, const char * _Nullable s2, size_t n, locale_t _Nullable loc);

double _kernel_cshims_strtod_l(const char * _Nullable restrict nptr, char * _Nullable * _Nullable restrict endptr, locale_t _Nullable loc);

float _kernel_cshims_strtof_l(const char * _Nullable restrict nptr, char * _Nullable * _Nullable restrict endptr, locale_t _Nullable loc);

int _kernel_cshims_get_formatted_str_length(double value);

#endif /* KernelCShimsString_h */
