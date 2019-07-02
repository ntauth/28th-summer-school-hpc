!--------------------------------------------c
!  Example: simple data type                 c
!  Send and Receive an Integer Data          c
!  Send and Receive a  Double Precision Data c
!  Send and Receive an Array of Integers     c
!--------------------------------------------c


      program main

      use mpi

      implicit none

      integer ierr,rank,size

      integer i,j
      integer status(MPI_STATUS_SIZE)


!--- data to communicate------------------------------------------------------
      integer MSIZE
      parameter (MSIZE=10)
      integer data_int
      double precision data_double
      double precision matrix(MSIZE,MSIZE)



!--- Start up MPI  ----------- -----------------------------------------------

! ---> INSERT MPI code

!--- Check number of processes ----------------------------------------------

      if (size.lt.2) then
         if (rank.eq.0) print *, 'SORRY: need at least 2 processes'

!--- exit MPI on error ------------------------------------------------------
         call MPI_FINALIZE(ierr)
         stop

      endif

!--- INTEGER TYPE -----------------------------------------------------------

      if (rank.eq.0) then

         data_int = 10
! ---> INSERT MPI code

      end if
      if (rank.eq.1) then
! ---> INSERT MPI code

         print *,'Proc 1 receives ',data_int,'from proc 0'
         print *,' '
      endif

!---  ARRAY OF DOUBLE TYPE  --------------------------------------------------

      if (rank.eq.0) then

         do i=1,MSIZE
            do j=1,MSIZE
               matrix(i,j)= dble(i+j)
            enddo
         enddo
! ---> INSERT MPI code

      end if

      if (rank.eq.1) then
! ---> INSERT MPI code

         print *,'Proc 1 receives the following matrix from proc 0'
         write (*,'(10(f6.2,2x))') matrix
      endif

!--- QUIT --------------------------------------------------------------------
! ---> INSERT MPI code
            
      end
