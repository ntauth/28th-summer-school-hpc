/* Exercise: Circular Shift non-blocking 
 *
 * In this exercise you will communicate a matrix 
 * among process in a circular topology, so that
 * every process has a left and a right neighbor
 * to receive and to send data respectivelly.
 *
 * Resolve deadlocks with non-blocking MPI function
 */
#include <stdio.h>
#include <mpi.h>

/* MSIZE is the size of the integer arrays to be sent */
#define MSIZE 50000

int main(int argc, char *argv[])
{
    MPI_Status status;
    MPI_Request request;
    int rank, size, tag, to, from;

    int i;
    int A[MSIZE], B[MSIZE];
    
    /* Start up MPI */
/* ---> INSERT MPI code */    
    
    /* print banner */
    if (rank == 0) {
        printf("\nCircular shift example: each process fills matrix A\n");
        printf("elements with its rank and sends them to the right\n");
        printf("process which receives them into matrix B.\n\n");

        fflush(stdout);
    }

    /* Arbitrarily choose 201 to be our tag.  Calculate the rank of the
       to process in the ring.  Use the modulus operator so that the
       last process "wraps around" to rank zero. */
    
/* ---> INSERT code */    
    tag = 
    to = 
    from = 

    for (i = 0; i < MSIZE; i++)
        A[i] = rank;

    /* starting non-blocking send of array A */
/* ---> INSERT MPI code */    

    printf("Proc %d sends %d integers to proc %d\n", 
        rank, MSIZE, to);

    /* starting blocking receive of array A in B */
/* ---> INSERT MPI code */    

    printf("Proc %d receives %d integers from proc %d\n", 
        rank, MSIZE, from);

    /* wait for completition */
/* ---> INSERT MPI code */    

    /* print first content of arrays A and B */
    printf("Proc %d has A[0] = %d, B[0] = %d\n\n", rank, A[0], B[0]);

    /* now array A can be changed */

    /* Quit */
/* ---> INSERT MPI code */    

    return 0;
}
