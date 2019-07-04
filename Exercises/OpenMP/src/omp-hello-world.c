/**
 * @author Ayoub Chouak (@ntauth)
 */

#include <stdio.h>

#if defined(_OPENMP)
    #include <omp.h>
#endif

int main()
{
    #if defined(_OPENMP)

    int thread_id;

    #pragma omp parallel private(thread_id)
    {
        thread_id = omp_get_thread_num();

        #pragma critical
        printf("[+] Thread %d\n", thread_id);
    }

    #endif

    return 0;
}