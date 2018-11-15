#!/bin/bash
# run the following to activate a node
# $sinfo | less
# and choose a node with either 'idle' or 'mixed' classification under the column "STATE"
# $srun --pty -t 0-03:00 -A ocp -w node<node number> /bin/bash


ROOT='/rigel/ocp/users/tu2140/chkp63n/MITgcm/' 
GENMAKE=$ROOT'tools/genmake2'
MOD=$ROOT'Southern-Ocean/channel_flat/code'
OPTFILE=${ROOT}'Southern-Ocean/channel_flat/code/linux_ia64_ifort_habanero'

cd build
${GENMAKE} -mpi -rootdir=${ROOT} -mods=${MOD} -of=${OPTFILE}

make depend
make -j4
