# server - forecast plots
# generate all forecast plot outputs
#' @param output shiny output object
#' @param data list of datasets (includes pre-calculated forecasts)
generate_forecast_plots <- function(output, data) {
  
  # total spending forecast
  output$plot_total_forecast <- renderPlotly({
    # create seamless connection at boundary
    last_historical <- data$spending_total_fc %>%
      filter(type == "Historical") %>%
      filter(year == max(year))
    
    spending_fc_connected <- data$spending_total_fc %>%
      bind_rows(last_historical %>% mutate(type = "Forecast"))
    
    # calculate axis limits
    y_data_max <- max(data$spending_total_fc$value, na.rm = TRUE)
    y_data_min <- min(data$spending_total_fc$value, na.rm = TRUE)
    y_axis_top <- y_data_max * 1.20
    
    # calculate offset for labels
    offset_distance <- (y_data_max - y_data_min) * 0.20
    
    # prepare label data with alternating positions
    label_data <- spending_fc_connected %>%
      filter(year >= 2022 & year <= 2027) %>%
      group_by(year) %>%
      slice(1) %>%
      ungroup() %>%
      mutate(
        is_above = year %% 2 == 0,
        label_y = ifelse(is_above, value + offset_distance * 1.5, value - offset_distance * 1.5),
        label_text = paste0(year, ": $", sprintf("%.1f", value), "B"),
        vjust_value = ifelse(is_above, 0, 1)
      )
    
    p <- ggplot(spending_fc_connected, aes(x = year, y = value, color = type, linetype = type)) +
      # shaded forecast area
      annotate("rect", xmin = 2022, xmax = 2028, ymin = 0, ymax = y_axis_top,
               fill = "grey80", alpha = 0.4, inherit.aes = FALSE) +
      
      geom_vline(xintercept = 2022, linetype = "dotted", color = "gray60", size = 0.5) +
      geom_line(size = 0.5) +
      geom_point(size = 1.5) +
      
      # leader lines
      geom_segment(data = label_data, aes(x = year, y = value, xend = year, yend = label_y),
                   color = colors$primary, size = 0.5, inherit.aes = FALSE) +
      
      # data labels
      geom_text(data = label_data, aes(x = year, y = label_y, label = label_text, vjust = vjust_value),
                size = 3, fontface = "bold", color = colors$gray_dark, inherit.aes = FALSE) +
      
      scale_color_manual(values = year_colors, name = NULL) +
      scale_linetype_manual(values = c("Historical" = "solid", "Forecast" = "dashed"), name = NULL) +
      
      labs(x = "Year", y = "Total spending ($B)") +
      theme_minimal() +
      theme(
        panel.grid.major.x = element_line(color = plot_theme$panel_grid_color, size = plot_theme$panel_grid_size),
        panel.grid.major.y = element_blank(),
        axis.line = element_line(color = plot_theme$axis_line_color, size = plot_theme$axis_line_size),
        axis.text = element_text(size = plot_theme$axis_text_size),
        legend.position = "bottom"
      ) +
      scale_y_continuous(labels = scales::dollar_format(suffix = "B"), limits = c(0, y_axis_top), expand = c(0, 0))
    
    ggplotly(p, tooltip = FALSE) %>% layout(title = list(text = ""))
  })
  
  # celebration rate forecast
  output$plot_celebrate_forecast <- renderPlotly({
    last_historical <- data$celebrating_pct_fc %>%
      filter(type == "Historical") %>%
      filter(year == max(year))
    
    celebrating_fc_connected <- data$celebrating_pct_fc %>%
      bind_rows(last_historical %>% mutate(type = "Forecast"))
    
    y_data_max <- max(data$celebrating_pct_fc$pct * 100, na.rm = TRUE)
    y_data_min <- min(data$celebrating_pct_fc$pct * 100, na.rm = TRUE)
    y_axis_top <- y_data_max * 1.15
    offset_distance <- (y_data_max - y_data_min) * 0.20
    
    label_data <- celebrating_fc_connected %>%
      filter(year >= 2022 & year <= 2027) %>%
      group_by(year) %>%
      slice(1) %>%
      ungroup() %>%
      mutate(
        value_pct = pct * 100,
        is_above = year %% 2 == 0,
        label_y = ifelse(is_above, value_pct + offset_distance * 1.8, value_pct - offset_distance * 1.8),
        label_text = paste0(year, ": ", sprintf("%.1f", value_pct), "%"),
        vjust_value = ifelse(is_above, 0, 1)
      )
    
    p <- ggplot(celebrating_fc_connected, aes(x = year, y = pct * 100, color = type, linetype = type)) +
      annotate("rect", xmin = 2022, xmax = 2028, ymin = 0, ymax = y_axis_top,
               fill = "grey80", alpha = 0.4, inherit.aes = FALSE) +
      
      geom_vline(xintercept = 2022, linetype = "dotted", color = "gray60", size = 0.5) +
      geom_line(size = 0.5) +
      geom_point(size = 1.5) +
      
      geom_segment(data = label_data, aes(x = year, y = value_pct, xend = year, yend = label_y),
                   color = colors$primary, size = 0.5, inherit.aes = FALSE) +
      
      geom_text(data = label_data, aes(x = year, y = label_y, label = label_text, vjust = vjust_value),
                size = 3, fontface = "bold", color = colors$gray_dark, inherit.aes = FALSE) +
      
      scale_color_manual(values = year_colors, name = NULL) +
      scale_linetype_manual(values = c("Historical" = "solid", "Forecast" = "dashed")) +
      
      labs(x = "Year", y = "% Celebrating") +
      theme_minimal() +
      theme(
        panel.grid.major.x = element_line(color = plot_theme$panel_grid_color, size = plot_theme$panel_grid_size),
        panel.grid.major.y = element_blank(),
        panel.grid.minor = element_blank(),
        axis.line = element_line(color = plot_theme$axis_line_color, size = plot_theme$axis_line_size),
        axis.text = element_text(size = plot_theme$axis_text_size),
        legend.position = "bottom"
      ) +
      scale_y_continuous(limits = c(0, y_axis_top), expand = c(0, 0))
    
    ggplotly(p, tooltip = FALSE) %>% layout(title = list(text = ""))
  })
  
  # per-person spend forecast
  output$plot_spend_forecast <- renderPlotly({
    last_historical <- data$per_person_spend_fc %>%
      filter(type == "Historical") %>%
      filter(year == max(year))
    
    per_person_fc_connected <- data$per_person_spend_fc %>%
      bind_rows(last_historical %>% mutate(type = "Forecast"))
    
    y_data_max <- max(data$per_person_spend_fc$amount, na.rm = TRUE)
    y_data_min <- min(data$per_person_spend_fc$amount, na.rm = TRUE)
    y_axis_top <- y_data_max * 1.15
    offset_distance <- (y_data_max - y_data_min) * 0.20
    
    label_data <- per_person_fc_connected %>%
      filter(year >= 2022 & year <= 2027) %>%
      group_by(year) %>%
      slice(1) %>%
      ungroup() %>%
      mutate(
        is_above = year %% 2 == 0,
        label_y = ifelse(is_above, amount + offset_distance * 1.5, amount - offset_distance * 1.5),
        label_text = paste0(year, ": $", sprintf("%.0f", amount)),
        vjust_value = ifelse(is_above, 0, 1)
      )
    
    p <- ggplot(per_person_fc_connected, aes(x = year, y = amount, color = type, linetype = type)) +
      annotate("rect", xmin = 2022, xmax = 2028, ymin = 0, ymax = y_axis_top,
               fill = "grey80", alpha = 0.4, inherit.aes = FALSE) +
      
      geom_vline(xintercept = 2022, linetype = "dotted", color = "gray60", size = 0.5) +
      geom_line(size = 0.5) +
      geom_point(size = 1.5) +
      
      geom_segment(data = label_data, aes(x = year, y = amount, xend = year, yend = label_y),
                   color = colors$primary, size = 0.5, inherit.aes = FALSE) +
      
      geom_text(data = label_data, aes(x = year, y = label_y, label = label_text, vjust = vjust_value),
                size = 3, fontface = "bold", color = colors$gray_dark, inherit.aes = FALSE) +
      
      scale_color_manual(values = year_colors, name = NULL) +
      scale_linetype_manual(values = c("Historical" = "solid", "Forecast" = "dashed")) +
      
      labs(x = "Year", y = "Avg. Spend per Person ($)") +
      theme_minimal() +
      theme(
        panel.grid.major.x = element_line(color = plot_theme$panel_grid_color, size = plot_theme$panel_grid_size),
        panel.grid.major.y = element_blank(),
        panel.grid.minor = element_blank(),
        axis.line = element_line(color = plot_theme$axis_line_color, size = plot_theme$axis_line_size),
        axis.text = element_text(size = plot_theme$axis_text_size),
        legend.position = "bottom"
      ) +
      scale_y_continuous(limits = c(0, y_axis_top), expand = c(0, 0), labels = scales::dollar_format())
    
    ggplotly(p, tooltip = FALSE) %>% layout(title = list(text = ""))
  })
  
  # category forecast with fixed legend box
  output$plot_category_forecast <- renderPlotly({
    # create seamless connection
    last_historical <- data$gift_category_fc %>%
      filter(type == "Historical") %>%
      group_by(category) %>%
      filter(year == max(year)) %>%
      ungroup()
    
    gift_fc_connected <- data$gift_category_fc %>%
      bind_rows(last_historical %>% mutate(type = "Forecast"))
    
    forecast_start <- min(data$gift_category_fc$year[data$gift_category_fc$type == "Forecast"])
    forecast_end <- max(data$gift_category_fc$year[data$gift_category_fc$type == "Forecast"])
    
    legend_data <- data$gift_category_fc %>%
      filter(type == "Forecast") %>%
      arrange(category, year)
    
    # create base plot
    p <- ggplot(gift_fc_connected, aes(x = year, y = pct * 100, color = category, linetype = type)) +
      # shaded forecast area
      annotate("rect", xmin = forecast_start, xmax = forecast_end, ymin = 0, ymax = 25,
               fill = "grey80", alpha = 0.35, inherit.aes = FALSE) +
      
      # forecast boundary line
      geom_vline(xintercept = forecast_start, linetype = "dotted", color = "gray60", size = 0.5) +
      
      geom_line(size = 0.5) +
      geom_point(size = 1) +
      
      scale_color_manual(values = category_colors, name = "Category") +
      scale_linetype_manual(values = c("Historical" = "solid", "Forecast" = "dashed"), name = NULL) +
      
      labs(x = "Year", y = "% Planning to Buy") +
      theme_minimal() +
      theme(
        panel.grid.major.x = element_line(color = plot_theme$panel_grid_color, size = plot_theme$panel_grid_size),
        panel.grid.major.y = element_blank(),
        panel.grid.minor = element_blank(),
        axis.line = element_line(color = plot_theme$axis_line_color, size = plot_theme$axis_line_size),
        axis.text = element_text(size = plot_theme$axis_text_size),
        legend.position = "bottom"
      ) +
      scale_y_continuous(limits = c(0, 25), expand = c(0, 0), breaks = seq(0, 25, 5))
    
    # convert to plotly
    plotly_obj <- ggplotly(p, tooltip = c("x", "y", "color")) %>%
      layout(title = list(text = ""))
    
    if (nrow(legend_data) > 0) {
      legend_text <- legend_data %>%
        mutate(line = sprintf("%s | %d | %.1f%%", category, year, pct * 100)) %>%
        pull(line) %>%
        paste(collapse = "<br>")
      
      legend_full <- paste0(
        "<b>Category | Year | %</b><br>",
        "─────────────────<br>",
        legend_text
      )
      
      plotly_obj <- plotly_obj %>%
        layout(
          annotations = list(
            list(
              x = 0.02,
              y = 0.98,
              xref = "paper",
              yref = "paper",
              text = legend_full,
              showarrow = FALSE,
              xanchor = "left",
              yanchor = "top",
              align = "left",
              font = list(size = 10, family = "monospace"),
              bgcolor = "rgba(255, 255, 255, 0.9)",
              bordercolor = "black",
              borderwidth = 1,
              borderpad = 8
            )
          )
        )
    }
    
    plotly_obj
  })
}