library(knitr)
library(kableExtra)

# Round while preserving sum
round_preserve_sum <- function(values, digits) {
  scale <- 10^digits
  scaled <- values * scale
  floored <- floor(scaled)
  missing_units <- round(scale - sum(floored))

  remainders <- (floored + 1 - scaled) / scaled
  indices <- order(remainders)

  result <- floored
  result[indices[1:missing_units]] <- result[indices[1:missing_units]] + 1
  return(result / scale)
}

# Calculate weights from Saaty matrix
calculate_weights <- function(matrix, method = "eigenvector", digits = 3) {
  actual_matrix <- ifelse(matrix < 0, 1 / (-matrix), matrix)
  n <- nrow(actual_matrix)

  if (method == "average") {
    norm_matrix <- sweep(actual_matrix, 2, colSums(actual_matrix), "/")
    weights <- rowMeans(norm_matrix)
    lambda_max <- sum(colSums(actual_matrix) * weights)
  } else if (method == "eigenvector") {
    eig <- eigen(actual_matrix)
    max_index <- which.max(Re(eig$values))
    weights <- Re(eig$vectors[, max_index])
    lambda_max <- Re(eig$values[max_index])
  } else {
    stop("Invalid method.")
  }

  weights <- weights / sum(weights)

  # Compute Consistency Index (CI)
  ci <- (lambda_max - n) / (n - 1)

  # Random Index (RI) values from Saaty for matrices of size 1–10
  ri_values <- c(0, 0, 0.58, 0.90, 1.12, 1.24, 1.32, 1.41, 1.45, 1.49)
  ri <- if (n <= length(ri_values)) ri_values[n] else NA

  cr <- if (!is.na(ri) && ri != 0) ci / ri else NA

  list(
    weights = round(weights, digits),
    consistency_ratio = round(cr, 3),
    lambda_max = round(lambda_max, 3),
    ci = round(ci, 3),
    ri = ri
  )
}


# Convert matrix to a data frame table
matrix_to_table <- function(matrix, attributes) {
  formatted <- apply(matrix, c(1, 2), function(x) if (x < 0) paste0("1/", -x) else as.character(x))
  df <- data.frame(Attribute = attributes, formatted, stringsAsFactors = FALSE)
  colnames(df) <- c("", attributes)
  return(df)
}

# Display the table using kableExtra
show_table <- function(df, weights = NULL, digits = 3) {
  if (!is.null(weights)) {
    df <- rbind(df, c("Weights", formatC(weights, digits = digits, format = "f")))
  }
  if (knitr::is_html_output()) {
    kbl(df, format = "html", escape = FALSE, align = "c") %>%
      kable_styling(full_width = FALSE, bootstrap_options = c("hover", "responsive")) %>%
      row_spec(0, background = "#f2f2f2", bold = TRUE) %>% # Bold the header row
      row_spec(nrow(df), bold = TRUE) %>% # Highlight last row
      column_spec(1, background = "#f2f2f2", bold = TRUE) %>% # Bold the first column
      column_spec(2:ncol(df))
  } else {
    kbl(df, format = "simple", escape = TRUE, align = "c")
  }
}
