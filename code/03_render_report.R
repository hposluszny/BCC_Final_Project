here::i_am("code/03_render_report.R")

library(here)
library(rmarkdown)

render(
  input = here::here("BCC_Analysis.Rmd"),
  output_dir = here::here("output")
)