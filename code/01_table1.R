here::i_am("code/01_table1.R")

library(tidyverse)
library(gtsummary)

bcc_analysis <- readRDS(
  here::here("data", "clean", "BCC_analysis.rds")
)

#create BMI variable from height and weight
bcc_analysis <- bcc_analysis %>%
  mutate(
    bmi = weight_kg / (height_cm / 100)^2
  )

#create table 1 vars
##convert DXA values from g to kg
##set unusable (failed QC) DXA/D2O values to missing
table1_data <- bcc_analysis %>%
  mutate(
    dxa_ffm_kg = if_else(
      use_dxa,
      dxa_fatfree_g / 1000,
      NA_real_
    ),
    dxa_fm_kg = if_else(
      use_dxa,
      dxa_fat_g / 1000,
      NA_real_
    ),
    dxa_fat_pct_table = if_else(
      use_dxa,
      dxa_fat_pct,
      NA_real_
    ),
    d2o_ffm_kg_table = if_else(
      use_d2o,
      d2o_ffm_kg,
      NA_real_
    ),
    d2o_fm_kg_table = if_else(
      use_d2o,
      d2o_fm_kg,
      NA_real_
    )
  )

#create Table 1
# create Table 1
table1 <- table1_data %>%
  select(
    sex_label,
    age,
    height_cm,
    weight_kg,
    bmi,
    waist_cm,
    dxa_fat_pct_table,
    dxa_fm_kg,
    bia_fm_kg,
    d2o_fm_kg_table,
    bodpod_fm_kg,
    dxa_ffm_kg,
    bia_ffm_kg,
    d2o_ffm_kg_table,
    bodpod_ffm_kg
  ) %>%
  tbl_summary(
    by = sex_label,
    statistic = all_continuous() ~ "{mean} ± {sd}",
    digits = all_continuous() ~ 1,
    missing = "no",
    label = list(
      age ~ "Age, years",
      height_cm ~ "Height, cm",
      weight_kg ~ "Weight, kg",
      bmi ~ "BMI, kg/m²",
      waist_cm ~ "Waist circumference, cm",
      dxa_fat_pct_table ~ "DXA body fat, %",
      
      dxa_fm_kg ~ "Dual-energy X-ray absorptiometry",
      bia_fm_kg ~ "Bioelectrical impedance analysis",
      d2o_fm_kg_table ~ "Deuterium oxide dilution",
      bodpod_fm_kg ~ "Air displacement plethysmography",
      
      dxa_ffm_kg ~ "Dual-energy X-ray absorptiometry",
      bia_ffm_kg ~ "Bioelectrical impedance analysis",
      d2o_ffm_kg_table ~ "Deuterium oxide dilution",
      bodpod_ffm_kg ~ "Air displacement plethysmography"
    )
  ) %>%
  
  # customize column headers
  modify_header(
    label ~ "**Characteristic**",
    stat_1 ~ "**Men**  \n*Mean ± SD*  \nN = {n}",
    stat_2 ~ "**Women**  \n*Mean ± SD*  \nN = {n}"
  ) %>%
  
  # remove automatic Mean ± SD footnotes
  remove_footnote_header(
    columns = all_stat_cols()
  ) %>%
  
  # group participant characteristics
  add_variable_group_header(
    header = "Participant characteristics",
    variables = c(
      age,
      height_cm,
      weight_kg,
      bmi,
      waist_cm,
      dxa_fat_pct_table
    ),
    indent = 0L
  ) %>%
  
  # group fat mass measurements
  add_variable_group_header(
    header = "Fat mass, kg",
    variables = c(
      dxa_fm_kg,
      bia_fm_kg,
      d2o_fm_kg_table,
      bodpod_fm_kg
    ),
    indent = 2L
  ) %>%
  
  # group fat-free mass measurements
  add_variable_group_header(
    header = "Fat-free mass, kg",
    variables = c(
      dxa_ffm_kg,
      bia_ffm_kg,
      d2o_ffm_kg_table,
      bodpod_ffm_kg
    ),
    indent = 2L
  ) %>%
  
  # bold section headings
  modify_bold(
    columns = label,
    rows = label %in% c(
      "Participant characteristics",
      "Fat mass, kg",
      "Fat-free mass, kg"
    )
  ) %>%
  
  # add table title
  modify_caption(
    "**Table 1. Participant Characteristics and Body Composition by Sex**"
  ) %>%
  
  # convert to gt table
  as_gt() %>%
  
  # clarify sample sizes
  gt::tab_source_note(
    source_note = gt::md(
      "N represents the total number of participants in each sex group. Means and SDs were calculated using available data for each measure; sample sizes may therefore vary because of method-specific data-quality exclusions."
    )
  )

table1

#save Table 1
saveRDS(
  table1,
  here::here("output", "table1.rds")
)
