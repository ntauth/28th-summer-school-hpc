program Nbody
   implicit none
   real(kind(1.d0)) :: pos(3,DIM), forces(3, DIM), f(3), ene
   real(kind(1.d0)) :: rij(3), d2, d, cut2=1000.d0
   integer :: i, j, k, nbodies=DIM
   character(50) :: fn

   write(fn,'("positions.xyz.",I0)') nbodies
   open(11,FILE=fn)
   read(11,*) pos
   close(11)

   forces = 0.d0
   ene = 0.d0

!$omp parallel do private(i,j,k,rij,d,d2,f) reduction(+:ene) schedule(guided)
   do i = 1, DIM
      do j = i+1, DIM
         rij(:) = pos(:,i) - pos(:,j)
         d2 = 0.d0
         do k = 1, 3
            d2 = d2 + rij(k)**2
         end do
         if (d2 .le. cut2) then
            d = sqrt(d2)
            f(:) = - 1.d0 / d**3 * rij(:)
            do k=1, 3
!$omp atomic
              forces(k,i) = forces(k,i) +  f(k)
!$omp atomic
              forces(k,j) = forces(k,j) -  f(k)
            end do
            ene = ene + (-1.d0/d)
         end if
      end do
   end do
!$omp end parallel do

      open(12,FILE='results')
      write (12,fmt='(e20.10)') ene
      write (12,fmt='(i5,1x,3e20.10)') (i,  forces(:, i), i =1, nbodies)
      close(12)

end program Nbody
