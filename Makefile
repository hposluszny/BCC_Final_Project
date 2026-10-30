# DATA 550 Final Project
# Reproducible BCC analysis using synthetic data

all: output/BCC_Analysis.html

# Step 1: Clean synthetic data
data/clean/BCC_analysis.rds: data/BCC_synthetic.csv code/00_clean_data.R
	Rscript -e 'source("code/00_clean_data.R")'

# Step 2: Generate Table 1
output/table1.rds: data/clean/BCC_analysis.rds code/01_table1.R
	Rscript -e 'source("code/01_table1.R")'

# Step 3: Generate Bland-Altman figure
output/figure1_bland_altman_fm_vs_dxa.png: data/clean/BCC_analysis.rds code/02_figure1_bland_altman.R
	Rscript -e 'source("code/02_figure1_bland_altman.R")'

# Step 4: Render final HTML report
output/BCC_Analysis.html: BCC_Analysis.Rmd code/03_render_report.R output/table1.rds output/figure1_bland_altman_fm_vs_dxa.png
	Rscript -e 'source("code/03_render_report.R")'