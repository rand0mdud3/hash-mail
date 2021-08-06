#!/bin/bash
set -e
export TEST_HMAIL=1
HASHMAIL=./hash-mail
for f in fails/t*; do
    echo ==== $f
    cat $f | $HASHMAIL
done

echo ==== Random
head -c4098 /dev/urandom > tmp.bin
cat tmp.bin | $HASHMAIL
rm -f tmp.bin
