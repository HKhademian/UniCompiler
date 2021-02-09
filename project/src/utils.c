#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "utils.h"

#define NAMES_FIX 19

const char *NAMES[NAMES_FIX] = {
		"Zer", "One", "Two", "Thr", "Fou", "Fiv", "Six", "Sev", "Eig", "Nin",
		/*10*/ "Ten", /*11*/ "Hun", /*12*/ "Tou", /*13*/ "Mil", /*14*/ "Bil",
		/*15*/ "Plu", /*16*/ "Min", /*17*/ "Mul", /*18*/ "Div"
};

char *strings[1000] = {0};

int alloc_str(size_t len)
{
	static int last_str = 0;
	char *str = strings[last_str] = malloc(len + 1);
	*(str + len) = '\0';
	// printf("alloc str %d size %d\n", last_str, len);
	return NAMES_FIX + last_str++;
}

const char *get_str(int i)
{
	return i < 0 ? "" : i < NAMES_FIX ? NAMES[i] : strings[i - NAMES_FIX];
}

void free_str()
{
	for (int i = 0; strings[i] != 0; i++)
		free(strings[i]), strings[i] = 0;
}

int join(int s1, int pos, int s2)
{
	const char *str1 = get_str(s1), *strPos = get_str(pos), *str2 = get_str(s2);
	const size_t len1 = strlen(str1), lenPos = strlen(strPos), len2 = strlen(str2);
	int result = alloc_str(len1 + lenPos + 1 + len2 + 1);
	char *str = (char *)get_str(result);

	memcpy(str, str1, len1), str += len1;
	memcpy(str, strPos, lenPos), str += lenPos;
	*str = '_', str += 1;
	memcpy(str, str2, len2), str += len2;
	*str = '\0';

	return result;
}

int mix(int s1, int pos, int s2)
{
	const char *str1 = get_str(s1), *strPos = get_str(pos), *str2 = get_str(s2);
	const size_t len1 = strlen(str1), lenPos = strlen(strPos), len2 = strlen(str2);
	int result = alloc_str(len1 + lenPos + 2 + len2 + 1);
	char *str = (char *)get_str(result);

	memcpy(str, str1, len1), str += len1;
	*str = ' ', str += 1;
	memcpy(str, strPos, lenPos), str += lenPos;
	*str = ' ', str += 1;
	memcpy(str, str2, len2), str += len2;
	*str = '\0';

	return result;
}

int concat(int s1, int s2)
{
	const char *str1 = get_str(s1), *str2 = get_str(s2);
	const size_t len1 = strlen(str1), len2 = strlen(str2);
	int result = alloc_str(len1 + len2 + 1);
	char *str = (char *)get_str(result);

	memcpy(str, str1, len1), str += len1;
	memcpy(str, str2, len2), str += len2;
	*str = '\0';

	return result;
}

// int keep(const char *str1)
// {
// 	const size_t len1 = strlen(str1);
// 	int result = alloc_str(len1 + 1);
// 	char *str = (char *)get_str(result);
// 	memcpy(str, str1, len1), str += len1;
// 	*str = '\0';
// 	return result;
// }

int wrap(int s1)
{
	const char *str1 = get_str(s1);
	const size_t len1 = strlen(str1);
	int result = alloc_str(len1 + 2 + 1);
	char *str = (char *)get_str(result);

	*str = '(', str += 1;
	memcpy(str, str1, len1), str += len1;
	*str = ')', str += 1;
	*str = '\0';

	return result;
}

int eval(int $1)
{
	// int s = alloc_str(1000);
	int t = get_temp();
	//char *buffer = (char *) get_str(s);
	// sprintf(buffer, "Assign %s to %s", get_str($1), get_str(t));
	printf("Assign %s to %s\n", get_str($1), get_str(t));
	return t;
}

int get_temp()
{
	static int last_temp = 1;
	int t = alloc_str(5);
	char *str = (char *)get_str(t);
	sprintf(str, "t%d", last_temp++);
	return t;
}
