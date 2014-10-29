#!/bin/bash

#
# tests fail with this variable set to 1 (error -33: CL_INVALID_DEVICE)
# on both Cray and GNU prg envs
#
export MPICH_G2G_PIPELINE=16

for i in $( seq 21 27 ); do
    for j in $( seq 1 10 ); do
        NUM="$( echo "2^${i}" | bc -l )"
        echo "# Transfering ${NUM} doubles ..."
        aprun -n 2 -N 1 ./10_mpi 0 gpu 0 ${NUM}
    done
done
