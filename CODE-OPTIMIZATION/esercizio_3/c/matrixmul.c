#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <time.h>

#define nn (1024)

double a[nn][nn];       /** matrix**/
double b[nn][nn];
double c[nn][nn];

int main()
{
  int k, i, j, ii, jj;
  double sum;
  float time1, time2, dub_time;

  printf("===============================\n");
  printf("matrix-matric product (double precision) \n");
  printf("size %d \n",nn );
  printf("===============================\n");

  /* initialize matrix */
  time1 = clock();
  for (j = 0; j < nn; j++)
    {
    for (i = 0; i < nn; i++)
      {
      a[j][i] = ((double)rand())/((double)RAND_MAX);
      b[j][i] = ((double)rand())/((double)RAND_MAX);
      c[j][i] = 0.0L;		
      }
    }
  time2 = clock();
  dub_time = (time2 - time1)/(double) CLOCKS_PER_SEC;
  printf("Time for init --------->  %f \n", dub_time);

  time1 = clock();

/*  c_ij = c_ij + a_ik * b_kj                                  */ 

  for (i = 0; i < nn; i ++)
       for (k = 0; k < nn; k++)
            for (j = 0; j < nn; j++)
                 c[i][j] = c[i][j] + a[i][k]*b[k][j];

  time2 = clock();
  dub_time = (time2 - time1)/(double) CLOCKS_PER_SEC;
  printf("===============================\n");
  printf("Time  -----------------> %f \n", dub_time);
  printf("Mflops ----------------> %f \n", 
          2.0*nn*nn*nn/(1000*1000*dub_time));

  /* a simple check */
  sum = 0.0;
  for (i = 0; i < nn; i++)
     for (j = 0; j < nn; j++)
         sum = sum + c[i][j];
  printf("Check -------------> %f \n", sum);
  printf("Check -------------> %f \n", c[nn/2][nn/2]);

   return 0;  
}
