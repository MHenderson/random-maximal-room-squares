library(targets)

tar_option_set(
  packages = c("tibble", "wallis"),
    format = "rds"
)

tar_source()

list(
  tar_target(orders, seq(10, 14, 2)),
  tar_target(seeds, 42:44),
  tar_target(
       name = results,
    command = random_room(orders, seeds),
    pattern = cross(orders, seeds)
  )
)
