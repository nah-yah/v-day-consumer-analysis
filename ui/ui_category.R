# category ui
category_ui <- function() {
  tagList(
    div(
      class = "content-panel",
      h3("Where money goes", style = "margin-bottom: 0; color: #2c3e50;"),
      h6(
        "How Valentine's Day spending is allocated across gift categories and how it evolved from 2010 to 2022"
      ),
      
      tags$hr(style = "border-top: 1px solid #e0e0e0; margin: 0 0 20px 0;"),
      
      fluidRow(column(
        6,
        wrap_chart(
          withSpinner(
            plotlyOutput("plot_tier_spending", height = "500px"),
            color = "#A9A9A9",
            type = 6
          ),
          "Spending by category tier",
          "High-value gifts account for most of the $10B+ growth since 2010"
        )
      ), column(
        6,
        wrap_chart(
          withSpinner(
            plotlyOutput("plot_per_person_category", height = "500px"),
            color = "#A9A9A9",
            type = 6
          ),
          "Spend per buyer by category",
          "Jewelry buyers spend 6× more than those buying cards or candy"
        )
      )),
      
      tags$div(style = "margin: 10px 0;"),
      
      fluidRow(column(
        12,
        wrap_chart(
          withSpinner(
            plotlyOutput("plot_pct_buying", height = "800px"),
            color = "#A9A9A9",
            type = 6
          ),
          "Buyer adoption by category",
          "Candy and greeting cards reach over half of all shoppers, far more than jewelry (22%)"
        )
      )),
      
      tags$div(style = "margin: 10px 0;"),
      
      fluidRow(column(
        12,
        wrap_chart(
          withSpinner(
            plotlyOutput("plot_quadrant_tiers", height = "500px"),
            color = "#A9A9A9",
            type = 6
          ),
          "Category positioning: Spend vs. Adoption",
          "Jewelry and dining out sit in the high-spend, low-adoption quadrant, a niche but high-impact segment"
        )
      )),
      
      div(
        class = "metric-card",
        style = "margin-bottom: 25px; padding: 15px;",
        h4(strong("Strategic insight"), style = "margin-bottom: 0; color: #2c3e50;"),
        p(tags$ul(
          tags$li(
            " Jewelry drives growth but reaches only 22% of shoppers which leaves 78% of the market underserved.
                  A shift in luxury spending could significantly impact total Valentine’s revenue."
          ),
          tags$li(
            "The solution: cross-sell high-value items to high-adoption segments.
                  Bundle jewelry or experiences with everyday tokens like cards or flowers to expand reach while preserving margin."
          )
        ), style = "margin: 0; line-height: 1.5; color: #495057;")
      ),
      tags$div(style = "margin: 10px 0;")
    )
  )
}
