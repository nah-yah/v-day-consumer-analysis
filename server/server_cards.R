# metric cards
# generate all metric card outputs
#' @param output hiny output object
#' @param input shiny input object
#' @param rv list of reactive values from server_reactive.R
#' @param data list of datasets
generate_metric_cards <- function(output, input, rv, data) {
  
  # spending comparison card
  output$spending_comparison_card <- renderUI({
    df <- data$per_person_spend %>% 
      filter(year %in% rv$selected_years())
    
    # validate data exists
    if (nrow(df) == 0) return(NULL)
    
    # get reference year data
    spend_ref <- data$per_person_spend %>% 
      filter(year == reference_year) %>% 
      pull(amount)
    
    if (length(spend_ref) == 0) {
      return(tags$div("Reference year data not available"))
    }
    
    # calculate comparison
    avg_selected <- mean(df$amount, na.rm = TRUE)
    
    if (is.na(avg_selected)) {
      return(tags$div("Selected year data not available"))
    }
    
    diff <- avg_selected - spend_ref
    pct_change <- safe_divide(diff, spend_ref) * 100
    
    diff_sign <- ifelse(diff >= 0, "+", "")
    pct_sign <- ifelse(pct_change >= 0, "+", "")
    
    label <- if (input$year_select == "All") "All years" else input$year_select
    
    # render card
    tags$div(
      class = "metric-card",
      h4(strong("Avg. spend per person")),
      tags$hr(style = "border-top: 1px solid #e0e0e0; margin: 0 10px;"),
      p(
        sprintf("%s: %s", label, format_dollars(avg_selected)),
        br(),
        sprintf("%s (reference): %s", reference_year, format_dollars(spend_ref)),
        br(),
        strong(
          sprintf(
            "%s%s (%s%.0f%%) vs. %s",
            diff_sign,
            format_dollars(abs(diff)),
            pct_sign,
            abs(pct_change),
            reference_year
          )
        )
      )
    )
  })
  
  # celebration rate card
  output$celebration_comparison_card <- renderUI({
    df <- data$celebrating_pct %>% 
      filter(year %in% rv$selected_years())
    
    # Validate data exists
    if (nrow(df) == 0) return(NULL)
    
    # Get reference year data
    celebrate_ref <- data$celebrating_pct %>% 
      filter(year == reference_year) %>% 
      pull(pct)
    
    if (length(celebrate_ref) == 0) {
      return(tags$div("Reference year celebration data not available"))
    }
    
    # Calculate comparison
    avg_selected <- mean(df$pct, na.rm = TRUE)
    
    if (is.na(avg_selected)) {
      return(tags$div("Selected year celebration data not available"))
    }
    
    diff_pp <- (avg_selected - celebrate_ref) * 100
    pct_change <- safe_divide(diff_pp, celebrate_ref * 100) * 100
    
    diff_sign <- ifelse(diff_pp >= 0, "+", "")
    pct_sign <- ifelse(pct_change >= 0, "+", "")
    
    label <- if (input$year_select == "All") "All years" else input$year_select
    
    # render card
    tags$div(
      class = "metric-card",
      h4(strong("Celebration rate")),
      tags$hr(style = "border-top: 1px solid #e0e0e0; margin: 0 10px;"),
      p(
        sprintf("%s: %s", label, format_pct(avg_selected)),
        br(),
        sprintf("%s (reference): %s", reference_year, format_pct(celebrate_ref)),
        br(),
        strong(
          sprintf(
            "%s%.1f pp (%s%.0f%%) vs. %s",
            diff_sign,
            abs(diff_pp),
            pct_sign,
            abs(pct_change),
            reference_year
          )
        )
      )
    )
  })
}