spatial_units <- st_read("../data/results/Spatial_Units-All_Attributes.geojson", quiet = TRUE)
features <- spatial_units |>
  st_drop_geometry()

# 1. Map attribute names to column names in your data
attribute_to_col <- list(
  "Soil quality" = "Soil_Quality",
  "Plant health" = "NDVI",
  "Green-blue connectivity" = "Green_Area",
  "Available space near streams" = "Space_along_Streams",
  "Anticipated flood risk" = "Flood_Safety",
  "Soil infiltration capacity" = "Infiltration",
  "Shade" = "Shade_3pm",
  "Visibility" = "Visibility",
  "Peripherality" = "Accessibility",
  "Land use variety" = "Land_Use_Types"
)
