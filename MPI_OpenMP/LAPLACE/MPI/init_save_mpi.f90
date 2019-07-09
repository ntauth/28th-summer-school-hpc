function ind2pos(i,n,L)
integer, parameter :: dp=kind(1.d0)
integer :: i, n
real(dp) :: ind2pos, L
ind2pos = ((i-1)-(n-1)/ 2.0)*L/(n-1)
end function ind2pos

subroutine init_field(temp,n,L,ix_start,iy_start,ix_size,iy_size)
! initialize the T field
integer, parameter :: dp=kind(1.d0)
integer :: ix,iy,n,ix_start, iy_start, ix_size,iy_size
real(dp), dimension(0:ix_size+1,0:iy_size+1) :: temp
real(dp) :: ind2pos, L, x, y
real(dp), parameter :: sigma = 0.1d0
real(dp), parameter :: tmax = 100.d0

do iy=0,iy_size+1
    do ix=0,ix_size+1
        x = ind2pos(ix+ix_start,n,L)
        y = ind2pos(iy+iy_start,n,L)
        temp(ix,iy) = tmax*exp(-(x**2+y**2)/(2.0*sigma**2))
    enddo
enddo
end subroutine init_field

