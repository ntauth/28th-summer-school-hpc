module timing
integer, parameter :: myk=kind(1.d0)
contains
subroutine time(t)

real(myk), intent(out) :: t
integer :: time_array(8)

call date_and_time(values=time_array)
t = 3600.*time_array(5)+60.*time_array(6)+time_array(7)+time_array(8)/1000.

end subroutine time

end module timing

program vectorization_test

use timing

implicit none
integer, parameter :: n=10000000
integer, parameter :: n_rep=10
real :: rtest
integer :: itest
real(myk) :: a(n),b(n),c(n)
integer :: i,i_rep
real(myk) :: start_time, end_time

call random_number(a)
call random_number(b)

print*,'a(5),b(5),c(5): ',a(5),b(5),c(5)
!-----------------------------------------------------------------
! 1 - simple vector add
!-----------------------------------------------------------------
call time(start_time)
do i_rep=1,n_rep
   do i=1,n
      c(i) = a(i)**0.3_myk+b(i)**0.2_myk
   enddo
enddo
call time(end_time)
call random_number(rtest)
itest = int(2000*rtest)
print*,'Elapsed time for simple loop: ',end_time-start_time
print*,'a(itest),b(itest),c(itest): ',a(itest),b(itest),c(itest)
end program vectorization_test
