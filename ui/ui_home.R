# home page ui
home_ui <- function() {
  tagList(
    div(
      class = "content-panel",
      
      # hero section
      div(
        style = "text-align: center; margin-bottom: 40px; padding: 30px 20px; background: linear-gradient(135deg, #fff5f7 0%, #ffffff 100%); border-radius: 12px;",
        h2("The Valentine's Day market grew 60% in a decade.", style = "color: #E31937; margin-bottom: 15px; font-size: 28px; font-weight: 700;"),
      ),
      
      tags$hr(style = "border-top: 1px solid #e0e0e0; margin: 30px 0;"),
      
      # key statistics cards
      fluidRow(
        column(
          3,
          div(
            class = "metric-card",
            style = "text-align: center; padding: 20px !important;",
            h3("$25.9B", style = "color: #E31937; margin: 0; font-size: 32px; font-weight: 700;"),
            p("Total spending in 2022", style = "margin: 5px 0 0 0; font-size: 13px; color: #6c757d;")
          )
        ),
        column(
          3,
          div(
            class = "metric-card",
            style = "text-align: center; padding: 20px !important;",
            h3("+60%", style = "color: #E31937; margin: 0; font-size: 32px; font-weight: 700;"),
            p("Growth since 2010", style = "margin: 5px 0 0 0; font-size: 13px; color: #6c757d;")
          )
        ),
        column(
          3,
          div(
            class = "metric-card",
            style = "text-align: center; padding: 20px !important;",
            h3("+$3.2B", style = "color: #E31937; margin: 0; font-size: 32px; font-weight: 700;"),
            p("Jewelry growth alone", style = "margin: 5px 0 0 0; font-size: 13px; color: #6c757d;")
          )
        ),
        column(
          3,
          div(
            class = "metric-card",
            style = "text-align: center; padding: 20px !important;",
            h3("51%", style = "color: #E31937; margin: 0; font-size: 32px; font-weight: 700;"),
            p("Gen Z celebration rate", style = "margin: 5px 0 0 0; font-size: 13px; color: #6c757d;")
          )
        )
      ),
      
      tags$hr(style = "border-top: 1px solid #e0e0e0; margin: 40px 0 30px 0;"),
      
      # main narrative
      div(
        style = "line-height: 1.8; font-size: 15px; color: #2c3e50;",
        
        p(
          "For most of the 2010s, Valentine's Day spending was predictable: $18-20 billion annually, 52-55% participation, steady growth tracking inflation.",
          strong("Then 2020 happened.", style = "font-size: 17px; color: #E31937;"),
          "Spending surged to $27.4 billion with a 37% jump, but",
          strong("participation stayed flat at 55%."),
          " What changed was ",
          em("intensity"),
          " ,per-person spending leaped from $140 to $196.",
          "This wasn't pandemic panic-buying; by 2022, spending remained at $25.9 billion (43% above pre-2020 levels)."
        ),
        
        
        fluidRow(
          # force 1: jewelry
          column(
            4,
            div(
              style = "padding: 25px; background-color: #fff5f7; border-radius: 8px; border-left: 4px solid #E31937; min-height: 280px;",
              h5("The Jewelry paradox", style = "color: #E31937; margin-top: 0; margin-bottom: 15px; font-weight: 600;"),
              p(
                style = "font-size: 14px; line-height: 1.6; color: #2c3e50;",
                "Jewelry accounts for ",
                strong("$3.2B of growth"),
                " since 2010. Yet only ",
                strong("22% of shoppers"),
                " buy it. Meanwhile, 52% buy $7 candy."
              ),
              div(
                style = "margin-top: 35px; padding-top: 15px; border-top: 1px dotted #E31937;",
                p(style = "font-size: 13px; color: #6c757d; margin: 0;", "78% of shoppers are locked out of the growth engine.")
              )
            )
          ),
          
          # force 2: gen z
          column(
            4,
            div(
              style = "padding: 25px; background-color: #f0f8ff; border-radius: 8px; border-left: 4px solid #4A90E2; min-height: 280px;",
              h5("Gen Z transformation", style = "color: #4A90E2; margin-top: 0; margin-bottom: 15px; font-weight: 600;"),
              p(
                style = "font-size: 14px; line-height: 1.6; color: #2c3e50;",
                strong("51% of 18-24 year-olds"),
                " celebrate, 11 points above any other group.",
                strong("29% self-gift"),
                " (4× the rate of 65+) and spend ",
                strong("$180+ per person"),
                " on experiences over objects."
              ),
              div(
                style = "margin-top: 15px; padding-top: 15px; border-top: 1px dotted #4A90E2;",
                p(
                  style = "font-size: 13px; color: #6c757d; margin: 0;",
                  "By 2028, Gen Z enters peak earning years with new spending priorities."
                )
              )
            )
          ),
          
          # force 3: gender
          column(
            4,
            div(
              style = "padding: 25px; background-color: #f0fff0; border-radius: 8px; border-left: 4px solid #00BA38; min-height: 280px;",
              h5("Gender inversion", style = "color: #00BA38; margin-top: 0; margin-bottom: 15px; font-weight: 600;"),
              p(
                style = "font-size: 14px; line-height: 1.6; color: #2c3e50;",
                "Celebration drivers diverge by gender:",
                strong("tradition motivates 68% of men,"),
                "while",
                strong("emotional expression drives 51% of women.")
              ),
              div(
                style = "margin-top: 15px; padding-top: 15px; border-top: 1px dotted #00BA38;",
                p(
                  style = "font-size: 13px; color: #6c757d; margin: 0;",
                  "The market tilts toward authentic expression over obligation."
                )
              )
            )
          )
        ),
        
        tags$hr(style = "border-top: 1px dotted #d0d0d0; margin: 35px 0;"),
        
        h4("Where this is heading: 2023–2027", style = "color: #E31937; margin-top: 30px; margin-bottom: 15px;"),
        p(
          "Projections suggest the market will reach ",
          strong("$27.7 billion by 2027"),
          " (+3.2% annual growth). But participation is declining (from 53% to 47.8%), so all growth will come from higher per-person spending that is expected to hit ",
          strong("$209 by 2027"),
          ". Three trends will shape this trajectory:"
        ),
        p(
          tags$strong("Experiences are growing fastest"), 
          " among under-35 shoppers, especially dining and events. ",
          tags$strong("Self-gifting is normalizing"), 
          ", spreading from Gen Z (29%) to Millennials (18%). And ",
          tags$strong("the jewelry paradox must resolve, "), 
          "either luxury expands reach or mass-market trades up.",
          style = "margin-top: 10px;"
        ),
      ),
      
      tags$hr(style = "border-top: 1px solid #e0e0e0; margin: 40px 0 30px 0;"),
      
      # navigation to sections
      h4("Explore the data", style = "color: #2c3e50; margin-bottom: 20px;"),
      fluidRow(
        column(
          3,
          div(
            style = "text-align: center; padding: 15px; background-color: #f8f9fa; border-radius: 8px; cursor: pointer;",
            onclick = "showTab('picture');",
            h5("The big picture", style = "color: #E31937; margin-bottom: 10px; font-weight: 600;"),
            p("How the market evolved (2010-2022)", style = "font-size: 13px; color: #6c757d; margin: 0;")
          )
        ),
        column(
          3,
          div(
            style = "text-align: center; padding: 15px; background-color: #f8f9fa; border-radius: 8px; cursor: pointer;",
            onclick = "showTab('category');",
            h5("Where money goes", style = "color: #E31937; margin-bottom: 10px; font-weight: 600;"),
            p("Category spending and tiers", style = "font-size: 13px; color: #6c757d; margin: 0;")
          )
        ),
        column(
          3,
          div(
            style = "text-align: center; padding: 15px; background-color: #f8f9fa; border-radius: 8px; cursor: pointer;",
            onclick = "showTab('demographics');",
            h5("Who's driving trends", style = "color: #E31937; margin-bottom: 10px; font-weight: 600;"),
            p("Age, gender, and emerging behaviors", style = "font-size: 13px; color: #6c757d; margin: 0;")
          )
        ),
        column(
          3,
          div(
            style = "text-align: center; padding: 15px; background-color: #f8f9fa; border-radius: 8px; cursor: pointer;",
            onclick = "showTab('explore');",
            h5("What's next", style = "color: #E31937; margin-bottom: 10px; font-weight: 600;"),
            p("Forecasts and strategic opportunities", style = "font-size: 13px; color: #6c757d; margin: 0;")
          )
        )
      ),
      
      tags$hr(style = "border-top: 1px solid #e0e0e0; margin: 40px 0 30px 0;"),
      
      # export section
      h4("Export dataset", style = "color: #2c3e50; margin-bottom: 15px;"),
      p(
        "Download the complete Valentine's Day dataset including all historical trends, categories, and demographics.",
        style = "color: #6c757d; margin-bottom: 20px;"
      ),
      
      fluidRow(
        column(
          4,
          downloadButton(
            "download_full_data",
            "Download complete dataset (CSV)",
            class = "btn-primary",
            style = "width: 100%; background-color: #E31937; border: none; padding: 12px; font-size: 14px;"
          )
        ),
        column(
          4,
          downloadButton(
            "download_summary",
            "Download executive summary (CSV)",
            class = "btn-primary",
            style = "width: 100%; background-color: #4A90E2; border: none; padding: 12px; font-size: 14px;"
          )
        ),
        column(
          4,
          downloadButton(
            "download_forecast",
            "Download forecast data (CSV)",
            class = "btn-primary",
            style = "width: 100%; background-color: #00BA38; border: none; padding: 12px; font-size: 14px;"
          )
        )
      ),
      
      tags$div(style = "margin: 20px 0;"),
      
      p(
        tags$em(
          "Data source: National Retail Federation surveys of U.S. adults (2010–2022), sourced via Kaggle's Sunja dataset and distributed through TidyTuesday."
        ),
        style = "font-size: 12px; color: #6c757d; text-align: center; margin-top: 20px;"
      )
    )
  )
}