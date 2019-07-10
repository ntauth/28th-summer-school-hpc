#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <time.h>

#define n (1000)
#define n_short  (4)

double timestwo(double a)
{
    return (2.0*a);
}

int whatis(int nn)
{
   if (nn <100)
     return 10;
   else
     return 20;
}

int main()
{
double a[n],b[n],c[n],d[n];
double da[n][n],db[n][n],dc[n][n];
double summ,x,w;
int ai[n], ind;
int i,j;


  for (j = 0; j < n; j++)
    {
    a[j] = ((double)rand())/((double)RAND_MAX);
    b[j] = ((double)rand())/((double)RAND_MAX);
    c[j] = ((double)rand())/((double)RAND_MAX);
    d[j] = ((double)rand())/((double)RAND_MAX);
    ai[j] = (int)100.0*a[j];
    for (i = 0; i < n; i++)
      {
      da[j][i] = ((double)rand())/((double)RAND_MAX);
      db[j][i] = ((double)rand())/((double)RAND_MAX);
      dc[j][i] = 0.0L;
      }
    }

printf("a[5],b[5],c[5],d[5]: %f %f %f %f\n", a[5],b[5],c[5],d[5]);

// 1 - simple vector add

for (i=0;i<n;i++)
    c[i] = a[i] + b[i];

printf("a[5],b[5],c[5],d[5]: %f %f %f %f\n", a[5],b[5],c[5],d[5]);

// 2 - short vector add

for (i=0;i<n_short;i++)
    c[i] = a[i] + b[i];

printf("a[5],b[5],c[5],d[5]: %f %f %f %f\n", a[5],b[5],c[5],d[5]);

// 3 - previous step usage (read after write)

for (i=0;i<n;i++)
    c[i] = c[i-1] + a[i];

printf("a[5],b[5],c[5],d[5]: %f %f %f %f\n", a[5],b[5],c[5],d[5]);

// 4 - next step usage (write after read)

for (i=0;i<n;i++)
    c[i] = c[i+1] + a[i];

printf("a[5],b[5],c[5],d[5]: %f %f %f %f\n", a[5],b[5],c[5],d[5]);

//  5 - double assignment (write after write)

for (i=0;i<n;i++)
    {
    c[i] = a[i];
    c[i+1] = b[i];
    }

printf("a[5],b[5],c[5],d[5]: %f %f %f %f\n", a[5],b[5],c[5],d[5]);

// 6 - reduction

summ =0.0;
printf("summ: %f\n", summ);
for (i=0;i<n;i++)
    summ = summ + c[i];

printf("summ: %f\n", summ);

// 7 - loop bound with function

for (i=0;i<whatis(n);i++)
    c[i] = c[i-1] + a[i];

printf("a[5],b[5],c[5],d[5]: %f %f %f %f\n", a[5],b[5],c[5],d[5]);

//  8 - mixed data
for (i=0;i<n;i++)
    c[i] = ai[i] + b[i];

printf("a[5],b[5],c[5],d[5]: %f %f %f %f\n", a[5],b[5],c[5],d[5]);

//9 - branching in loop
for (i=0;i<n;i++)
    if (a[i] > 0.5) 
      c[i] =0.0;
    else
      c[i] =1.0;

printf("a[5],b[5],c[5],d[5]: %f %f %f %f\n", a[5],b[5],c[5],d[5]);

//10 - branching in loop - II
w = 2.73;
for (i=0;i<n;i++) {
    if (a[i] < 0) x = b[i]*w ;
    d[i] = a[i]+1;
    if (a[i] < 0) c[i] = x*a[i];
}
printf("a[5],b[5],c[5],d[5]: %f %f %f %f\n", a[5],b[5],c[5],d[5]);

//11 - mod operator inside loop

for (i=0;i<n;i++) {
   c[i] = (100*(int)(a[i]))%7 + c[i] ; 
}
printf("a[5],b[5],c[5],d[5]: %f %f %f %f\n", a[5],b[5],c[5],d[5]);

//12 - complex index computation

for (i=0;i<n;i++) {
   ind = (int)(sqrt((float)i)) ; 
   c[ind] = (100*(int)(a[i]))%7 ; 
}
printf("a[5],b[5],c[5],d[5]: %f %f %f %f\n", a[5],b[5],c[5],d[5]);

//13 - break (exit)

for (i=0;i<n;i++) {
   c[i] = a[i] - b[i];
   if(c[i] < 0.) break;
}
printf("a[5],b[5],c[5],d[5]: %f %f %f %f\n", a[5],b[5],c[5],d[5]);

//14 - continue (cycle)

for (i=0;i<n;i++) {
   c[i] = a[i] - b[i];
   if(c[i] < 0.) continue;
   c[i] = c[i]-2.*b[i];
}
printf("a[5],b[5],c[5],d[5]: %f %f %f %f\n", a[5],b[5],c[5],d[5]);

// 15 - nested loops

   for (j = 0; j < n; j++)
       for (i = 0; i < n; i++)
           dc[i][j] = da[i][j] + db[i][j];

printf("da[5][5],db[5][5],dc[5][5]: %f %f %f\n", da[5][5],db[5][5],dc[5][5]);

// 16 - nested loops II

for (j = 0; j < n; j++)
    {
    da[i][j] = 0.0;
    for (i = 0; i < n; i++)
        dc[i][j] = da[i][j] + db[i][j];
    }

printf("da[5][5],db[5][5],dc[5][5]: %f %f %f\n", da[5][5],db[5][5],dc[5][5]);

// 17 - calling function

   for (i = 0; i < n; i++)
       c[i] = timestwo(c[i]);

printf("a[5],b[5],c[5],d[5]: %f %f %f %f\n", a[5],b[5],c[5],d[5]);

// 18 - calling mathematical function

for (i = 0; i < n; i++)
    c[i] = sin(c[i]);

printf("a[5],b[5],c[5],d[5]: %f %f %f %f\n", a[5],b[5],c[5],d[5]);


}



