#!/bin/bash

#SBATCH --account=ocp
#SBATCH --exclusive
#SBATCH -n 200
#SBATCH -J 05NoSBDar
#SBATCH --time=11:59:00
#SBATCH --mail-user=tu2140@columbia.edu
#SBATCH --mail-type=ALL

NPROC=200

module load intel-parallel-studio/2017 netcdf-fortran/4.4.4 netcdf/gcc/64/4.4.0
module list

cd $SLURM_SUBMIT_DIR
ulimit -s unlimited
mpirun -n $NPROC ./mitgcmuv

# code below is used for autorestart
#lastline=`tail -1 STDOUT.0000`
#testline=`echo $lastline | grep 'ended Normally'`

#echo $lastline

#pmeta=$( ls -t pickup.0*.meta |head -1)
#plabel=$(echo $pmeta | sed 's/pickup.\(.*\).meta/\1/' )

#if [ $plabel -ge 10368000 ]
#then
#        echo 'Enough, enough, enough calculation done!'
#	exit 1
#fi


#if [ ${#testline} -gt 0 ]
#then
#	./most_recent_pickup.sh
#	sbatch jobscript.sh
#else
#	echo "Something is wrong!!!!!!!! AHHHH!!!"
#	echo $lastline
#fi
