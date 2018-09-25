#!/bin/bash

# Created by Alvin Wong z5076152 s2/2018
# Extracts all .dot and .txt (created when running aspire/s5 scripts)
# NOTE: Not used anymore since changing how transcripts are stored

# Copy all .dot transcripts
find ~/thesis/kaldi/egs/wsj/s5/export/corpora5/ -type f -name '*.dot' | while read line; do
  file=`echo $line | sed 's/\(.*\)\/\(.*\)\.dot$/\2\.dot/'`
  if [[ $line =~ LDC94S13C ]]; then
    filePath="transcripts/LDC94S13C/$file"
  elif [[ $line =~ LDC94S13B ]]; then
    filePath="transcripts/LDC94S13B/$file"
  elif [[ $line =~ LDC93S6A ]]; then
    filePath="transcripts/LDC93S6A/$file"
  fi
  cp $line $filePath
done

# Copy all .txt transcripts
find ~/thesis/databases/original/ -type f -name '*.dot' | sed 's/\(.*\)\/.*\.dot$/\1/' | uniq -u | while read line; do
  for file in "$line"/*; do
    if [[ $file =~ .*\.txt$ ]]; then
      fileName=`echo $file | sed 's/\(.*\)\/\(.*\)\.txt$/\200\.txt/'`
      if [[ $line =~ Other ]]; then
        filePath="transcripts/LDC94S13C/$fileName"
      elif [[ $line =~ Sennheiser ]]; then
        filePath="transcripts/LDC94S13B/$fileName"
      elif [[ $line =~ Complete ]]; then
        filePath="transcripts/LDC93S6A/$fileName"
      fi
      echo "cp $file $filePath"
    fi
  done
done
