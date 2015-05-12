BINS      = 01_device_query 02_create_context 03_kernel_load_and_exec 08_cpp 09_memcpy 10_mpi
BINS_UTIL = 04_matrix_multiply 05_dot_product 06_matrix_multiply_timing 07_convolution
SRCS      = $(BINS:=.cpp)
SRCS_UTIL = $(BINS_UTIL:=.cpp)

all: clutil.o clcc osu_bwidth 07_convolution_image_write $(BINS) $(BINS_UTIL)

$(BINS) :
	$(CXX) $(OPTS) $(INC) $(LIBDIR) $(LIBS) $@.cpp -o $@

$(BINS_UTIL) : $(SRCS_UTIL)
	$(CXX) $(OPTS) $(INC) $(LIBDIR) $(LIBS) clutil.o $< -o $@

clcc : cl-compiler.cpp
	$(CXX) $(OPTS) $(INC) $(LIBDIR) $(LIBS) clutil.o $< -o $@

07_convolution_image_write : 07_convolution.cpp
	$(CXX) $(OPTS) -DWRITE_TO_IMAGE $(INC) $(LIBDIR) $(LIBS) clutil.o $< -o $@

osu_bwidth : osu_bwidth.c
	$(CC) $(OPTS) $< $(INC) $(LIBDIR) $(LIBS) -o $@

clutil.o : clutil.cpp
	$(CC) $(OPTS) -c $< $(INC) $(LIBDIR) $(LIBS) -o $@

clean:
	echo $(SRCS)
	rm -f *.o $(BINS)

.PHONY: clean

