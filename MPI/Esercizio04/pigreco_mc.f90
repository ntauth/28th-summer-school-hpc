PROGRAM MC_GUESS_PI

    use mpi
    IMPLICIT NONE

    INTEGER             :: i, inside
    REAL*8              :: x, y, harvest(2)
    REAL*8              :: guess_pi
    REAL*8              :: pi
    
    ! parsing input
    ! INTEGER             :: arg, num_input_arg
    ! INTEGER, EXTERNAL   :: iargc
    ! CHARACTER(len=128)  :: parsed_arg
    INTEGER :: tries

    INTEGER :: nproc, myid, error
    INTEGER :: myinside, mytries
    INTEGER, DIMENSION(MPI_STATUS_SIZE) :: status

! ---> INSERT MPI code

    IF (myid == 0) THEN
        write (*,*) 'Enter number of iterations: '
        read(*,*) tries
        DO i = 1,nproc-1
           CALL MPI_SEND(tries, 1, MPI_INTEGER, i, i, MPI_COMM_WORLD, error)
        END DO
    ELSE
       CALL MPI_RECV(tries, 1, MPI_INTEGER, 0, myid, MPI_COMM_WORLD, status, error)
    ENDIF

! ---> INSERT code
    ! compute local tries
    mytries = 

    ! assign rest to first processes
    i = MOD(tries,nproc)
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
    IF (myid == 0) THEN

        inside = myinside;

        DO i = 1,nproc-1
! ---> INSERT MPI code

! ---> INSERT code
            inside = 
        ENDDO

        guess_pi = 4.0*inside/tries

        pi = 4.0*ATAN(1.0)
        WRITE(*,*) "Real Pi value: ",Pi
        WRITE(*,*) "Pi estimate: ",guess_pi

    ELSE
! ---> INSERT MPI code

    ENDIF

! ---> INSERT MPI code

END PROGRAM
