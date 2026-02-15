# data loading
# load all datasets
#' @return list of data frames
load_valentines_data <- function() {
  
  message("Loading data...")
  
  # historical spending data
  spending_total <- read.csv(
    "data/historical_spending_total_expected_spending.csv",
    row.names = 1,
    check.names = FALSE
  ) %>%
    rownames_to_column("year") %>%
    pivot_longer(cols = -year, values_to = "value") %>%
    select(year, value) %>%
    mutate(value = clean_currency(value))
  
  celebrating_pct <- read.csv(
    "data/historical_spending_percent_celebrating.csv",
    row.names = 1,
    check.names = FALSE
  ) %>%
    rownames_to_column("year") %>%
    pivot_longer(cols = -year, values_to = "pct") %>%
    select(year, pct) %>%
    mutate(pct = clean_pct(pct))
  
  per_person_spend <- read.csv(
    "data/historical_spending_average_expected_spending.csv",
    check.names = FALSE,
    stringsAsFactors = FALSE
  ) %>%
    rename(year = 1) %>%
    mutate(amount = parse_number(.[[2]])) %>%
    select(year, amount)
  
  # Category data
  gift_pct_buying_long <- read.csv(
    "data/historical_gift_trends_percent_buying.csv",
    row.names = 1,
    check.names = FALSE
  ) %>%
    rownames_to_column("year") %>%
    pivot_longer(-year, names_to = "category", values_to = "pct") %>%
    mutate(pct = clean_pct(pct))
  
  gift_per_person_long <- read.csv(
    "data/historical_gift_trends_per_person_spending.csv",
    row.names = 1,
    check.names = FALSE
  ) %>%
    rownames_to_column("year") %>%
    pivot_longer(-year, names_to = "category", values_to = "amount") %>%
    mutate(amount = as.numeric(gsub("[$,]", "", amount)))
  
  gift_total_long <- read.csv(
    "data/historical_gift_trends_total_expected_spending.csv",
    row.names = 1,
    check.names = FALSE
  ) %>%
    rownames_to_column("year") %>%
    pivot_longer(-year, names_to = "category", values_to = "total_billions") %>%
    mutate(total_billions = clean_currency(total_billions))
  
  # demographics (age)
  planned_age_long <- read.csv(
    "data/planned_gifts_age.csv",
    row.names = 1,
    check.names = FALSE
  ) %>%
    rownames_to_column("age_group") %>%
    pivot_longer(-age_group, names_to = "category", values_to = "pct") %>%
    mutate(pct = clean_pct(pct))
  
  celebrating_age_1 <- read.csv(
    "data/spending_or_celebrating_age_1.csv",
    row.names = 1,
    check.names = FALSE
  ) %>%
    rownames_to_column("age_group") %>%
    pivot_longer(-age_group, values_to = "celebrating_pct") %>%
    mutate(celebrating_pct = clean_pct(celebrating_pct))
  
  celebrating_age_2_long <- read.csv(
    "data/spending_or_celebrating_age_2.csv",
    row.names = 1,
    check.names = FALSE
  ) %>%
    rownames_to_column("behavior") %>%
    pivot_longer(-behavior, names_to = "age_group", values_to = "pct") %>%
    mutate(pct = clean_pct(pct))
  
  # demographics (gender)
  planned_gender_long <- read.csv(
    "data/planned_gifts_gender.csv",
    row.names = 1,
    check.names = FALSE
  ) %>%
    rownames_to_column("gender") %>%
    pivot_longer(-gender, names_to = "category", values_to = "pct") %>%
    mutate(pct = clean_pct(pct))
  
  celebrating_gender_1 <- read.csv(
    "data/spending_or_celebrating_gender_1.csv",
    row.names = 1,
    check.names = FALSE
  ) %>%
    rownames_to_column("gender") %>%
    pivot_longer(-gender, values_to = "celebrating_pct") %>%
    mutate(celebrating_pct = clean_pct(celebrating_pct))
  
  celebrating_gender_2_long <- read.csv(
    "data/spending_or_celebrating_gender_2.csv",
    row.names = 1,
    check.names = FALSE
  ) %>%
    rownames_to_column("behavior") %>%
    pivot_longer(-behavior, names_to = "gender", values_to = "pct") %>%
    mutate(pct = clean_pct(pct))
  
  # motivations
  motivations <- read_excel(
    "data/Valentines Day.xlsx",
    col_names = c("reason", "men", "women"),
    skip = 1
  ) %>%
    pivot_longer(c(men, women), names_to = "gender", values_to = "pct") %>%
    mutate(
      pct = as.numeric(pct),
      gender = tools::toTitleCase(gender)
    )
  
  message("Data loading complete!")
  
  # return as list
  list(
    spending_total = spending_total,
    celebrating_pct = celebrating_pct,
    per_person_spend = per_person_spend,
    gift_pct_buying_long = gift_pct_buying_long,
    gift_per_person_long = gift_per_person_long,
    gift_total_long = gift_total_long,
    planned_age_long = planned_age_long,
    celebrating_age_1 = celebrating_age_1,
    celebrating_age_2_long = celebrating_age_2_long,
    planned_gender_long = planned_gender_long,
    celebrating_gender_1 = celebrating_gender_1,
    celebrating_gender_2_long = celebrating_gender_2_long,
    motivations = motivations
  )
}

# pre-calculate derived datasets
#' @param data_list list of raw datasets from load_valentines_data()
#' @return list with additional calculated datasets
calculate_derived_data <- function(data_list) {
  
  message("Calculating derived datasets...")
  
  # tier assignments
  tier_data <- assign_tiers(
    data_list$gift_per_person_long,
    data_list$gift_pct_buying_long,
    year = tier_calculation_year
  )
  
  # quadrant data for positioning chart
  quadrant_data <- data_list$gift_per_person_long %>%
    filter(year == tier_calculation_year) %>%
    select(category, avg_spend = amount) %>%
    left_join(
      data_list$gift_pct_buying_long %>% 
        filter(year == tier_calculation_year) %>% 
        select(category, pct_buy = pct),
      by = "category"
    ) %>%
    left_join(tier_data, by = "category") %>%
    mutate(x = pct_buy * 100, y = avg_spend)
  
  # category growth (top 3)
  category_growth <- data_list$gift_pct_buying_long %>%
    filter(year >= 2018) %>%
    group_by(category) %>%
    summarise(slope = coef(lm(pct ~ as.numeric(year)))[2], .groups = "drop") %>%
    arrange(desc(slope)) %>%
    head(3) %>%
    pull(category)
  
  message("Derived data calculation complete!")
  
  c(data_list, list(
    tier_data = tier_data,
    quadrant_data = quadrant_data,
    category_growth = category_growth
  ))
}

# generate forecast datasets
#' @param data_list List of datasets
#' @return List with forecast data
generate_forecasts <- function(data_list) {
  
  message("Generating forecasts...")
  
  spending_total_fc <- forecast_trend(data_list$spending_total, "value")
  celebrating_pct_fc <- forecast_trend(data_list$celebrating_pct, "pct")
  per_person_spend_fc <- forecast_trend(data_list$per_person_spend, "amount")
  
  # category forecasts (top 3 growing categories)
  gift_category_fc <- data_list$gift_pct_buying_long %>%
    filter(category %in% data_list$category_growth) %>%
    group_by(category) %>%
    nest() %>%
    mutate(forecast = map(data, ~ forecast_trend(.x, "pct"))) %>%
    unnest(forecast) %>%
    select(-data)
  
  message("Forecast generation complete!")
  
  c(data_list, list(
    spending_total_fc = spending_total_fc,
    celebrating_pct_fc = celebrating_pct_fc,
    per_person_spend_fc = per_person_spend_fc,
    gift_category_fc = gift_category_fc
  ))
}