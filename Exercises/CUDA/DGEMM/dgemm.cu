#include <stdio.h>
#include <math.h>
#include <assert.h>

#define epsilon (float) 1e-5
#define THREADxBLOCKalongXorY 16

typedef float DataType_t;

//
// Kernels
//
void MatrixMulOnHost(DataType_t* M, DataType_t* N, DataType_t* P, int Width)
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

__global__ void MatrixMulKernel(DataType_t* dM, DataType_t* dN, DataType_t* dP, int Width)
{
    int i, j, k;
    DataType_t pvalue;

    i = blockIdx.y * blockDim.y + threadIdx.y;
    j = blockIdx.x * blockDim.x + threadIdx.x;

    if (i < Width && j < Width)
    {
        pvalue = 0;

        for (k = 0; k < Width; k++)
            pvalue += dM[i*Width + k] * dN[k*Width + j];
        
        dP[i*Width + j] = pvalue;
    }
}

void MatrixMulOnDevice(DataType_t* M, DataType_t* N, DataType_t* P, int Width)
{
    int gridsize, size;
    float mflops;
    DataType_t *dM, *dN, *dP;

    cudaError_t mycudaerror;
    cudaEvent_t start, stop;
    float elapsed;

    size = Width * Width * sizeof(DataType_t);

    // CUDA grid management
    gridsize = Width / THREADxBLOCKalongXorY;

    if (gridsize * THREADxBLOCKalongXorY < Width)
        gridsize = gridsize + 1;
    
    dim3 dimGrid(gridsize, gridsize);
    dim3 dimBlock(THREADxBLOCKalongXorY, THREADxBLOCKalongXorY);
    printf("Gridsize: %d\n", gridsize);

    cudaMalloc(&dM, size);
    cudaMemcpy(dM, M, size, cudaMemcpyHostToDevice);
    cudaMalloc(&dN, size);
    cudaMemcpy(dN, N, size, cudaMemcpyHostToDevice);
    cudaMalloc(&dP, size);

    // cudaGetLastError call to reset previous CUDA errors
    mycudaerror = cudaGetLastError();

    // Create start and stop CUDA events
    cudaEventCreate(&start);
    cudaEventCreate(&stop);

    // Kernel launch
    cudaEventRecord(start);
    MatrixMulKernel<<<dimGrid, dimBlock>>>(dM, dN, dP, Width);
    cudaEventRecord(stop);

    // Device synchronization and cudaGetLastError call
    cudaEventSynchronize(stop);

    // Event record, synchronization, elapsed time and destruction
    cudaEventElapsedTime(&elapsed, start, stop);

    // calculate Mflops
    mflops = 2 * pow(Width, 3) / elapsed;
    elapsed /= 1000.f; // Convert to seconds
    
    printf("Kernel elapsed time %fs \n", elapsed);
    printf("Mflops: %f\n", mflops);

    // copy back results from device
    cudaMemcpy(P, dP, size, cudaMemcpyDeviceToHost);

    // free memory on device
    cudaFree(dM);
    cudaFree(dN);
    cudaFree(dP);
}

//
// Main
//
int main(int argc, char** argv)
{
    int Width;
    DataType_t *M, *N, *hP, *gP;
    DataType_t it;
    int x, y;
    int errCnt;

    if (argc < 2)
    {
        fprintf(stderr, "Usage: %s Width\n", argv[0]);
        exit(1);
    }

    Width = atoi(argv[1]);

    if (Width < 1)
    {
        fprintf(stderr, "Error Width=%d, must be > 0\n", Width);
        exit(1);
    }

    M = (DataType_t*) malloc(Width * Width * sizeof(DataType_t));
    N = (DataType_t*) malloc(Width * Width * sizeof(DataType_t));
    hP = (DataType_t*) malloc(Width * Width * sizeof(DataType_t));
    gP = (DataType_t*) malloc(Width * Width * sizeof(DataType_t));

    if (M == NULL)
    {
        fprintf(stderr,"Could not get memory for M\n");
        exit(1);
    }

    if (N == NULL)
    {
        fprintf(stderr,"Could not get memory for N\n");
        exit(1);
    }

    if (hP == NULL)
    {
        fprintf(stderr,"Could not get memory for hP\n");
        exit(1);
    }

    if (gP == NULL)
    {
        fprintf(stderr,"Could not get memory for gP\n");
        exit(1);
    }

    memset(gP, 0, Width * Width * sizeof(DataType_t));
    memset(hP, 0, Width * Width * sizeof(DataType_t));

    for (y = 0; y < Width; y++)
    {
        for (x = 0; x < Width; x++)
        {
            M[y*Width + x] = (DataType_t) (((y + 1) * Width + x + 1) / Width);
            N[y*Width + x] = (DataType_t) (((y + 1) * Width + x + 1) / Width);
        }
    }

    MatrixMulOnHost(M, N, hP, Width);
    MatrixMulOnDevice(M, N, gP, Width);

    errCnt = 0;

    for (y = 0; y < Width; y++)
    {
        for (x = 0; x < Width; x++)
        {
            it = hP[y*Width + x];
            
            if (fabs(it - gP[y*Width + x]) > epsilon*it)
            {
                printf("failing x=%d, y=%d: %f!=%f \n", x, y, it, gP[y*Width + x]);
                errCnt++;
            }
        }
    }

    if (errCnt == 0)
        printf("\nTEST PASSED\n");
    else
        printf("\n\nTEST FAILED: number of errors:  %d\n", errCnt);
}
