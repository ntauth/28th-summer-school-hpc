#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <time.h>

#define n (1000000)
#define n_rep  (10)

int main()
{
double a[n], b[n],c[n];
int i, j, itest;
double rtest;
float time1, time2;

for (i = 0; i < n; i++)
	{
	a[i] = ((double)rand())/((double)RAND_MAX);
	b[i] = ((double)rand())/((double)RAND_MAX);
	}

printf("a[5],b[5],c[5]: %f %f %f \n", a[5],b[5],c[5]);

time1 = clock();

// simple vector add 
for (j=0;j<n_rep;j++)
    for (i=0;i<n;i++)
	c[i] = pow(a[i],0.3) + pow(b[i],0.2);
	
time2 = clock();
rtest =  ((double)rand())/((double)RAND_MAX);
itest = (int)(2000*rtest);

printf("Elapsed time for simple loop:  %f \n", (time2 - time1)/(double) CLOCKS_PER_SEC);
printf("a(itest),b(itest),c(itest) %f %f %f \n", a[itest],b[itest],c[itest]);


}



