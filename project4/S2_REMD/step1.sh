#!/bin/bash

# Define the path to the GROMACS executable
gmx=gmx

# Create directories for each simulation step from 0 to 1000
for i in $(seq 0 5); do
    mkdir step_$i
done

# Define an array of temperatures for the REMD simulations
temperatures=(298 398 498 598 698 798 898 998)

# Change directory to the current step
cd /home/jyang753/project4/S2_REMD/step_0

# Prepare simulation input files (.tpr) for each temperature in the step0 directory
for i in $(seq 1 8); do
    $gmx grompp -c /home/jyang753/project4/S2_REMD/enemin.gro -p /home/jyang753/project4/S2_REMD/ala2.top -f /home/jyang753/project4/S2_REMD/mdp/nvt_$i.mdp -o /home/jyang753/project4/S2_REMD/step_0/$i.tpr -maxwarn 10
done

# Return to the parent directory
cd ..

# Directory containing the TPR files
sim_dir="/home/jyang753/project4/S2_REMD/step_0"
# Script file to generate
script_file="${sim_dir}/run-md.sh"
# Create or clear the script file
: > "$script_file"

# Loop over each TPR file in the directory
for tpr in "${sim_dir}"/*.tpr; do

    # Remove the file extension to get the base filename
    base_name="${tpr%.tpr}"

    # Write the mdrun command to the script file
    echo "$gmx mdrun -deffnm $base_name" >> "$script_file"

    # Write the energy analysis command to the script file
    echo "echo 10 | $gmx energy -f ${base_name}.edr -o ${base_name}.xvg" >> "$script_file"
    
done

# Make the script executable
chmod +x "$script_file"


