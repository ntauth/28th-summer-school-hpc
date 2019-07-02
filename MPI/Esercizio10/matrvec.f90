!------------------------------------------
!  Exercise: Matrix * Vector
!  
!  In this exercise you will compute the matrix vector 
!  product of a matrix A with a vector V.
!  
!  Matrix A is split among processes. Partial results are 
!  collected to master process and written to file. 
!
!  MPI SCATTER and GATHER subroutines will be used
! 
!  This version works only with matrix size commensurable
!  with the number of involved processes.
!------------------------------------------

      program main

      use mpi
      implicit none

      integer ierr,rank,size

      integer i,j
      integer localsize
      integer MSIZE
      parameter(MSIZE=8)
      integer matrix(MSIZE,MSIZE),vector(MSIZE)
      integer matrix_t(MSIZE,MSIZE)
      integer local_matrix(MSIZE*MSIZE)
      integer local_vector(MSIZE*MSIZE)
      
      character*15 outfile
 

      outfile='matrixvec.out'

      
!---  Start up MPI  ----------------------------------------------------
! ---> INSERT MPI code


!---  Check number of processes ----------------------------------------


      if(mod(MSIZE,size).ne.0) then
         if(rank.eq.0) print '(a44,2x,i4)',   &
             'You have to use a number of process that fit',MSIZE

!---  exit MPI on error ------------------------------------------------

         call MPI_FINALIZE(ierr)
         stop

      endif

!---  Process 0 initialize matrix --------------------------------------
      
      if(rank.eq.0) then
      print *,'Matrix-vector product example: matrix A is split among'
      print *,'processes and a local matrix-vector product is computed.'
      print *,'Partial results are collected to master process and'
      print *,'written to file.'
      print *,' using MPI_SCATTER and MPI_GATHER'
      print *,' '

!---  Preparing data structures ----------------------------------------
         do j=1,MSIZE
            vector(j)=j
         enddo

         do i=1,MSIZE
            do j=1,MSIZE
               matrix(i,j) = i+j
            enddo
         enddo
         
!---  Print INPUT data -------------------------------------------------

         
         OPEN(unit=18,file=outfile)
         WRITE(18,*) 'MATRIX'
         do i=1,MSIZE
          WRITE(18,*) (matrix(i,j),j=1,MSIZE)
         enddo
         WRITE(18,*) 'VECTOR'
         WRITE(18,*) (vector(j),j=1,MSIZE)
         WRITE(18,*)

         print '(a7,2x,i4,a30,2x,i4,a10)','Process',rank   &
             ,'is distributing matrix to all',size,'processes'
         
      endif


!---  Size of data for local structures --------------------------------

      localsize = MSIZE / size
      do i=1,MSIZE*MSIZE
            local_matrix(i)=0
      enddo
      do i=1,MSIZE
            local_vector(i)=0
      enddo

!---  Scattering Matrix to all processes, place it in local_matrix -----
!---  While C manages array row after row, F77 use column after column -
!---  We need to pass rows to processes, so we build a trasposed matrix-

      do i=1,MSIZE
         do j=1,MSIZE
            matrix_t(i,j)=matrix(j,i)
         enddo
      enddo

! ---> INSERT MPI code

      print '(a,i4,a,i4)','Process 0 scatters'   &
          ,localsize,' rows to proc',rank

!--- main process broadcast vector V 
! ---> INSERT MPI code

!---  Begin of Product Matrix*Vector -----------------------------------

      do i=1,localsize
        do j=1,MSIZE
           local_vector(i)=local_vector(i)+local_matrix((i-1)*MSIZE+j) &
                *vector(j)
        enddo
      enddo


      
!---  Gather local_vectrs from all processes, place them in vector  ----
! ---> INSERT MPI code

      print '(a,i4,a,i4)','Process 0 gathers',  &
          localsize,' rows from proc',rank

      if(rank.eq.0) then
         WRITE(18,*) 'MATRIX*VECTOR result:'
         WRITE(18,*) (vector(i),i = 1,MSIZE)
         WRITE(18,*)
         print '(a28,2x,a15)','Results can be found in file: ', outfile
      endif


!--- QUIT -------------------------------------------------------------------
      
! ---> INSERT MPI code
      
      end
