# constants & configuration
# color schemes
colors <- list(
  primary = "#E31937",
  primary_dark = "#C41230",
  secondary = "#4A90E2",
  tertiary = "#00BA38",
  accent = "#F8766D",
  gray_light = "#A9A9A9",
  gray_dark = "#2c3e50",
  background = "#fff5f7",
  white = "#ffffff"
)

# tier colors
tier_colors <- c(
  "High-value gifts" = "#E31937",
  "Everyday tokens" = "#8A8A8A",
  "Balanced choices" = "#4A90E2",
  "Gifts" = "#00BA38"
)

# gender colors
gender_colors <- c(
  "Men" = "#4A90E2",
  "Women" = "#F8766D"
)

# year comparison colors
year_colors <- c(
  "2010" = "#A9A9A9",
  "2022" = "#E31937",
  "Historical" = "#4A90E2",
  "Forecast" = "#E31937"
)

# category colors (for forecast plot)
category_colors <- c("#4A90E2", "#F8766D", "#00BA38")

# age groups
age_groups <- c("18-24", "25-34", "35-44", "45-54", "55-64", "65+")

# tier levels
tier_levels <- c(
  "High-value gifts",
  "Everyday tokens",
  "Balanced choices",
  "Gifts"
)

# reference year
reference_year <- "2020"
tier_calculation_year <- "2022"

# chart defaults
chart_height <- "450px"
chart_height_small <- "400px"
chart_height_large <- "500px"
chart_height_xlarge <- "800px"

# forecast parameters
forecast_years_ahead <- 5
forecast_start_year <- 2023
forecast_end_year <- 2027

# plot theme
plot_theme <- list(
  panel_grid_color = "#f0f0f0",
  panel_grid_size = 0.5,
  axis_line_color = "black",
  axis_line_size = 0.3,
  axis_text_size = 9,
  title_size = 14
)

# data labels
labels <- list(
  total_spending = "Total Valentine's Day spending",
  celebration_rate = "Celebration participation rate",
  per_person_spend = "Average spend per person",
  category_growth = "Category spending comparison"
)