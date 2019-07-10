// solves 2-D Laplace equation using a relaxation scheme
#define MAX(A,B) (((A) > (B)) ? (A) : (B))
#define ABS(A)   (((A) <  (0)) ? (-(A)): (A))

#include <stdio.h>
#include <math.h>
#include <float.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <mpi.h>

double ind2pos(int i, int n, double L) ;
int init_field(double *temp, int n, int L, int ix_start, int iy_start, int ix_size, int iy_size) ;

int main(int argc, char *argv[]) {
   
   unsigned n, stride_x, stride_y, maxIter, i, j, iter = 0;
   double tol, var = DBL_MAX, top = 100.0;
   double *T, *Tnew, *Tmp;
   int itemsread;
   double startTime, endTime;
   FILE *fout;
   double L=2.0;
// MPI
   int rank, nprocs, required, provided, tag=201;
   MPI_Status status;
   MPI_Comm cartesianComm;
   int cart_rank, cart_dims[2], cart_coord[2];
   int cart_reorder, cart_periods[2];
   int mymsize_x, mymsize_y, res, mystart_x, mystart_y;
   double *buffer_s_rl,*buffer_s_lr;
   double *buffer_s_tb,*buffer_s_bt;
   double *buffer_r_rl,*buffer_r_lr;
   double *buffer_r_tb,*buffer_r_bt;
   int source_rl, dest_rl, source_lr, dest_lr;
   int source_tb, dest_tb, source_bt, dest_bt;
   double myvar=1.0;
   int ierr;
   char filename[14];
   int output=0;

   ierr = MPI_Init_thread(&argc, &argv, MPI_THREAD_SINGLE, &provided);

   // if (provided < MPI_THREAD_*)
   //    MPI_Abort(MPI_COMM_WORLD, 1);

   ierr = MPI_Comm_rank(MPI_COMM_WORLD, &rank);
   ierr = MPI_Comm_size(MPI_COMM_WORLD, &nprocs);

   if ( rank == 0 ) {
      fprintf(stderr,"Enter mesh size, max iterations and tolerance: ");
      itemsread = scanf("%u ,%u ,%lf", &n, &maxIter, &tol);
      if (itemsread!=3) {
         fprintf(stderr, "Input error!\n");
         MPI_Finalize();
         exit(-1);
      }
   }

   // broadcast input parameters (n,maxIter,tol) from process 0 to others
   MPI_Bcast(&n, 1, MPI_INT, 0, MPI_COMM_WORLD);
   MPI_Bcast(&maxIter, 1, MPI_INT, 0, MPI_COMM_WORLD);
   MPI_Bcast(&tol, 1, MPI_DOUBLE, 0, MPI_COMM_WORLD);

   // creating a new communicator with a 2D cartesian topology 
   cart_dims[0] = 0 ; cart_dims[1] = 0 ;
   MPI_Dims_create(nprocs,2,cart_dims);
   cart_periods[0] = 0 ; cart_periods[1] = 0 ;
   cart_reorder = 0;
   MPI_Cart_create(MPI_COMM_WORLD, 2, cart_dims, 
     cart_periods, cart_reorder, &cartesianComm );
   MPI_Comm_rank(cartesianComm, &cart_rank);
   MPI_Cart_coords(cartesianComm, cart_rank, 2, cart_coord);

   // calculating problem size/process
   res = n% cart_dims[0];
   mymsize_x = n / cart_dims[0];
   mystart_x = mymsize_x * cart_coord[0];
   if (cart_coord[0] > cart_dims[0] -1-res) {
      mymsize_x = mymsize_x + 1;
      mystart_x = mystart_x + cart_coord[0] - (cart_dims[0] -res);
   }
   res = n% cart_dims[1];
   mymsize_y = n / cart_dims[1];
   mystart_y = mymsize_y * cart_coord[1];
   if (cart_coord[1] > cart_dims[1] -1-res) {
      mymsize_y = mymsize_y + 1;
      mystart_y = mystart_y + cart_coord[1] - (cart_dims[1] -res);
   }
//   printf("I am %d of %d processes\n",rank,nprocs);
//   printf("mymsize_x:  %d\n",mymsize_x);
//   printf("mymsize_y:  %d\n",mymsize_y);

   stride_x = mymsize_x + 2;
   stride_y = mymsize_y + 2;
   // allocating memory for T , Tnew and buffers, calloc initializes to zero...
   T = calloc(stride_x*stride_y, sizeof(*T));
   Tnew = calloc(stride_x*stride_y, sizeof(*T));
   buffer_s_rl = calloc(mymsize_y, sizeof(*T));
   buffer_s_lr = calloc(mymsize_y, sizeof(*T));
   buffer_s_tb = calloc(mymsize_x, sizeof(*T));
   buffer_s_bt = calloc(mymsize_x, sizeof(*T));
   buffer_r_rl = calloc(mymsize_y, sizeof(*T));
   buffer_r_lr = calloc(mymsize_y, sizeof(*T));
   buffer_r_tb = calloc(mymsize_x, sizeof(*T));
   buffer_r_bt = calloc(mymsize_x, sizeof(*T));

   init_field(T,n,L,mystart_x,mystart_y,mymsize_x,mymsize_y);

   for(i = 0; i<=mymsize_x+1; i++) 
      for(j = 0; j<=mymsize_y+1; j++) 
         Tnew[i*stride_y+j] = T[i*stride_y+j] ;

   // calculating source/dest neighbours (right->left)
   MPI_Cart_shift(cartesianComm, 0, -1, &source_rl, &dest_rl);
   // calculating source/dest neighbours (left->right)
   MPI_Cart_shift(cartesianComm, 0,  1, &source_lr, &dest_lr);
   // calculating source/dest neighbours (top->bottom)
   MPI_Cart_shift(cartesianComm, 1, -1, &source_tb, &dest_tb);
   // calculating source/dest neighbours (bottom->top)
   MPI_Cart_shift(cartesianComm, 1,  1, &source_bt, &dest_bt);

   startTime = MPI_Wtime();

   while(var > tol && iter <= maxIter) {
      ++iter;
      var = 0.0;
      myvar = 0.0;
      for(j = 1; j<=mymsize_y; j++) 
         buffer_s_rl[j-1] = T[stride_y+j];
        //--- exchange boundary data with neighbours (right->left)
      MPI_Sendrecv(buffer_s_rl, mymsize_y, MPI_DOUBLE, dest_rl, tag,   
                   buffer_r_rl, mymsize_y, MPI_DOUBLE, source_rl, tag, 
                   cartesianComm, &status);
      if(source_rl >= 0) {
        for(j = 1; j<=mymsize_y; j++) 
           T[stride_y*(mymsize_x+1)+j] = buffer_r_rl[j-1];
      }

      for(j = 1; j<=mymsize_y; j++) 
         buffer_s_lr[j-1] = T[mymsize_x*stride_y+j];
        //--- exchange boundary data with neighbours (left->right)
        MPI_Sendrecv(buffer_s_lr, mymsize_y, MPI_DOUBLE, dest_lr, tag+1,   
                     buffer_r_lr, mymsize_y, MPI_DOUBLE, source_lr, tag+1, 
                     cartesianComm, &status);
      if(source_lr >= 0) {
        for(j = 1; j<=mymsize_y; j++) 
           T[j] = buffer_r_lr[j-1];
      }

      for(i = 1; i<=mymsize_x; i++) 
         buffer_s_tb[i-1] = T[stride_y*i+1];
        //--- exchange boundary data with neighbours (top->bottom)
        MPI_Sendrecv(buffer_s_tb, mymsize_x, MPI_DOUBLE, dest_tb, tag+2,   
                     buffer_r_tb, mymsize_x, MPI_DOUBLE, source_tb, tag+2, 
                     cartesianComm, &status);
      if(source_tb >= 0) {
        for(i = 1; i<=mymsize_x; i++) 
           T[stride_y*i+mymsize_y+1] = buffer_r_tb[i-1];
      }

        //--- exchange boundary data with neighbours (bottom->top)
      for(i = 1; i<=mymsize_x; i++) 
         buffer_s_bt[i-1] = T[stride_y*i+mymsize_y];
        MPI_Sendrecv(buffer_s_bt, mymsize_x, MPI_DOUBLE, dest_bt, tag+3,   
                     buffer_r_bt, mymsize_x, MPI_DOUBLE, source_bt, tag+3, 
                     cartesianComm, &status);
      if(source_bt >= 0) {
        for(i = 1; i<=mymsize_x; i++) 
           T[stride_y*i] = buffer_r_bt[i-1];
      }

      #pragma omp parallel for private(j) collapse(2)
      for (i=1; i<=mymsize_x; ++i)
      {
         for (j=1; j<=mymsize_y; ++j) {         
            Tnew[i*stride_y+j] = 0.25*( T[(i-1)*stride_y+j] + T[(i+1)*stride_y+j] 
                                + T[i*stride_y+(j-1)] + T[i*stride_y+(j+1)] );
#ifdef basic
            myvar = fmax(myvar, fabs(Tnew[i*stride_y+j] - T[i*stride_y+j]));
#else
            myvar = MAX(myvar, ABS(Tnew[i*stride_y+j] - T[i*stride_y+j]));
#endif  
         }
      }
      
      Tmp =T; T =Tnew; Tnew = Tmp; 

      MPI_Allreduce(&myvar, &var, 1, MPI_DOUBLE, MPI_MAX, MPI_COMM_WORLD);

   }

   endTime = MPI_Wtime();

   if ( rank == 0 ) {
      printf("Number of MPI processes %u\n",nprocs);
      printf("Elapsed time (s) = %.2lf\n", endTime-startTime);
      printf("Mesh size: %u\n", n);
      printf("Stopped at iteration: %u\n", iter);
      printf("Maximum error: %lE\n", var);
   }

   free(T);
   free(Tnew);

   ierr = MPI_Finalize();
   return 0;
}
