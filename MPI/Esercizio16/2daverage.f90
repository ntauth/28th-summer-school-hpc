!------------------------------------------c
!  Program Shift                           c
!  Circular Shift                          c
!------------------------------------------c

program main

      use mpi

      implicit none

      integer i, j
      integer ierr, rank, size
      integer tag, tag1, dest, source
      integer value, north, south, east, west
      real*8 average, toBePrinted

      integer status(MPI_STATUS_SIZE)

!      cartesian topology 
       integer comm_cart
       integer dims(2), coords(2)
       logical periods(2)


!--- Start up MPI  ----------- ----------------------------------------------
! ---> INSERT MPI code

      value = rank

! create 2D cartesian communicator
! ---> INSERT MPI code
      periods =
      dims =

      tag=200
      tag1=201

! send to north/from south (using MPI_Cart_shift)
! ---> INSERT MPI code

! send to south/from north (using MPI_Cart_shift)
! ---> INSERT MPI code

! send to east/from west (using MPI_Cart_shift)
! ---> INSERT MPI code

! send to west/from east (using MPI_Cart_shift)
! ---> INSERT MPI code

      average = 0.25d0 * (north + south + east + west)

! writing results
      if (rank .eq. 0) then
         do i = 1, dims(1)
            do j = 1, dims(2)
               coords(1) = i - 1  
               coords(2) = j - 1
! ---> INSERT MPI code (MPI_Cart_rank)

               if ( .not.(source .eq. 0)) then
! ---> INSERT MPI code
                   MPI_Recv ...
                   write(*,fmt="(i2,':(',i2,',',i2,')',f6.2,5x)",advance="no") &
                            source, i, j, toBePrinted
               else
                   write(*,fmt="(i2,':(',i2,',',i2,')',f6.2,5x)",advance="no") &
                            source, i, j, average
               endif
            end do
            write(*,*)
         end do
      else
! ---> INSERT MPI code
         MPI_SEND ...
      endif


! ---> INSERT MPI code

end program main

