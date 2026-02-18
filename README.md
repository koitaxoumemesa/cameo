# Supplementary code for the paper: Title of paper
[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/scientificcomputing/example-paper/HEAD)

This repository contains supplementary code for the paper
> Finsberg, H., Dokken, J. 2022.
> Title of paper, Journal of ..., volume, page, url

## Abstract
Provide the abstract of the paper

# CAZy dbCAN Pipeline (`cazy_dbcan`)

This folder contains SLURM/Singularity scripts and a parser used to:

1. build a local dbCAN database,
2. annotate UniRef90 proteins with dbCAN,
3. convert dbCAN annotations into a HUMAnN-compatible ID mapping.

## File Documentation

- [`dbcan-db-setup.sh`](README.dbcan-db-setup.md): downloads and indexes dbCAN databases.
- [`dbcan_cazy_build.sh`](README.dbcan_cazy_build.sh.md): orchestrates UniRef90 → dbCAN annotation workflow (currently prints merge instructions; earlier setup steps are commented).
- [`dbcan_reads.def`](README.dbcan_reads.def.md): Singularity definition file for a dbCAN-focused container image.
- [`parse_dbcan_to_humann_map.py`](README.parse_dbcan_to_humann_map.py.md): parses dbCAN `overview.txt` into HUMAnN mapping format.
- [`parse_dbcan_to_humann_map.sh`](README.parse_dbcan_to_humann_map.sh.md): SLURM wrapper that runs the parser in Singularity.

## Typical Order of Use

1. Update the local SLURM settings and directories for your system. Or, use the .def file to create the container and run locally.
2. Run `dbcan-db-setup.sh` once to build the dbCAN DB directory.
3. Run `dbcan_cazy_build.sh` (and the generated array workflow if used) to produce merged `overview.txt` output.
4. Run `parse_dbcan_to_humann_map.sh` to generate `dbcan_map_cazy_uniref90.txt.gz` for HUMAnN `--id-mapping`.

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


## Having issues
If you have any troubles please file and issue in the GitHub repository.

## License
MIT
