random_room_1 <- function(order, seed) {
  
  r <- Room$new(size = order)
  
  for(e in sample(r$empty_cells, length(r$empty_cells))) {
    for(p in sample(r$free_pairs, length(r$free_pairs))) {
      if(r$is_available(e, p)) {
        r$set(e, p)
        break()
      }
    }
  }
  
  tibble(
        seed = as.integer(seed),
           n = as.integer(order),
    n_filled = as.integer(r$n_filled),
      volume = r$volume
  )
  
}

random_room_2 <- function(order, seed) {
  
  r <- Room$new(size = order)
  
  for(p in sample(r$free_pairs, length(r$free_pairs))) {
    for(e in sample(r$empty_cells, length(r$empty_cells))) {
      if(r$is_available(e, p)) {
        r$set(e, p)
        break()
      }
    }
  }
  
  tibble(
    seed = as.integer(seed),
    n = as.integer(order),
    n_filled = as.integer(r$n_filled),
    volume = r$volume
  )
  
}