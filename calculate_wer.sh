#!/bin/bash

# Created by Alvin Wong z5076152 s2/2018
# Run extract_transcript.sh first
# Compare transcripts and text files

find ~/thesis/databases/transcripts/offline/LDC94S13C/ -type f -name '*.txt' | while read line; do
  hyp=$line
  ref=`echo $hyp | sed 's/txt/dot/'`
  if [ -f $ref ]; then
    echo "Comparing $ref and $hyp"
    cat $hyp | sed 's/mister/mr./g' | sed 's/\[noise\]//g' | sed 's/\._/./g' > hyp.txt
    cat $ref | sed 's/ (.*)//' | sed 's/\\\.POINT/point/g' | sed 's/\\%PERCENT/percent/g' | sed 's/\[.*\]/<unk>/g' | sed 's/\\-/-/g' | sed 's/\\"/"/g' | sed "s/\\\'/'/g" | sed 's/\\\././g' | tr '[:upper:]' '[:lower:]' > ref.txt
    python wer.py ref.txt hyp.txt >> log.txt
    rm ref.txt hyp.txt
  else
    echo "Missing $ref"
  fi
done
