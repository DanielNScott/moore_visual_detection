#!/bin/bash

name=${1}
path=${2}

cmd='matlab -nosplash -nodesktop -r "addpath(genpath(pwd())); ps.path='"'"'$path'"'"'; ps.fname=['"'"'$name'"'"','"'"'.mat'"'"']; try; run_analysis; catch ME; disp(ME); end; exit;"'
eval $cmd 1>${path}${name}.out 2>${path}${name}.err

