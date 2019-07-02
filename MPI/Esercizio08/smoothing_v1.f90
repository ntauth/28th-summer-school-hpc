program smoothing

      use mpi

      implicit none

      integer i, j, iter
      integer neighbours, locallength, niter

      parameter (neighbours=1)
      parameter (locallength=10)
      parameter (niter=5)

      integer status(MPI_STATUS_SIZE)
      integer rank, nprocs, tag, ierr
      integer next, prev

      integer sendtoleft, sendtoright
      integer recvfromleft, recvfromright
      DOUBLE PRECISION  newvalue
      DOUBLE PRECISION, DIMENSION(:), ALLOCATABLE :: globalarray
      DOUBLE PRECISION, DIMENSION(:), ALLOCATABLE :: localarray
      DOUBLE PRECISION, DIMENSION(:), ALLOCATABLE :: workarray

      character*15 outfile

      outfile='smoothing.out'

!---  Start up MPI  ---------------------------------------------------

! ---> INSERT MPI code

!---  initialize local data ---
      ALLOCATE(localarray(locallength))
      ALLOCATE(workarray(locallength + 2*neighbours))

      localarray = 0.0 
      workarray = 0.0 

!--- master process prints resume parameters ---
      if (rank.eq.0) then
          print *,'Using ',neighbours,' elements for ', &
                 niter,' iterations'

          ALLOCATE(globalarray(locallength * nprocs))
        
          do i = 1, locallength*nprocs
            globalarray(i) = dble(i)
          end do

!--- master process prints starting array ---
          print *,'Starting array is:'
          do j = 0, nprocs-1
             do i = 1, locallength
                write(*,'(F6.2,2x)', ADVANCE='NO') globalarray(j*locallength+i)
             enddo
             write(*,*)
          enddo
      endif

!--- master distribute chunks of global array to other processes ---

! ---> INSERT MPI code

!--- Arbitrarily choose 201 to be our tag ---
      
      tag = 201
      next = mod(rank + 1,nprocs)
      prev = mod(rank + nprocs - 1,nprocs)

!---  !!!! IMPORTANT NOTE !!!!
!---  From now on, we will have local array containing current data.
!---  We send/copy this data into workarray and then compute new data
!---  into local_array and print it

!--- compute position of the local array from which send and 
!--- receive the border elements from neighbour processes 

      sendtoleft = 
      recvfromleft = 

      sendtoright = 
      recvfromright = 

      do iter = 1, niter

!--- exchange border elements among neighbours processes 

! ---> INSERT MPI code

!--- exchange border elements among neighbours processes 

! ---> INSERT MPI code

    
!--- copy core elements to the working array ---
        do i = 1, locallength
            workarray(i+neighbours) = localarray(i)
        end do

!--- compute mean on elements in the core of the array 
        do i = 1, locallength
            newvalue = 0.0
            do j = - neighbours, neighbours
                newvalue = newvalue + workarray(i+j+neighbours)
            end do
            localarray(i) = newvalue / (2*neighbours+1)
        end do

!--- master process gathers results from other processes ---

! ---> INSERT MPI code

!--- prints out its results ---
        if (rank.eq.0) then
            print *,'ITER ', iter
            do j = 0, nprocs-1
               do i = 1, locallength
                  write(*,'(F6.2,2x)', ADVANCE='NO') globalarray(j*locallength+i)
               enddo
               write(*,*)
            enddo
        endif

      end do


!--- QUIT -------------------------------------------------------------------
      
! ---> INSERT MPI code
      
end program smoothing
