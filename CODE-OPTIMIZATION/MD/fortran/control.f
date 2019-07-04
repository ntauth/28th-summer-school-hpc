C
C $Id: control.f,v 1.1 2002/01/08 12:30:07 spb Exp spb $
C
C Control program for the MD update
C

      PROGRAM MD
      IMPLICIT NONE
      INCLUDE 'coord.inc'
      INTEGER i
      REAL start, stop
      REAL tarray(2)
      REAL etime

C  timestep value
      DOUBLE PRECISION dt
      PARAMETER( dt = 0.2 )

C  number of timesteps to use.
      INTEGER Nstep
      PARAMETER(Nstep=10)

C read the initial data from a file

      OPEN(unit=1,file='input.dat',status='OLD')
      DO i=1,Nbody
        READ(1,10) mass(i),visc(i),
     $    pos(i,Xcoord),pos(i,Ycoord),pos(i,Zcoord),
     $    vel(i,Xcoord),vel(i,Ycoord),vel(i,Zcoord)
      END DO
      CLOSE(unit=1)

C
C Run 5 timesteps and time how long it took
C


      start = etime(tarray)
      CALL evolve(Nstep,dt)
      stop = etime(tarray)

      WRITE(*,*) Nstep, ' timesteps took ',(stop-start)


C write final result to a file
      OPEN(unit=1,file='output.dat')
      DO i=1,Nbody
        WRITE(1,10) mass(i),visc(i),
     $    pos(i,Xcoord),pos(i,Ycoord),pos(i,Zcoord),
     $    vel(i,Xcoord),vel(i,Ycoord),vel(i,Zcoord)
      END DO
      CLOSE(unit=1)

10    FORMAT(8E13.5)

      END

