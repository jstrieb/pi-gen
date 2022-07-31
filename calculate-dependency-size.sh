#!/bin/bash

if [ ! -f dependency_graph.txt ]; then
  # echo stage2/01-sys-tweaks/00-packages \
  find . -type f -iname "*packages*" \
    | xargs cat \
    | tr ' ' '\n' \
    | xargs -L 1 debtree \
    | tee dependency_graph.txt
fi

cat dependency_graph.txt \
  | grep -o -E '"\w+" -> "\w+"' \
  | sed -E -e 's/"(\w+)" -> "(\w+)"/\1\n\2/g' \
  | sort \
  | uniq \
  | xargs apt-cache show \
  | grep -E "^(Package|Installed-Size)" \
  | cut -d " " -f 2 \
  | xargs -L 2 echo \
  | sed -E -e 's/(.*) (.*)/\2 \1/g' \
  | sort -n \
  | uniq -f 1 \
  | tee sizes.txt
