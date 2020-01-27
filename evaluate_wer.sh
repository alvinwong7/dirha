#!/bin/bash

# Evaluating WER from results
for file in results/*; do
  cat $file | grep 'WER' | sed 's/%.*//' | sed 's/WER: *//' > data.txt
  echo $file
  awk '{s+=$1}END{print "WER:",(NR?s/NR:"NaN"),"%"}' RS=" " data.txt
done
