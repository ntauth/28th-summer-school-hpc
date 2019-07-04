/* $Id: coord.h,v 1.2 2002/01/08 12:32:48 spb Exp spb $
 * This file defines static arrays that contains the primary coordinates
 * of the particles,
 *
 *  Nbody	Number of particles
 *  Npair	Number of particle pairs
 *  pos		Position of the particles
 * vel		velocity of the particles
 *  f		Forces acting on each particle
 *  visc		viscosity coefficient for each particle
 *  mass		mass of each particle
 *  delta_x	seperation vector for each particle pair
 *  r		seperation for each particle pair
 */

#ifdef DECL
#define DEF
#else
#define DEF extern
#endif
#define Nbody 4*1024
#define  Npair ((Nbody*(Nbody-1))/2)

enum{ Xcoord=0, Ycoord, Zcoord, Ndim };
      
DEF double *pos[Ndim], *vel[Ndim];
DEF double *f[Ndim], *visc, *mass;
DEF double *delta_x[3];
DEF double *r;

#define Size 1.0
#define G 2.0

void evolve(int Nstep, double dt);
