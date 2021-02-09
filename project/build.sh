set -e

lexV="${lexV:-3}" # define lexVersion if not defined
genDir="./gen"
outDir="./out"
binFile="$outDir/strnum"

## regenerate all generated sources
#rm -rf "$genDir"
#rm -rf "$outDir"
mkdir -p "$genDir"
mkdir -p "$outDir"

yacc -d -o "$genDir/numstr.tab.c" "./src/numstr.y"          # parse yacc/bison rules

flex -d -o "$genDir/numstr.yy.c" "./src/numstr-v$lexV.l"    # parse lex/flex rules

gcc -o  "$binFile" \
        "$genDir/numstr.tab.c" "$genDir/numstr.tab.h" \
        "$genDir/numstr.yy.c" \
        "./src/utils.c" "./src/utils.h"

echo "$binFile"
