#include <assert.h>
#include <stdio.h>
#include <stddef.h>
#include <openmpi/mpi.h>

/************ Macros and Typedefs **/
#define mpi_error_status_t int

#define __info(_Fmt, ...) \
    fprintf(stdout, "[+] " _Fmt, __VA_ARGS__)

#define __error(_Fmt, ...) \
    fprintf(stderr, "[!] " _Fmt, __VA_ARGS__)

#if defined(DEBUG)
    #define xassert(_Cnd, _Fmt, ...) assert(_Cnd)
#else
    #define xassert(_Cnd, _Fmt, ...) __error(_Fmt, __VA_ARGS__)
#endif

/************ Functions           **/
mpi_error_status_t main(int argc, char** argv)
{
    mpi_error_status_t status;
    int comm_proc_rank, comm_group_size;
    int data;

    /** @region Initialization */
    status = MPI_Init(&argc, &argv);

    xassert(status == MPI_SUCCESS, "MPI_Init failed.", NULL);

    /** @region - */
    MPI_Comm_rank(MPI_COMM_WORLD, &comm_proc_rank);
    MPI_Comm_size(MPI_COMM_WORLD, &comm_group_size);

    __info("Process %d out of %d", comm_proc_rank, comm_group_size);

    switch (comm_proc_rank)
    {
        case 0:
            data = 0;
            MPI_Send(&data, 1, MPI_INT, 1, 1337, MPI_COMM_WORLD);
            break;
        case 1:
            data = 1;
            MPI_Send(&data, 1, MPI_INT, 0, 1337, MPI_COMM_WORLD);
            __info("Process %d receives %d from process 0", comm_proc_rank, data);
            break;
        default:
            __error("Invalid rank.", NULL);
            break;
    }

    getchar();

    /** @region Finalization */
    status =  MPI_Finalize();

    xassert(status == MPI_SUCCESS, "MPI_Finalize failed.", NULL);

    return status;
}