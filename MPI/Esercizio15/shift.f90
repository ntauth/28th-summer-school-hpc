!------------------------------------------
!  Program Shift                          
!  Circular Shift                          
!------------------------------------------

      program main

      use mpi
      implicit none

      integer i
      integer ierr, rank, size
      integer tag, count, dest, source
      integer MSIZE
      parameter(MSIZE=50000)
      integer A(MSIZE), B(MSIZE)

      integer status(MPI_STATUS_SIZE)

!     cartesian topology 
      logical periods(1)
      integer dims(1), comm_cart

!--- Start up MPI  ----------- ----------------------------------------------
! ---> INSERT MPI code


      do i=1,MSIZE
         A(i)=rank
      enddo

!--- sending/receiving arraies A and B --------------------------------------
      tag=201

! --- create 1D cartesian communicator
! ---> INSERT MPI code
      dims(1) =
      periods(1) =


      print *,'Proc',rank,'sends',MSIZE,'integers to proc',dest
      print *,'Proc',rank,'receives',MSIZE,'integers from proc',source



!--- print first content of array A and B -----------------------------------

      print *,'Proc',rank,'has A(1) =',A(1),' and B(1)=',B(1)

!--- QUIT -------------------------------------------------------------------

! ---> INSERT MPI code

      end
