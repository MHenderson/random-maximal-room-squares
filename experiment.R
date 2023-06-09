library(dplyr)

X <- targets::tar_read(results)

XX <- X %>%
  filter(name == "greedy2") %>%
  filter(n %in% c(20, 22, 24))

plot_room_square(XX$cells[[1]][[1]], 20)

plot_room_square(XX$cells[[2]][[1]], 22)


plot_room_square(XX$cells[[3]][[1]], 24)
