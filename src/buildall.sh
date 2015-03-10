#!/bin/sh

# 
# - On Daint/Santis, compile with this module setup:
#
# module switch PrgEnv-cray PrgEnv-gnu
# module load craype-accel-nvidia35
# 
# - On Opcode, compile with this module setup:
#
# module load mvapich2/2.0-gcc-opcode2-4.7.2
#
SRC=../src
CLSRC=../src/kernels

case $( hostname ) in 
    *daint*)
        #CC="cc -g -O0"
        #CXX="CC -g O0"
        MPI_HOME="/opt/cray/mpt/7.0.4/gni/mpich2-gnu/48/"
        CC="clang -g -O0 -I${MPI_HOME}/include -L${MPI_HOME}/lib -lmpich"
        CXX="clang++ -g -O0 -I${MPI_HOME}/include -L${MPI_HOME}/lib -lmpich"
        CLSDK=/opt/nvidia/cudatoolkit
        CLLIB=/opt/cray/nvidia/default
        ;;
    *santis*)
        CC="cc -g -O0"
        CXX="CC -g -O0"
        CLSDK=/opt/nvidia/cudatoolkit/default
        CLLIB=${CLSDK}
        ;;
    *opcode*)
        CC=mpicc
        CXX=mpicxx
        CLSDK=/apps/opcode/CUDA-5.5
        CLLIB=/apps/opcode/CUDA-5.5
        MPIHOME=/apps/opcode/mvapich2/2.0/gcc/opcode2/4.7.2
        ;;
    *dom*)
        CC=mpicc
        CXX=mpicxx
        CLSDK=/usr/local/cuda-6.0
        CLLIB=${CLSDK}
        ;;
    *)
        echo "Unknown system: ${HOSTNAME}"
        exit 1
        ;;
esac

echo "Building on ${HOSTNAME} ..."
$CXX $SRC/01_device_query.cpp -I$CLSDK/include -L$CLLIB/lib64 -lOpenCL -o 01_device_query
$CXX $SRC/02_create_context.cpp -I$CLSDK/include -L$CLLIB/lib64 -lOpenCL -o 02_create_context
$CXX $SRC/03_kernel_load_and_exec.cpp -I$CLSDK/include -L$CLLIB/lib64 -lOpenCL -o 03_kernel_load_and_exec
$CXX $SRC/04_matrix_multiply.cpp $SRC/clutil.cpp -I$CLSDK/include -L$CLLIB/lib64 -lOpenCL -o 04_matrix_multiply
$CXX $SRC/05_dot_product.cpp $SRC/clutil.cpp -I$CLSDK/include -L$CLLIB/lib64 -lOpenCL -o 05_dot_product
$CXX $SRC/06_matrix_multiply_timing.cpp $SRC/clutil.cpp -I$CLSDK/include -L$CLLIB/lib64 -lOpenCL -o 06_matrix_multiply_timing
$CXX $SRC/07_convolution.cpp $SRC/clutil.cpp -I$CLSDK/include -L$CLLIB/lib64 -lOpenCL -o 07_convolution
$CXX -DWRITE_TO_IMAGE $SRC/07_convolution.cpp $SRC/clutil.cpp -I$CLSDK/include -L$CLLIB/lib64 -lOpenCL -o 07_convolution_image_write
$CXX $SRC/08_cpp.cpp -I$CLSDK/include -L$CLLIB/lib64 -lOpenCL -o 08_cpp
$CXX $SRC/09_memcpy.cpp -I$CLSDK/include -L$CLLIB/lib64 -lOpenCL -o 09_memcpy
$CXX $SRC/10_mpi.cpp -I$MPIHOME/include -I$CLSDK/include -L$MPIHOME/lib -L$CLLIB/lib64 -lmpich -lOpenCL -o 10_mpi
$CXX $SRC/cl-compiler.cpp $SRC/clutil.cpp -I$CLSDK/include -L$CLLIB/lib64 -lOpenCL -o clcc
$CC  -DPINNED $SRC/osu_bwidth.c -I$CLSDK/include -L$CLLIB/lib64 -lOpenCL -o osu_bwidth

