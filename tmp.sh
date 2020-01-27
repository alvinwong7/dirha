#!/bin/bash

for line in $(find ~/thesis/databases/wav/SNR -type f -name '*.wav'); do
  if [[ $line =~ p ]]; then
    fout=`echo $line | sed 's/\.wav/.txt/'`
    ./test.sh $line $fout &
  fi
done
