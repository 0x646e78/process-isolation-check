#!/usr/bin/env bash

last_step=$1

tmp=$(mktemp)

cd diagram-components/

for i in $(seq 0 $1); do
cat $i >> $tmp
done
cat 3_footer >> $tmp

cd ../
tac $tmp | sed '0,/^.*(/s/^.*(/:/;0,/) then/s/) then/;/' |tac > model

docker run --rm -v $(pwd):/opt/plantuml/src/ ectoplasm/plantuml:latest model

rm model
rm $tmp
