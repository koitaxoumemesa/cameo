

CAMEO: A CAZyme Mapping Engine Optimized for HUMAnN
--
<p align="center">  
<img src="./docs/cameo.jpg" alt="CAMEO logo" width="166">  
</p>

![DOI: 10.5281/zenodo.21074017](https://zenodo.org/badge/DOI/10.5281/zenodo.21074017.svg)

**TLDR**: Get the pre-compiled utility mapping file here: [`dbcan_map_cazy_uniref90.txt.gz`](./data/dbcan_map_cazy_uniref90.txt.gz) or with:

`wget https://raw.githubusercontent.com/koitaxoumemesa/cameo/main/data/dbcan_map_cazy_uniref90.txt.gz`


> [!NOTE]
> This repository contains supplementary code for the paper. If you use the utility mapping file, please cite our publication:
> 
> - Bolino, M. and Frese, S.A. 2026. "CAMEO: A CAZyme Mapping Engine Optimized for HUMAnN."
> 
> **Please also cite the following papers** if you use the workflow or the pre-computed file:
> 
> - Buchfink B, Reuter K, Drost HG, "Sensitive protein alignments at tree-of-life scale using DIAMOND", Nature Methods 18, 366–368 (2021). doi:10.1038/s41592-021-01101-x
> 
> - Beghini, F, et al. "Integrating taxonomic, functional, and strain-level profiling of diverse microbial communities with bioBakery 3." elife 10 (2021): e65088. doi:10.7554/eLife.65088
> 
>  - Zheng, J., Ge, Q., Yan, Y., Zhang, X., Huang, L. and Yanbin Yin. Dbcan3: automated carbohydrate-active enzyme and substrate annotation. Nucleic acids research (2023): 51(W1), W115-W121. doi:10.1093/nar/gkad328

# Abstract

There are technical barriers to creating functional mapping databases and a dearth of validated databases that can be easily implemented by users. Here, we present CAMEO, a precomputed and validated protein map for carbohydrate active enzymes, as well as an approach to building new protein mapping files for use in HUMAnN. 

The inspiration for this work comes from this post in the [Biobakery forums](https://forum.biobakery.org/t/how-to-do-cazy-gene-profiling/2669) and what we perceived to be a very low CAZyme mapping rate with the 2021 mapping file.   
## Quick and easy usage with your HUMAnN workflow:

1. Get the mapping file:

	`wget https://raw.githubusercontent.com/koitaxoumemesa/cameo/main/data/dbcan_map_cazy_uniref90.txt.gz`

2.  Point to this file as the mapping file with the HUMAnN utility scripts:

	 `humann_regroup_table --input $TABLE --output $TABLE2 --custom dbcan_map_cazy_uniref90.txt.gz`
	 
	- `$TABLE` = gene families table (tsv format)
	- `$TABLE2` = regrouped gene/pathway table
## CAZy dbCAN Pipeline (`cazy_dbcan`)

We also present a workflow to reproduce the HUMAnN-compatible utility mapping file to match UniRef90 proteins to CAZymes using dbcan4. You can adjust the files used in the workflow below to create a utility mapping file for other databases (e.g., UniRef50) as well! Or, you can adapt this to build a new mapping file with alternative software (replacing dbcan with your classifier of choice).

The workflow is used to:

1. build a local dbCAN database,
2. annotate UniRef proteins with dbCAN,
3. convert dbCAN annotations into a HUMAnN-compatible ID mapping.

## Typical Usage to reproduce the mapping file:

4. Clone the Github

	`git clone https://github.com/koitaxoumemesa/cameo.git`

5. Update the local SLURM settings, filepaths, and directories for your system.
   
6. Pull the dbcan container from dockerhub ([koitaxoumemesa/dbcan](https://hub.docker.com/repository/docker/koitaxoumemesa/dbcan)).
   
7. Run `dbcan-db-setup.sh` once to build the dbCAN DB directory.
   
8. Run `dbcan_cazy_build.sh` (and the generated array workflow if used) to produce merged `overview.txt` output.
   
9. Run `parse_dbcan_to_humann_map.sh` to generate `dbcan_map_cazy_uniref90.txt.gz` for HUMAnN `--id-mapping`.

See the individual documentation below for details on each step.
## File Documentation 

- [`dbcan-db-setup.sh`](./docs/README.dbcan-db-setup.md): downloads and indexes dbCAN databases.
- [`dbcan_cazy_build.sh`](./docs/README.dbcan_cazy_build.sh.md): orchestrates UniRef90 → dbCAN annotation workflow (currently prints merge instructions; earlier setup steps are commented).
- [`dbcan_reads.def`](./docs/README.dbcan_reads.def.md): Singularity definition file for a dbCAN-focused container image.
- [`parse_dbcan_to_humann_map.py`](./docs/README.parse_dbcan_to_humann_map.py.md): parses dbCAN `overview.txt` into HUMAnN mapping format.
- [`parse_dbcan_to_humann_map.sh`](./docs/README.parse_dbcan_to_humann_map.sh.md): SLURM wrapper that runs the parser in Singularity.
## ## Additional requirements:

The workflow assumes you have a the necessary containers. See [here](https://hub.docker.com/repository/docker/koitaxoumemesa/dbcan/general) for the dbcan container we used. The https://hub.docker.com/r/biobakery/humann container was used (we called it humann3.9 here). The shell scripts are written for a SLURM-managed HPC environment, update them with your local variables before running. 
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
  version = {0.1},
  year = {2026}
}
```
# Validation Summary

<img src="./data/figure_1.png" alt="Results">

### CAMEO generation workflow and CAZyme analysis.

(A) A schematic of CAMEO generation using the HUMAnN DIAMOND database and dbCAN3. (B) A comparison of shotgun metagenomes from *Bifidobacterium longum* subsp. *infantis* EVC001-colonized infants (mean relative abundance ~88%) mapped with either a genome-derived annotation for *B. infantis*, the CAMEO-build mapping file, or a previous version of a CAZyme mapping file (‘Original’). The PC1 axis is plotted here. (C) Mean differences between the CAMEO-derived and the ‘Original’ mapping file in relation to the genome-derived mapping file (‘genome-annotated’) is shown as a heatmap. (D-E) PCoA measured by Bray-Curtis comparing EVC001-colonized (~88% *B. infantis* EVC001 relative abundance) vs control fecal samples (lacking *B. infantis*) using the Original or CAMEO mapping strategies, respectively.

To validate CAMEO, we leveraged a shotgun metagenome dataset from age- and diet-matched infants colonized at high levels by *Bifidobacterium longum* subsp *. infantis* EVC001 (N = 29) as well as a control group lacking this organism (N = 31). We used [a previously circulated mapping file from 2021](https://forum.biobakery.org/t/how-to-do-cazy-gene-profiling/2669) (the ‘original’ mapping file), the *B. infantis* ATCC15697 genome as a known source of CAZyme annotations to build a compatible CAZyme mapping file (the ‘genome-annotated’ mapping approach), and our CAMEO-derived mapping file. We first found that the proportion of reads from EVC001-colonized infants that were CAZyme-mapped with each strategy were 0.7%, 1.6%, and 5.3%, respectively. Then, we compared results across these samples and found that the CAMEO-derived and genome-derived annotation strategies were most similar (**Figure 1B-C**). When we compared the *B. infantis* EVC001-colonized samples to the control samples (**Figure 1D-E**), we saw an improvement in CAZyme discrimination (R2 = 0.064 vs. 0.101) over to the original mapping file.

The metagenomic samples used here are available in the NCBI SRA under accession PRJNA390646 and can be referenced with these publications:

> Casaburi, G. _et al._ Early-life gut microbiome modulation reduces the abundance of antibiotic-resistant bacteria. _Antimicrob. Resist. Infect. Control_ **8**, 131 (2019).
> 
> Frese, S. A. _et al._ Persistence of Supplemented Bifidobacterium longum subsp. infantis EVC001 in Breastfed Infants. _mSphere_ **2**, (2017).
> 
> Smilowitz, J. T. _et al._ Safety and tolerability of Bifidobacterium longum subspecies infantis EVC001 supplementation in healthy term breastfed infants: a phase I clinical trial. _BMC Pediatr._ **17**, 133 (2017). 


## Funding

Portions of this work were funded by the United States Department of Agriculture (USDA) National Insitute of Food and Agriculture and the National Institutes of Health (NIH) NIGMS. Its contents are solely the responsibility of the authors and do not necessarily represent the official views of the USDA or the NIH. This work was also supported, in part, by the [University of Nevada, Reno Agricultural Experiment Station](https://naes.unr.edu/), the [University of Nevada, Reno College of Agriculture, Biotechnology, and Natural Resources](https://www.unr.edu/cabnr) and the [University of Nevada, Reno Department of Nutrition](https://www.unr.edu/nutrition).

## Having issues
If you have any troubles please file and issue in the GitHub repository.
## License
GNU GPL v3

