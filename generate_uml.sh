#!/usr/bin/env bash

last_step=$1

tmp=$(mktemp)

cd diagram-components/

for i in $(seq 0 $1); do
cat $i >> $tmp
done
cat 3_footer >> $tmp

cd ../
tac $tmp | sed 's/^.*(/:/;s/) then/;/' |tac > model
plantuml model
rm model
rm $tmp
