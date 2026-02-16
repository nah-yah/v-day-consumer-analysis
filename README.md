# The Valentine's Day market dashboard

A production-ready Shiny dashboard analyzing $25.9B+ in Valentine's Day spending trends (2010-2022) with forecasts through 2027.

---

## Overview

This dashboard provides strategic insights into the U.S. Valentine's Day market through:
- **Historical analysis** (2010-2022): $16B → $25.9B growth trajectory
- **Category segmentation**: Tier-based analysis across 7+ gift categories
- **Demographic insights**: Age, gender, and behavioral patterns
- **Forecasts** (2023-2027): Linear projections with 95% confidence intervals

**Key findings:**
- 60% market growth since 2010 driven by premium gifting
- Jewelry accounts for $3.2B growth despite only 22% adoption
- Gen Z (18-24) shows 51% celebration rate, 11+ points above other groups
- Per-person spending projected to reach $209 by 2027

---

## Quick Start

### Prerequisites
```r
# Required R version
R >= 4.0

# Required packages
install.packages(c(
  "shiny", "readxl", "readr", "dplyr", "tidyr", 
  "tibble", "ggplot2", "plotly", "scales", "purrr", 
  "shinycssloaders"
))
```

### Installation

1. **Clone or download this repository**

2. **Add your data files**
   - Place all CSV files in `data/` folder
   - Place `Valentines Day.xlsx` in `data/` folder
   
   Required files:
   - `historical_spending_total_expected_spending.csv`
   - `historical_spending_percent_celebrating.csv`
   - `historical_spending_average_expected_spending.csv`
   - `historical_gift_trends_percent_buying.csv`
   - `historical_gift_trends_per_person_spending.csv`
   - `historical_gift_trends_total_expected_spending.csv`
   - `planned_gifts_age.csv`
   - `spending_or_celebrating_age_1.csv`
   - `spending_or_celebrating_age_2.csv`
   - `planned_gifts_gender.csv`
   - `spending_or_celebrating_gender_1.csv`
   - `spending_or_celebrating_gender_2.csv`
   - `Valentines Day.xlsx`

3. **Run the app**
   ```r
   shiny::runApp()
   ```

The dashboard will open in your default browser at `http://localhost:XXXX`

---

## Project structure

```
valentines_dashboard/
├── app.R                          # Main app
│
├── data/                          # Data files (not tracked in git)
│   ├── *.csv                      # Historical spending data
│   └── Valentines Day.xlsx        # Motivations data
│
├── utils/                         # Core utilities
│   ├── constants.R                # Colors, labels, config
│   ├── helper_functions.R         # Reusable functions
│   └── data_loading.R             # Data loading & preprocessing
│
├── ui/                            # UI components (one per tab)
│   ├── ui_css.R                   # All CSS styles
│   ├── ui_sidebar.R               # Sidebar navigation
│   ├── ui_home.R                  # Home page
│   ├── ui_bigpicture.R            # Big picture tab
│   ├── ui_category.R              # Category analysis
│   ├── ui_demographics.R          # Demographics tab
│   └── ui_forecast.R              # Forecast tab
│
├── server/                        # Server logic (organized by function)
│   ├── server_reactive.R          # Reactive values & filtering
│   ├── server_cards.R             # Metric comparison cards
│   ├── server_plots_main.R        # Main tab plots
│   ├── server_plots_category.R    # Category plots
│   ├── server_plots_demo.R        # Demographics plots
│   ├── server_plots_forecast.R    # Forecast plots with legend fix
│   └── server_downloads.R         # CSV download handlers
│
└── docs/                          # Documentation
    ├── README.md                  # This file
    ├── migration_guide.txt        # Migration from monolithic app
    └── legend_box_fix.md          # Forecast legend implementation
```

---

## Features

### 1. **Home page**
- Executive summary with key metrics ($25.9B, +60%, Gen Z trends)
- Three market forces analysis (Jewelry Paradox, Gen Z, Gender Inversion)
- 2023-2027 outlook
- Direct navigation to analysis sections
- One-click dataset downloads (full, summary, forecast)

### 2. **The big picture**
- Total spending trends (2009-2022)
- Celebration participation rates
- Per-person spending evolution
- Category growth comparison (2010 vs 2022 tornado chart)
- Metric cards comparing selected years vs 2020 baseline

### 3. **Where money goes**
- **Tier-based segmentation:**
  - High-value gifts (jewelry, dining)
  - Everyday tokens (candy, cards)
  - Balanced choices
  - Gifts
- Spend per buyer by category
- Adoption rates across tiers
- Quadrant positioning (spend × adoption)
- Strategic insights on cross-selling opportunities

### 4. **Who's driving trends**
- **By age group:**
  - Celebration rates (51% for 18-24)
  - Self-treating behavior (29% Gen Z)
  - Gift preferences heatmap
- **By gender:**
  - Purchase patterns (jewelry 30% men vs 14% women)
  - Motivations (tradition vs emotional expression)
- **Emerging behaviors:**
  - Anti-Valentine's purchasing (~5% of 18-24)

### 5. **What's next**
- Linear regression forecasts (2023-2027)
- Total spending: $27.7B by 2027
- Participation rate: declining to 47.8%
- Per-person spend: rising to $209
- Strategic budget allocation recommendations

### 6. **Filtering**
- Category filter (All, or specific categories)
- Tier filter (High-value, Everyday tokens, etc.)
- Year range selector
- Age group filter
- Gender filter

---

## Design system

### Color palette
```r
Primary:     #E31937  (Valentine Red)
Secondary:   #4A90E2  (Trust Blue)
Tertiary:    #00BA38  (Growth Green)
Accent:      #F8766D  (Pink)
Background:  #fff5f7  (Light Pink)
```

### Typography
- **Headers:** Georgia, serif (elegant, readable)
- **Body:** System UI fonts (modern, performant)
- **Data:** Monospace (aligned, precise)

---

## Performance Optimizations

### 1. **Data loading strategy**
```r
# data loaded once at app startup (not per session)
data <- load_valentines_data()
data <- calculate_derived_data(data)
data <- generate_forecasts(data)
```

**Benefits:**
- Faster session initialization
- Consistent data across users
- Reduced memory usage

### 2. **Reactive caching**
```r
# Filtered data cached per user session
rv <- create_reactive_values(input, data)
```

**Benefits:**
- Instant filter updates
- No redundant calculations
- Smooth user experience

### 3. **Lazy rendering**
- Charts render only when tab is active
- Hidden tabs don't consume resources
- Plotly's built-in optimization

---

## Development

### Adding a new plot

1. **Create the plot function** in appropriate server file:
   ```r
   # In server/server_plots_main.R
   generate_main_plots <- function(output, rv, data) {
     output$my_new_plot <- renderPlotly({
       df <- data$my_dataset
       p <- ggplot(df, aes(...)) + ...
       ggplotly(p) %>% layout(title = list(text = ""))
     })
   }
   ```

2. **Add to UI** in appropriate UI file:
   ```r
   # In ui/ui_bigpicture.R
   wrap_chart(
     plotlyOutput("my_new_plot", height = CHART_HEIGHT),
     "My new chart title",
     "Subtitle explaining what the chart shows"
   )
   ```

3. **Test independently** before integrating

### Adding a new filter

1. **Add to sidebar** (`ui/ui_sidebar.R`):
   ```r
   selectInput("my_filter", "My Filter", 
               choices = c("All", unique(data$my_column)))
   ```

2. **Add to reactive logic** (`server/server_reactive.R`):
   ```r
   if (input$my_filter != "All") {
     df <- df %>% filter(my_column == input$my_filter)
   }
   ```

3. **Use in plots:**
   ```r
   df <- rv$filtered_historical()$my_dataset
   ```

---

## Data Sources

**Primary:** National Retail Federation (NRF) annual Valentine's Day surveys
- Survey period: 2009-2022
- Sample size: 6,000-8,000 U.S. adults annually
- Methodology: Online panel surveys

**Distribution:** 
- Via Kaggle (Sunja dataset)
- Distributed through TidyTuesday project

---

## Acknowledgments

- **Data:** National Retail Federation, Suraj Das on Kaggle
- **Technical stack:** Shiny, Plotly, tidyverse ecosystem
- **Legend box fix:** Plotly annotation approach (see `LEGEND_BOX_FIX.md`)

---

## Additional resources

- [Shiny documentation](https://shiny.rstudio.com/)
- [Plotly R documentation](https://plotly.com/r/)
- [Tidyverse style guide](https://style.tidyverse.org/)
- [NRF Valentine's Day survey](https://nrf.com/research-insights/holiday-data-and-trends/valentines-day)
- [Kaggle dataset](https://www.kaggle.com/datasets/infinator/happy-valentines-day-2022)

---

**Built using R Shiny**

*Last updated: February 2026*