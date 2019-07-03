/**
 * Exercise 15: Circular Shift 1D
 *
 */
#include <assert.h>
#include <stdio.h>
#include <mpi.h>

/* MSIZE is the size of the integer arrays to send */
#define MSIZE 500
#define MSG_TAG 201

int main(int argc, char *argv[])
{
    MPI_Status status;
    int op_status;
    int rank, size, tag, src, dst;
    int periods[1] = {1};
    int comm_cart;
    int i;
    int A[MSIZE], B[MSIZE];
    
    /* Start up MPI */
    op_status = MPI_Init(&argc, &argv);

    assert(op_status == MPI_SUCCESS);

    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    MPI_Cart_create(MPI_COMM_WORLD, 1, &size, periods, 0, &comm_cart);
    
    tag = MSG_TAG;

    for (i = 0; i < MSIZE; i++)
        A[i] = rank;

    MPI_Cart_shift(comm_cart, 0, 1, &src, &dst);
    MPI_Sendrecv(A, MSIZE, MPI_INT, dst, tag,
                 B, MSIZE, MPI_INT, src, tag,
                 comm_cart, &status);

    printf("Proc %d sends %d integers to proc %d\n", 
        rank, MSIZE, src);

    printf("Proc %d receives %d integers from proc %d\n", 
        rank, MSIZE, dst);

    /* print first content of arrays A and B */
    printf("Proc %d has A[0] = %d, B[0] = %d\n\n", rank, A[0], B[0]);

    /* Quit */
    op_status = MPI_Finalize();

    assert(op_status == MPI_SUCCESS);

    return 0;
}
