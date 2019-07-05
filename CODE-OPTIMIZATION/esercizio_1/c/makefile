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
CC = gcc
OPT = -O0 #-DSINGLEPRECISION 
#----------------------------------------------
# main & dipendenze
main = mm
dip = 
#----------------------------------------------
# ...creo l'eseguibile"
$(main): $(main).o $(dip) 
	@echo "...creo l'eseguibile"
	$(CC) $(OPT)  $(main).o $(dip) -o $(main)
#----------------------------------------------
# ...compilo i singoli files 
.c.o: 
	$(CC) $(OPT)  -c $< 
#----------------------------------------------
clean:
	@echo "...pulisco i file obj" 
	rm -rf *.o
	rm -rf $(main)
#----------------------------------------------
info:
	@echo "...compilatore" $(CC)
	@echo "...opzioni    " $(OPT)
	@echo "...main       " $(main).c
	@echo "...dipendenze " $(dip)
	


