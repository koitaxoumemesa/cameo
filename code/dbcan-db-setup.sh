#!/usr/bin/env bash
#SBATCH --job-name
#SBATCH --ntasks                    # 1 task will be run (1 nodes)
#SBATCH --cpus-per-task
#SBATCH --mem
#SBATCH --time                # Max run time is 2d
#SBATCH --mail-type               # Send mail on all state changes
#SBATCH --mail-user    # email me job status
#SBATCH --output         # The output file name
#SBATCH --error         # The error file name
#SBATCH --account    #account to bill
#SBATCH --partition     #partition to use

# Singularity command line options
set -euo pipefail

# Use Singularity
module purge
module load singularity 

WORKDIR="$PWD"
THREADS=${SLURM_CPUS_PER_TASK}
mkdir -p "$WORKDIR"
mkdir -p "${WORKDIR}/log"
cd "$WORKDIR"


#############################################
# USER-CONFIGURABLE VARIABLES — EDIT THESE #
#############################################

DBCAN_CONTAINER="$PWD/database/dbcan.sif"                 # contains run_dbcan + dependencies
DBCAN_DB_DIR="$WORKDIR/database/db"

mkdir -p "$DBCAN_DB_DIR"
cd "$DBCAN_DB_DIR" \
    && wget http://bcb.unl.edu/dbCAN2/download/Databases/fam-substrate-mapping-08012023.tsv && mv fam-substrate-mapping-08012023.tsv fam-substrate-mapping.tsv \
    && wget http://bcb.unl.edu/dbCAN2/download/Databases/PUL.faa && singularity exec --bind "$WORKDIR","$DBCAN_DB_DIR" "$DBCAN_CONTAINER" makeblastdb -in PUL.faa -dbtype prot \
    && wget http://bcb.unl.edu/dbCAN2/download/Databases/dbCAN-PUL_12-12-2023.xlsx && mv dbCAN-PUL_12-12-2023.xlsx dbCAN-PUL.xlsx \
    && wget http://bcb.unl.edu/dbCAN2/download/Databases/dbCAN-PUL.tar.gz && tar xvf dbCAN-PUL.tar.gz && rm dbCAN-PUL.tar.gz \
    && wget https://bcb.unl.edu/dbCAN2/download/Databases/dbCAN_sub.hmm && singularity exec --bind "$WORKDIR","$DBCAN_DB_DIR" "$DBCAN_CONTAINER" hmmpress dbCAN_sub.hmm \
    && wget https://bcb.unl.edu/dbCAN2/download/Databases/V12/CAZyDB.07262023.fa && mv CAZyDB.07262023.fa CAZyDB.fa && singularity exec --bind "$WORKDIR","$DBCAN_DB_DIR" "$DBCAN_CONTAINER" diamond makedb --in CAZyDB.fa -d CAZy \
    && wget https://bcb.unl.edu/dbCAN2/download/Databases/V12/dbCAN-HMMdb-V12.txt && mv dbCAN-HMMdb-V12.txt dbCAN.txt && singularity exec --bind "$WORKDIR","$DBCAN_DB_DIR" "$DBCAN_CONTAINER" hmmpress dbCAN.txt \
    && wget https://bcb.unl.edu/dbCAN2/download/Databases/V12/tcdb.fa && singularity exec --bind "$WORKDIR","$DBCAN_DB_DIR" "$DBCAN_CONTAINER" diamond makedb --in tcdb.fa -d tcdb \
    && wget http://bcb.unl.edu/dbCAN2/download/Databases/V12/tf-1.hmm && singularity exec --bind "$WORKDIR","$DBCAN_DB_DIR" "$DBCAN_CONTAINER" hmmpress tf-1.hmm \
    && wget http://bcb.unl.edu/dbCAN2/download/Databases/V12/tf-2.hmm && singularity exec --bind "$WORKDIR","$DBCAN_DB_DIR" "$DBCAN_CONTAINER" hmmpress tf-2.hmm \
    && wget https://bcb.unl.edu/dbCAN2/download/Databases/V12/stp.hmm && singularity exec --bind "$WORKDIR","$DBCAN_DB_DIR" "$DBCAN_CONTAINER" hmmpress stp.hmm \
    && cd "$WORKDIR" && wget http://bcb.unl.edu/dbCAN2/download/Samples/EscheriaColiK12MG1655.fna \
    && wget http://bcb.unl.edu/dbCAN2/download/Samples/EscheriaColiK12MG1655.faa \
    && wget http://bcb.unl.edu/dbCAN2/download/Samples/EscheriaColiK12MG1655.gff