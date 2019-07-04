#----------------------------------------------
# esempio (banale) di makefile 
# Giorgio Amati, CASPUR 2006 
#----------------------------------------------
# target: 
# 	main: eseguibile
# 	clean: elimina tutti gli obj
# 	info: informazioni varie
#----------------------------------------------
# compilatore, opzioni etc etc..
FC = gfortran
OPT = -O0 #-O3 -DSINGLE_PRECISION
#----------------------------------------------
# main & dipendenze
main = mm
dip = mod_tools.o
#----------------------------------------------
# ...creo l'eseguibile"
$(main): $(dip) $(main).o 
	@echo "...creo l'eseguibile"
	$(FC) $(OPT)  $(dip) $(main).o -o $(main)
#----------------------------------------------
# ...compilo i singoli files 
%.o:%.f90
	$(FC) $(OPT)  -c $< 
%.o:%.F90 
	$(FC) $(OPT)  -c $< 
#----------------------------------------------
clean:
	@echo "...pulisco i file obj" 
	rm -rf *.mod
	rm -rf *.o
	rm -rf $(main)
#----------------------------------------------
info:
	
	@echo "...compilatore" $(FC)
	@echo "...opzioni    " $(OPT)
	@echo "...main       " $(main).f
	@echo "...dipendenze " $(dip)
	


