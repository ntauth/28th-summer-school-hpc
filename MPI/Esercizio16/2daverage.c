#include <stdlib.h>
#include <stdio.h>
#include <mpi.h>


int main(int argc, char *argv[])
{
    MPI_Status status;
    int rank, size, tag, tag1;
    int source, dest;
    int i, j;
    int value, north, south, east, west;
    double average, toBePrinted;

    /* cartesian topology */
    MPI_Comm comm_cart;
    int periods[2];
    int dims[2], coords[2];

    /* Start up MPI */
/* ---> INSERT MPI code */


    value = rank;

    /* create 2D cartesian communicator */
    periods =
    dims =
/* ---> INSERT MPI code */

    tag = 200;
    tag1 = 201;

    /* send to nord/from south (using MPI_Cart_shift)*/
/* ---> INSERT MPI code */

    /* send to south/from north (using MPI_Cart_shift) */
/* ---> INSERT MPI code */

    /* send to east/from west (using MPI_Cart_shift) */
/* ---> INSERT MPI code */

    /* send to west/from east (using MPI_Cart_shift) */
/* ---> INSERT MPI code */


    average = 0.25 * (north + south + east + west);

    /* writing results */
    if (rank == 0)
    {
       for (i=0; i < dims[0]; i++)
       {
          for (j=0; j < dims[1]; j++)
          {
              coords[0] = i;
              coords[1] = j;
/* ---> INSERT MPI code (MPI_Cart_rank) */

              if (source != 0)
              {
/* ---> INSERT MPI code */
                 MPI_Recv ...
                 printf(" %d:(%d,%d) %5.2lf     ", source, i, j, toBePrinted);
              }
              else
                 printf(" %d:(%d,%d) %5.2lf     ", source, i, j, average);

          }
          printf("\n");
       }
    }
    else
/* ---> INSERT MPI code */
       MPI_Send ...


    /* Quit */
/* ---> INSERT MPI code */

    return 0;
}

