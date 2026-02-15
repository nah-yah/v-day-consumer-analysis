# category tab plots
# generate all category tab plots
#' @param output shiny output object
#' @param input shiny input object
#' @param rv list of reactive values
#' @param data list of datasets
generate_category_plots <- function(output, input, rv, data) {
  
  # tier spending over time
  output$plot_tier_spending <- renderPlotly({
    df <- rv$filtered_historical()$gift_total %>%
      left_join(data$tier_data, by = "category") %>%
      group_by(year, tier) %>%
      summarise(total = sum(total_billions), .groups = "drop") %>%
      mutate(year = as.numeric(year))
    
    p <- ggplot(df, aes(x = year, y = total, fill = tier)) +
      geom_area(position = "stack", alpha = 0.8) +
      labs(x = "Year", y = "Billions USD", fill = "Tier") +
      theme_minimal() +
      theme(
        plot.background = element_rect(fill = "white", color = NA),
        panel.background = element_rect(fill = "white", color = NA),
        panel.grid.major.x = element_blank(),
        panel.grid.major.y = element_line(color = "#f0f0f0", size = 0.5),
        axis.line = element_line(color = "black", size = 0.3),
        axis.text = element_text(size = 9),
        legend.position = "bottom"
      ) +
      scale_y_continuous(labels = dollar_format(suffix = "B")) +
      scale_x_continuous(labels = function(x) sprintf("%.0f", x)) +
      scale_fill_manual(values = tier_colors)
    
    ggplotly(p, tooltip = FALSE) %>%
      layout(title = list(text = ""))
  })
  
  # per-person spending by category
  output$plot_per_person_category <- renderPlotly({
    selected_years <- unique(rv$filtered_historical()$gift_total$year)
    year_to_show <- if (length(selected_years) == 1) 
      selected_years 
    else 
      max(selected_years)
    
    df_filtered <- data$gift_per_person_long %>%
      filter(year == year_to_show)
    
    if (input$tier_filter != "All") {
      df_filtered <- df_filtered %>%
        left_join(data$tier_data, by = "category") %>%
        filter(tier == input$tier_filter)
    } else {
      df_filtered <- df_filtered %>%
        left_join(data$tier_data, by = "category")
    }
    
    df_filtered <- df_filtered %>% arrange(tier, desc(amount))
    
    if (nrow(df_filtered) == 0) {
      return(ggplot() + annotate("text", x = 1, y = 1, label = "No data") + theme_void())
    }
    
    p <- plot_ly(
      data = df_filtered,
      y = ~reorder(category, amount),
      x = ~amount,
      type = "bar",
      orientation = "h",
      color = ~tier,
      colors = tier_colors,
      showlegend = TRUE
    )
    
    p <- p %>% add_text(
      x = ~amount,
      y = ~reorder(category, amount),
      text = ~paste0("$", round(amount, 0)),
      textposition = "inside",
      insidetextanchor = "left",
      textfont = list(color = "#000000", size = 10),
      showlegend = FALSE
    )
    
    p %>% layout(
      xaxis = list(title = "Avg. spend per buyer ($)"),
      yaxis = list(
        title = "Category",
        categoryorder = "array",
        categoryarray = rev(df_filtered$category)
      ),
      plot_bgcolor = "white",
      paper_bgcolor = "white",
      legend = list(orientation = "h", x = 0.5, xanchor = "center", y = -0.2),
      title = list(text = "")
    )
  })
  
  # percent buying by category
  output$plot_pct_buying <- renderPlotly({
    selected_years <- unique(rv$filtered_historical()$gift_total$year)
    
    if (length(selected_years) > 2) {
      years_to_show <- c("2010", max(selected_years))
    } else {
      years_to_show <- selected_years
    }
    
    df <- data$gift_pct_buying_long %>%
      filter(year %in% years_to_show)
    
    if (input$tier_filter != "All") {
      df <- df %>%
        left_join(data$tier_data, by = "category") %>%
        filter(tier == input$tier_filter)
    } else {
      df <- df %>%
        left_join(data$tier_data, by = "category")
    }
    
    df <- df %>%
      mutate(year = factor(year, levels = sort(years_to_show)))
    
    if (nrow(df) == 0) {
      return(ggplot() + annotate("text", x = 1, y = 1, label = "No data") + theme_void())
    }
    
    p <- ggplot(df, aes(x = reorder(category, -pct), y = pct * 100, fill = year)) +
      geom_col(position = "dodge", width = 0.7) +
      geom_text(
        aes(label = paste0(round(pct * 100, 1), "%")),
        position = position_dodge(width = 0.7),
        vjust = 0.5,
        size = 3,
        color = "black"
      ) +
      facet_wrap(~tier, scales = "free_x", ncol = 3) +
      labs(x = "Category", y = "% of shoppers", fill = "Year") +
      theme_minimal() +
      theme(
        plot.background = element_rect(fill = "white", color = NA),
        panel.background = element_rect(fill = "white", color = NA),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_line(color = "#f0f0f0", size = 0.5),
        panel.grid.minor.y = element_blank(),
        axis.text.x = element_text(angle = 0, hjust = 1, size = 9, margin = margin(t = 5)),
        axis.text.y = element_text(size = 9),
        axis.title.x = element_text(margin = margin(t = -5)),
        strip.text = element_text(face = "bold", size = 10),
        panel.spacing = unit(0.2, "lines"),
        legend.position = "top"
      ) +
      scale_fill_manual(values = c("2010" = "#A9A9A9", "2022" = "#E31937"))
    
    ggplotly(p, tooltip = FALSE) %>%
      layout(title = list(text = ""))
  })
  
  # quadrant analysis
  output$plot_quadrant_tiers <- renderPlotly({
    df_temp <- data$gift_per_person_long %>%
      filter(year == "2022") %>%
      left_join(data$gift_pct_buying_long %>% filter(year == "2022"), by = "category")
    
    h_spend <- quantile(df_temp$amount, 0.75, na.rm = TRUE)
    l_spend <- quantile(df_temp$amount, 0.25, na.rm = TRUE)
    h_adoption <- quantile(df_temp$pct, 0.75, na.rm = TRUE) * 100
    l_adoption <- quantile(df_temp$pct, 0.25, na.rm = TRUE) * 100
    
    quadrant_data <- df_temp %>%
      left_join(data$tier_data, by = "category") %>%
      mutate(x = pct * 100, y = amount)
    
    p <- ggplot(quadrant_data, aes(x = x, y = y, color = tier, text = category)) +
      annotate("rect", xmin = -Inf, xmax = l_adoption, ymin = h_spend, ymax = Inf,
               fill = "#fff5f7", alpha = 0.3) +
      annotate("rect", xmin = h_adoption, xmax = Inf, ymin = h_spend, ymax = Inf,
               fill = "#f0f0ff", alpha = 0.3) +
      annotate("rect", xmin = h_adoption, xmax = Inf, ymin = -Inf, ymax = l_spend,
               fill = "#f0fff0", alpha = 0.3) +
      annotate("rect", xmin = -Inf, xmax = l_adoption, ymin = -Inf, ymax = l_spend,
               fill = "#f0f8ff", alpha = 0.3) +
      geom_vline(xintercept = h_adoption, linetype = "dashed", color = "gray50") +
      geom_hline(yintercept = h_spend, linetype = "dashed", color = "gray50") +
      geom_point(size = 4) +
      geom_text(aes(label = category), nudge_y = 3, vjust = 0.7, size = 3) +
      annotate("text", x = min(quadrant_data$x) + 5, y = max(quadrant_data$y) - 5,
               label = "High-value gifts", color = "#E31937", fontface = "bold", size = 3.5) +
      annotate("text", x = max(quadrant_data$x) - 5, y = min(quadrant_data$y) + 5,
               label = "Everyday tokens", color = "#8A8A8A", fontface = "bold", size = 3.5) +
      annotate("text", x = min(quadrant_data$x) + 5, y = min(quadrant_data$y) + 5,
               label = "Gifts", color = "#4A90E2", fontface = "bold", size = 3.5) +
      labs(x = "% of shoppers buying category", y = "Avg. spend per buyer ($)", 
           color = "Category tier") +
      theme_minimal() +
      theme(
        plot.background = element_rect(fill = "white", color = NA),
        panel.background = element_rect(fill = "white", color = NA),
        legend.position = "bottom"
      ) +
      scale_color_manual(values = tier_colors)
    
    ggplotly(p, tooltip = "text") %>%
      layout(title = list(text = ""))
  })
}