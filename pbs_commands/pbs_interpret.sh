#!/bin/bash -l

# declare a name for this job to be sample_job
#PBS -N methyl_interpret
# Specify the gpuq queue
#PBS -q gpuq
# Specify the number of gpus nodes=1:ppn=8:
#PBS -l gpus=1
# gpus ppn was 4 and 4, figure out in future
# Specify the gpu feature
#PBS -l feature=gpu
# request 4 hours and 30 minutes of cpu time
#PBS -l walltime=08:00:00
# mail is sent to you when the job starts and when it terminates or aborts

# Join error and standard output into one file
#PBS -j oe
# By default, PBS scripts execute in your home directory, not the
# directory from which they were submitted. The following line
# places you in the directory from which the job was submitted.
cd $PBS_O_WORKDIR
# run the program
gpuNum=`cat $PBS_GPUFILE | sed -e 's/.*-gpu//g'`
unset CUDA_VISIBLE_DEVICES
export CUDA_DEVICE=$gpuNum
module load python/3-Anaconda
module load cuda
echo $gpuNum
source activate methylnet_pro2
CUDA_VISIBLE_DEVICES="$gpuNum" python model_interpretability.py produce_shapley_data -mth gradient -ssbs 30 -ns 300 -bs 512 -r 4 -rt 5 -col disease -nf 4000 -c
exit 0