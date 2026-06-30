#!/usr/bin/env bash
#SBATCH --job-name
#SBATCH --ntasks
#SBATCH --cpus-per-task
#SBATCH --mem
#SBATCH --time
#SBATCH --mail-type
#SBATCH --mail-user
#SBATCH --output
#SBATCH --error
#SBATCH --account
#SBATCH --partition

# Script to parse dbCAN output and create HUMAnN CAZy utility mapping file
# This runs after dbcan_cazy_build.sh completes

set -euo pipefail

module purge
module load singularity

# Paths (adjust these to match your environment)
WORK_DIR="$PWD"
DBCAN_CONTAINER="$PWD/database/dbcan.sif"
SCRIPT_DIR="$PWD"

# Input: merged overview file from dbcan_cazy_build.sh Step 6
INPUT_OVERVIEW="${WORK_DIR}/final_results/uniref90_cazymes_overview.txt"

# Output: HUMAnN utility mapping file
OUTPUT_MAP="${SCRIPT_DIR}/dbcan_map_cazy_uniref90.txt.gz"

# Python script
PARSE_SCRIPT="${SCRIPT_DIR}/parse_dbcan_to_humann_map.py"

# Check inputs
if [ ! -f "${INPUT_OVERVIEW}" ]; then
    echo "ERROR: Input overview file not found: ${INPUT_OVERVIEW}"
    echo "You may need to run the merge step from dbcan_cazy_build.sh first:"
    echo "  cd ${WORK_DIR}"
    echo "  mkdir -p final_results"
    echo "  cat dbcan_results/*overview.txt > final_results/uniref90_cazymes_overview.txt"
    exit 1
fi

if [ ! -f "${PARSE_SCRIPT}" ]; then
    echo "ERROR: Python script not found: ${PARSE_SCRIPT}"
    exit 1
fi

echo "=== Parsing dbCAN output to create HUMAnN CAZy mapping ==="
echo "Input: ${INPUT_OVERVIEW}"
echo "Output: ${OUTPUT_MAP}"
date

# Run the parsing script in the container
# The container has Python 3.9 and should have all required packages
singularity exec \
    --bind ${WORK_DIR},${SCRIPT_DIR} \
    "${DBCAN_CONTAINER}" \
    python3 "${PARSE_SCRIPT}" \
        --input "${INPUT_OVERVIEW}" \
        --output "${OUTPUT_MAP}" \
        --min-members 1

echo ""
echo "=== COMPLETE ==="
echo "HUMAnN CAZy mapping file created: ${OUTPUT_MAP}"
echo "You can now use this with HUMAnN using the --id-mapping option"
echo ""
echo "Example HUMAnN usage:"
echo "  humann --input sample.fastq.gz \\"
echo "    --output output_dir \\"
echo "    --id-mapping ${OUTPUT_MAP}"
date

exit 0
