!------------------------------------------!
!  Example: Hello                          !
!  All processes print an Hello World      !
!  with its rank                           !
!------------------------------------------!

      program main

      use mpi

      integer ierr,rank,procs

!--- initialize MP  -----------------------------------------
      call MPI_INIT(ierr)

!--- get my identifier in standard communicator -------------
      call MPI_COMM_RANK(MPI_COMM_WORLD,rank,ierr)

!--- get the number of processes in standard communicator ---
      call MPI_COMM_SIZE(MPI_COMM_WORLD,procs,ierr)

      print '(a,i2,a,i2)', 'Hello! I am process',rank  &
          ,' of ',procs


!--- finalize MPI  --------------------------.----------------
      call MPI_FINALIZE(ierr)

      end
