#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <mpi.h>

/************ Macros and Typedefs **/
#define mpi_error_status_t int

#define __info(_Fmt, ...) \
    fprintf(stdout, "[+] " _Fmt "\n", __VA_ARGS__)

#define __error(_Fmt, ...) \
    fprintf(stderr, "[!] " _Fmt "\n", __VA_ARGS__)

#define RANGE_PARTITION_SIZE 2048

/************ Functions           **/
mpi_error_status_t main(int argc, char** argv)
{
    MPI_Status recv_status;
    mpi_error_status_t status;
    int comm_proc_rank, comm_group_size;
    double a, b;
    double pi, psum;
    double dh;
    int chunks_per_proc;
    int i;

    a = 0;
    b = 1;
    pi = psum = 0;
    dh = (b - a) / RANGE_PARTITION_SIZE;

    /** @region Initialization */
    status = MPI_Init(&argc, &argv);

    assert(status == MPI_SUCCESS);

    /** @region - */
    MPI_Comm_rank(MPI_COMM_WORLD, &comm_proc_rank);
    MPI_Comm_size(MPI_COMM_WORLD, &comm_group_size);

    __info("Pi Worker %d", comm_proc_rank);
    
    chunks_per_proc = RANGE_PARTITION_SIZE / comm_group_size;

    for (i = 1 + comm_proc_rank * chunks_per_proc; i <= (comm_proc_rank + 1) * chunks_per_proc; i++)
        psum += (4 * dh) / (1 + pow((i - 0.5) * dh, 2));

    MPI_Reduce(&psum, &pi, 1, MPI_DOUBLE_PRECISION, MPI_SUM, 0, MPI_COMM_WORLD);
   
    if (comm_proc_rank == 0) 
        __info("LIBC Pi = %.10f - Approximation = %.10f", M_PI, pi);

    /** @region Finalization */
    status = MPI_Finalize();

    assert(status == MPI_SUCCESS);

    getchar();

    return status;
}
