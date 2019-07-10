program laplace

   implicit none
   integer, parameter                 :: dp=kind(1.d0)
   integer                            :: n, maxIter, i, j, iter = 0
   real (dp), dimension(:,:), pointer :: T, Tnew, Tmp=>null()
   real (dp)                          :: tol, var = 1.d0, top = 100.d0
   real                               :: starttime, endtime
   integer                            :: ierr
   real (dp)                          :: L=2.d0
    
   write(*,*) 'Enter mesh size, max iterations and tolerance:'
   read(*,*,iostat=ierr)  n, maxIter, tol
   if(ierr /= 0)  STOP 'Input error!'

   allocate (T(0:n+1,0:n+1), Tnew(0:n+1,0:n+1),stat=ierr)
   if(ierr/=0) STOP 'T Tnew matrix allocation failed'

   call init_field(T,n,L)

   Tnew = T

   call cpu_time(startTime)

   do while (var > tol .and. iter <= maxIter)
      iter = iter + 1
      var = 0.d0       
      do j = 1, n
         do i = 1, n
            Tnew(i,j) = 0.25d0 * ( T(i-1,j) + T(i+1,j) + T(i,j-1) + T(i,j+1) )
            var = max(var, abs( Tnew(i,j) - T(i,j) ))
         end do
      end do
 
      Tmp =>T; T =>Tnew; Tnew => Tmp; 

   end do

   call cpu_time(endTime)

   write(*,'(/A,F10.4)') ' Elapsed time (s)     =', endTime - startTime
   write(*,*) 'Mesh size            =', n
   write(*,*) 'Stopped at iteration =', iter
   write(*,*) 'The maximum error    =', var
    
   deallocate (T, Tnew)
   nullify(Tmp)

end program laplace
