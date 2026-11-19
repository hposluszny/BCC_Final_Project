# Body Composition Calibration Study: DATA 550 Final Project

**Author:** Hannah Posluszny

## Project Overview

This project demonstrates a reproducible workflow for evaluating agreement between body composition assessment methods using synthetic data.

The analysis is based on the structure of the Body Composition Calibration (BCC) Study conducted in Guatemala City, Guatemala.

The analysis compares fat mass estimates obtained using:

- Dual-energy X-ray absorptiometry (DXA)
- Bioelectrical impedance analysis (BIA)
- Deuterium oxide dilution (D2O)
- Air displacement plethysmography (ADP)

DXA serves as the reference method.

## Data

The project uses a fully synthetic dataset containing 80 fictional participants.

The synthetic data preserve the variable structure of the original BCC dataset but contain no actual participant measurements.

File: `data/BCC_synthetic.csv`

All results are illustrative and do not represent actual findings from the BCC Study.

## Project Organization

- `data/BCC_synthetic.csv`: Synthetic participant data
- `code/00_clean_data.R`: Data preparation and cleaning
- `code/01_table1.R`: Code for generating Table 1
- `code/02_figure1_bland_altman.R`: Code for generating Figure 1
- `code/03_render_report.R`: Code for rendering the report
- `BCC_Analysis.Rmd`: R Markdown report
- `Makefile`: Automated workflow
- `output/`: Generated tables, figures, and report

## Analysis

### Table 1: Participant Characteristics and Body Composition

Table 1 presents descriptive statistics by sex, including age, anthropometric measurements, fat mass, and fat-free mass.

The code used to generate Table 1 is located in:

`code/01_table1.R`

### Figure 1: Bland-Altman Analysis

Figure 1 evaluates agreement between fat mass estimates obtained using BIA, D2O dilution, and ADP compared with DXA.

The plots display mean differences and 95% limits of agreement for each method.

The code used to generate Figure 1 is located in:

`code/02_figure1_bland_altman.R`

## Reproducing the Analysis

Install R (the lockfile records R 4.6.1), GNU Make, and Pandoc. RStudio bundles
Pandoc, but a terminal session needs to find it on `PATH` or through
`RSTUDIO_PANDOC`. On Windows, open Git Bash and use `which make` to check that
Chocolatey's GNU Make comes first on `PATH`. Also check that `Rscript --version`
finds your R installation.

From the repository root, restore the R package versions recorded in
`renv.lock`, then build the report.

```bash
make install
make
```

Run `make install` again after pulling a change to `renv.lock` to synchronize your
project library. Equivalently, run `renv::restore()` in R from the repository root.

`make` builds `data/clean/BCC_analysis.rds` from the tracked
`data/BCC_synthetic.csv`. The cleaned RDS is required by the table, figure, and
report, and Make regenerates it when it is missing or its inputs change.
The completed report is saved to `output/BCC_Analysis.html`.

## Notes

This project was developed for DATA 550 at Emory University.

The dataset and results are synthetic and are intended solely to demonstrate reproducible data analysis.
