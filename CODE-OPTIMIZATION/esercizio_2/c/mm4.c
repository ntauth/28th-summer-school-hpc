/** semplice prodotto matrice matrice   **/
/** Giorgio Amati, CASPUR, 2006-2012   **/
/** Francesc Salvadore , CASPUR, 2006-2012    **/
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <time.h>

//#define nn (2048)
#include "size.h"

#include "inc_precision.h"

REAL a[nn][nn];       /** matrici**/
REAL b[nn][nn];
REAL c[nn][nn];
REAL r;

int main()
{
  int k, i, j, ii, jj;
  REAL somma;
  float time1, time2, dub_time;

  printf("===============================\n");
  if(sizeof(a[1][1]) == sizeof(float))  
    printf("prodotto di matrici in singola precisione\n"); 
  else  
    printf("prodotto di matrici in doppia precisione\n"); 
  printf("dimensioni %d \n",nn );
  printf("===============================\n");
  printf("Inizializzazione \n");

  /* initialize matrix */
  time1 = clock();
  for (j = 0; j < nn; j++)
    {
    for (i = 0; i < nn; i++)
      {
      a[j][i] = ((REAL)rand())/((REAL)RAND_MAX);
      b[j][i] = ((REAL)rand())/((REAL)RAND_MAX);
      c[j][i] = 0.0L;		
      }
    }
  time2 = clock();
  dub_time = (time2 - time1)/(double) CLOCKS_PER_SEC;
  printf("Tempo impiegato per inizializzare \n");
  printf("Tempo -----------------> %f \n", dub_time);

  time1 = clock();
/*  qui sotto va completato il programma, prodotto righe per colonne */
/*  c_ij = c_ij + a_ik * b_kj                                  */ 
      for (k = 0; k < nn; k++)       {
  for (j = 0; j < nn; j++)     {
       r=b[k][j];
    for (i = 0; i < nn; i++)       {
      c[i][j]= c[i][j] + a[i][k]*r;
     }
     }
    }
                 

/*  qui sopra va completato il programma, prodotto righe per colonne */
  time2 = clock();
  dub_time = (time2 - time1)/(double) CLOCKS_PER_SEC;
  printf("===============================\n");
  printf("Tempo per prodotto classico \n");
  printf("Tempo -----------------> %f \n", dub_time);
  printf("Mflops ----------------> %f \n", 
          2.0*nn*nn*nn/(1000*1000*dub_time));

  /* semplice controllo */
  somma = 0.0;
  for (i = 0; i < nn; i++)
     for (j = 0; j < nn; j++)
         somma = somma + c[i][j];
  printf("Controllo -------------> %f \n", somma);
  printf("Controllo -------------> %f \n", c[nn/2][nn/2]);

   return 0;  
}
