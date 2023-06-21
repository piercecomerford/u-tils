#!/bin/bash

# Takes ground-state energies for each U_in
# Assumes a *LOT* about directory structure

for d in ./*/; do
 cd $d/0.0
 # So that the slurm.out files play nice
 # this spits out lots of errors which i to be honest do not care about
 # and which makes it difficult to pipe this script into a .py;
 # thus the redirect to /dev/null
 &>/dev/null mv slurm* slurm_output

# Grab the total energy from the output files (relies on convergence to work but does not in fact assume it)
 fulline=$(grep -h -n '<--' *.out)
 arr=($fulline)
 TotalEnergy=$(echo ${arr[3]})
 E+=("$TotalEnergy,")

# Grab the DFT+U energy also

 fulline=$(grep -h -n 'DFT+U energy of Hubbard site      1 is' *.out | tail -1)
 arr=($fulline)
 DFTUEnergy=$(echo ${arr[7]})
 EU+=("$DFTUEnergy,")

 cd ../..
done

# Puts it all in a Python array.
echo "_E = np.array([${E[*]}])"
echo "_E_U = np.array([${EU[*]}])"
