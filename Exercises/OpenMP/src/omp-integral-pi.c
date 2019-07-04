/**
 * @author Ayoub Chouak (@ntauth)
 *
 */

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

#if defined(_OPENMP)
#include <omp.h>
#endif

#define INTERVALS 1e8

int main(int argc, char **argv)
{
    long int i, intervals = INTERVALS;
    double x, dx, f, sum, pi;
    time_t tm_start;
    double tm_diff;

    tm_start = clock();

    printf("[+] Number of intervals: %ld\n", intervals);

    sum = 0.0;
    dx = 1.0 / intervals;

    #pragma omp parallel for private(x, f) reduction(+:sum)
    for (i = 1; i <= intervals; i++)
    {
        x = dx * ((double) (i - 0.5));
        f = 4.0 / (1.0 + x*x);
        sum = sum + f;
    }

    pi = dx*sum;

    tm_diff = (clock() - tm_start) / (double) CLOCKS_PER_SEC;

    printf("Computed PI %.24f\n", pi);
    printf("The true PI %.24f\n\n", M_PI);
    printf("Elapsed time (s) = %.2lf\n", tm_diff);

    return 0;
}