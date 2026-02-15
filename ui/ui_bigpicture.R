# big picture ui
bigpicture_ui <- function() {
  tagList(div(
    class = "content-panel",
    h3("Market overview", style = "margin-bottom: 0; color: #2c3e50;"),
    h6(
      "How is the american Valentine's Day market from 2010 to 2022 and where is it going?"
    ),
    
    tags$hr(style = "border-top: 1px solid #e0e0e0; margin: 0 0 20px 0;"),
    
    fluidRow(column(
      6, uiOutput("spending_comparison_card")
    ), column(
      6, uiOutput("celebration_comparison_card")
    )),
    
    tags$div(style = "margin: 10px 0;"),
    
    fluidRow(
      column(
        6,
        wrap_chart(
          withSpinner(
            plotlyOutput("plot_total_spend", height = "450px"),
            color = "#A9A9A9",
            type = 6
          ),
          "Total Valentine's Day spending",
          "Spending hit $27.4B in 2020 and remained 20% above pre-pandemic levels through 2022"
        ),
        tags$div(style = "margin: 30px 0;"),
        wrap_chart(
          withSpinner(
            plotlyOutput("plot_category_growth", height = "450px"),
            color = "#A9A9A9",
            type = 6
          ),
          "Category spending comparison",
          "Jewelry spending surged by $3.2B, more than all other categories combined, while dining out and candy each grew by about $1B"
        )
      ),
      column(
        6,
        wrap_chart(
          withSpinner(
            plotlyOutput("plot_participation", height = "450px"),
            color = "#A9A9A9",
            type = 6
          ),
          "Celebration participation rate",
          "Celebration rates held steady at ~55% which shows that higher per-person spending drove the 2020 spike"
        ),
        tags$div(style = "margin: 30px 0;"),
        wrap_chart(
          withSpinner(
            plotlyOutput("plot_intensity", height = "450px"),
            color = "#A9A9A9",
            type = 6
          ),
          "Average spend per person",
          "Per-person spending jumped to $196 in 2020 but returned to $160–$170 by 2022"
        )
      )
    )
  ))
}