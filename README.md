

CAMEO: A CAZyme Mapping Engine Optimized for HUMAnN
--

<div align="center">
  <img src="./docs/cameo.jpg" alt="CAMEO logo" width="166">
</div>

![GitHub Downloads (all assets, latest release)](https://img.shields.io/github/downloads/koitaxoumemesa/cameo/latest/total)

**TLDR**: Get the pre-compiled CAZyme utility mapping file here: [`dbcan_map_cazy_uniref90.txt.gz`](dbcan_map_cazy_uniref90.txt.gz).

# Abstract

There are technical barriers to creating functional mapping databases and a dearth of validated databases that can be easily implemented by users. Here, we present CAMEO, a precomputed and validated protein map for carbohydrate active enzymes, as well as an approach to building new protein mapping files for use in HUMAnN. 

The inspiration for this work comes from this post in the [Biobakery forums](https://forum.biobakery.org/t/how-to-do-cazy-gene-profiling/2669) and what we thought to be a very low CAZyme mapping rate with the 2021 mapping file in our data.   

> [!NOTE]
> This repository contains supplementary code for the paper. If you use the utility mapping file, please cite our publication:
> 
> - Bolino, M. and Frese, S.A. 2026. "CAMEO: A CAZyme Mapping Engine Optimized for HUMAnN."
> 
> **As well as the following papers**:
> 
> - Buchfink B, Reuter K, Drost HG, "Sensitive protein alignments at tree-of-life scale using DIAMOND", Nature Methods 18, 366–368 (2021). doi:10.1038/s41592-021-01101-x
> 
> - Beghini, F, et al. "Integrating taxonomic, functional, and strain-level profiling of diverse microbial communities with bioBakery 3." elife 10 (2021): e65088. doi:10.7554/eLife.65088
> 
>  - Zheng, J., Ge, Q., Yan, Y., Zhang, X., Huang, L. and Yanbin Yin. Dbcan3: automated carbohydrate-active enzyme and substrate annotation. Nucleic acids research (2023): 51(W1), W115-W121. doi:10.1093/nar/gkad328

## Quick and easy usage with your HUMAnN workflow:

1. Download the CAMEO CAZyme mapping file for the UniRef90 dataset (assuming you are using this one):

  `wget https://raw.githubusercontent.com/koitaxoumemesa/cameo/main/data/dbcan_map_cazy_uniref90.txt.gz`

2.  Point to this file as the mapping file with the HUMAnN utility scripts:

   `humann_regroup_table --input $TABLE --output $TABLE2 --custom dbcan_map_cazy_uniref90.txt.gz`
   
  - `$TABLE` = gene families table (tsv format)
  - `$TABLE2` = regrouped gene/pathway table




# Results summary

<img src="./data/figure_1.png" alt="Results of analysis and validation" style="display: block; margin: 0 auto;">

**CAMEO generation workflow and CAZyme analysis.** (A) A schematic of CAMEO generation using the HUMAnN DIAMOND database and dbCAN3. (B) A comparison of shotgun metagenomes from _Bifidobacterium longum_ subsp. _infantis_ EVC001-colonized infants (mean relative abundance ~88%) mapped with either a genome-derived annotation for _B. infantis_, the CAMEO-build mapping file, or a previous version of a CAZyme mapping file (‘Original’). The PC1 axis is plotted here. (C) Mean differences between the CAMEO-derived and the ‘Original’ mapping file in relation to the genome-derived mapping file (‘genome-annotated’) is shown as a heatmap. (D-E) PCoA measured by Bray-Curtis comparing EVC001-colonized (~88% _B. infantis_ EVC001 relative abundance) vs control fecal samples (lacking _B. infantis_) using the Original or CAMEO mapping strategies, respectively.

We used a previously circulated mapping file from 2021 (the ‘original’ mapping file), the _B. infantis_ ATCC15697 genome as a known source of CAZyme annotations to build a compatible CAZyme mapping file (the ‘genome-annotated’ mapping approach), and our CAMEO-derived mapping file. We first found that the proportion of reads from EVC001-colonized infants that were CAZyme-mapped with each strategy were 0.7%, 1.6%, and 5.3%, respectively.

# CAZy dbCAN Pipeline (`cazy_dbcan`)

We also present a workflow to reproduce the HUMAnN-compatible utility mapping file to match UniRef90 proteins to CAZymes using dbcan4. You can adjust the files used in the workflow below to create a utility mapping file for other databases (e.g., UniRef50) as well! Or, you can adapt this to build a new mapping file with alternative software (replacing dbcan with your classifier of choice). We will plan to update the mapping file for future UniRef/HUMAnN updates as they are released.

The workflow is used to:

1. build a local dbCAN database,
2. annotate UniRef proteins with dbCAN,
3. convert dbCAN annotations into a HUMAnN-compatible ID mapping.
## Typical Usage

1. Update the local SLURM settings and directories for your system.
2. Pull the dbcan container from dockerhub ([koitaxoumemesa/dbcan](https://hub.docker.com/repository/docker/koitaxoumemesa/dbcan)) or build locally with the Singularity .def file.
3. Run `dbcan-db-setup.sh` once to build the dbCAN DB directory.
4. Run `dbcan_cazy_build.sh` (and the generated array workflow if used) to produce merged `overview.txt` output.
5. Run `parse_dbcan_to_humann_map.sh` to generate `dbcan_map_cazy_uniref90.txt.gz` for HUMAnN `--id-mapping`.

See the individual documentation below for details on each step.
## Additional requirements:

The workflow assumes you have a the necessary containers. See [here](https://hub.docker.com/repository/docker/koitaxoumemesa/dbcan/general) for the dbcan container we used. The https://hub.docker.com/r/biobakery/humann container was used (we called it humann3.9 here). The shell scripts are written for a SLURM-managed HPC environment, update them with your local variables before running. 
## File Documentation

- [`dbcan-db-setup.sh`](README.dbcan-db-setup.md): downloads and indexes dbCAN databases.
- [`dbcan_cazy_build.sh`](README.dbcan_cazy_build.sh.md): orchestrates UniRef90 → dbCAN annotation workflow (currently prints merge instructions; earlier setup steps are commented).
- [`dbcan_reads.def`](README.dbcan_reads.def.md): Singularity definition file for a dbCAN-focused container image.
- [`parse_dbcan_to_humann_map.py`](README.parse_dbcan_to_humann_map.py.md): parses dbCAN `overview.txt` into HUMAnN mapping format.
- [`parse_dbcan_to_humann_map.sh`](README.parse_dbcan_to_humann_map.sh.md): SLURM wrapper that runs the parser in Singularity.
## Runtime Output Directories

- `log/`: SLURM stdout/stderr logs. Check this as needed
- `final_results/`: merged output artifacts such as combined dbCAN overview and details.
## Citation

```
@software{Bolino_CAMEO_2026,
  author = {Bolino, Matthew and Steven A. Frese},
  doi = {10.5281/zenodo.1234},
  month = {06},
  title = CAMEO: A CAZyme Mapping Engine Optimized for HUMAnN}},
  url = {https://github.com/koitaxoumemesa/cameo},
  version = {1.0},
  year = {2026}
}
```
## Funding

This work was supported by funding from the Food & Human Health Program, project award no. 2022-67018-36233 and 2026-67017-45939, from the [U.S. Department of Agriculture’s National Institute of Food and Agriculture](https://www.nifa.usda.gov). Any opinions, findings, conclusions, or recommendations expressed in this publication are those of the author(s) and should not be construed to represent any official USDA or U.S. Government determination or policy. Computational resources were provided, in part, by the Research & Innovation Office and the Cyberinfrastructure Team in the Office of Information Technology at the [University of Nevada, Reno](http://www.unr.edu).

## Having issues
If you have any troubles please file an issue in the GitHub repository.
## License
GNU GPLv3
