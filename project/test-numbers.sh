set -e

binFile=$(./build.sh)

function testcase() {
    printf "TestCase \"$1\":\n"
    echo "$1" | "$binFile"
    printf "\n\n"
}

testcase "1"
testcase "21"
testcase "321"
testcase "4321"
testcase "54321"
testcase "654321"
testcase "7654321"
testcase "87654321"
testcase "987654321"
testcase "1987654321"
testcase "21987654321"
testcase "321987654321"
