!---------------------------------------------!
!  Exercise: Pi                               !
!                                             !
!  Compute the value of PI using the integral !
!  pi = 4* int 1/(1+x*x)    x in [0-1]        !
!                                             !
!  The integral is approximated by a sum of   !
!  n interval.                                !
!                                             !
!  The approximation to the integral in each  !
!  interval is: (1/n)*4/(1+x*x).              !
!                                             !
!  Each process then adds up every            !
!  n'th interval:                             !
!  (x = -1/2+rank/n, -1/2+rank/n+size/n,...)  !
!  The sums computed by each process are      !
!  added together using REDUCTION             !
!---------------------------------------------!



      program main

      use mpi
      implicit none

      integer ierr,rank,nprocs
      integer i

      integer intervals
      double precision dx,sum,x
      double precision f,pi

      double precision  PI25DT
      parameter        (PI25DT = 3.141592653589793238462643d0)



!--- Executive Stantments ---------------------------


!--- Start up MPI ------------------------------------------------

! ---> INSERT MPI code

      if(rank.eq.0) then
        print *, 'Evaluation of pi example: each process evaluates'
        print *, 'a subsection of the integral 4/(1+x*x) between -1/2'
        print *, 'and 1/2, then sends its partial result to the master'
        print *, ' '
      endif

      intervals=1000
      sum=0.d0
      dx=1.d0/dble(intervals)

!--- Each Process computes integral ------------------------------
      do i=rank+1,intervals,nprocs
         x=dx*(dble(i)-0.5d0)
         f=4.d0/(1.d0+x*x)
         sum=sum+f
      enddo
      
      pi=dx*sum
 
!     reduction of partial pi sum on master process
!      ! ! !           WARNING            ! ! !      
!     MPI STANDARD explicitly declears that the send 
!     buffer must be different from the recv buffer

!     using variable sum as sending buffer
      sum = pi

! ---> INSERT MPI code
    
    
      if(rank.eq.0) then
         PRINT *, '..reduction to master process..'
         PRINT *, ' '
         PRINT '(a13,2x,f30.25)','Computed PI =', pi
         PRINT '(a13,2x,f30.25)','The True PI =', PI25DT
      endif
         

!--- QUIT  --------------------------------------------------------------------
! ---> INSERT MPI code
      
      end
      
