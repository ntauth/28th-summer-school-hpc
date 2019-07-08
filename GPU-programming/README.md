# GPU programming

## Slides

The slides are available in PDF format
```bash
cd slides
```

## Exercises

A skeleton of exercises are provided

#### OpenACC exercises

```bash
cd hands-on/openacc
```

#### CUDA exercises

```bash
cd hands-on/cuda
```

At the end of course the solutions of all exercises are published in the repository

## Load Environment

#### PGI environment

```bash
module load profile/advanced
module load pgi
module load cuda
```

#### GNU environment

```bash
module load profile/advanced
module load gnu
module load cuda
```

#### Show loaded environment
```bash
module list
```

## Get a compute node interactively

```bash
srun -N 1 -A train_scR2019 -p gll_usr_gpuprod --reservation=s_tra_gpuR --gres=gpu:kepler:1 --pty /bin/bash
```


