# reactive values & filtering logic
# create all reactive values for the application
#' @param input shiny input object
#' @param data list of datasets
#' @return list of reactive expressions
create_reactive_values <- function(input, data) {
  
  # selected years based on filter
  selected_years <- reactive({
    if (input$year_select == "All") {
      data$spending_total$year
    } else {
      input$year_select
    }
  })
  
  # filtered historical data based on all filters
  filtered_historical <- reactive({
    # start with base gift data
    gift_data <- data$gift_total_long %>%
      filter(year %in% selected_years())
    
    # apply category filter
    if (input$category != "All") {
      gift_data <- gift_data %>% filter(category == input$category)
    }
    
    # apply tier filter
    if (input$tier_filter != "All") {
      gift_data <- gift_data %>%
        left_join(data$tier_data, by = "category") %>%
        filter(tier == input$tier_filter) %>%
        select(-tier)
    }
    
    # return list of filtered datasets
    list(
      total_spend = data$spending_total %>% 
        filter(year %in% selected_years()),
      
      celebrating = data$celebrating_pct %>% 
        filter(year %in% selected_years()),
      
      per_person = data$per_person_spend %>% 
        filter(year %in% selected_years()),
      
      gift_total = gift_data
    )
  })
  
  # filtered gift percent buying
  filtered_gift_pct_buying <- reactive({
    df <- data$gift_pct_buying_long %>%
      filter(year %in% selected_years())
    
    if (input$category != "All") {
      df <- df %>% filter(category == input$category)
    }
    
    if (input$tier_filter != "All") {
      df <- df %>%
        left_join(data$tier_data, by = "category") %>%
        filter(tier == input$tier_filter) %>%
        select(-tier)
    }
    
    df
  })
  
  # filtered gift per person
  filtered_gift_per_person <- reactive({
    df <- data$gift_per_person_long %>%
      filter(year %in% selected_years())
    
    if (input$category != "All") {
      df <- df %>% filter(category == input$category)
    }
    
    if (input$tier_filter != "All") {
      df <- df %>%
        left_join(data$tier_data, by = "category") %>%
        filter(tier == input$tier_filter) %>%
        select(-tier)
    }
    
    df
  })
  
  # return all reactive values as a list
  list(
    selected_years = selected_years,
    filtered_historical = filtered_historical,
    filtered_gift_pct_buying = filtered_gift_pct_buying,
    filtered_gift_per_person = filtered_gift_per_person
  )
}