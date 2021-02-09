set -e

binFile=$(./build.sh)

function testcase() {
    printf "TestCase \"$1\":\n"
    echo "$1" | "$binFile"
    printf "\n\n"
}

testcase "12925"

testcase "2840*(106+5)"

testcase "(106+5)*2840"

testcase "106+5*2840"

testcase "we are in 2021"

testcase "1+2*3-7/5*3-1+4*3/7+2"
