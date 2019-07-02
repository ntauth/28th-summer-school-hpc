#include <stdio.h>
#include <mpi.h>

/* MSIZE is the size of the integer arrays to send */
#define MSIZE 10000

int main(int argc, char *argv[])
{
    MPI_Status status;
    int rank, size, tag;

    int i;
    int A[MSIZE], B[MSIZE];

    /* cartesian topology */
    int periods[1], dims[1];
    MPI_Comm comm_cart;
    int source, dest;

    /* Start up MPI */
/* ---> INSERT MPI code */


    for (i = 0; i < MSIZE; i++)
        A[i] = rank;
    tag = 201;

    /* create 1D cartesian communicator */
/* ---> INSERT MPI code */
    periods =
    dims =


    printf("Proc %d sents %d integers to proc %d\n",
        rank, MSIZE, dest);
    printf("Proc %d receives %d integers from proc %d\n",
        rank, MSIZE, source);

    /* print first content of arrays A and B */
    printf("Proc %d has A[0] = %d, B[0] = %d\n", rank, A[0], B[0]);

    /* Quit */
/* ---> INSERT MPI code */

    return 0;
}

