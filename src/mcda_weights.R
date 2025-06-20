source("../src/saaty_funcs.R")
library(sf, quietly = TRUE)

attributes <- list(
  "Biodiversity" = c(
    "Soil quality",
    "Plant health",
    "Green-blue connectivity"
  ),
  "Climate Adaptation" = c(
    "Available space near streams",
    "Anticipated flood risk",
    "Soil infiltration capacity",
    "Shade"
  ),
  "Quality of Life" = c(
    # "Visibility",
    "Walking accessibility",
    "Land use variety"
  )
)

saaty_matrices <- list(
  "Biodiversity" = matrix(
    c(
      1, 3, 4,
      -3, 1, 2,
      -4, -2, 1
    ),
    nrow = 3, byrow = TRUE
  ),
  "Climate Adaptation" = matrix(
    c(
      1, -2, -3, 2,
      2, 1, 3, 4,
      3, -3, 1, 3,
      -2, -4, -3, 1
    ),
    nrow = 4, byrow = TRUE
  ),
  "Quality of Life" = matrix(
    # c(
    # 1, -4, -2,
    # 4,  1,  3,
    # 2, -3,  1
    # ), nrow = 3, byrow = TRUE
    c(
      1, 3,
      -3, 1
    ),
    nrow = 2, byrow = TRUE
  )
)

saaty_weights <- lapply(saaty_matrices, calculate_weights)
