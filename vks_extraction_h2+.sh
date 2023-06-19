#!/bin/bash

# Takes the relevant information from a onetep output file and sticks it into Python arrays to be used with variousU.py
# Heavily adapted from code that Andrew Burgess wrote. Actually only basically a bug-fix of that + exportation to Python arrays instead of Mathematica ones.

U_step=$(pwd | grep -o "\weV" | tail -1)

for d in ./*/; do
 cd $d
 mv slurm* slurm_output

 fulline=$(grep -h -n -A 1 'DFT+U information on Hubbard site      1 of species' *.out | head -2 | tail -1)
 arr=($fulline)
 KohnShamUp_plus_hubbard=$(echo ${arr[7]})
 fulline=$(grep -h -n -A 2 'DFT+U information on Hubbard site      1 of species' *.out | head -3 | tail -1)
 arr=($fulline)
 Hubbard_potential=$(echo ${arr[5]})
 KohnShamUp=$(bc <<< $KohnShamUp_plus_hubbard+-1*$Hubbard_potential)
 KSup+=("{$d,$KohnShamUp},")

 # I only really want the up ones tbh
 KS+=("$KohnShamUp,")

 fulline=$(grep -h -n -A 1 'DFT+U information on Hubbard site      1 of species' *.out | tail -1)
 arr=($fulline)
 KohnShamDown_plus_hubbard=$(echo ${arr[7]})
 fulline=$(grep -h -n -A 2 'DFT+U information on Hubbard site      1 of species' *.out | tail -1)
 arr=($fulline)
 Hubbard_potential=$(echo ${arr[5]})
 KohnShamDown=$(bc <<< $KohnShamDown_plus_hubbard+-1*$Hubbard_potential)
 KSdown+=("{$d,$KohnShamDown},")

 Occupancy_Up=$(grep -h -A 2 'Occupancy matrix of Hubbard site      1 and spin      1 is' *.out | tail -1)
 Occupancy_Up_2=$(echo $Occupancy_Up)
 occ_up+=("{$d,$Occupancy_Up_2},")

 # And these ones
 occ+=("$Occupancy_Up_2,")
 Occupancy_Down=$(grep -h -A 2 'Occupancy matrix of Hubbard site      1 and spin      2 is' *.out | tail -1)
 Occupancy_Down2=$(echo $Occupancy_Down)
 occ_down+=("{$d,$Occupancy_Down2},")
 cd ..
done


echo "Vks$U_step=np.array([${KS[*]}])"
echo "occ$U_step=np.array([${occ[*]}])"
