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

#define MTX_SIZE_MULTIPLIER 2

/************ Functions           **/
void print_matrix(double* mtx, int rows, int cols)
{
    int m, n;

    for (m = 0; m < rows; m++)
    {
        for (n = 0; n < cols; n++)
            printf("%.2f ", mtx[m * cols + n]);

        printf("\n");
    }
}

void fill_matrix_random(double* mtx, int rows, int cols)
{
    int m, n;

    for (m = 0; m < rows; m++)
        for (n = 0; n < cols; n++)
            mtx[m * cols + n] = (rand() % 16) / 1.5;
}

mpi_error_status_t main(int argc, char** argv)
{
    MPI_Status recv_status;
    mpi_error_status_t status;
    int comm_proc_rank, comm_group_size;
    double* A, *A_loc, *V, *C, *C_loc;
    int size;
    int m, n;

    /** @region Initialization */
    srand(time(NULL));

    status = MPI_Init(&argc, &argv);

    assert(status == MPI_SUCCESS);

    MPI_Comm_rank(MPI_COMM_WORLD, &comm_proc_rank);
    MPI_Comm_size(MPI_COMM_WORLD, &comm_group_size);

    size = comm_group_size * MTX_SIZE_MULTIPLIER;
    
    if (comm_proc_rank == 0)
    {
        A = malloc(size * size * sizeof(double));
        fill_matrix_random(A, size, size);

        V = malloc(size * sizeof(double));
        fill_matrix_random(V, size, 1);

        C = malloc(size * sizeof(double));
    }
    
    A_loc = malloc(MTX_SIZE_MULTIPLIER * size * sizeof(double));
    C_loc = malloc(MTX_SIZE_MULTIPLIER * sizeof(double));

    /** @region Matrix-Vector Product */     
    MPI_Scatter(A, MTX_SIZE_MULTIPLIER * size, MPI_DOUBLE,
                A_loc, MTX_SIZE_MULTIPLIER * size, MPI_DOUBLE,
                0, MPI_COMM_WORLD);
    MPI_Bcast(V, size, MPI_DOUBLE, 0, MPI_COMM_WORLD); 
    
    for (m = 0; m < MTX_SIZE_MULTIPLIER; m++)
    {
        C_loc[m] = 0;

        for (n = 0; n < size; n++)
            C_loc[m] += A_loc[m * size + n] * V[n];        
    }
    
    MPI_Gather(C_loc, MTX_SIZE_MULTIPLIER, MPI_DOUBLE,
               C, MTX_SIZE_MULTIPLIER, MPI_DOUBLE,
               0, MPI_COMM_WORLD);
    
    if (comm_proc_rank == 0)
    {
        __info("A x V", NULL);
        print_matrix(A, size, size);
        print_matrix(V, size, 1);
        printf("=\n");
        print_matrix(C, size, 1);
    }

    /** @region Finalization */
    status = MPI_Finalize();

    assert(status == MPI_SUCCESS);
    
    getchar();

    return status;
}
