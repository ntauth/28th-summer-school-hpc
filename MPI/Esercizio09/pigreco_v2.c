/* Exercise: Pi
 *
 * In this exercise you will determine the value 
 * of PI using the integral  of 
 *    4/(1+x*x) between -1/2 and 1/2. 
 *
 * The integral is approximated by a sum of n intervals.
 * 
 * The approximation to the integral in each interval is:
 *    (1/n)*4/(1+x*x). 
 *
 * Each process then adds up every n'th interval: 
 *    (x = -1/2+rank/n, -1/2+rank/n+size/n,...) 
 * 
 * The sums computed by each process are added together 
 * using REDUCTION */

#include <stdio.h>
#include "mpi.h"

#define PI25DT 3.141592653589793238462643

#define INTERVALS 1000

int main(int argc, char **argv)
{
    int rank, nprocs, tag;

    int i;
    int interval = INTERVALS;
    double x, dx, f, sum, pi;
    
    /* Start up MPI */
/* ---> INSERT MPI code */
    
    /* print banner */
    if (rank == 0) {
        printf("\nEvaluation of pi example: each process evaluates\n");
        printf("a subsection of the integral 4/(1+x*x) between -1/2\n");
        printf("and 1/2, then sends its partial result to the master.\n\n");

        fflush(stdout);
    }

    sum = 0.0;
    dx = 1.0 / (double) interval;
    
    /* each process computes integral */
    for (i = rank+1; i <= interval; i = i+nprocs) {
        x = dx * ((double) (i - 0.5));
        f = 4.0 / (1.0 + x*x);
        sum = sum + f;
    }
         
    pi = dx*sum;
   
   
    /* Arbitrarily choose 201 to be our tag. */
    tag = 201;
   
    /* reduction of partial pi sum on master process 0 
       ! ! !           WARNING            ! ! !      
    MPI STANDARD explicitly declears that the send buffer 
    must be different from the recv buffer. */

    sum = pi; /* using variable sum as sending buffer */

/* ---> INSERT MPI code */
    
    if (rank == 0) {
        printf("\n..reduction to master process..\n");
        printf("\nComputed PI %.24f\n", pi);
        printf("The true PI %.24f\n\n", PI25DT);
    }
   
    /* Quit */
/* ---> INSERT MPI code */

    return 0;
}
