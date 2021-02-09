set -e

binFile=$(./build.sh)

printf "Use EOF to end your input [ctrl+d maybe]\n"
"$binFile"
