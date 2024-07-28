library(targets)

tar_option_set(
  packages = c("dplyr", "flextable", "tibble", "wallis"),
    format = "rds"
)

tar_source()

list(
  tar_target(orders, seq(10, 22, 2)),
  tar_target(seeds, 42:46),
  tar_target(
       name = results,
    command = random_room(orders, seeds),
    pattern = cross(orders, seeds)
  ),
  tar_target(
    name = summary_results,
    command = {
      results |>
        group_by(n) |>
        summarise(
          min_filled = min(n_filled),
          max_filled = max(n_filled),
          min_volume = min(volume),
          max_volume = max(volume)
        )
    }
  ),
  tar_target(
    name = summary_results_as_flextable,
    command = {
      set_flextable_defaults(
        font.size = 6,
          padding = 6,
        theme_fun = theme_zebra
      )
      flextable(summary_results)
    }
  ),
  tar_target(
    name = save_table_as_png,
    command = save_as_image(summary_results_as_flextable, path = "png/summary-results.png")
  )
)
