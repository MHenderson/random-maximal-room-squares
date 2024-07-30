library(targets)

tar_option_set(
  packages = c("dplyr", "flextable", "ggplot2", "scales", "tibble", "wallis"),
    format = "rds"
)

tar_source()

list(
  tar_target(orders, seq(10, 50, 2)),
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
    name = results_plot,
    command = {
      ggplot(results, aes(n, volume)) +
        geom_point(shape = 4, alpha = 0.5, colour = "blue") +
        theme_bw() +
        scale_x_continuous(labels = comma) +
        ylim(0.6, 0.9)
    }
  ),
  tar_target(
    name = save_table_as_png,
    command = save_as_image(summary_results_as_flextable, path = "png/summary-results.png")
  ),
  tar_target(
    name = save_results_plot,
    command = ggsave(plot = results_plot, filename = "png/results-plot.png", width = 1200, height = 800, units = "px")
  )
)
