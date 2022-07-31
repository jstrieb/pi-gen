#!/bin/bash

if [ ! -f dependency_graph.txt ]; then
  echo Calculating dependencies...

  # find . -type f -iname "*packages*" \
  echo stage2/01-sys-tweaks/00-packages \
    | xargs cat \
    | tr ' ' '\n' \
    | xargs -L 1 debtree \
    | tee dependency_graph.txt
fi

echo Calculating sizes...

cat dependency_graph.txt \
  | grep -o -E '".+" -> ".+"' \
  | sed -E -e 's/"(.+)" -> "(.+)"/\1\n\2/g' \
  | sort \
  | uniq \
  | xargs apt-cache show \
  | grep -E "^(Package|Size)" \
  | cut -d " " -f 2 \
  | xargs -L 2 echo \
  | sort -k 2 -n \
  | uniq -f 1 \
  | tee sizes.txt
