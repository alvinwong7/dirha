#!/bin/bash

for d in $(find /media/alvinwong/8c4606db-e4d3-4263-aad4-c6b284d8d030/alvin/original/WSJ -maxdepth 10 -type d)
do
  nd=`echo $d | sed "s/original/prepared/g"`
  echo "Creating directory $nd"
  mkdir -p $nd
  flag=`expr 0`
  if [ `ls -l $d | wc -l` -gt `ls -l $nd | wc -l` ]; then
    echo "Something's not quite right!"
    for file in "$d"/*; do
      nfile=`echo $file | sed "s/original/prepared/g"`
      nfile=`echo $nfile | sed "s/\.wv1/_1\.wav/g"`
      nfile=`echo $nfile | sed "s/\.wv2/_2\.wav/g"`
      if [[ $file =~ .*\.wv[12]$ ]]; then
        echo "Converting $file"
        ~/Downloads/sph2pipe_v2.5/sph2pipe $file $nfile
      elif [[ ! $file =~ .*\.wv[12]$ ]] && [[ -f $file ]]; then
        echo "Copying $file"
        cp $file $nfile
      fi
    done
  fi
done
echo "Complete!"
