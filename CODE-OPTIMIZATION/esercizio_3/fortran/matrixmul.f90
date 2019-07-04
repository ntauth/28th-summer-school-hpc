module precision_module
   integer, parameter :: dp_kind = kind(1.d0)
   integer, parameter :: sp_kind = kind(1.)
   integer, parameter :: my_kind = dp_kind
end module precision_module
   
module timing_module
   use precision_module
   contains
   subroutine timing(t)
         
   real(my_kind), intent(out) :: t
   integer :: time_array(8)
         
   call date_and_time(values=time_array)
   t = 3600.*time_array(5)+60.*time_array(6)+time_array(7)+time_array(8)/1000.
         
   end subroutine timing
end module timing_module

program mm
!
    use precision_module
    use timing_module
       
    implicit none
!
    integer i,j,k ! index
!    real i,j,k ! index
    integer, parameter :: n=1024            ! size of the matrix
!
    real(my_kind) a(1:n,1:n) ! matrix
    real(my_kind) b(1:n,1:n) ! matrix
    real(my_kind) c(1:n,1:n) ! matrix (destination)
    real(my_kind) time1, time2 ! timing
    real(my_kind) :: mflops, bandwidth, sum
!
    mflops = 2*float(n)*float(n)*float(n)/(1000.0_my_kind*1000.0_my_kind)
    bandwidth = 3*my_kind*float(N)*float(N)/(1024*1024)
!
    call timing(time1)
    call random_number(a)
    call random_number(b)
    c = 0._my_kind 
    call timing(time2)
    write(*,*) "--------------------------------------"
    write(*,*) " Matrix-Matrix Multiplication         "
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
    do j = 1,n
       do k = 1,n
          do i = 1,n
             c(i,j) = c(i,j) + a(i,k)*b(k,j)
          enddo
       enddo
    enddo
!
    call timing(time2)
    print*, "--------------------------------------"
    print*, "time for moltiplication", time2-time1
    print*, "Mflops                 ", mflops/(time2-time1)
    print*, 'bandwidth :  ', bandwidth/(time2-time1)
    print*, "--------------------------------------"

! simple check
    sum = 0._my_kind
    do i=1,n
       do j=1,n 
          sum = sum + c(i,j);
       enddo
    enddo
    write(*,*) 'Check -------------> ',sum
    write(*,*) 'Check -------------> ',c(n/2,n/2)
!
end program mm

