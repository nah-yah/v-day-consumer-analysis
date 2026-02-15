# download handlers
# generate all download handlers
#' @param output shiny output object
#' @param data list of datasets
generate_downloads <- function(output, data) {
  
  # download full dataset
  output$download_full_data <- downloadHandler(
    filename = function() {
      paste0("valentines_complete_dataset_", Sys.Date(), ".csv")
    },
    content = function(file) {
      full_data <- data$gift_total_long %>%
        left_join(data$gift_per_person_long, 
                  by = c("year", "category"),
                  suffix = c("_total", "_per_person")) %>%
        left_join(data$gift_pct_buying_long, by = c("year", "category")) %>%
        rename(
          total_spending_billions = total_billions,
          per_person_amount = amount,
          pct_buying = pct
        ) %>%
        left_join(data$tier_data, by = "category")
      
      write.csv(full_data, file, row.names = FALSE)
    }
  )
  
  # download executive summary
  output$download_summary <- downloadHandler(
    filename = function() {
      paste0("valentines_executive_summary_", Sys.Date(), ".csv")
    },
    content = function(file) {
      summary_data <- data$spending_total %>%
        left_join(data$celebrating_pct, by = "year") %>%
        left_join(data$per_person_spend, by = "year") %>%
        rename(
          total_spending_billions = value,
          pct_celebrating = pct,
          avg_per_person = amount
        ) %>%
        mutate(
          year = as.numeric(year),
          total_spending_billions = round(total_spending_billions, 2),
          pct_celebrating = round(pct_celebrating * 100, 1),
          avg_per_person = round(avg_per_person, 2)
        ) %>%
        arrange(year)
      
      write.csv(summary_data, file, row.names = FALSE)
    }
  )
  
  # download forecast data
  output$download_forecast <- downloadHandler(
    filename = function() {
      paste0("valentines_forecast_2023-2027_", Sys.Date(), ".csv")
    },
    content = function(file) {
      forecast_data <- data$spending_total_fc %>%
        rename(total_spending_billions = value) %>%
        left_join(data$celebrating_pct_fc %>% rename(pct_celebrating = pct),
                  by = c("year", "type")) %>%
        left_join(data$per_person_spend_fc %>% rename(avg_per_person = amount),
                  by = c("year", "type")) %>%
        mutate(
          year = as.numeric(year),
          total_spending_billions = round(total_spending_billions, 2),
          pct_celebrating = round(pct_celebrating * 100, 1),
          avg_per_person = round(avg_per_person, 2)
        ) %>%
        arrange(type, year)
      
      write.csv(forecast_data, file, row.names = FALSE)
    }
  )
}