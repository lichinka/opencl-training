#!/bin/sh

# 
# - On Daint, compile with this module setup:
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
        echo "Building on daint ..."
        CC=cc
        CXX=CC
        CLSDK=/opt/nvidia/cudatoolkit
        CLLIB=/opt/cray/nvidia/default
        ;;
    *opcode*)
        echo "Building on opcode ..."
        CC=mpicc
        CXX=g++
        CLSDK=/apps/opcode/CUDA-5.5
        CLLIB=/apps/opcode/CUDA-5.5
        ;;
esac

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
$CC  $SRC/10_mpi.cpp -I$CLSDK/include -L$CLLIB/lib64 -lOpenCL -o 10_mpi
$CXX $SRC/cl-compiler.cpp $SRC/clutil.cpp -I$CLSDK/include -L$CLLIB/lib64 -lOpenCL -o clcc
$CC  -DPINNED $SRC/osu_bwidth.c -I$CLSDK/include -L$CLLIB/lib64 -lOpenCL -o osu_bwidth

