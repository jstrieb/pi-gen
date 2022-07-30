#!/bin/bash

# find . -type f -iname "*package*" \
echo stage2/01-sys-tweaks/00-packages \
  | xargs cat \
  | xargs apt-cache depends \
  | tee dependencies.txt

cat dependencies.txt \
  | sed 's/[[:space:]]*\(Depends\|Breaks\|Suggests\|Replaces\||\)\?:\? \?//g' \
  | sed 's/<\|>//g' \
  | xargs apt-cache show \
  | grep "^\(Package\|Size\)" \
  | sed 's/\(Package\|Size\): //g' \
  | xargs -L 2 echo \
  | sed 's/\([^ ]*\) \(.*\)/\2 \1/g' \
  | sort -n \
  | uniq \
  | tee sizes.txt
