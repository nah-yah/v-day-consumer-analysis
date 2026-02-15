# demographics tab plots
# generate all demographics tab plots
#' @param output shiny output object
#' @param input shiny input object
#' @param rv list of reactive values
#' @param data list of datasets
generate_demo_plots <- function(output, input, rv, data) {
  
  # celebration by age
  output$plot_celebrate_age <- renderPlotly({
    df <- data$celebrating_age_1 %>%
      mutate(age_group = factor(age_group, 
                                levels = c("18-24", "25-34", "35-44", "45-54", "55-64", "65+")))
    
    if (input$age_group != "All") {
      df <- df %>% filter(age_group == input$age_group)
    }
    
    if (nrow(df) == 0) {
      return(ggplot() + annotate("text", x = 1, y = 1, label = "No data") + theme_void())
    }
    
    df <- df %>%
      mutate(
        is_max = celebrating_pct == max(celebrating_pct, na.rm = TRUE),
        bar_color = ifelse(is_max, "#E31937", "#A9A9A9")
      )
    
    p <- ggplot(df, aes(x = age_group, y = celebrating_pct * 100, fill = bar_color)) +
      geom_col(width = 0.85) +
      geom_text(
        aes(label = paste0(round(celebrating_pct * 100, 1), "%")),
        color = "black",
        size = 3.5,
        vjust = 0.5,
        hjust = 0.5
      ) +
      scale_fill_identity() +
      labs(x = "Age group", y = "% celebrating Valentine's Day") +
      theme_minimal() +
      theme(
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_line(color = "#f0f0f0", size = 0.5),
        axis.text.x = element_text(angle = 0, size = 10),
        legend.position = "none"
      )
    
    ggplotly(p, tooltip = FALSE) %>%
      layout(title = list(text = ""))
  })
  
  # self-treating by age
  output$plot_self_treat <- renderPlotly({
    df <- data$celebrating_age_2_long %>%
      filter(behavior == "Treat yourself") %>%
      mutate(age_group = factor(age_group, 
                                levels = c("18-24", "25-34", "35-44", "45-54", "55-64", "65+")))
    
    if (input$age_group != "All") {
      df <- df %>% filter(age_group == input$age_group)
    }
    
    if (nrow(df) == 0) {
      return(ggplot() + annotate("text", x = 1, y = 1, label = "No data") + theme_void())
    }
    
    df <- df %>%
      mutate(
        is_max = pct == max(pct, na.rm = TRUE),
        bar_color = ifelse(is_max, "#E31937", "#A9A9A9"),
        hover_text = paste0("Pct: ", round(pct * 100, 1), "%")
      )
    
    p <- ggplot(df, aes(x = age_group, y = pct * 100, fill = bar_color, text = hover_text)) +
      geom_col(width = 0.85) +
      geom_text(
        aes(label = paste0(round(pct * 100, 1), "%")),
        color = "black",
        size = 3.5,
        vjust = 0.5,
        hjust = 0.5
      ) +
      scale_fill_identity() +
      labs(x = "Age group", y = "% treating themselves") +
      theme_minimal() +
      theme(
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_line(color = "#f0f0f0", size = 0.5),
        axis.text.x = element_text(angle = 0, size = 10),
        legend.position = "none"
      )
    
    ggplotly(p, tooltip = "text") %>%
      layout(title = list(text = ""))
  })
  
  # gift preferences by age (heatmap)
  output$plot_gifts_age <- renderPlotly({
    if (nrow(data$planned_age_long) == 0) {
      return(ggplot() + annotate("text", x = 1, y = 1, label = "No data") + theme_void())
    }
    
    df <- data$planned_age_long %>%
      mutate(
        age_group = factor(age_group, 
                           levels = c("18-24", "25-34", "35-44", "45-54", "55-64", "65+")),
        pct = as.numeric(pct)
      ) %>%
      filter(!is.na(pct))
    
    if (input$age_group != "All") {
      df <- df %>% filter(age_group == input$age_group)
    }
    
    if (nrow(df) == 0) {
      return(ggplot() + annotate("text", x = 1, y = 1, label = "No data") + theme_void())
    }
    
    p <- ggplot(df, aes(
      x = category,
      y = age_group,
      fill = pct * 100,
      text = paste0("Pct: ", round(pct * 100, 1), "%")
    )) +
      geom_tile(color = "white") +
      scale_fill_gradient(low = "white", high = "#E31937", name = "%") +
      labs(x = "Category", y = "Age group") +
      theme_minimal() +
      theme(
        axis.text.x = element_text(angle = 0, hjust = 1, size = 9),
        axis.text.y = element_text(size = 9),
        legend.position = "top",
        legend.direction = "horizontal",
        legend.title = element_text(size = 9),
        legend.text = element_text(size = 8)
      )
    
    ggplotly(p, tooltip = "text") %>%
      layout(title = list(text = ""))
  })
  
  # gift preferences by gender
  output$plot_gifts_gender <- renderPlotly({
    df <- data$planned_gender_long %>%
      mutate(category = factor(category, levels = rev(c(
        "An evening out", "Jewelry", "Gift cards", "Clothing",
        "Flowers", "Candy", "Greeting cards"
      ))))
    
    p <- ggplot(df, aes(x = category, y = pct * 100, fill = gender)) +
      geom_col(position = "dodge", width = 0.75) +
      geom_text(
        aes(label = paste0(round(pct * 100, 1), "%")),
        position = position_dodge(width = 0.8),
        color = "black",
        size = 3,
        vjust = 0.5,
        hjust = 0.5
      ) +
      scale_fill_manual(values = gender_colors, name = NULL) +
      labs(x = "Category", y = "% planning to buy") +
      coord_flip() +
      theme_minimal() +
      theme(
        panel.grid.major.y = element_line(color = "#f0f0f0", size = 0.5),
        panel.grid.minor.y = element_blank(),
        panel.grid.major.x = element_blank(),
        axis.text.y = element_text(size = 10),
        axis.text.x = element_text(size = 9),
        legend.position = "top",
        legend.direction = "horizontal"
      )
    
    ggplotly(p, tooltip = FALSE) %>%
      layout(title = list(text = ""))
  })
  
  # motivations by gender
  output$plot_motivations <- renderPlotly({
    df <- data$motivations %>%
      mutate(
        reason = factor(reason, levels = rev(unique(reason))),
        pct = as.numeric(pct)
      )
    
    if (input$gender != "All") {
      df <- df %>% filter(gender == input$gender)
    }
    
    if (nrow(df) == 0) {
      return(ggplot() + annotate("text", x = 1, y = 1, label = "No data") + theme_void())
    }
    
    p <- ggplot(df, aes(
      x = reason,
      y = pct * 100,
      fill = gender,
      text = paste0("Pct: ", round(pct * 100, 1), "%")
    )) +
      geom_col(position = "dodge", width = 0.75) +
      geom_text(
        aes(label = paste0(round(pct * 100, 1), "%")),
        position = position_dodge(width = 0.75),
        color = "black",
        size = 3,
        vjust = 0.5,
        hjust = 0.5
      ) +
      scale_fill_manual(values = gender_colors, name = NULL) +
      labs(x = "Reason", y = "% citing this motivation") +
      coord_flip() +
      theme_minimal() +
      theme(
        panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        panel.grid.major.x = element_line(color = "#f0f0f0", size = 0.5),
        axis.text.y = element_text(size = 10),
        axis.text.x = element_text(size = 9),
        legend.position = "top",
        legend.direction = "horizontal"
      )
    
    ggplotly(p, tooltip = FALSE) %>%
      layout(title = list(text = ""))
  })
  
  # anti-Valentine's by gender
  output$plot_anti_val <- renderPlotly({
    df <- data$celebrating_gender_2_long %>%
      filter(behavior == "Purchase \"anti-Valentine's Day\" gifts")
    
    if (nrow(df) == 0) {
      return(ggplot() + annotate("text", x = 1, y = 1, label = "No data") + theme_void())
    }
    
    p <- ggplot(df, aes(
      x = gender,
      y = pct * 100,
      fill = gender,
      text = paste0("Pct: ", round(pct * 100, 1), "%")
    )) +
      geom_col(width = 0.7) +
      geom_text(
        aes(label = paste0(round(pct * 100, 1), "%")),
        color = "black",
        size = 3.5,
        vjust = 0.5,
        hjust = 0.5
      ) +
      scale_fill_manual(values = gender_colors, name = NULL) +
      labs(x = "Gender", y = "% buying anti-Valentine's gifts") +
      theme_minimal() +
      theme(
        panel.grid.major.x = element_line(color = "#f0f0f0", size = 0.5),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_blank(),
        axis.text.x = element_text(size = 10),
        legend.position = "top",
        legend.direction = "horizontal"
      )
    
    ggplotly(p, tooltip = "text") %>%
      layout(title = list(text = ""))
  })
  
  # anti-Valentine's by age
  output$plot_anti_val_age <- renderPlotly({
    df <- data$celebrating_age_2_long %>%
      filter(behavior == "Purchase \"anti-Valentine's Day\" gifts") %>%
      mutate(age_group = factor(age_group, 
                                levels = c("18-24", "25-34", "35-44", "45-54", "55-64", "65+")))
    
    if (nrow(df) == 0) {
      return(ggplot() + annotate("text", x = 1, y = 1, label = "No data") + theme_void())
    }
    
    df <- df %>%
      mutate(
        is_max = pct == max(pct, na.rm = TRUE),
        bar_color = ifelse(is_max, "#E31937", "#A9A9A9")
      )
    
    p <- ggplot(df, aes(x = age_group, y = pct * 100, fill = bar_color)) +
      geom_col(width = 0.75) +
      geom_text(
        aes(label = paste0(round(pct * 100, 1), "%")),
        color = "black",
        size = 3.5,
        vjust = 0.5,
        hjust = 0.5
      ) +
      scale_fill_identity() +
      labs(x = "Age group", y = "% buying anti-Valentine's gifts") +
      theme_minimal() +
      theme(
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        axis.text.x = element_text(angle = 0, size = 10),
        legend.position = "none"
      )
    
    ggplotly(p, tooltip = FALSE) %>% 
      layout(title = list(text = ""))
  })
}