!------------------------------------------
! Exercise: Ring
!
! In this exercise you will communicate an integer
! among process in a circular topology, so that
! every process has a left and a right neighbor
! to receive and to send data respectivelly.
!
! Please, read carefully the comments before the
! do while cycle to understand the rules of the game.
!
!------------------------------------------

      program main

      use mpi

      implicit none

      integer ierr,rank,size
      integer tag,from,next

      integer num

      integer status(MPI_STATUS_SIZE)
      
!--- Start up MPI  ----------------------------------------------------------
! ---> INSERT MPI code

!---------------------------------------------------------------------------
!    Arbitrarily choose 201 to be our tag. Calculate the rank of the        
!    next process. Use the modulus operator so that the                     
!    last process "wraps around" to rank zero.                              
!---------------------------------------------------------------------------

! ---> INSERT code
      tag=
      next = 
      from = 

      num=1
      
!--- If we are the console process, get an integer from the user to    
!--- specify how many times we want to go around the ring

      if(rank.eq.0) then
         print '(a50)','Enter the number of times around the ring'
         read(*,*) num
         if(num.lt.0) num=1

         print '(a,2x,i4,2x,a,2x,i4,2x,a,2x,i4)','Proc ',rank,  &
              ' sends a bag with ',num,' sandwich to proc',next

! ---> INSERT MPI code
         
      endif

!--- Main process start the ring --------------------------------------


!----------------------------------------------------------------------------
! Pass the message around the ring.  The exit mechanism works as             
! follows: the message (a positive integer) is passed around the             
! ring.  Each time it passes rank 0, it is decremented.  When each           
! processes receives the 0 message, it passes it on to the next              
! process and then quits.  By passing the 0 first, every process             
! gets the 0 message and can quit normally.                                  
!----------------------------------------------------------------------------



      do while(num.gt.0) 
! ---> INSERT MPI code

         print '(a,2x,i4,2x,a,2x,i4,2x,a)','Proc ',rank,       &
              ' receives a bag with ',num,' sandwich'
         if(rank.eq.0) then
            num=num-1
            print '(a40)','* * * Process 0 eats one sandwich * * *'
         endif
         print '(a,2x,i4,2x,a,2x,i4,2x,a,2x,i4)','Proc ',rank,   &
             ' sends a bag with ',num,' sandwich to proc ',next
         
! ---> INSERT MPI code
         
      enddo
      

!--- End of the ring ------------------------------------------------

      print '(a,2x,i4,2x,a)','Proc ',rank,' leaves the ring'
      print *,'*******************************************'

!--- The last process send 0 to process 0, which needs to
!--- be received before the program can exit 

      if(rank.eq.0) then
! ---> INSERT MPI code

         print '(a)','...process 0 starves'
      endif

!--- QUIT -------------------------------------------------------------------
      
! ---> INSERT MPI code
      
      end
