/* Exercise: Smoothing 
 *
 * In this exercise you will smooth an array, doing the
 * mean of each element in a window of M neighbours
 * 
 * Window length and iterations are defined in the code.
 *
 * This version uses non-blocking communications.
 */

#include <stdlib.h>
#include <stdio.h>
#include <mpi.h>

#define NEIGHBOURS 1
#define ITERATIONS 2
#define LOCAL_LENGTH 10

int main(int argc, char *argv[])
{
    MPI_Status status;
    MPI_Request send[2], recv[2];
    int rank, nprocs, tag1, tag2, next, prev;

    int i, j, iter;
    int neighbours = NEIGHBOURS;
    int niter = ITERATIONS;
    int start, stop;

    /* data */
    double *global_array;
    double *local_array, *workarray;

    /* Start up MPI */
/* ---> INSERT MPI code */


    
    /* print banner */
    if (rank == 0) {
        printf("\nArray Smoothing example:\n");
        printf("Iterative mean of array elements with its first %d neighbours.\n", 
            NEIGHBOURS);
        printf("Neighbours and iterations are defined in the code.\n");
        printf("This version uses non-blocking communications.\n\n");

        fflush(stdout);
    }

    /* initialize local data */
    local_array = (double *) malloc (LOCAL_LENGTH*sizeof(double));
    workarray = (double *) malloc ((LOCAL_LENGTH+2*neighbours)*sizeof(double));

    if (rank == 0) {
        /* resume parameters*/
        printf("Using %d neighbours elements for %d iterations\n\n",
            neighbours, niter);

        /* initialize global array */
        global_array = (double *)malloc(LOCAL_LENGTH*nprocs*sizeof(double));

        for (i = 0; i < LOCAL_LENGTH*nprocs; i++) {
            global_array[i] = (double) i+1;
        }

        /* master process prints starting array */
        printf("\nStarting array is:\n");
        for (j = 0; j < nprocs; j++) {
            for (i = 0; i < LOCAL_LENGTH; i++) {
                printf("%6.2f ", global_array[j*LOCAL_LENGTH+i]);
            }
            printf("\n");
        }
    }

    /* master distribute chunks of global array to other processes */

/* ---> INSERT MPI code */



    /* Arbitrarily choose 201 and 202 to be our tag1 and tag2.  Calculate the rank of the
       next process in the ring.  Use the modulus operator so that the
       last process "wraps around" to rank zero. */
    
    tag1 = 201;
    tag2 = 202;
    next = (rank + 1) % nprocs;
    prev = (rank + nprocs - 1) % nprocs;

    /* from now on, we will have local array containing current data.
       We send/copy this data into workarray and then compute new data
       into local_array and print it */

    for (iter = 1; iter <= niter; iter++) {

        /* exchange border elements among neighbours processes 
         * using non-blocking send and receive in order to overlap
         * communication and smoothing */

/* ---> INSERT MPI code */

/* ---> INSERT MPI code */

/* ---> INSERT MPI code */

/* ---> INSERT MPI code */
    
        /* copy elements to the working array */
        for (i = 0; i < LOCAL_LENGTH; i++) {
            workarray[i+neighbours] = local_array[i];
        }

        /* set left and right border of inner core elements of local_array 
         * that can be computed without the exchanged ones */
        start = neighbours;
        stop  = LOCAL_LENGTH-neighbours;

        /* compute mean on element in the core of the array */
        for (i = start; i < stop; i++) {
            double newvalue = 0.0;

            for (j = - neighbours; j <= neighbours; j++) {
                newvalue = newvalue + workarray[i+j+neighbours];
            }
            local_array[i] = newvalue / (2*neighbours+1);
        }

        /* compute mean on left border */

        /* Check communication has been completed */
/* ---> INSERT MPI code */

        start = 0;
        stop  = neighbours;
        for (i = start; i < stop; i++) {
            double newvalue = 0.0;

            for (j = - neighbours; j <= neighbours; j++) {
                newvalue = newvalue + workarray[i+j+neighbours];
            }
            local_array[i] = newvalue / (2*neighbours+1);
        }

        /* compute mean on right border */

        /* Check communication has been completed */
/* ---> INSERT MPI code */

        start = LOCAL_LENGTH-neighbours;
        stop = LOCAL_LENGTH;
        for (i = start; i < stop; i++) {
            double newvalue = 0.0;

            for (j = - neighbours; j <= neighbours; j++) {
                newvalue = newvalue + workarray[i+j+neighbours];
            }
            local_array[i] = newvalue / (2*neighbours+1);
        }

        /* master process gathers results from other processes */

/* ---> INSERT MPI code */


        /* prints out results */
        if (rank == 0) {
            printf("\nITER %3d:\n", iter);
            for (j = 0; j < nprocs; j++) {
                for (i = 0; i < LOCAL_LENGTH; i++) {
                    printf("%6.2f ", global_array[j*LOCAL_LENGTH+i]);
                }
                printf("\n");
            }
        }

    }
    /* Quit */
/* ---> INSERT MPI code */


    return 0;
}
