# `parse_dbcan_to_humann_map.py`

Python CLI script that converts dbCAN `overview.txt` annotations into a HUMAnN-compatible ID mapping table.

## Purpose

Creates a CAZy-family-to-UniRef90 mapping in HUMAnN utility format:

```text
CAZyFamily<TAB>UniRef90_ID1<TAB>UniRef90_ID2<...>
```

The script parses CAZy calls from `HMMER`, `dbCAN_sub`, and `DIAMOND` columns.

## Inputs

- Required:
  - `--input` / `-i`: dbCAN `overview.txt` file (plain text or `.gz`)
  - `--output` / `-o`: output mapping file path (gzipped output)
- Optional:
  - `--min-members`: keep only CAZy families with at least this many UniRef90 IDs (default: `1`)

Input assumptions:

- Tab-delimited dbCAN overview-like columns where:
  - column 1 = `Gene ID`
  - columns 3–5 include CAZy annotation fields (`HMMER`, `dbCAN_sub`, `DIAMOND`)
- Gene IDs are filtered to those beginning with `UniRef90_`.

## Outputs

- Gzipped mapping file, e.g. `dbcan_map_cazy_uniref90.txt.gz`
- stderr progress/stats including:
  - family counts,
  - total annotation count,
  - top 10 families by member count.

## Usage

```bash
python parse_dbcan_to_humann_map.py \
  --input final_results/uniref90_cazymes_overview.txt \
  --output dbcan_map_cazy_uniref90.txt.gz \
  --min-members 1
```

## Parsing Rules

- Removes coordinate suffixes like `(55-193)`.
- Splits multi-annotations on `+`, `|`, and `,`.
- Extracts family prefixes using regex `^([A-Z]+\d+)`.
  - Examples: `GH5_1` → `GH5`, `CBM1(55-193)` → `CBM1`.

## Exit Behavior

- Exits non-zero if input file does not exist.
- Warns and skips malformed lines with fewer than 5 fields.
