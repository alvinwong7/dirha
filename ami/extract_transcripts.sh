#!/bin/bash

for file in ~/thesis/databases/transcripts/ami/*; do
  name=`echo $file | sed 's/.*\///' | sed 's/\.[A-Z]\.words\.xml//'`
  cat $file | sed 's/<[^<]*>//g' | sed 's/ *//g' | sed "s/&#39;/'/" | tr '\n' ' ' | sed 's/\t/ /g' |sed 's/ +/ /g' | sed 's/ \([\.,?]\)/\1/g' > tmp.txt
  for line in $(find ~/thesis/databases/transcripts/offline/amicorpus -maxdepth 14 -type d -name $name); do
    cat tmp.txt >> "$line/audio/ref.txt"
  done
  rm tmp.txt
done
