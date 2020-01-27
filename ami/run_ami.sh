#!/bin/bash

if [ ! $# -eq 1 ]; then
  echo "Inappropriate args"
  echo "Usage: $0 <REGEX for ami>"
  exit 1
fi

finding="amicorpus/$1"

. cmd.sh
. path.sh
for line in $(find /media/alvinwong/8c4606db-e4d3-4263-aad4-c6b284d8d030/alvin/prepared/amicorpus -maxdepth 10 -type d); do
  nd=`echo $line | sed 's/.*\/amicorpus/\/home\/alvinwong\/thesis\/databases\/transcripts\/offline\/amicorpus/'`
  #echo "Creating directory $nd"
  mkdir -p $nd
  if [[ $line =~ $finding ]]; then
    for file in $line/*; do
      if [[ $file =~ wav ]]; then
        ftest=`echo $file | sed 's/.*\///' | sed 's/\.wav/.txt/'`
        fout="$nd/$ftest"
        echo $fout
        online2-wav-nnet3-latgen-faster --online=false \
          --do-endpointing=false \
          --frame-subsampling-factor=3 \
          --config=exp/tdnn_7b_chain_online/conf/online.conf \
          --max-active=7000 \
          --beam=15.0 \
          --lattice-beam=6.0 \
          --acoustic-scale=1.0 \
          --word-symbol-table=exp/tdnn_7b_chain_online/graph_pp/words.txt \
          exp/tdnn_7b_chain_online/final.mdl \
          exp/tdnn_7b_chain_online/graph_pp/HCLG.fst \
          'ark:echo utterance-id1 utterance-id1|' \
          'scp,p:echo utterance-id1 "'$file'" |' \
          'ark:|~/thesis/kaldi/src/latbin/lattice-best-path --acoustic-scale=0.1 ark,t:- ark,t:- | ~/thesis/kaldi/egs/aspire/s5/utils/int2sym.pl -f 2- exp/tdnn_7b_chain_online/graph_pp/words.txt | cut -d " " -f2- >> "'$fout'"'
      fi
    done
  fi
done
