#!/bin/bash

#
# all tests fail if:
#
#   export MPICH_RDMA_ENABLED_CUDA=1
#
# is set (error -33: CL_INVALID_DEVICE) on Cray systems with cray and gnu 
# program environments. Failure occurs at context-creation time.
# Moreover, setting this variable:
#
#   export MPICH_G2G_PIPELINE=16
#
# is ignored by the MPICH-cray implementation if the above RDMA is not set.
#
NPROC=2

case $( hostname ) in
    *daint*)
        EXEC="aprun -n ${NPROC} -N 1"
        ;;
    *opcode*)
        export CUDA_VISIBLE_DEVICES="0,1"
        EXEC="mpiexec.hydra -n ${NPROC}"
        ;;
esac

#
# timed-transfer tests
#
#for i in $( seq 13 15 ); do
#    NUM="$( echo "2^${i}" | bc -l )"
#    echo "# Transfering ${NUM} doubles ..."
#    ${EXEC} ./10_mpi 0 gpu 0 ${NUM}
#done

#
# bandwidth test
#

${EXEC} ./osu_bwidth

