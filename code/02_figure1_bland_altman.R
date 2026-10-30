here::i_am("code/02_figure1_bland_altman.R")

library(tidyverse)

# load analysis-ready dataset
bcc_analysis <- readRDS(
  here::here("data", "clean", "BCC_analysis.rds")
)

# create Bland-Altman dataset for fat mass
ba_fm <- bind_rows(
  
  # BIA vs DXA
  bcc_analysis %>%
    filter(use_dxa) %>%
    transmute(
      study_id,
      method = "Bioelectrical impedance\nanalysis",
      dxa_fm_kg = dxa_fat_g / 1000,
      comparison_fm_kg = bia_fm_kg
    ),
  
  # D2O dilution vs DXA
  bcc_analysis %>%
    filter(use_dxa, use_d2o) %>%
    transmute(
      study_id,
      method = "Deuterium oxide\ndilution",
      dxa_fm_kg = dxa_fat_g / 1000,
      comparison_fm_kg = d2o_fm_kg
    ),
  
  # ADP vs DXA
  bcc_analysis %>%
    filter(use_dxa) %>%
    transmute(
      study_id,
      method = "Air displacement\nplethysmography",
      dxa_fm_kg = dxa_fat_g / 1000,
      comparison_fm_kg = bodpod_fm_kg
    )
) %>%
  filter(
    !is.na(dxa_fm_kg),
    !is.na(comparison_fm_kg)
  ) %>%
  mutate(
    mean_fm_kg = (comparison_fm_kg + dxa_fm_kg) / 2,
    diff_fm_kg = comparison_fm_kg - dxa_fm_kg
  )

# calculate method-specific sample sizes
ba_fm_n <- ba_fm %>%
  count(method, name = "n")

# calculate mean difference and 95% limits of agreement
ba_fm_summary <- ba_fm %>%
  group_by(method) %>%
  summarise(
    bias = mean(diff_fm_kg),
    sd_diff = sd(diff_fm_kg),
    loa_lower = bias - 1.96 * sd_diff,
    loa_upper = bias + 1.96 * sd_diff,
    .groups = "drop"
  )

# add sample size to method labels
ba_fm <- ba_fm %>%
  left_join(ba_fm_n, by = "method") %>%
  mutate(
    method_label = paste0(method, "\n(n = ", n, ")")
  )

ba_fm_summary <- ba_fm_summary %>%
  left_join(ba_fm_n, by = "method") %>%
  mutate(
    method_label = paste0(method, "\n(n = ", n, ")")
  )

# preserve desired panel order
method_levels <- c(
  paste0(
    "Bioelectrical impedance\nanalysis\n(n = ",
    ba_fm_n$n[ba_fm_n$method == "Bioelectrical impedance\nanalysis"],
    ")"
  ),
  paste0(
    "Deuterium oxide\ndilution\n(n = ",
    ba_fm_n$n[ba_fm_n$method == "Deuterium oxide\ndilution"],
    ")"
  ),
  paste0(
    "Air displacement\nplethysmography\n(n = ",
    ba_fm_n$n[ba_fm_n$method == "Air displacement\nplethysmography"],
    ")"
  )
)

ba_fm <- ba_fm %>%
  mutate(
    method_label = factor(method_label, levels = method_levels)
  )

ba_fm_summary <- ba_fm_summary %>%
  mutate(
    method_label = factor(method_label, levels = method_levels)
  )

# create Bland-Altman plot
figure1_fm_ba <- ggplot(
  ba_fm,
  aes(
    x = mean_fm_kg,
    y = diff_fm_kg
  )
) +
  geom_point(
    size = 2,
    alpha = 0.8
  ) +
  geom_hline(
    data = ba_fm_summary,
    aes(yintercept = bias),
    linetype = "solid",
    linewidth = 0.7
  ) +
  geom_hline(
    data = ba_fm_summary,
    aes(yintercept = loa_lower),
    linetype = "dashed",
    linewidth = 0.6
  ) +
  geom_hline(
    data = ba_fm_summary,
    aes(yintercept = loa_upper),
    linetype = "dashed",
    linewidth = 0.6
  ) +
  facet_wrap(
    ~ method_label,
    nrow = 1
  ) +
  labs(
    x = "Average of method and DXA fat mass (kg)",
    y = "Difference in fat mass (method - DXA, kg)"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    strip.text = element_text(
      face = "bold",
      size = 10
    ),
    panel.grid.minor = element_blank(),
    panel.spacing = unit(0.5, "lines")
  )

# save figure
ggsave(
  filename = here::here(
    "output",
    "figure1_bland_altman_fm_vs_dxa.png"
  ),
  plot = figure1_fm_ba,
  width = 10,
  height = 4.5,
  dpi = 300
)
figure1_fm_ba
