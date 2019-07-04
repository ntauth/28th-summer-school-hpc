Program Hello_from_Threads
#ifdef _OPENMP
   use omp_lib
#endif
   implicit none

   integer :: iam
#ifdef _OPENMP

!$omp parallel 
   iam=omp_get_thread_num()

!$omp critical
   write(*,*) 'Hello from', iam
!$omp end critical

!$omp end parallel
#else
   write(*,*) 'Hello, this is a serial program'
#endif
end program Hello_from_Threads
