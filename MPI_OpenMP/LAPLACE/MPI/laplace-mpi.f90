program laplace
   use mpi
   implicit none
   integer, parameter                 :: dp=kind(1.d0)
   integer                            :: n, maxIter, i, j, iter = 0
   real (dp), dimension(:,:), pointer :: T, Tnew, Tmp=>null()
   real (dp)                          :: tol, var = 1.d0, top = 100.d0
   integer                            :: ierr
   real(kind(1.d0)) :: startTime, endTime
! MPI
   integer :: rank, nprocs, required, provided, tag=201, status(MPI_STATUS_SIZE)
   integer :: cartesianComm, cart_rank, cart_dims(2), cart_coord(2)
   logical :: cart_reorder, cart_periods(2)
   integer :: mymsize_x, mymsize_y, res, mystart_x, mystart_y
   real (kind(1.d0)), dimension(:), allocatable :: buffer_s_rl, buffer_s_lr
   real (kind(1.d0)), dimension(:), allocatable :: buffer_s_tb,buffer_s_bt
   real (kind(1.d0)), dimension(:), allocatable :: buffer_r_rl,buffer_r_lr
   real (kind(1.d0)), dimension(:), allocatable :: buffer_r_tb,buffer_r_bt
   integer :: source_rl, dest_rl, source_lr, dest_lr
   integer :: source_tb, dest_tb, source_bt, dest_bt
   real (kind(1.d0)) :: myvar=1.0
   real (kind(1.d0)) :: L=2.d0

   call MPI_Init(ierr)
   call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
   call MPI_Comm_size(MPI_COMM_WORLD, nprocs, ierr) 

   if ( rank == 0 ) then
      write(*,*) 'Enter mesh size, max iterations and tollerance:'
      read(*,*,iostat=ierr)  n, maxIter, tol
      if(ierr /= 0)  then 
         call MPI_FINALIZE(ierr)
         STOP 'Input error!'
      endif
   endif

   ! broadcast input parameters (n,maxIter,tol) from process 0 to others
   call MPI_Bcast(n, 1, MPI_INTEGER, 0, MPI_COMM_WORLD, ierr)
   call MPI_Bcast(maxIter, 1, MPI_INTEGER, 0, MPI_COMM_WORLD, ierr)
   call MPI_Bcast(tol, 1, MPI_DOUBLE_PRECISION, 0, MPI_COMM_WORLD, ierr)

   ! creating a new communicator with a 2D cartesian topology 
   cart_dims = 0 
   call mpi_dims_create(nprocs,2,cart_dims,ierr)
   cart_periods = .false.
   cart_reorder = .false.
   ! call MPI_Dims_Create(nprocs, 2, cart_dims, ierr)
   call MPI_Cart_Create(MPI_COMM_WORLD, 2, cart_dims, &
     cart_periods, cart_reorder, cartesianComm, ierr)
   call MPI_Comm_rank(cartesianComm, cart_rank, ierr)
   call MPI_Cart_coords(cartesianComm, cart_rank, 2, cart_coord, ierr)

   ! calculating problem size/process
   res = mod(n, cart_dims(1))
   mymsize_x = n / cart_dims(1)
   mystart_x = mymsize_x * cart_coord(1)
   if (cart_coord(1) > cart_dims(1) -1-res) then
      mymsize_x = mymsize_x + 1
      mystart_x = mystart_x + cart_coord(1) - (cart_dims(1) -res)
   endif
   res = mod(n, cart_dims(2))
   mymsize_y = n / cart_dims(2)
   mystart_y = mymsize_y * cart_coord(2)
   if (cart_coord(2) > cart_dims(2) -1-res) then
      mymsize_y = mymsize_y + 1
      mystart_y = mystart_y + cart_coord(2) - (cart_dims(2) -res)
   endif

   ! allocating memory for T , Tnew and buffers
   allocate (T(0:mymsize_x+1,0:mymsize_y+1), Tnew(0:mymsize_x+1,0:mymsize_y+1))
   allocate(buffer_s_rl(1:mymsize_y),buffer_s_lr(1:mymsize_y),buffer_s_tb(1:mymsize_x),buffer_s_bt(1:mymsize_x))
   allocate(buffer_r_rl(1:mymsize_y),buffer_r_lr(1:mymsize_y),buffer_r_tb(1:mymsize_x),buffer_r_bt(1:mymsize_x))

   T = 0.d0

   call init_field(T,n,L,mystart_x,mystart_y,mymsize_x,mymsize_y)

   Tnew = T

   ! calculating source/dest neighbours (right->left)
   call MPI_Cart_shift(cartesianComm, 0, -1, source_rl, dest_rl, ierr)
   ! calculating source/dest neighbours (left->right)
   call MPI_Cart_shift(cartesianComm, 0,  1, source_lr, dest_lr, ierr)
   ! calculating source/dest neighbours (top->bottom)
   call MPI_Cart_shift(cartesianComm, 1, -1, source_tb, dest_tb, ierr)
   ! calculating source/dest neighbours (bottom->top)
   call MPI_Cart_shift(cartesianComm, 1,  1, source_bt, dest_bt, ierr)

   startTime = MPI_Wtime()

   do while (var > tol .and. iter <= maxIter)
      iter = iter + 1
      var = 0.d0       
      myvar = 0.d0

      buffer_s_rl(1:mymsize_y) = T(1,1:mymsize_y)
      !--- exchange boundary data with neighbours (right->left)
      call MPI_Sendrecv(buffer_s_rl, mymsize_y, MPI_DOUBLE_PRECISION, dest_rl, tag,         &
                        buffer_r_rl, mymsize_y, MPI_DOUBLE_PRECISION, source_rl, tag, &
                        cartesianComm, status, ierr)
      if(source_rl >= 0) T(mymsize_x+1,1:mymsize_y) = buffer_r_rl(1:mymsize_y)

      buffer_s_lr(1:mymsize_y) = T(mymsize_x,1:mymsize_y)
      !--- exchange boundary data with neighbours (left->right)
      call MPI_Sendrecv(buffer_s_lr, mymsize_y, MPI_DOUBLE_PRECISION, dest_lr, tag+1,  &
                        buffer_r_lr, mymsize_y, MPI_DOUBLE_PRECISION, source_lr, tag+1,        &
                        cartesianComm, status, ierr)
      if(source_lr >= 0) T(0,1:mymsize_y) = buffer_r_lr(1:mymsize_y)

      buffer_s_tb(1:mymsize_x) = T(1:mymsize_x,1)
      !--- exchange boundary data with neighbours (top->bottom)
      call MPI_Sendrecv(buffer_s_tb, mymsize_x, MPI_DOUBLE_PRECISION, dest_tb, tag+2,         &
                        buffer_r_tb, mymsize_x, MPI_DOUBLE_PRECISION, source_tb, tag+2, &
                        cartesianComm, status, ierr)
      if(source_tb >= 0) T(1:mymsize_x,mymsize_y+1) = buffer_r_tb(1:mymsize_x)

      !--- exchange boundary data with neighbours (bottom->top)
      buffer_s_bt(1:mymsize_x) = T(1:mymsize_x,mymsize_y)
      call MPI_Sendrecv(buffer_s_bt, mymsize_x, MPI_DOUBLE_PRECISION, dest_bt, tag+3,  &
                        buffer_r_bt, mymsize_x, MPI_DOUBLE_PRECISION, source_bt, tag+3,        &
                        cartesianComm, status, ierr)
      if(source_bt >= 0) T(1:mymsize_x,0) = buffer_r_bt(1:mymsize_x)

      do j = 1, mymsize_y
         do i = 1, mymsize_x
            Tnew(i,j) = 0.25d0 * ( T(i-1,j) + T(i+1,j) + T(i,j-1) + T(i,j+1) )
            myvar = max(myvar, abs( Tnew(i,j) - T(i,j) ))
         end do
      end do
      Tmp =>T; T =>Tnew; Tnew => Tmp; 

      call MPI_Allreduce(myvar, var, 1, MPI_DOUBLE_PRECISION, &
                    MPI_MAX, MPI_COMM_WORLD, ierr)

   end do

   endTime = MPI_Wtime()

   if ( rank == 0 ) then
      write(*,*) 'Number of MPI processes',nprocs
      write(*,'(/A,F10.4)') ' Elapsed time (s)     =', endTime - startTime
      write(*,*) 'Mesh size            =', n
      write(*,*) 'Stopped at iteration =', iter
      write(*,*) 'The maximum error    =', var
   end if

   deallocate (T, Tnew)
   nullify(Tmp)

   call MPI_Finalize(ierr)

end program laplace
