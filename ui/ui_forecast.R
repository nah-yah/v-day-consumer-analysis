# forecast ui
forecast_ui <- function() {
  tagList(div(
    class = "content-panel",
    h3("What’s next", style = "margin-bottom: 0; color: #2c3e50; font-weight = 300"),
    h6("Projections based on 10+ years of historical trends"),
    tags$hr(style = "border-top: 1px solid #e0e0e0; margin: 0 0 20px 0;"),
    
    # charts
    fluidRow(column(
      12,
      wrap_chart(
        withSpinner(
          plotlyOutput("plot_total_forecast", height = "400px"),
          color = "#A9A9A9",
          type = 6
        ),
        
        "Total spending forecast",
        "Expected to reach $27.7B by 2027 (+3.2% CAGR)"
      )
    ), column(
      12,
      wrap_chart(
        withSpinner(
          plotlyOutput("plot_celebrate_forecast", height = "400px"),
          color = "#A9A9A9",
          type = 6
        ),
        
        "Celebration rate outlook",
        "Projected to decline modestly to 47.8% by 2027"
      )
    )),
    fluidRow(column(
      12,
      wrap_chart(
        withSpinner(
          plotlyOutput("plot_spend_forecast", height = "400px"),
          color = "#A9A9A9",
          type = 6
        ),
        
        "Per-person spend projection",
        "Expected to reach $209 by 2027 driven by inflation and premium gifting"
      )
    ), column(
      12,
      wrap_chart(
        withSpinner(
          plotlyOutput("plot_category_forecast", height = "400px"),
          color = "#A9A9A9",
          type = 6
        ),
        
        "Fastest-Growing Categories",
        "Gift cards and jewelry lead growth in % planning to buy (21–23% CAGR 2023–2027); experiential categories show stronger momentum in other metrics"
      )
    )),
    
    # strategic insight card
    div(
      class = "metric-card",
      style = "margin-bottom: 25px; padding: 15px;",
      h4(strong("Strategic insight"), style = "margin-bottom: 0; color: #2c3e50;"),
      p(
        "Brands that rely on static 2022 data risk missing forward momentum. Total spending will grow to ",
        strong("$27.7B by 2027"),
        " (+3.2% CAGR), but participation is declining (from 53% to 47.8%). This means growth will come entirely from higher spend per person, projected to reach ",
        strong("$209 by 2027"),
        ", driven by premium gifting and experiential purchases.",
        tags$br(),
        tags$br(),
        "To capture this shift, allocate 2023–2027 budgets toward:",
        tags$ul(
          tags$li("Premium experiences (dining, events)"),
          tags$li("Self-gift bundles (especially for Gen Z)"),
          tags$li("High-value cross-sells (jewelry + cards)")
        ),
        style = "margin: 0; line-height: 1.6; color: #495057;"
      )
    ),
    
    
    # methodology note
    p(
      tags$em(
        "Forecasts use 10-year historical trends with linear regression. Assumes no major economic shocks."
      ),
      style = "font-size: 12px; color: #6c757d; margin-top: 20px;"
    )
  ))
}