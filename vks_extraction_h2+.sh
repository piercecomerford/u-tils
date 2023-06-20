#!/bin/bash

# Takes the relevant information from a onetep output file and sticks it into Python arrays to be used with variousU.py
# Heavily adapted from code that Andrew wrote. Actually only basically a bug-fix + simplification of that + export to Python arrays instead of Mathematica ones.

# Each perturbation is a single subfolder of the main ../U_ineV/ that we're in.
for d in ./*/; do
 cd $d
# So that the slurm.out files play nice
 mv slurm* slurm_output

# Grab the very final information on DFT+U calculations (ASSUMES CONVERGENCE!!!)
 fulline=$(grep -h -n -A 1 'DFT+U information on Hubbard site      1 of species' *.out | head -2 | tail -1)
 arr=($fulline)
 KohnShamUp_plus_hubbard=$(echo ${arr[7]})
 fulline=$(grep -h -n -A 2 'DFT+U information on Hubbard site      1 of species' *.out | head -3 | tail -1)
 arr=($fulline)
 Hubbard_potential=$(echo ${arr[5]})
# Subtracts the v_U from v_Hxc+U
 KohnShamUp=$(bc <<< $KohnShamUp_plus_hubbard+-1*$Hubbard_potential)
 # I only really want the up ones; want them comma separated
 KS+=("$KohnShamUp,")

# Same idea but for occupancy
 Occupancy_Up=$(grep -h -A 2 'Occupancy matrix of Hubbard site      1 and spin      1 is' *.out | tail -1)
 Occupancy_Up_2=$(echo $Occupancy_Up)
 # And these ones
 occ+=("$Occupancy_Up_2,")

 cd ..
done

# Assumes you have a string with "VALUE OF U_in"eV in the folder you're working in; sets it to differentiate from other data.
U_in=$(pwd | grep -o "\weV" | tail -1)

# Puts it all in a Python array.
echo "Vks$U_in=np.array([${KS[*]}])"
echo "occ$U_in=np.array([${occ[*]}])"
