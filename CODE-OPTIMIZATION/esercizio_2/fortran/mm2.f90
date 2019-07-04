! =====================================================================
!     ****** CODICI/mm
!
!     COPYRIGHT
!       (c) 2002/2012 by CASPUR/G.Amati,F.Salvadore
!     NAME
!       mm
!     DESCRIPTION
!       Matrix Multiplication
!       naive version: no optimization
!     INPUTS
!       none
!     OUTPUT
!       none
!     TODO
!
!     NOTES
!       integer variables used: i,j,k,n
!       real variables used:    randd,a,b,c,mflop
!                               time1, time2
!
!     *****
! =====================================================================
!
program mm
!
    use precision_module
    use timing_module
       
    implicit none
!
    integer i,j,k ! index
!    integer, parameter :: n=1024            ! size of the matrix
    include 'size.h'
!
    real(my_kind) a(1:n,1:n) ! matrix
    real(my_kind) b(1:n,1:n) ! matrix
    real(my_kind) c(1:n,1:n) ! matrix (destination)
    real(my_kind) time1, time2 ! timing
    real(my_kind) mflops ! Mflops
    real(my_kind) sum 
    
!
    mflops = 2*float(n)*float(n)*float(n)/(1000.0*1000.0)
!
    call timing(time1)
    call random_number(a)
    call random_number(b)
    c = 0._my_kind
    call timing(time2)
    write(*,*) "--------------------------------------"
    write(*,*) " Matrix-Matrix Multiplication         "
    write(*,*) " Calcolo con precisione: ",precision(a(1,1))
    write(*,*) " rel. 0, naive multiplication         "
    write(*,*) " size =", n                      
    write(*,*) "--------------------------------------"
    write(*,*) "initialization", time2-time1
    write(*,*) a(n/2,n/2),b(n/2,n/2),c(n/2,n/2)
!
! main loop
!
    call timing(time1)
!
!  qui sotto va completato il programma, prodotto righe per colonne
!   c_ij = c_ij + a_ik * b_kj     
!
            do i=1,n
       do j=1,n
            sum=0.0
         do k=1,n
             sum= sum + a(i,k)*b(k,j)
             c(i,j)= sum 
            end do
         end do
       end do


!
!  qui sopra va completato il programma, prodotto righe per colonne
!
    call timing(time2)
    write(*,*) "--------------------------------------"
    write(*,*) "time for moltiplication", time2-time1
    write(*,*) "Mflops                 ", mflops/(time2-time1)
    write(*,*) "--------------------------------------"
    write(*,*) "       "
    write(*,*) "       "
    write(*,*) a(n/2,n/2),b(n/2,n/2),c(n/2,n/2)
!
end program mm

