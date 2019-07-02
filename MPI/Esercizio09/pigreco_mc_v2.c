/* Exercise: Pi with reduction
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
 * The sums computed by each process are reduced 
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <mpi.h>

#define Pi M_PI

int main(int argc, char *argv[]) {
    unsigned long int i, inside, tries;
    double x, y;
    double pi;
    
    int nproc, myid;
    unsigned long int myinside, mytries;

/* ---> INSERT MPI code */    

    /* check input */
    inside = 0;
    if ( (argc != 2) || ((tries = atoi(argv[1])) == 0) ) {
        if (myid == 0) printf("\nUsage: %s nTries\n", argv[0]);
        MPI_Finalize();
        exit(EXIT_FAILURE);
    }

    /* compute local tries */
/* ---> INSERT code */    
    mytries = 

    /* assign rest to first processes */
/* ---> INSERT code */    
    i = 
    if (myid < i) {
        mytries++;
    }

    /* Metodo MONTECARLO */
    srand48(mytries+myid);

    inside=0;
    myinside=0;
    for (i=0; i<mytries; i++) {
      x = drand48();
      y = drand48();
/* ---> INSERT code */    
      if ( x*x + y*y < 1.0 ) 
    }

    /* Reduction of all matches among processes */
/* ---> INSERT MPI code */    

    if (myid == 0) {
        pi = 4.0*inside/(double)tries;
        printf("\nReal Pi value: %.16f\n",Pi);
        printf("Pi estimate: %.16f\n",pi);
    }

/* ---> INSERT MPI code */    
    return 0;
}
