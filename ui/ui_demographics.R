# demographics ui
demographics_ui <- function() {
  tagList(div(
    class = "content-panel",
    h3("Who's driving the trends", style = "margin-bottom: 0; color: #2c3e50;"),
    h6("How age, gender, and behavior shape Valentine’s spending"),
    tags$hr(style = "border-top: 1px solid #e0e0e0; margin: 0 0 20px 0;"),
    
    # Sub-tab navigation
    div(
      class = "subtab-nav",
      style = "display: flex; gap: 8px; margin-bottom: 20px;",
      tags$button(
        onclick = "showSubTab('all');",
        class = "subtab-btn active",
        id = "subtab-all",
        "All"
      ),
      tags$button(
        onclick = "showSubTab('age');",
        class = "subtab-btn",
        id = "subtab-age",
        "By age group"
      ),
      tags$button(
        onclick = "showSubTab('gender');",
        class = "subtab-btn",
        id = "subtab-gender",
        "By gender"
      ),
      tags$button(
        onclick = "showSubTab('emerging');",
        class = "subtab-btn",
        id = "subtab-emerging",
        "Emerging behaviors"
      )
    ),
    
    # section: by age group
    div(
      id = "section-age",
      class = "demographics-section",
      div(
        class = "section-group",
        h4(class = "section-group-title", "By age group"),
        p(
          class = "section-group-subtitle",
          "Gen Z and Millennials are reshaping Valentine’s through higher engagement, self-gifting, and experiential purchases."
        ),
        div(class = "section-group-divider"),
        fluidRow(column(
          6,
          wrap_chart(
            withSpinner(
              plotlyOutput("plot_celebrate_age", height = "400px"),
              color = "#A9A9A9",
              type = 6
            ),
            "Celebration participation by age",
            "51% of 18 to 24-year-olds celebrate Valentine’s Day, 11+ points above the next-highest group"
          )
        ), column(
          6,
          wrap_chart(
            withSpinner(
              plotlyOutput("plot_self_treat", height = "400px"),
              color = "#A9A9A9",
              type = 6
            ),
            "Self-treating by age",
            "29% of 18 to 24-year-olds buy gifts for themselves; nearly 4× the rate of 65+ shoppers"
          )
        )),
        fluidRow(column(
          12,
          wrap_chart(
            withSpinner(
              plotlyOutput("plot_gifts_age", height = "400px"),
              color = "#A9A9A9",
              type = 6
            ),
            "Gift preferences by age",
            "Gen Z (18–24) and Millennials (25–34) prioritize dining/events; jewelry peaks among 25 to 34-year-olds"
          )
        ))
      )
    ),
    
    # section: by gender
    div(
      id = "section-gender",
      class = "demographics-section",
      div(
        class = "section-group",
        h4(class = "section-group-title", "By gender"),
        p(
          class = "section-group-subtitle",
          "Gender shapes both what people buy and why they celebrate. Men lean into tradition and jewelry, women prioritize flowers and self-gifting"
        ),
        div(class = "section-group-divider"),
        fluidRow(column(
          6,
          wrap_chart(
            withSpinner(
              plotlyOutput("plot_gifts_gender", height = "400px"),
              color = "#A9A9A9",
              type = 6
            ),
            "Gift preferences by gender",
            "Men are more likely to buy jewelry (30% vs 14%); women lead in flowers (56% vs 19%) and candy (52% vs 43%)"
          )
        ), column(
          6,
          wrap_chart(
            withSpinner(
              plotlyOutput("plot_motivations", height = "400px"),
              color = "#A9A9A9",
              type = 6
            ),
            "Motivations for celebrating",
            "Men prioritize tradition (68% vs 25%); women emphasize expressing care (51% vs 29%)"
          )
        ))
      )
    ),
    
    # section: emerging behaviors
    div(
      id = "section-emerging",
      class = "demographics-section",
      div(
        class = "section-group",
        h4(class = "section-group-title", "Emerging behaviors"),
        p(
          class = "section-group-subtitle",
          "Anti-Valentine’s purchasing is small but notable, ~5% of younger adults buy anti-Valentine’s gifts, led slightly by men"
        ),
        div(class = "section-group-divider"),
        fluidRow(column(
          6,
          wrap_chart(
            withSpinner(
              plotlyOutput("plot_anti_val", height = "400px"),
              color = "#A9A9A9",
              type = 6
            ),
            "Anti-Valentine's by gender",
            "3% of men buy anti-Valentine’s gifts, 1.5× the rate of women"
          )
        ), column(
          6,
          wrap_chart(
            withSpinner(
              plotlyOutput("plot_anti_val_age", height = "400px"),
              color = "#A9A9A9",
              type = 6
            ),
            "Anti-Valentine's by age",
            "Peak at 5% among 18–24 and 35 to 44-year-olds, and is near zero among 55+"
          )
        ))
      )
    )
  ))
}