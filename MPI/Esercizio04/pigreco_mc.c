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
    MPI_Status status;
    unsigned long int myinside, mytries;

/* ---> INSERT MPI code */

    /* check input */
    inside = 0;
    if ( (argc != 2) || ((tries = atoi(argv[1])) == 0) ) {
        if (myid == 0) printf("\nUsage: %s nTries\n", argv[0]);
        MPI_Finalize();
        exit(EXIT_FAILURE);
    }

/* ---> INSERT code */
    /* compute local tries */
    mytries = 

    /* assign rest to first processes */
    i = tries%nproc;
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

    /* Collect all matches from processes */
    if (myid == 0) {

        inside = myinside;
        for (i=1;i<nproc;i++) {
/* ---> INSERT MPI code */

/* ---> INSERT code */
            inside = 
        }

        pi = 4.0*inside/(double)tries;
        printf("\nReal Pi value: %.16f\n",Pi);
        printf("Pi estimate: %.16f\n",pi);

    } else {
/* ---> INSERT MPI code */

    }

/* ---> INSERT MPI code */

    return 0;
}
