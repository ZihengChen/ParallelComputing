#include <stdio.h>

__global__ void square(float *d_out, float *d_in){
    int idx = blockDim.x*blockIdx.x + threadIdx.x;
    float f = d_in[idx];
    d_out[idx] =  f +1;
}


int main(int argc, char ** argv){
	const int ARRAY_SIZE = 51200;
	const int ARRAY_BYTES =  ARRAY_SIZE * sizeof(float);
    
    float h_in[ARRAY_SIZE],h_out[ARRAY_SIZE];
    for (int i = 0; i<ARRAY_SIZE; i++) {
        h_in[i] =  float(i);
    }
    float * d_in, * d_out;
    // 1. alloc memory on device
    cudaMalloc( (void **) &d_in,  ARRAY_BYTES );
    cudaMalloc( (void **) &d_out, ARRAY_BYTES );
	

    // 2. htod, launch kernel, dtoh
    cudaMemcpy(d_in,  h_in,  ARRAY_BYTES, cudaMemcpyHostToDevice);
    square<<< 100,ARRAY_SIZE/100>>> (d_out,d_in);
    cudaMemcpy(h_out, d_out, ARRAY_BYTES, cudaMemcpyDeviceToHost);
    
    for (int i = 0; i<ARRAY_SIZE; i++) {
        printf("%f ",h_out[i]);
    }
    cudaFree(d_in);
    cudaFree(d_out);
    
    return 0;
}
