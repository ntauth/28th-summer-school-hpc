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
!  (x = rank/n, rank/n+size/n,...)            !
!                                             !
!  The sums computed by each process are      !
!  added together                             !
!---------------------------------------------!



      program main

      use mpi

      implicit none


      integer ierr,rank,size
      integer tag,from,to
      integer i
      integer status(MPI_STATUS_SIZE)

      integer intervals
      double precision dx,sum,x
      double precision f,pi
      double precision in

      double precision  PI25DT
      parameter        (PI25DT = 3.141592653589793238462643d0)



!--- Executive Stantments ---------------------------


!--- Start up MPI ------------------------------------------------
! ---> INSERT MPI code

      intervals=1000
      sum=0.d0
      dx=1.d0/dble(intervals)

      if(rank.eq.0) then
       write(*,*) 'Evaluation of pi example: each process evaluates'
       write(*,*) 'a subsection of the integral 4/(1+x*x) between 0'
       write(*,*) 'and 1,then sends its partial result to the master.'
       write(*,*)
      endif
!--- Each Process computes integral ------------------------------
      do i=rank+1,intervals,size
         x=dx*(dble(i)-0.5d0)
         f=4.d0/(1.d0+x*x)
         sum=sum+f
      enddo
      
      pi=dx*sum
 
!---  slave processes send partial pi sum to master process 0 ----
!--- Arbitraril choose 201 to our tag ----------------------------

      tag=201
      to=0

      if(rank.ne.0) then
! ---> INSERT MPI code

      else
         do from=1,size-1
            print '(a11,2x,f20.10)','I have pi =',pi
! ---> INSERT MPI code

            print '(a11,2x,f20.10,2x,a9,i4)','.. received',in  &
                ,'from proc',from
            pi=pi+in
         enddo
      endif
    

      if(rank.eq.0) then
         PRINT '(a40)','***************************************'
         PRINT '(a13,2x,f30.25)','Computed PI =', pi
         PRINT '(a13,2x,f30.25)','The True PI =', PI25DT
      endif
         

!--- QUIT  --------------------------------------------------------------------
! ---> INSERT MPI code
      
      end
      
