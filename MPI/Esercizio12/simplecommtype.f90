!--------------------------------------------c
!  Exercise: timing non-blocking sends
!
!  In this exercise you will try non-blocking
!  communications (syncronous and buffered)
!  to send a matrix from process 0 to process 1.
!
! Follow this rules:
!  - Before the two communication, a barrier should
!    syncronize the processes;
!  - Process 0 will begin the non-blocking send
!  - while process 1 will sleep for 5 seconds 
!    before starting the receive
!  - measure how long process 0 will take in
!    the two different sending calls
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

      double precision matrix(MSIZE,MSIZE)


      INTEGER mpibuffer_length
      ! timing
      double precision startTime, endTime
      double precision, DIMENSION(:), ALLOCATABLE :: mpibuffer
      


!--- Start up MPI  ----------- -----------------------------------------------
! ---> INSERT MPI code

!--- Check number of processes ----------------------------------------------

      if(size.ne.2) then
         if(rank.eq.0) print *, 'I need two processes to run'

!--- exit MPI on error ------------------------------------------------------
         call MPI_FINALIZE(ierr)
         stop

      endif

!---  Syncronous communication -----------------------------------------


      if(rank.eq.0) then
        print *, 'Communication mode examples: process 0 sends a vector'
        print *, 'to process 1 using a syncronous and a buffered send.'
        print *, 'Process 1 waits for 5 seconds before starting the'
        print *, 'corresponding receive call. Time spent by process 0'
        print *, 'in the syncronous and buffered sends is reported.'

         do i=1,MSIZE
            do j=1,MSIZE
               matrix(i,j)= dble(i+j)
            enddo
         enddo

      endif

      CALL MPI_BARRIER(MPI_COMM_WORLD, ierr)

      if(rank.eq.0) then

! ---> INSERT MPI code
         
         print '(a12,2x,f10.7,2x,a18)','Proc 0 spent',endTime - startTime &
              ,'to exit from SSend.'

      else

!---  Process 1 sleeps for 5 seconds and receive ---------------------
         CALL sleep(5)
! ---> INSERT MPI code

      endif


!---  Buffered Communications ------------------------------------------

      if(rank.eq.0) then
         
         do i=1,MSIZE
            do j=1,MSIZE
               matrix(i,j)= dble(i+j)
            enddo
         enddo
         
      endif

      CALL MPI_BARRIER(MPI_COMM_WORLD, ierr)

      if(rank.eq.0) then

         mpibuffer_length=msize*msize+MPI_BSEND_OVERHEAD
         ALLOCATE(mpibuffer(mpibuffer_length))
! ---> INSERT MPI code


! ---> INSERT MPI code


         print '(a12,2x,f10.7,2x,a18)','Proc 0 spent',endTime - startTime &
                ,'to exit from BSend.'


      else

!---  Process 1 sleeps for 5 seconds and receive ---------------------
         CALL sleep(5)
! ---> INSERT MPI code
         
      endif


!--- QUIT --------------------------------------------------------------------
! ---> INSERT MPI code
            
end program main
