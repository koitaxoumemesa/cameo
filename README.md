# Supplementary code for the paper: TITLE
[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/scientificcomputing/example-paper/HEAD)
![GitHub Downloads (all assets, latest release)](https://img.shields.io/github/downloads/koitaxoumemesa/humann-cazymes/latest/total)

This repository contains supplementary code for the paper. If you use the utility mapping file, please cite our publication:
> Bolino, M., Haththotuwe-Gamage , N., Frese. S.A. 2026.
> TITLE, Journal of ..., volume, page, url

Please also cite the following papers if you use the workflow or the pre-computed file:
> Buchfink B, Reuter K, Drost HG, "Sensitive protein alignments at tree-of-life scale using DIAMOND", Nature Methods 18, 366–368 (2021). doi:10.1038/s41592-021-01101-x
> 
> Beghini, F, et al. "Integrating taxonomic, functional, and strain-level profiling of diverse microbial communities with bioBakery 3." elife 10 (2021): e65088. doi:10.7554/eLife.65088
> 
> Zheng, J., Ge, Q., Yan, Y., Zhang, X., Huang, L. and Yanbin Yin. Dbcan3: automated carbohydrate-active enzyme and substrate annotation. Nucleic acids research (2023): 51(W1), W115-W121. doi:10.1093/nar/gkad328

## Abstract
Provide the abstract of the paper

# CAZy dbCAN Pipeline (`cazy_dbcan`)

See the pre-compiled utility mapping file here: [`dbcan_map_cazy_uniref90.txt.gz`](dbcan_map_cazy_uniref90.txt.gz)

We also present a workflow to reproduce the HUMAnN-compatible utility mapping file to match UniRef90 proteins to CAZymes using dbcan4. You can adjust the files used in the workflow below to create a utility mapping file for other databases (e.g., UniRef50) as well! 

The workflow is used to:

1. build a local dbCAN database,
2. annotate UniRef proteins with dbCAN,
3. convert dbCAN annotations into a HUMAnN-compatible ID mapping.

## Additional requirements:

The workflow assumes you have a container for DIAMOND (≥v2.0.14). The 3.9 and later HUMAnN install uses this. 

## File Documentation

- [`dbcan-db-setup.sh`](README.dbcan-db-setup.md): downloads and indexes dbCAN databases.
- [`dbcan_cazy_build.sh`](README.dbcan_cazy_build.sh.md): orchestrates UniRef90 → dbCAN annotation workflow (currently prints merge instructions; earlier setup steps are commented).
- [`dbcan_reads.def`](README.dbcan_reads.def.md): Singularity definition file for a dbCAN-focused container image.
- [`parse_dbcan_to_humann_map.py`](README.parse_dbcan_to_humann_map.py.md): parses dbCAN `overview.txt` into HUMAnN mapping format.
- [`parse_dbcan_to_humann_map.sh`](README.parse_dbcan_to_humann_map.sh.md): SLURM wrapper that runs the parser in Singularity.

## Typical Usage

1. Update the local SLURM settings and directories for your system.
2. Build the container with the dbcan_reads.def file to create the container to either run locally or on your HPC.
3. Run `dbcan-db-setup.sh` once to build the dbCAN DB directory.
4. Run `dbcan_cazy_build.sh` (and the generated array workflow if used) to produce merged `overview.txt` output.
5. Run `parse_dbcan_to_humann_map.sh` to generate `dbcan_map_cazy_uniref90.txt.gz` for HUMAnN `--id-mapping`.

See the individual documentation, above, for details on each step.

## Runtime Output Directories

- `log/`: SLURM stdout/stderr logs.
- `final_results/`: merged output artifacts such as combined dbCAN overview and details.

## Citation

```
@software{Lisa_My_Research_Software_2017,
  author = {Lisa, Mona and Bot, Hew},
  doi = {10.5281/zenodo.1234},
  month = {12},
  title = {{My Research Software}},
  url = {https://github.com/scientificcomputing/example-paper},
  version = {2.0.4},
  year = {2017}
}
```
## Funding

Portions of this work were funded by the United States Department of Agriculture (USDA) National Insitute of Food and Agriculture and the National Institutes of Health (NIH) NIGMS. Its contents are solely the responsibility of the authors and do not necessarily represent the official views of the USDA or the NIH. This work was also supported, in part, by the [University of Nevada, Reno Agricultural Experiment Station](https://naes.unr.edu/) and the [University of Nevada, Reno Department of Nutrition](https://www.unr.edu/nutrition).

## Having issues
If you have any troubles please file and issue in the GitHub repository.

## License
MIT
