#!/bin/bash

# Defines the location of data as $path
. ./defdatapath.sh

#
callpath=`pwd`
cd $path
matlab  -nosplash -nodesktop -r "files = ls('*_proc.mat','-1'); files = split(files); agg={}; for i=1:numel(files); try; load(files{i}); agg{i}=proc; end; end; save('agg.mat','agg'); exit;"

cd $callpath
