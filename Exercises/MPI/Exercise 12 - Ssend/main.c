#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

/************ Macros and Typedefs **/
#define mpi_error_status_t int

#define __info(_Fmt, ...) \
    fprintf(stdout, "[+] " _Fmt "\n", __VA_ARGS__)

#define __error(_Fmt, ...) \
    fprintf(stderr, "[!] " _Fmt "\n", __VA_ARGS__)

#define PAYLOAD_SIZE 64

/************ Functions           **/
mpi_error_status_t main(int argc, char** argv)
{
    MPI_Status recv_status;
    mpi_error_status_t status;
    int comm_proc_rank, comm_group_size;
    float* payload;
    float* recv_buffer;
    int tm_start, tm_end;
    int i;

    /** @region Initialization */
    status = MPI_Init(&argc, &argv);

    assert(status == MPI_SUCCESS);

    /** @region - */
    MPI_Comm_rank(MPI_COMM_WORLD, &comm_proc_rank);
    MPI_Comm_size(MPI_COMM_WORLD, &comm_group_size);

    __info("Process %d out of %d", comm_proc_rank, comm_group_size);

    switch (comm_proc_rank)
    {
        case 0:
            payload = malloc(PAYLOAD_SIZE * sizeof(float));

            for (i = 1; i <= PAYLOAD_SIZE; i++)
                payload[i - 1] = i * i;
            
            tm_start = MPI_Wtime();
            MPI_Ssend(payload, PAYLOAD_SIZE, MPI_FLOAT, 1, 1337, MPI_COMM_WORLD);
            tm_end = MPI_Wtime();

            __info("Execution took %d seconds.", tm_end - tm_start);

            break;
        case 1:
            recv_buffer = malloc(PAYLOAD_SIZE * sizeof(float));

            sleep(5);
            MPI_Recv(recv_buffer, PAYLOAD_SIZE, MPI_FLOAT, 0, 1337, MPI_COMM_WORLD, &recv_status);
	    
            break;
        default:
            __error("Invalid rank.", NULL);
            break;
    }

    /** @region Finalization */
    status = MPI_Finalize();

    assert(status == MPI_SUCCESS);
  
    getchar();
 
    return status;
}
