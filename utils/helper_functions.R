# helper functions
# data cleaning
# clean percentage strings to numeric decimals
#' @param x character vector with percentages
#' @return numeric vector
clean_pct <- function(x) {
  as.numeric(sub("%", "", x)) / 100
}

# clean currency strings to billions
#' @param x character vector with currency
#' @return numeric vector in billions
clean_currency <- function(x) {
  x <- trimws(x)
  x <- gsub("[$,]", "", x)
  is_billion <- grepl("B", x)
  x_num <- as.numeric(gsub("B", "", x))
  ifelse(is_billion, x_num, x_num / 1e9)
}

# chart Wrapper
# wrap plot with title, subtitle, and styled container
#' @param plot_output shiny plot output
#' @param title chart title
#' @param subtitle optional chart subtitle
#' @return tagList with styled container
wrap_chart <- function(plot_output, title, subtitle = NULL) {
  tagList(
    div(
      class = "chart-container",
      div(
        class = "chart-header",
        div(class = "chart-title", title),
        if (!is.null(subtitle)) div(class = "chart-subtitle", subtitle)
      ),
      tags$hr(class = "chart-divider"),
      div(class = "chart-body", plot_output)
    )
  )
}

# tier logic
# assign categories to tiers based on spend and adoption
#' @param per_person_df per-person spending data
#' @param pct_buying_df percent buying data
#' @param year year to use for tier calculation (default: 2022)
#' @return data frame with category and tier
assign_tiers <- function(per_person_df, pct_buying_df, year = "2022") {
  spend <- per_person_df %>%
    filter(year == !!year) %>%
    select(category, avg_spend = amount)
  
  adoption <- pct_buying_df %>%
    filter(year == !!year) %>%
    select(category, pct_buy = pct)
  
  df <- inner_join(spend, adoption, by = "category")
  
  # calculate quantiles
  high_spend <- quantile(df$avg_spend, 0.75, na.rm = TRUE)
  low_spend <- quantile(df$avg_spend, 0.25, na.rm = TRUE)
  high_adoption <- quantile(df$pct_buy, 0.75, na.rm = TRUE)
  low_adoption <- quantile(df$pct_buy, 0.25, na.rm = TRUE)
  
  df %>%
    mutate(
      tier = case_when(
        avg_spend >= high_spend ~ "High-value gifts",
        avg_spend <= low_spend & pct_buy >= high_adoption ~ "Everyday tokens",
        avg_spend <= low_spend & pct_buy <= low_adoption ~ "Balanced choices",
        TRUE ~ "Gifts"
      ),
      tier = factor(tier, levels = tier_levels)
    ) %>%
    select(category, tier)
}

# forecast
# create linear trend forecast
#' @param df data frame with year and value column
#' @param value_col name of value column to forecast
#' @param years_ahead number of years to forecast (default: 5)
#' @return data frame with historical + forecast data
forecast_trend <- function(df, value_col, years_ahead = forecast_years_ahead) {
  df <- df %>%
    mutate(year = as.numeric(as.character(year)))
  
  # fit linear model
  fit <- lm(reformulate("year", response = value_col), data = df)
  
  # future years
  max_year <- max(df$year)
  future_years <- (max_year + 1):(max_year + years_ahead)
  
  # predict
  pred <- predict(fit, newdata = data.frame(year = future_years))
  
  # combine
  bind_rows(
    df %>% mutate(type = "Historical"),
    tibble(year = future_years, !!value_col := pred, type = "Forecast")
  ) %>%
    arrange(year)
}

# validation
# validate that data frame is not empty
#' @param df data frame to check
#' @param message error message to display
#' @return NULL
validate_not_empty <- function(df, message = "No data available") {
  validate(need(nrow(df) > 0, message))
}

# safe division with zero check
#' @param numerator numerator value
#' @param denominator denominator value
#' @param default default value if denominator is zero
#' @return result of division or default
safe_divide <- function(numerator, denominator, default = 0) {
  if_else(denominator != 0, numerator / denominator, default)
}

# formatting
# format number as currency in billions
#' @param x numeric value in billions
#' @return formatted string (e.g., "$25.9B")
format_billions <- function(x) {
  paste0("$", round(x, 1), "B")
}

# format number as percentage
#' @param x numeric value
#' @param digits number of decimal places
#' @return formatted string
format_pct <- function(x, digits = 1) {
  paste0(round(x * 100, digits), "%")
}

# format number as currency
#' @param x numeric value
#' @param digits number of decimal places
#' @return formatted string
format_dollars <- function(x, digits = 2) {
  paste0("$", format(round(x, digits), big.mark = ",", nsmall = digits))
}