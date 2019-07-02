/* Example: Hello
 *
 * All processes print an Hello World with its rank
*/  
#include <stdio.h>
#include "mpi.h"

int main(int argc, char **argv)
{
    int rank, size;
    
    /* initialize MPI */
    MPI_Init(&argc, &argv);

    /* get my identifier in standard communicator */
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    /* get the number of processes in standard communicator */
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    printf("Hello! I am process %d of %d\n", rank, size);
     
    /* finalize MPI */
    MPI_Finalize();

    return 0;
}

