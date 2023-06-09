# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline # nolint

# Load packages required to define the pipeline:
library(targets)
library(tarchetypes) # Load other packages as needed. # nolint

# Set target options:
tar_option_set(
  packages = c("dplyr", "here", "purrr", "readr", "tibble", "tidyr"), # packages that your targets need to run
  format = "rds" # default storage format
  # Set other options as needed.
)

# tar_make_clustermq() configuration (okay to leave alone):
options(clustermq.scheduler = "multicore")

# tar_make_future() configuration (okay to leave alone):
# Install packages {{future}}, {{future.callr}}, and {{future.batchtools}} to allow use_targets() to configure tar_make_future() options.

# Run the R scripts in the R/ folder with your custom functions:
tar_source()
# source("other_functions.R") # Source other scripts as needed. # nolint

list(
  tar_target(orders, seq(2, 80, 2)),
  tar_target(
    results,
    tibble(
            n = as.integer(orders),
      greedy1 = list(greedy1(orders)),
      greedy2 = list(greedy2(orders))
    ) %>%
    pivot_longer(-n) %>%
    mutate(
        volume = map_dbl(value, "volume"),
      n_filled = map_dbl(value, "n_filled"),
         cells = map(value, "cells")
    ) %>%
    select(-value),
    pattern = map(orders)
  ),
  tar_target(
    final_results,
    results %>%
      select(-cells) %>%
      pivot_wider(names_from = name, values_from = c(volume, n_filled)) %>%
      rename(
        t1 = n_filled_greedy1,
        t2 = n_filled_greedy2,
        r1 = volume_greedy1,
        r2 = volume_greedy2
      ) %>%
      select(n, t1, t2, r1, r2)
  ),
  tar_render(
    name = readme,
    "README.Rmd"
  )
)
