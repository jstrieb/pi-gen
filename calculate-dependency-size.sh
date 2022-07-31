#!/bin/bash

echo stage2/01-sys-tweaks/00-packages \
  | xargs cat \
  | tr ' ' '\n' \
  | xargs -L 1 debtree \
  | tee dependency_graph.txt

cat dependency_graph.txt \
  | grep -o -E '"\w+" -> "\w+"' \
  | sed -E -e 's/"(\w+)" -> "(\w+)"/\1\n\2/g' \
  | sort \
  | uniq \
  | xargs apt-cache show \
  | grep -E "^(Package|Size)" \
  | cut -d " " -f 2 \
  | xargs -L 2 echo \
  | sed -E -e 's/(.*) (.*)/\2 \1/g' \
  | sort -n \
  | uniq -f 1 \
  | tee sizes.txt
