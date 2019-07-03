#!/bin/bash

#-------------------- hw section -------------------------------

#### Ask for a number of nodes each with cpus "ntasks-per-node" 
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
##SBATCH --mem=10GB
 
#### Maximum length of the job (hh:mm:ss)
#SBATCH --time=3:00

#-------------------- partition system -------------------------------

#### Partition of submission (reservation for the school, comment "qos" and "reservation" lines to submit as a regular user)
#SBATCH --partition=gll_usr_prod
##SBATCH --qos=
##SBATCH --reservation= 

# --------------- accounting/budget  -----------------------------

#### account number (type saldo -b)
#SBATCH --account=train_scR2019 

# ---------------- other info ------------------------------------

#### File for standard output and error
#SBATCH --output=matvec.out
#SBATCH --error=matvec.err

#### Job name
##SBATCH --job-name=hello_my_friend

#### send email to the following address
##SBATCH --mail-user= 

#### send email after abort or end
##SBATCH --mail-type= 

# -----------end of SLURM keywords section -------------------------

module load autoload intelmpi

srun --mpi=pmi2 ./matvec.x





