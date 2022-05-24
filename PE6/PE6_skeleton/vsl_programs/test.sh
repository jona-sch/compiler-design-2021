#!/bin/sh

print_help() {
    echo "Usage: ./test.sh [-v|-h|-q]
        -v, --verbose   Print output from successful tests as well
        -q, --quiet     Don't print diagnostics for failed tests
        -h, --help      Print this message and exit"
    exit $1
}
verbose=0
diagnostics=1
space='.'

# Parse arguments 
for arg in "$@"; do
    case $arg in
    -v|--verbose)
        verbose=1
    ;;
    -h|--help) 
        print_help 0
    ;;
    -q|--help)
        diagnostics=0
    ;;
    *)
        echo "unexpected argument $arg"
        print_help 1
    ;;
    esac
done

# Color escape codes
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
RST="\e[0m"
BOLD="\e[1m"
ULIN="\e[4m"
BRED="\e[48;5;1m"


bindir=.      # Set directory of binaries
temp=$(mktemp)      # Generate some temporary files
expout=$(mktemp)

testcase() {
    echo "${BOLD}Test: $prgm${RST}"
    $bindir/$prgm > $temp
    exit_code=$?
    if [ $verbose -eq 1 ]
    then 
        cat $temp
    fi
    if [ $exit_code -ne $code ]
    then
        echo "${YELLOW}Warning: $prgm expected exit code $code but got $exit_code${RST}"
    fi
    diff -q  $temp $expout > /dev/null
    if [ $? -ne 0 ]
    then
        if [ $diagnostics -ne 1 ]; then 
            echo "  ${RED}Failed.${RST}"
        else
            echo "${RED}${BOLD}Test failed, expected output (space shown as '$space'):${RST}${RED}"
            cat $expout | tr ' ' '.'
            echo "${RED}${BOLD}Got output:${RST}${RED}"
            cat $temp | tr ' ' '.'
            echo "${RST}${YELLOW}Diff:\n$(diff $temp $expout)${RST}"
        fi
    else
        echo "  ${GREEN}Passed.${RST}"
    fi
}

# Add a test
# # Test n: prgm
# prgm="$bindir arg0 arg1..."  
# printf "expected output" > $expout
# code=<expected exit code>


# Test 1: multi_hello
prgm=multi_hello
printf "1 2 3 4 5 6 7 8 \nMorna \n42 15 8 \n1 \n" > $expout
code=1
testcase

# Test 2: while_test
prgm=while_test
printf "20 \nfoobar \n19 \n18 \n17 \n16 \n15 \n14 \n13 \n12 \n11 \n10 \nSkip... \n8 \n7 \n6 \n5 \n4 \n3 \n2 \n1 \n0 \n" > $expout
code=0
testcase

#Test 3: trouble(1)
prgm="trouble 1"
printf "wang \n" > $expout
code=1
testcase

# Test 4: uminus
prgm=uminus
printf "a is 100 and b is 20 \na/(-b) is -5 \n10/(-2) is -5 \n" > $expout
code=0
testcase

# Test 5: return_nested
prgm="return_nested"
printf "t is 128 \n" > $expout
code=0
testcase

# Test 6: precedence
prgm="precedence"
printf "2*(3-1) :=  4 \n2*3-1 :=  5 \n" > $expout
code=0
testcase

# Test 7: bitops(0, 0)
a=0
b=0
prgm="bitops $a $b"
printf "a is $a and b is $b \n\
~ $a = $((~$a)) \n\
$a | $b = $(($a | $b)) \n\
$a ^ $b = $(($a ^ $b)) \n\
$a & $b = $(($a & $b)) \n\
$a << $b = $(($a << $b)) \n\
$a >> $b = $(($a >> $b)) \n" > $expout
code=0
testcase

# Test 8: bitops(1, 0)
a=1
b=0
prgm="bitops $a $b"
printf "a is $a and b is $b \n\
~ $a = $((~$a)) \n\
$a | $b = $(($a | $b)) \n\
$a ^ $b = $(($a ^ $b)) \n\
$a & $b = $(($a & $b)) \n\
$a << $b = $(($a << $b)) \n\
$a >> $b = $(($a >> $b)) \n" > $expout
code=0
testcase

# Test 9: bitops(255, 2)
a=255
b=2
prgm="bitops $a $b"
printf "a is $a and b is $b \n\
~ $a = $((~$a)) \n\
$a | $b = $(($a | $b)) \n\
$a ^ $b = $(($a ^ $b)) \n\
$a & $b = $(($a & $b)) \n\
$a << $b = $(($a << $b)) \n\
$a >> $b = $(($a >> $b)) \n" > $expout
code=0
testcase

# Test 10: bitops(10101010, 2048)
a=10101010
b=2048
prgm="bitops $a $b"
printf "a is $a and b is $b \n\
~ $a = $((~$a)) \n\
$a | $b = $(($a | $b)) \n\
$a ^ $b = $(($a ^ $b)) \n\
$a & $b = $(($a & $b)) \n\
$a << $b = $(($a << $b)) \n\
$a >> $b = $(($a >> $b)) \n" > $expout
code=0
testcase

# Test 11: bitops(9223372036854775808, 1)
a=9223372036854775808 # 2^63
b=2
prgm="bitops $a $b"
printf "a is $a and b is $b \n\
~ $a = $((~$a)) \n\
$a | $b = $(($a | $b)) \n\
$a ^ $b = $(($a ^ $b)) \n\
$a & $b = $(($a & $b)) \n\
$a << $b = $(($a << $b)) \n\
$a >> $b = $(($a >> $b)) \n" > $expout
code=0
testcase

# Test 12: bitops(9223372036854775809, 1)
a=-1 
b=2
prgm="bitops $a $b"
printf "a is $a and b is $b \n\
~ $a = $((~$a)) \n\
$a | $b = $(($a | $b)) \n\
$a ^ $b = $(($a ^ $b)) \n\
$a & $b = $(($a & $b)) \n\
$a << $b = $(($a << $b)) \n\
$a >> $b = $(($a >> $b)) \n" > $expout
code=0
testcase

# Test 13: simplefun
prgm="simplefun"
printf "Parameter s is 5 t is  10 \n" > $expout
code=0
testcase
