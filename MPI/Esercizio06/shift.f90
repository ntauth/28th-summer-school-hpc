!------------------------------------------------
! Exercise: Circular Shift
!
! In this exercise you will communicate a matrix 
! among process in a circular topology, so that
! every process has a left and a right neighbor
! to receive and to send data respectivelly.
!
! Check what happens for huge size of the message
!------------------------------------------------

      program main

      use mpi

      implicit none

      integer i
      integer ierr,rank,size
      integer tag,from,to
      integer MSIZE
!--- try to change MSIZE with 500, 5000 and 50000 ---      
!--- does it work for all these sizes? What happens ?
      parameter(MSIZE=500)
      integer A(MSIZE),B(MSIZE)

      integer status(MPI_STATUS_SIZE)
      

!--- Start up MPI  ----------------------------------------------------
! ---> INSERT MPI code

!----- print banner ---------------------------------------------------
      if (rank.eq.0) then
         print *,  &
             'Circular shift example: each process fills matrix A'  
         print *,  &
             'elements with its rank and sends them to the right'   
         
         print *,'process which receives them into matrix B'
         PRINT *,' '
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

!--- starting send of array A  -----------------------------------------

! ---> INSERT MPI code

      print '(a4,2x,i4,2x,a8,2x,i4,2x,a16,2x,i4)','Proc',rank,'sends  '&
          ,MSIZE,'integers to proc',to

!--- starting receives of array A in B ---------------------------------

! ---> INSERT MPI code

     print '(a4,2x,i4,2x,a8,2x,i4,2x,a16,2x,i4)','Proc',rank,'receives'&
          ,MSIZE,'integers from proc',from



!--- print first content of array A and B ------------------------------

      print '(a4,2x,i4,2x,a10,2x,i4,2x,a10,i4)','Proc',rank,'has A(1)='&
          ,A(1),' and B(1)=',B(1)
      print *,'**************************************'

!--- QUIT --------------------------------------------------------------
      
! ---> INSERT MPI code
      
      end
