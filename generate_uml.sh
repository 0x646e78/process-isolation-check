#!/usr/bin/env bash

function echo_exit {
  echo $1
  exit 1
}

$(which docker 2&>1 /dev/null) || echo_exit "No image generated. Needs docker for image generation."

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
