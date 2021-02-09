#ifndef STRNUM_UTILS_H
#define STRNUM_UTILS_H
#include <stddef.h>

int wrap(int s1);

/// <s1><pos>_<s2>
int join(int s1, int pos, int s2);

/// <s1> <pos> <s2>
int mix(int s1, int pos, int s2);

/// <s1><s2>
int concat(int s1, int s2);

// save str1 to mem
// int keep(const char *str1);

/// assign <s1> to <temp>
int eval(int s1);

/// a new temp variable name
int get_temp();

/// return string cell i holds
/// if i<0 then it returns empty str
/// else if i in [0,9] then return their name
/// else if i in [10,18] then return reserved key strings
/// else return string allocated in that cell i'th
const char *get_str(int i);

int alloc_str(size_t len);

void free_str();

#endif //STRNUM_UTILS_H
