!---------------------------------------------------
! Exercise: Circular Shift non-blocking
!
! In this exercise you will communicate a matrix 
! among process in a circular topology, so that
! every process has a left and a right neighbor
! to receive and to send data respectivelly.
!
! Resolve deadlocks with non-blocking MPI function
!---------------------------------------------------

      program main

      use mpi
      implicit none

      integer i
      integer ierr,rank,size
      integer tag,from,to
      integer MSIZE
      parameter(MSIZE=50000)
      integer A(MSIZE),B(MSIZE)

      integer status(MPI_STATUS_SIZE)
      integer request
      
      
!--- Start up MPI  ---------------------------------------------------------
! ---> INSERT MPI code

!----- print banner --------------------------------------------------------
      if (rank.eq.0) then
         print *,    &
             'Circular shift example: each process fills matrix A' 
         print *,    &
             'elements with its rank and sends them to the right'
         
         print *,'process which receives them into matrix B'
         print *

      endif
    
!-----------------------------------------------------------------------
!    Arbitrarily choose 201 to be our tag. Calculate the rank of the   
!    to process. Use the modulus operator so that the                   
!    last process "wraps around" to rank zero.                          
!-----------------------------------------------------------------------

! ---> INSERT code
      tag=
      to = 
      from = 

      do i=1,MSIZE
         A(i)=rank
      enddo 

!---  starting non blocking send of array A  ---------------------------


! ---> INSERT MPI code

      print '(a4,2x,i2,2x,a8,2x,i5,2x,a18,2x,i4)','Proc',rank,'sends'  &
          ,MSIZE,'integers to proc',to

!---  starting blocking receives of array A in B -----------------------

     
! ---> INSERT MPI code

     print '(a4,2x,i2,2x,a8,2x,i5,2x,a18,2x,i4)','Proc',rank,'receives'&
          ,MSIZE,'integers from proc',from


!---  Wait for completition --------------------------------------------
! ---> INSERT MPI code

!--- print first content of array A and B ------------------------------

      print '(a4,2x,i2,2x,a10,2x,i2,2x,a10,i2)','Proc',rank,'has A(1)='&
          ,A(1),' and B(1)=',B(1)
      print *,'******************************************'

!--- QUIT --------------------------------------------------------------
      
! ---> INSERT MPI code
      
      end
