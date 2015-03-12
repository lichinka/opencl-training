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
    *daint* | *santis*)
        EXEC="aprun -n ${NPROC} -N 1"
        ;;
    *opcode*)
        export CUDA_VISIBLE_DEVICES="0,4"
        EXEC="mpiexec.hydra -n ${NPROC}"
        ;;
    *)
        echo "Don't know to compile here. Exiting."
        exit 1
        ;;
esac

#
# timed-transfer tests
#
for i in $( seq 10 15 ); do
    NUM="$( echo "2^${i}" | bc -l )"
    echo "# Transfering ${NUM} doubles ..."
    ${EXEC} ./10_mpi 0 gpu 0 ${NUM}
done

#
# bandwidth test
#
export MV2_USE_CUDA=1
for streams in $( seq 0 1 ); do
    for ipc in $( seq 0 1 ); do
        for smp in $( seq 0 1 ); do
            export MV2_CUDA_NONBLOCKING_STREAMS=${streams}
            export MV2_CUDA_IPC=${ipc}
            export MV2_CUDA_SMP_IPC=${smp}
            env | grep MV2
            ${EXEC} ./osu_bwidth
            echo "##########"
        done
    done
done


