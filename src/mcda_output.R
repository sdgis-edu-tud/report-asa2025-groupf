source("mcda_weights.R")
source("attributes.R")

# 2. Compute weighted average for each category
for (cat in names(attributes)) {
  attr_names <- attributes[[cat]]
  col_names <- unlist(attribute_to_col[attr_names])
  weights <- saaty_weights[[cat]]$weights
  # Ensure order matches
  stopifnot(length(col_names) == length(weights))
  # Compute weighted sum (row-wise)
  cat_col_name <- gsub(" ", "_", cat, fixed = TRUE)
  spatial_units[[paste0(cat_col_name, "_Score")]] <- as.matrix(features[, col_names]) %*% weights
}

# 3. Store the weighted average of each category without the attributes
# Identify columns to exclude: the attribute columns used for scoring
exclude_cols <- unlist(attribute_to_col[unlist(attributes)])
# Keep all columns except the attribute columns, plus geometry
keep_cols <- setdiff(names(spatial_units), exclude_cols)

# Add the three category scores to the kept columns
keep_cols <- unique(c(keep_cols, paste0(gsub(" ", "_", names(attributes)), "_Score")))

# Subset the data
output <- spatial_units[, keep_cols]

# Compute the overall average score (across the three categories)
output$MCDA_Score <- rowMeans(st_drop_geometry(output)[, paste0(gsub(" ", "_", names(attributes)), "_Score")])

# Write to GeoJSON
st_write(output, "../data/results/Spatial_Units-MCDA.geojson", delete_dsn = TRUE, quiet = TRUE)
