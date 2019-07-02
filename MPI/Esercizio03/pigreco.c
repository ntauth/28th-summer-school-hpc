/* Exercise: Pi
 *
 * In this exercise you will determine the value 
 * of PI using the integral  of 
 *    4/(1+x*x) between 0 and 1
 *
 * The integral is approximated by a sum of n intervals.
 * 
 * The approximation to the integral in each interval is:
 *    (1/n)*4/(1+x*x). 
 *
 * Each process then adds up every n'th interval: 
 *    (x = rank/n, rank/n+size/n,...) 
 * 
 * The sums computed by each process are added together 
 */

#include <stdio.h>
#include "mpi.h"

#define PI25DT 3.141592653589793238462643

#define INTERVALS 1000

int main(int argc, char **argv)
{
    MPI_Status status;
    int rank, size, tag, from;

    int i;
    int interval = INTERVALS;
    double x, dx, f, sum, pi;
    
    /* Start up MPI */
/* ---> INSERT MPI code */
 
    /* print banner */
    if (rank == 0) {
        printf("\nEvaluation of pi example: each process evaluates\n");
        printf("a subsection of the integral 4/(1+x*x) between \n");
        printf("and 0, then sends its partial result to the master.\n\n");

        fflush(stdout);
    }

    sum = 0.0;
    dx = 1.0 / (double) interval;
    
    /* each process computes integral */
    for (i = rank+1; i <= interval; i = i+size) {
        x = dx * ((double) (i - 0.5));
        f = 4.0 / (1.0 + x*x);
        sum = sum + f;
    }
         
    pi = dx*sum;
   
    /* slave processes send partial pi sum to master process 0 */
    /* Arbitrarily choose 201 to be our tag. */
    tag = 201;
   
    if (rank != 0) {
/* ---> INSERT MPI code */

    } else {

        for (from = 1; from < size; from++) {

            printf("I have pi = %f\n", pi);

            /* master process receives partial pi sum from other processes */
/* ---> INSERT MPI code */

            printf(".. received %f from proc %d\n", sum, from);
   	        pi = pi + sum;

            fflush(stdout);
        }
    }
    
    if (rank == 0) {
        printf("\nComputed PI %.24f\n", pi);
        printf("The true PI %.24f\n\n", PI25DT);
    }
   
    /* Quit */
/* ---> INSERT MPI code */

    return 0;
}
