#include "sal.h"

#include <stdio.h>
#include <math.h>
#include <assert.h>

#define epsilon (float) 1e-5

#define BlockSize 32

typedef float DataType_t;

//
// Helpers
//
void MatrixRandomize(_Inout_ DataType_t* M, _In_ size_t Width)
{
    size_t i;

    for (i = 0; i < Width; i++)
        M[i] = (DataType_t) drand48();
}

// __attribute__((always inline))
// __device__

//
// Host and Device Kernels
//
__host__ void MatrixMulOnHost(DataType_t* M, DataType_t* N, DataType_t* P, int Width)
{
    int i, j, k;
    DataType_t pvalue;

    for (i = 0; i < Width; i++)
    {
        for (j = 0; j < Width; j++)
        {
            pvalue = 0;
      
            for (k = 0; k < Width; k++)
                pvalue += M[i * Width + k] * N[k * Width + j];

            P[i*Width + j] = pvalue;
        }
    }
}

__global__ void MatrixMulSharedKernel(
    _In_ DataType_t* dM,
    _In_ DataType_t* dN,
    _Out_ DataType_t* dP,
    _In_ size_t Width
)
/**
 * \brief Matrix-Matrix multiplication using shared mem
 *
 */
{
    __shared__ DataType_t As[BlockSize][BlockSize];
    __shared__ DataType_t Bs[BlockSize][BlockSize];

    DataType_t c;
    size_t it, jt, ib, jb;
    size_t k;

    it = threadIdx.y;
    jt = threadIdx.x;
    ib = blockIdx.y;
    jb = blockIdx.x;

    for (k = 0; k < Width / BlockSize; k++)
    {

    }
}

void MatrixMulOnDevice(DataType_t* M, DataType_t* N, DataType_t* P, size_t Width)
{
    cudaEvent_t start, stop;
    DataType_t* d_A, *d_B, *d_C;
    size_t size;
    float gpu_time;
    double time_sec, num_ops, gflops;

    size = Width * Width * sizeof(float);

    // Load A and B to device memory 
    cudaMalloc((void**) &d_A, size);
    cudaMalloc((void**) &d_B, size);
 
    cudaMemcpy(d_A, h_A, size, cudaMemcpyHostToDevice); 
    cudaMemcpy(d_B, h_B, size, cudaMemcpyHostToDevice);
 
    // Allocate C in device memory 
    cudaMalloc((void**) &d_C, size);
 
    // Grid specify
    dim3 dimBlock(BlockSize, BlockSize); 
    dim3 dimGrid(Width / dimBlock.x, Width / dimBlock.x);
 
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    
    // Start timing
    cudaEventRecord(start);
 
    // Invoke kernel 
    MatrixMulSharedKernel <<<dimGrid, dimBlock>>> (d_A, d_B, d_C, Width);
 
    // End timing
    cudaEventRecord(stop);
    cudaEventSynchronize(stop);
 
    cudaEventElapsedTime(&gpu_time, start, stop);
    time_sec = gpu_time / 1000.0;
    num_ops = 2.0 * (double) Width * (double) Width * (double) Width;
    gflops = 1.0e-9 * num_ops / time_sec;
    printf("CUDA Gflops = %.4f , Time = %.5f s dim=%d\n", gflops, time_sec, Width);
 
    // Read C from device memory 
    cudaMemcpy(h_C, d_C, size, cudaMemcpyDeviceToHost); 
 
    // Free device memory 
    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);
}

//
// Main
//
int main(int argc, char** argv)
{
    DataType_t* h_A, *h_B, *cpu_result, *gpu_result;
    size_t N, size;
    size_t i;
    int error;

    N = 32 * BlockSize;
    size = N * N * sizeof(DataType_t);

    // allocate matrices on the host
    h_A = (DataType_t*) malloc(size * sizeof(DataType_t));
    h_B = (DataType_t*) malloc(size * sizeof(DataType_t));

    // init matrices
    MatrixRandomize(h_A, N * N);
    MatrixRandomize(h_B, N * N);

    // allocate matrices to compare the results CPU/GPU
    cpu_result = (DataType_t*) malloc(size * sizeof(DataType_t));
    gpu_result = (DataType_t*) malloc(size * sizeof(DataType_t));

    // compute on GPU
    MatrixMulOnDevice(h_A, h_B, gpu_result, N);

    // compute on CPU
    MatrixMulOnHost(h_A, h_B, cpu_result, N);

    // check results
    error = 0;

    for (i = 0; i < N * N; i++)
    {
        if (fabs(cpu_result[i] - gpu_result[i]) > epsilon * cpu_result[i])
	        error++;
    }

    if (error == 0)
        printf("\nTEST PASSED\n");
    else
        printf("\n\nTEST FAILED: number of errors:  %d\n", error);

    free(h_A);
    free(h_B);
    free(cpu_result);
    free(gpu_result);
}
