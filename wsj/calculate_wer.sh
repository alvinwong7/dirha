#!/bin/bash

# Created by Alvin Wong z5076152 s2/2018
# Run extract_transcript.sh first
# Compare WSJ transcripts and text files

if [ ! $# -eq 1 ];then
  echo "Wrong amount of arguments"
  exit 1
fi

find $1 -type f -name '*.txt' | while read line; do
  hyp=$line
  ref=`echo $hyp | sed 's/txt/dot/'`
  if [ -f $ref ]; then
    #echo "Comparing $ref and $hyp"
    # For Kaldi:
      # delete [noise]
      # change ._ --> .
    cat $hyp | sed 's/\[[^\[]*\] *//g' | sed 's/\._/./g' | sed 's/ *<unk> */ /g' > hyp.txt
    # For WSJ:
      # delete file name e.g. (4p8s01.wav)
      # delete type of noise e.g. [lip_smack]
      # change [uh] --> uh
      # remove pauses e.g. which . indicate
      # remove <> and <*laughter*>
      # change \.POINT, \%PERCENT, \.PERIOD, etc. to corresponding characters
      # remove stutter f- for --> for, y- u.s --> u.s
    cat $ref | sed 's/ (.*)//' | sed 's/\\\.POINT/point/g' | sed 's/\\%PERCENT/percent/g' | sed 's/\\\.PERIOD/period/g' | sed 's/\\"CLOSE\\-QUOTE/close quote/g' | sed 's/\\"DOUBLE-QUOTE/double quote/g' | sed 's/\\"DOUBLE\\-QUOTE/double quote/g' | sed 's/\\"QUOTE/quote/g' | sed 's/\\.COMMA/comma/g' | sed 's/\\-HYPHEN/hyphen/g' | sed 's/\\-\\-DASH/dash/g' | sed 's/\\\/SLASH/slash/g' | sed 's/\\\.\\\.\\\.ELLIPSIS/ellipsis/g' | sed 's/\:COLON/colon/g' | sed 's/\\?QUESTION\\-MARK/question mark/g' | sed 's/\&AMPERSAND/ampersand/g' | sed 's/\\{LEFT-BRACE/left brace/g' | sed 's/\\}RIGHT-BRACE/right brace/g' | sed 's/\\(LEFT-PAREN/left parenthesis/g' | sed 's/\\)RIGHT-PAREN/right parenthesis/g' | sed 's/\\~//g' | sed 's/\[uh\]/uh/g' | sed 's/^ //'|sed 's/\[[^\[]*\]//g' | sed 's/\\-/-/g' | sed 's/\\"/"/g' | sed "s/\\[\'\.]/'/g" | sed 's/Mr\\./mister/g' | sed 's/\\\. \([^a-z]\)/.\1/g' | sed 's/[<>\*()]//g' | sed 's/ [a-z]*- / /g' | sed 's/ \. / /g' | sed 's/://g' | tr '[:upper:]' '[:lower:]' > ref.txt
    wer ref.txt hyp.txt >> log.txt
    wer=`wer ref.txt hyp.txt | grep 'WER' | sed 's/WER: *//' | sed 's/\..*//' | sed 's/ *//'`
    if (( $wer > 40 )); then
      echo $ref
    fi
    rm ref.txt hyp.txt
#  else
#    echo "Missing $ref"
  fi
done
