# DATA 550 Final Project
# Prepare synthetic BCC data for analysis

here::i_am("code/00_clean_data.R")

library(tidyverse)

# Load synthetic dataset
bcc_clean <- read_csv(
  here::here("data", "BCC_synthetic.csv"),
  show_col_types = FALSE
)

# Retain participants with complete body composition data
bcc_analysis <- bcc_clean %>%
  filter(
    !is.na(bia_ffm_kg_1),
    !is.na(bia_ffm_kg_2),
    !is.na(dxa_fatfree_g),
    !is.na(d2o_ffm_kg),
    !is.na(bodpod_ffm_kg)
  )

# Create method-specific quality control indicators
# All synthetic measurements are considered usable
bcc_analysis <- bcc_analysis %>%
  mutate(
    use_dxa = TRUE,
    use_d2o = TRUE,
    use_muac = TRUE
  )

# Create sex labels
bcc_analysis <- bcc_analysis %>%
  mutate(
    sex_label = factor(
      sex,
      levels = c(0, 1),
      labels = c("Men", "Women")
    )
  )

# Average duplicate BIA measurements
bcc_analysis <- bcc_analysis %>%
  mutate(
    bia_fm_kg = (bia_fm_kg_1 + bia_fm_kg_2) / 2,
    bia_ffm_kg = (bia_ffm_kg_1 + bia_ffm_kg_2) / 2,
    bia_tbw_kg = (bia_tbw_kg_1 + bia_tbw_kg_2) / 2,
    bia_fat_pct = (bia_fat_pct_1 + bia_fat_pct_2) / 2,
    bia_weight_kg = (bia_weight_kg_1 + bia_weight_kg_2) / 2,
    bia_height_m = (bia_height_m_1 + bia_height_m_2) / 2,
    bia_bmi = (bia_bmi_1 + bia_bmi_2) / 2,
    bia_fmi = (bia_fmi_1 + bia_fmi_2) / 2,
    bia_ffmi = (bia_ffmi_1 + bia_ffmi_2) / 2,
    bia_phase_angle = (bia_phase_angle_1 + bia_phase_angle_2) / 2
  )

# Create output directory if needed
dir.create(
  here::here("data", "clean"),
  recursive = TRUE,
  showWarnings = FALSE
)

# Save analysis-ready dataset
saveRDS(
  bcc_analysis,
  here::here("data", "clean", "BCC_analysis.rds")
)

# Confirm final sample size
cat("Analysis sample size:", nrow(bcc_analysis), "\n")



R.version.string
.libPaths()
