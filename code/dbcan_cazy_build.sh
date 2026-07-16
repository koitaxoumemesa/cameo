#!/usr/bin/env bash
#SBATCH OPTIONS

# Singularity command line options
set -euo pipefail

#Load Modules


WORKDIR="$PWD"
THREADS=${SLURM_CPUS_PER_TASK}
mkdir -p "$WORKDIR/log"


#############################################
# USER-CONFIGURABLE VARIABLES — EDIT THESE #
#############################################

# 1. Path to your HUMAnN-installed UniRef90 Diamond database
# Choose ONE of the two below:
DMND_DB="$PWD/database/uniref/uniref90_201901b_full.dmnd"

# 2. Singularity containers
DIAMOND_CONTAINER="$PWD/database/humann3.9.sif"           # must have diamond ≥2.0.14, I use one built for HUMAnN 3.9 which uses Diamond 2.0.14
DBCAN_CONTAINER="$PWD/database/dbcan.sif"                 # contains run_dbcan + dependencies

# 3. dbCAN3 database directory (already inside or bind-mounted)
DBCAN_DB_DIR="$PWD/database/dbcan/db"                         # contains dbcan.dmnd, dbcan.hmm, etc.

# 4. Where to store everything
WORK_DIR="$PWD/uniref90_cazyme_build"
mkdir -p $WORK_DIR
cd $WORK_DIR

##########################
# ADD YOUR SLURM OPTIONS BELOW
##########################

# echo "=== Starting UniRef90 → CAZyme annotation pipeline ==="
# echo "DMND database: $DMND_DB"
# echo "Work directory: $WORK_DIR"
# date

# # ------------------------------------------------------------------
# # Step 1: Extract all FASTA sequences from the HUMAnN Diamond database
# # ------------------------------------------------------------------
# echo "Step 1: Extracting FASTA sequences from Diamond database..."
# singularity exec $DIAMOND_CONTAINER diamond getseq \
#     --db "$DMND_DB" \
#     > humann_uniref90_sequences.fa

# N_SEQS=$(grep -c "^>" humann_uniref90_sequences.fa)
# echo "   → Extracted $N_SEQS sequences from the HUMAnN Diamond DB"

# # ------------------------------------------------------------------
# # Step 2: Split into chunks for parallel dbCAN3 runs
# # ------------------------------------------------------------------
# echo "Step 2: Splitting into 500k-sequence chunks..."
# mkdir -p chunks

# singularity exec --bind $WORK_DIR \
#     $DBCAN_CONTAINER python3 -c "
# from Bio import SeqIO
# import sys

# chunk_size = 500000
# input_file = 'humann_uniref90_sequences.fa'
# output_dir = 'chunks'

# chunk_num = 1
# records = []

# with open(input_file, 'r') as infile:
#     for record in SeqIO.parse(infile, 'fasta'):
#         records.append(record)
#         if len(records) >= chunk_size:
#             output_file = f'{output_dir}/chunk_{chunk_num:03d}.fa'
#             with open(output_file, 'w') as outfile:
#                 SeqIO.write(records, outfile, 'fasta')
#             print(f'Wrote {len(records)} sequences to {output_file}')
#             records = []
#             chunk_num += 1
    
#     # Write remaining records
#     if records:
#         output_file = f'{output_dir}/chunk_{chunk_num:03d}.fa'
#         with open(output_file, 'w') as outfile:
#             SeqIO.write(records, outfile, 'fasta')
#         print(f'Wrote {len(records)} sequences to {output_file}')
# "

# # Count chunks
# N_CHUNKS=$(ls chunks/*.fa | wc -l)
# echo "   → Created $N_CHUNKS chunks"

# # ------------------------------------------------------------------
# # Step 5: Submit parallel dbCAN3 jobs via SLURM array
# # ------------------------------------------------------------------
# echo "Step 5: Launching SLURM array job for dbCAN3 annotation..."

# cat > run_dbcan_array.sh <<'EOF'
# #!/usr/bin/env bash
# #SBATCH 

# WORK_DIR="$PWD/uniref90_cazyme_build"
# DBCAN_CONTAINER="$PWD/database/dbcan.sif"
# DBCAN_DB_DIR="$PWD/database/dbcan/db"

# N_CHUNKS=$(ls ${WORK_DIR}/chunks/*.fa | wc -l)


# CHUNK_FILE=$(ls $WORK_DIR/chunks/*.fa | sed -n ${SLURM_ARRAY_TASK_ID}p)
# PREFIX=$(basename $CHUNK_FILE .fa)

# singularity exec --bind $WORK_DIR,$DBCAN_DB_DIR \
#     $DBCAN_CONTAINER run_dbcan \
#         $CHUNK_FILE protein $WORK_DIR/dbcan_results \
#         --out_prefix $PREFIX \
#         --db_path $DBCAN_DB_DIR \
#         --dia_db $DBCAN_DB_DIR/dbcan.dmnd \
#         --hmm_db $DBCAN_DB_DIR/dbcan.hmm \
#         --tools diamond hmmer signalp \
#         --cgc_tools hotpep ecami \
#         --cpu $SLURM_CPUS_PER_TASK \
#         --dia_eval 1e-102 \
#         --hmm_eval 1e-15

# echo "Finished chunk $SLURM_ARRAY_TASK_ID: $PREFIX"
# EOF

# # Replace placeholder with actual number of chunks
# sed -i "s/N_CHUNKS/$N_CHUNKS/g" run_dbcan_array.sh

# echo ""
# echo "=== SETUP COMPLETE ==="
# echo "Created array job script: run_dbcan_array.sh"
# echo ""
# echo "To submit the array job, run:"
# echo "  sbatch run_dbcan_array.sh"
# echo ""
# echo "This will launch $N_CHUNKS parallel jobs."

# ------------------------------------------------------------------
# Step 6: Final merge step (run manually after array finishes)
# ------------------------------------------------------------------
echo ""
echo "=== AFTER ARRAY JOB COMPLETES ==="
echo "When the array job finishes, run the following to merge results:"
echo ""
echo "cd $WORK_DIR"
echo "mkdir -p final_results"
echo "cat dbcan_results/*overview.txt > final_results/uniref90_cazymes_overview.txt"
echo "cat dbcan_results/*diamond.out > final_results/uniref90_diamond_detail.tsv"
echo ""
echo "You now have a perfectly matched, CAZyme-annotated version of your HUMAnN UniRef90 database!"

exit 0