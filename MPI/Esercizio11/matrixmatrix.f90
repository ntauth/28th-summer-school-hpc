!------------------------------------------c
!  Exercise: Matrix * Matrix
!  
!  In this exercise you will compute the matrix matrix 
!  product of two matrix A and B.
!  
!  Matrix A is split among processes. Partial results are 
!  collected to master process and written to file. 
!
!  MPI SCATTER and GATHER subroutines will be used
! 
!  This version works only with matrix size commensurable
!  with the number of involved processes.
!------------------------------------------c

program main

      use mpi

      implicit none

      integer ierr,rank,size

      integer i,j,k
      integer MSIZE

      integer remain,localsize

      INTEGER, DIMENSION(:,:), ALLOCATABLE :: matrixA
      INTEGER, DIMENSION(:,:), ALLOCATABLE :: matrixB
      INTEGER, DIMENSION(:,:), ALLOCATABLE :: matrixC     


      INTEGER, DIMENSION(:), ALLOCATABLE :: local_matrixB
      INTEGER, DIMENSION(:), ALLOCATABLE :: local_matrixC




      character*15 outfile
 

      outfile='matrix.out'

      
!---  Start up MPI  ----------- ----------------------------------------
! ---> INSERT MPI code



!---  If we are the console process, get an integer from the user to ---
!     specify the dimension of the matrix   ----------------------------


      if(rank.eq.0) then
         write( *,"('Enter the matrix size to compute')")
         read(*,*) msize
         if(msize.le.0) msize=size
         print '(a,2x,i4)','Matrix size is',msize
      endif

!---  Main process broadcasts matrix size -------------------------------
! ---> INSERT MPI code

      if(mod(MSIZE,size).ne.0) then
         if(rank.eq.0) print '(a44,2x,i4)', &
              'You have to use a number of process that fit',msize
!---  exit MPI on error ------------------------------------------------
         call MPI_FINALIZE(ierr)
         stop
      endif


!---  All Processes allocate matrix A ----------------------------------

      ALLOCATE(matrixA(msize,msize))

!---  Master allocates matrix  B and C ---------------------------------

      if(rank.eq.0) then
         ALLOCATE(matrixB(msize,msize))
         ALLOCATE(matrixC(msize,msize))

!--- Initialize Matrices A and B ----------------------------------------
         
         do i=1,msize
            do j=1,msize
               matrixA(i,j) = i+j
               matrixB(i,j) = i+j
            enddo
         enddo
      endif


!---  Print INPUT data -------------------------------------------------

      if(rank.eq.0) then
         if(MSIZE.le.16) then
            OPEN(unit=18,file=outfile)
            WRITE(18,*) 'MATRIX A'
            do i=1,MSIZE
               WRITE(18,*) (matrixA(i,j),j=1,MSIZE)
            enddo
            WRITE(18,*) 'MATRIX B'
            do i=1,MSIZE
               WRITE(18,*) (matrixB(i,j),j=1,MSIZE)
            enddo
         endif
         
      endif
      

!---  Compute local size -----------------------------------------------

      localsize = msize/size

!---  Allocate local structures ----------------------------------------

      ALLOCATE(local_matrixB(localsize*msize))
      ALLOCATE(local_matrixC(localsize*msize))

!---  Main process brodcasts matrix A ----------------------------------
! ---> INSERT MPI code

!---  Scattering matrix to all process, place it in local matrix -------
! ---> INSERT MPI code      
       

      if(rank.eq.0) print *,'Computing matrix * matrix product'
      
!---  Begin of product matrix * matrix ---------------------------------
      
      
      do i=1,localsize
         do j=1,MSIZE
            local_matrixC((i-1)*msize+j)=0
            do k=1,msize
               ! fortran has different matrix structure 
               local_matrixC((i-1)*msize+j)=  &
                     local_matrixC((i-1)*msize+j) + &
                     matrixA(j,k) * local_matrixB((i-1)*msize+k)
            enddo
         enddo
      enddo


!---  Gathering of matrix C from all processes -------------------------
! ---> INSERT MPI code
   
      
      if(rank.eq.0) then
         
         if(MSIZE.le.16) then
             WRITE(18,*) 'MATRIX*MATRIX'
             do i=1,msize
                WRITE(18,*) (matrixC(i,j),j=1,MSIZE)
             enddo
         endif
         print *,'Result can be find in file :', outfile

      endif
      
      
!---  QUIT -------------------------------------------------------------
! ---> INSERT MPI code
      
end program main
