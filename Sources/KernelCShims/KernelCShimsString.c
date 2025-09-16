//
//  uuid.c
//  
//
//  Created by Jonathan Forbes on 23/05/2023.
//

#include "include/KernelCShimsString.h"
#include "include/KernelCShimsTargetConditionals.h"

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <float.h>

int _kernel_cshims_strncasecmp_l(const char * _Nullable s1, const char * _Nullable s2, size_t n, locale_t _Nullable loc) {
#if TARGET_OS_WINDOWS
    static _locale_t storage;
    static _locale_t *cloc = NULL;
    if (cloc == NULL) {
        storage = _create_locale(LC_ALL, "C");
        cloc = &storage;
    }
    return _strnicmp_l(s1, s2, n, loc ? loc : *cloc);
#else
    if (loc != NULL) {
        return strncasecmp_l(s1, s2, n, loc);
    }

#if TARGET_OS_MAC
    return strncasecmp_l(s1, s2, n, NULL);
#else
    locale_t clocale = newlocale(LC_ALL_MASK, "C", (locale_t)0);
    return strncasecmp_l(s1, s2, n, clocale);
#endif
#endif
}

double _kernel_cshims_strtod_l(const char * _Nullable restrict nptr, char * _Nullable * _Nullable restrict endptr, locale_t _Nullable loc) {
#if TARGET_OS_MAC
    return strtod_l(nptr, endptr, loc);
#elif TARGET_OS_WINDOWS
    return _strtod_l(nptr, endptr, loc);
#else
    locale_t clocale = newlocale(LC_ALL_MASK, "C", (locale_t)0);
    locale_t oldLocale = uselocale(clocale);
    double result = strtod(nptr, endptr);
    uselocale(oldLocale);
    return result;
#endif
}

float _kernel_cshims_strtof_l(const char * _Nullable restrict nptr, char * _Nullable * _Nullable restrict endptr, locale_t _Nullable loc) {
#if TARGET_OS_MAC
    return strtof_l(nptr, endptr, loc);
#elif TARGET_OS_WINDOWS
    return _strtof_l(nptr, endptr, loc);
#else
    locale_t clocale = newlocale(LC_ALL_MASK, "C", (locale_t)0);
    locale_t oldLocale = uselocale(clocale);
    float result = strtof(nptr, endptr);
    uselocale(oldLocale);
    return result;
#endif
}

int _kernel_cshims_get_formatted_str_length(double value) {
    char empty[1];
    return snprintf(empty, 0, "%0.*g", DBL_DECIMAL_DIG, value);
}
