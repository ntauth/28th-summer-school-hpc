#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <mpi.h>

/************ Macros and Typedefs **/
#define mpi_error_status_t int

#define __info(_Fmt, ...) \
    fprintf(stdout, "[+] " _Fmt "\n", __VA_ARGS__)

#define __error(_Fmt, ...) \
    fprintf(stderr, "[!] " _Fmt "\n", __VA_ARGS__)

#define ARRAY_SZ_MULTIPLIER 4
#define ITERS_DEFAULT 3
#define K_DEFAULT 2
#define MPI_MSG_TAG ((int) 201)

/************ Functions           **/
mpi_error_status_t main(int argc, char** argv)
{
    MPI_Status recv_status;
    mpi_error_status_t status;
    int comm_proc_rank, comm_group_size;
    double* A;
    double* B;
    double* W; // Work Array
    int N;
    int K;
    int Nloc;
    int iters = ITERS_DEFAULT;
    int prev, next;
    int i, j, k;

    /** @region Initialization */
    status = MPI_Init(&argc, &argv);

    assert(status == MPI_SUCCESS);

    MPI_Comm_rank(MPI_COMM_WORLD, &comm_proc_rank);
    MPI_Comm_size(MPI_COMM_WORLD, &comm_group_size);

    N = comm_group_size * ARRAY_SZ_MULTIPLIER;
    Nloc = N / comm_group_size;
    K = K_DEFAULT;
    A = malloc(N * sizeof(double));
    B = malloc(Nloc * sizeof(double));
    W = malloc((Nloc + 2*k) * sizeof(double));

    for (i = 0; i < N; i++)
        A[i] = i;
 
    // Print A
    if (comm_proc_rank == 0)
    {
        printf("A: \n");
    
        for (i = 0; i < N; i++)
            printf("%f ", A[i]);
        printf("\n\n");    
    }

    /** @region Array Smoothing */     
    MPI_Scatter(A, Nloc, MPI_DOUBLE_PRECISION,
                B, Nloc, MPI_DOUBLE_PRECISION,
                0, MPI_COMM_WORLD);

    for (i = 1; i <= iters; i++)
    {
        if (comm_proc_rank == 0)
            __info("Iteration %d", i);

        // Get the neigboring K elements
        prev = (comm_proc_rank - 1 + comm_group_size) % comm_group_size;
        next = (comm_proc_rank + 1) % comm_group_size;

        MPI_Sendrecv(&B[0], K, MPI_DOUBLE, prev, MPI_MSG_TAG,
                     &W[K + Nloc], K, MPI_DOUBLE, next, MPI_MSG_TAG, MPI_COMM_WORLD, &recv_status);

        for (j = 0; j < Nloc; j++)
            W[j + K] = B[j];

        MPI_Sendrecv(&B[Nloc - K], K, MPI_DOUBLE, next, MPI_MSG_TAG,
                     &W[0], K, MPI_DOUBLE_PRECISION, prev, MPI_MSG_TAG, MPI_COMM_WORLD, &recv_status);
        
        // Compute the average
        for (j = 0; j < Nloc; j++)
        {
            B[j] = 0;

            for (k = 0; k < 2*K + 1; k++)
                B[j] += W[j + k];

            B[j] /= 2*k + 1;
        }
        
        // Print B
        //if (comm_proc_rank == 0)
        //{
            for (j = 0; j < Nloc; j++)
                printf("%f ", B[j]);
            printf("\n");
        //}

        MPI_Gather(B, Nloc, MPI_DOUBLE_PRECISION,
                   A, Nloc, MPI_DOUBLE_PRECISION,
                   0, MPI_COMM_WORLD);
    }

    free(W);
    free(B);
    free(A);
    
    /** @region Finalization */
    status = MPI_Finalize();

    assert(status == MPI_SUCCESS);
    
    getchar();

    return status;
}
