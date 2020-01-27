#!/bin/bash

find transcripts/offline/amicorpus/ -maxdepth 14 -type f -name 'ref.txt' | while read ref; do
  name=`echo $ref | sed 's/.*\/amicorpus\/\(.*\)\/audio.*/\1/'`
  hyp=`find transcripts/offline/amicorpus/ -maxdepth 13 -type f -name "$name*"`
  cat $hyp | sed 's/\[[^\[]*\]//g' | sed 's/\._/./g' | sed 's/ *<unk> */ /g' | sed 's/ *mhm */ /g'> hyp.txt
  cat $ref | sed 's/\.//g' | sed 's/[Mm]m-hmm//g' | sed 's/ *[Hh]mm */ /g' | sed 's/ *[Mm]m */ /g' | sed 's/[,\.?]//g' | sed 's/_/./g' | tr '[:upper:]' '[:lower:]' > ref.txt
  echo "Calculating WER for $name"
  wer ref.txt hyp.txt >> log.txt
  rm ref.txt hyp.txt
done
