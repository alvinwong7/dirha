#!/bin/bash

# Created by Alvin Wong z5076152 s2/2018
# Extracts all .dot and .txt (created when running aspire/s5 scripts)
# NOTE: Not used anymore since changing how transcripts are stored

# Copy all .dot transcripts
senn="/home/alvinwong/thesis/databases/transcripts/online/LDC94S13B/"
oth="/home/alvinwong/thesis/databases/transcripts/online/LDC94S13C/"
i=0
j=0
find ~/thesis/kaldi/egs/wsj/s5/export/corpora5/LDC94S13B -type f -name '*.dot' | while read line; do
  i=$((i+1))
  echo "$i/3917"
  #echo $line
  if [[ ! $line =~ trans ]]; then
    filePath=`echo $line | sed 's/kaldi\/.*\/corpora5/databases\/transcripts\/online/'`
    j=$((j+1))
    echo "Copying to $filePath"
    #cp $line $filePath
  else
    filePath=`echo $line | sed 's/\(.*\)\/\(LDC.*\.dot\)$/\2/'`
    folder=`echo $line | sed 's/.*\/trans\/wsj1\/\(.*\)\/.*\/.*/\1/'`
    subfolder=`echo $line | sed 's/.*\/\(.*\)\/[a-zA-Z0-9]*\.dot/\1/'`
    file=`echo $line | sed 's/.*\/\(.*\.dot\)$/\1/'`
    if [[ $line =~ LDC94S13B ]]; then
      findPath=$senn
    elif [[ $line =~ LDC94S13C ]]; then
      findPath=$oth
    fi
    #echo "$folder/$subfolder"
    find $findPath -name $subfolder | while read lineA; do
      #echo $lineA | sed 's/.*\/LDC/LDC/'
      #echo $folder
      if [[ $folder =~ / ]]; then
        folderOne=`echo $folder | sed 's/\(.*\)\/.*/\1/'`
        folderTwo=`echo $folder | sed 's/.*\/\(.*\)/\1/'`
        #echo "$folderOne/$folderTwo"
        if [[ ( $lineA =~ $folderOne ) && ( $lineA =~ $folderTwo ) ]]; then
          echo "Copying to $lineA/$file"
          cp $line "$lineA/$file"
        fi
      else
        if [[ $lineA =~ $folder ]]; then
          echo "Copying to $lineA/$file"
          cp $line "$lineA/$file"
        fi
      fi
    done
  fi
done
