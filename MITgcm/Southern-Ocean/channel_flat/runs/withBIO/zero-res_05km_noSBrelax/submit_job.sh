#!/bin/bash
#
#SBATCH -A ocp
#SBATCH -J test-darwin
#SBATCH -t 1:00:00
#SBATCH --exclusive
#SBATCH -N 6
#SBATCH --mail-type=ALL
#SBATCH --mail-user=tu2140@columbia.edu
#SBATCH -D /rigel/ocp/users/tu2140/MITgcm/channel_moc/GCM/test_darwin

echo "Running MITgcm"
#./mitgcmuv > output.txt
mpirun -n 128 ./mitgcmuv

