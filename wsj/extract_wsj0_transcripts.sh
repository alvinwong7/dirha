#!/bin/bash

# Created by Alvin Wong z5076152 s2/2018
# Extracts all .dot and .txt (created when running aspire/s5 scripts)
# NOTE: Not used anymore since changing how transcripts are stored

# Copy all .dot transcripts
wsj0="/home/alvinwong/thesis/databases/transcripts/offline/LDC93S6A/"
i=0
j=0
find ~/thesis/kaldi/egs/wsj/s5/export/corpora5/LDC93S6A -type f -name '*.dot' | while read line; do
  i=$((i+1))
  #echo "$i/3917"
  #echo $line
  if [[ ! $line =~ transcrp ]]; then
    filePath=`echo $line | sed 's/kaldi\/.*\/corpora5/databases\/transcripts\/offline/'`
    j=$((j+1))
    echo "Copying to $filePath"
    cp $line $filePath
  else
    filePath=`echo $line | sed 's/\(.*\)\/\(LDC.*\.dot\)$/\2/'`
    folder=`echo $line | sed 's/.*\/dots\/\(.*\)\/.*\/.*/\1/'`
    subfolder=`echo $line | sed 's/.*\/dots\/.*\/\(.*\)\/.*/\1/'`
    file=`echo $line | sed 's/.*\/\(.*\.dot\)$/\1/'`
    findPath=$wsj0
    find $findPath -name $subfolder | while read lineA; do
    if [[ $lineA =~ $folder && ! $lineA =~ transcrp ]]; then
        echo "Copying to $filePath"
        cp $line "$lineA/$file"
      fi
    done
  fi
done
