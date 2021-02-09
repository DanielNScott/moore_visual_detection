#!/bin/bash

# Get the data path from the shared source file
. ./defdatapath.sh
#path='../parvalbuminCells/safe/'

files=`ls $path`
files=$(echo $files | tr "\s" "\n")

echo 'Running jobs for folder '$path
for f in $files
do
    echo 'Submitting batch for file '$f

    name=$(echo $f| cut -d'.' -f 1)
    sbatch -J $name -t 00:02:00 job.sh $name $path 1>${path}${name}.out 2>${path}${name}.err
done
