#!/bin/bash

. cmd.sh
. path.sh

# Takes (16-bit 8kHz mono) wav file as input
if [[ $# -ge 1 ]]; then
  fin=$1
else
  fin="tmp.wav"
fi
if [[ $# -eq 2 ]]; then
  fout=$2
else
  fout="output.txt"
fi
if [[ $fin =~ .*\.wav ]]; then
  online2-wav-nnet3-latgen-faster --online=true \
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
    'scp,p:echo utterance-id1 "'$fin'" |' \
    'ark:|~/thesis/kaldi/src/latbin/lattice-best-path --acoustic-scale=0.1 ark,t:- ark,t:- | ~/thesis/kaldi/egs/aspire/s5/utils/int2sym.pl -f 2- exp/tdnn_7b_chain_online/graph_pp/words.txt | cut -d " " -f2- >> "'$fout'"'
  echo "COMPLETE"
else
  echo "Not a wav file"
fi
