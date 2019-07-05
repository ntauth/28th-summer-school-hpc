/*
 * $Id: control-c.c,v 1.2 2002/01/08 12:32:48 spb Exp spb $
 *
 * Control program for the MD update
 *
 */
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define DECL
#include "coord.h"


int main(int argc, char *argv[]){
int i;
float  etime;
FILE *in, *out;
time_t start,stop;
/*  timestep value */
double dt=0.2;

/*  number of timesteps to use. */
int Nstep=10;

  if( argc > 1 ){
   Nstep=atoi(argv[1]);
  }

  /* set up multi dimensional arrays */
  r = calloc(Nbody*Nbody,sizeof(double));
  mass = calloc(Nbody,sizeof(double));
  visc = calloc(Nbody,sizeof(double));
  f[0] = calloc(Ndim*Nbody,sizeof(double));
  pos[0] = calloc(Ndim*Nbody,sizeof(double));
  vel[0] = calloc(Ndim*Nbody,sizeof(double));
  delta_x[0] = calloc(Ndim*Nbody*Nbody,sizeof(double));
  for(i=1;i<Ndim;i++){
    f[i] = f[0] + i * Nbody;
    pos[i] = pos[0] + i * Nbody;
    vel[i] = vel[0] + i * Nbody;
    delta_x[i] = delta_x[0] + i*Nbody*Nbody;
  }

/* read the initial data from a file */

  in = fopen("input.dat","r");

  if( ! in ){
    perror("input.dat");
    exit(1);
  }

  for(i=0;i<Nbody;i++){
    fscanf(in,"%13le%13le%13le%13le%13le%13le%13le%13le\n",mass+i,visc+i,
      &pos[Xcoord][i], &pos[Ycoord][i], &pos[Zcoord][i],
      &vel[Xcoord][i], &vel[Ycoord][i], &vel[Zcoord][i]);
  }
  fclose(in);

/*
 * Run Nstep timesteps and time how long it took
 */


      start=time(NULL);
      evolve(Nstep,dt); 
      stop=time(NULL);

      printf("%d timesteps took %f seconds\n",Nstep,(double)(stop-start));


/* write final result to a file */

  out = fopen("output.dat","w");

  if( ! out ){
    perror("output.dat");
    exit(1);
  }

  for(i=0;i<Nbody;i++){
    fprintf(out,"%13.5E%13.5E%13.5E%13.5E%13.5E%13.5E%13.5E%13.5E\n",
      mass[i],visc[i],
      pos[Xcoord][i], pos[Ycoord][i], pos[Zcoord][i],
      vel[Xcoord][i], vel[Ycoord][i], vel[Zcoord][i]);
  }
  fclose(out);

}
