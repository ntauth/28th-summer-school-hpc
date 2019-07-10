// solves 2-D Laplace equation using a relaxation scheme
#define MAX(A,B) (((A) > (B)) ? (A) : (B))
#define ABS(A)   (((A) <  (0)) ? (-(A)): (A))

#include <stdio.h>
#include <math.h>
#include <float.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

double ind2pos(int i, int n, double L);
int init_field(double *temp, int n, int L);

int main() {
   
   double *T, *Tnew, *Tmp;
   double tol, var = DBL_MAX, top = 100.0;
   unsigned n, n2, maxIter, i, j, iter = 0;
   int itemsread;
   FILE *fout;
   double L=2.0;

   printf("Enter mesh size, max iterations and tolerance: \n");
   itemsread = scanf("%u ,%u ,%lf", &n, &maxIter, &tol);

   if (itemsread!=3) {
      fprintf(stderr, "Input error!\n");
      exit(-1);
   }

   n2 = n+2;
   T = calloc(n2*n2, sizeof(*T));
   Tnew = calloc(n2*n2, sizeof(*T));

   if (T == NULL || Tnew == NULL) {
      fprintf(stderr, "Not enough memory!\n");
      exit(EXIT_FAILURE);
   }

   init_field(T,n,L);
   
   for(i = 0; i<=n+1; i++) 
      for(j = 0; j<=n+1; j++) 
         Tnew[i*n2+j] = T[i*n2+j] ;


   time_t startTime = clock();

   while(var > tol && iter <= maxIter) {
      ++iter;
      var = 0.0;
      for (i=1; i<=n; ++i)
         for (j=1; j<=n; ++j) {         
            Tnew[i*n2+j] = 0.25*( T[(i-1)*n2+j] + T[(i+1)*n2+j] 
                                + T[i*n2+(j-1)] + T[i*n2+(j+1)] );
#ifdef basic        
            var = fmax(var, fabs(Tnew[i*n2+j] - T[i*n2+j]));
#else
            var = MAX(var, ABS(Tnew[i*n2+j] - T[i*n2+j]));
#endif
         }

         Tmp=T; T=Tnew; Tnew=Tmp;


   }

   double endTime = (clock() - startTime) / (double) CLOCKS_PER_SEC;

   printf("Elapsed time (s) = %.2lf\n", endTime);
   printf("Mesh size: %u\n", n);
   printf("Maximum error: %lE\n", var);
   printf("iter: %8u, variation = %12.4lE\n", iter, var);

   free(T);
   free(Tnew);
   return 0;
}
