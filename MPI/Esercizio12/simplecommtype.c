/* Exercise: timing non-blocking sends
*
*  In this exercise you will try non-blocking
*  communications (syncronous and buffered)
*  to send a matrix from process 0 to process 1.
*
* Follow this rules:
*  - Before the two communication, a barrier should
*    syncronize the processes;
*  - Process 0 will begin the non-blocking send
*  - while process 1 will sleep for 5 seconds 
*    before starting the receive
*  - measure how long process 0 will take in
*    the two different sending calls
*/
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <mpi.h>

#define MSIZE 1000

int main(int argc, char *argv[]) {

    MPI_Status status;
    int rank, nprocs;
    double *mpibuffer;
    int     mpibuffer_length;

    int i;
    double startTime,endTime;

    /* data to communicate */
    double  vector[MSIZE];
    
    /* Start up MPI */
/* ---> INSERT MPI code */
    
    /* print banner */
    if (rank == 0) {
        printf("\nCommunication mode examples: process 0 sends a vector\n"); 
        printf("to process 1 using a syncronous and a buffered send.\n");
        printf("Process 1 waits for 5 seconds before starting the\n");
        printf("corresponding receive call. Time spent in the syncronous\n");
        printf("and buffered send is reported.\n\n");

        fflush(stdout);
    }

    /* simple datatype communication examples using two processes */
    if (nprocs < 2) {

        if (rank == 0) {
            printf("\nSORRY: need at least 2 processes.\n");
        }

        /* exit MPI on error */
        MPI_Finalize();
        
        exit(EXIT_FAILURE);
    }

    if (rank == 0) {

        for (i = 0; i < MSIZE; i++)
            vector[i] = (double) i;
    }

    MPI_Barrier(MPI_COMM_WORLD);


    /* SYNCRONOUS COMMUNICATION */
    if (rank == 0) {
        /* Process 0 start the Syncronous Send */
/* ---> INSERT MPI code */
    

        printf("Proc 0 spent %10.7f to exit from SSend.\n", endTime - startTime);

    }

    if (rank == 1) {
        
        /* Process 1 sleeps for 5 seconds and start the receive */
        sleep(5);
/* ---> INSERT MPI code */

    }

    if (rank == 0) {
        for (i = 0; i < MSIZE; i++)
            vector[i] = (double) i;
    }

    MPI_Barrier(MPI_COMM_WORLD);

    /* BUFFERED COMMUNICATION */
    if (rank == 0) {
        mpibuffer_length = (MSIZE*sizeof(double) + MPI_BSEND_OVERHEAD);
        mpibuffer = (double *) malloc (mpibuffer_length);
/* ---> INSERT MPI code */

/* ---> INSERT MPI code */
    

        printf("Proc 0 spent %10.7f to exit from Bsend.\n", endTime - startTime);

    }
    
    if (rank == 1) {
        
        /* Process 1 sleeps for 5 seconds and start the receive */
        sleep(5);
/* ---> INSERT MPI code */

    }

    /* Quit */
/* ---> INSERT MPI code */    

    return 0;
}
