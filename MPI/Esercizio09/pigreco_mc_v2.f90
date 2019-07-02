!---------------------------------------------
!  Exercise: Pi with reduction
!
!  Compute the value of PI using the integral 
!  pi = 4* int 1/(1+x*x)    x in [0-1]        
!
!  The integral is approximated by a sum of   
!  n interval.                                
!
!  The approximation to the integral in each  
!  interval is: (1/n)*4/(1+x*x).                         
!
!  Each process then adds up every             
!  n'th interval:                             
!  (x = -1/2+rank/n, -1/2+rank/n+size/n,...)  
!
!  The sums computed by each process are      
!  reduced on process 0
!---------------------------------------------
PROGRAM MC_GUESS_PI

    use mpi
    IMPLICIT NONE


    INTEGER             :: i, inside
    REAL*8              :: x, y, harvest(2)
    REAL*8              :: guess_pi
    REAL*8              :: pi
    
    INTEGER :: tries

    INTEGER :: nproc, myid, error
    INTEGER :: myinside, mytries
    INTEGER, DIMENSION(MPI_STATUS_SIZE) :: status

    ! inizialize MPI
! ---> INSERT MPI code


    IF (myid == 0) THEN
        write (*,*) 'Enter number of iterations: '
        read(*,*) tries
    ENDIF

    ! Collective broadcast tries to all processess
! ---> INSERT code


    ! compute local tries
! ---> INSERT code
    mytries = 

    ! assign rest to first processes
! ---> INSERT code
    i = 
    IF (myid < i) THEN
        mytries = mytries + 1
    ENDIF

    ! Metodo MONTECARLO
    CALL RANDOM_SEED()

    inside=0
    myinside=0
    DO i = 1,mytries
      CALL RANDOM_NUMBER(harvest)
      x = harvest(1)
      y = harvest(2)
! ---> INSERT code
      IF ( x*x + y*y < 1 )
    ENDDO

    ! Collect all matches from processes
! ---> INSERT MPI code

    IF (myid == 0) THEN
        guess_pi = 4.0*inside/tries

        pi = 4.0*ATAN(1.0)
        WRITE(*,*) "Real Pi value: ",Pi
        WRITE(*,*) "Pi estimate: ",guess_pi
    ENDIF

! ---> INSERT MPI code

END PROGRAM
