# main tab plots (big picture)
# generate all main tab plots
#' @param output shiny output object
#' @param rv list of reactive values
#' @param data list of datasets
generate_main_plots <- function(output, rv, data) {
  
  # total spending over time
  output$plot_total_spend <- renderPlotly({
    df <- data$spending_total %>% mutate(year = as.numeric(year))
    avg_spend <- mean(df$value, na.rm = TRUE)
    
    p <- ggplot(df, aes(x = year, y = value)) +
      geom_line(color = "#E31937", size = 1.2) +
      geom_point(color = "#E31937", size = 1.5) +
      geom_hline(
        yintercept = avg_spend,
        color = "darkgreen",
        linetype = "dotted",
        size = 0.2
      ) +
      annotate(
        "text",
        x = max(df$year) - 0.5,
        y = avg_spend + 0.5,
        label = paste0("Avg: $", round(avg_spend, 1), "B"),
        color = "darkgreen",
        size = 3,
        fontface = "bold",
        hjust = 1
      ) +
      geom_vline(
        xintercept = 2020,
        linetype = "dotted",
        color = "gray50",
        size = 0.1
      ) +
      annotate(
        "text",
        x = 2014,
        y = max(df$value) * 0.96,
        label = "Pre-2020",
        color = "gray50",
        size = 3.5,
        fontface = "bold"
      ) +
      annotate(
        "text",
        x = 2021.5,
        y = max(df$value) * 0.96,
        label = "Post-2020",
        color = "gray50",
        size = 3.5,
        fontface = "bold"
      ) +
      labs(x = "Year", y = "Billions USD") +
      theme_minimal() +
      theme(
        plot.background = element_rect(fill = "white", color = NA),
        panel.background = element_rect(fill = "white", color = NA),
        panel.grid.major.x = element_line(color = "#f0f0f0", size = 0.5),
        panel.grid.major.y = element_blank(),
        panel.grid.minor = element_blank(),
        axis.line = element_line(color = "black", size = 0.3),
        axis.text = element_text(size = 9)
      ) +
      scale_y_continuous(labels = dollar_format(suffix = "B"))
    
    ggplotly(p, tooltip = c("x", "y")) %>%
      layout(showlegend = FALSE, title = list(text = ""))
  })
  
  # participation rate
  output$plot_participation <- renderPlotly({
    df <- rv$filtered_historical()$celebrating %>% mutate(year = as.numeric(year))
    
    p <- ggplot(df, aes(x = year, y = pct * 100)) +
      geom_line(color = "steelblue", size = 1.2) +
      geom_point(color = "steelblue") +
      geom_vline(
        xintercept = 2020,
        linetype = "dotted",
        color = "gray50",
        size = 0.1
      ) +
      annotate(
        "text",
        x = 2014,
        y = max(df$pct * 100) * 0.96,
        label = "Pre-2020",
        color = "gray50",
        size = 3.5,
        fontface = "bold"
      ) +
      annotate(
        "text",
        x = 2021.5,
        y = max(df$pct * 100) * 0.96,
        label = "Post-2020",
        color = "gray50",
        size = 3.5,
        fontface = "bold"
      ) +
      labs(x = "Year", y = "Population %") +
      theme_minimal() +
      theme(
        plot.background = element_rect(fill = "white", color = NA),
        panel.background = element_rect(fill = "white", color = NA),
        panel.grid.major.x = element_line(color = "#f0f0f0", size = 0.5),
        panel.grid.major.y = element_blank(),
        panel.grid.minor = element_blank(),
        axis.line = element_line(color = "black", size = 0.3),
        axis.text = element_text(size = 9)
      )
    
    ggplotly(p, tooltip = c("x", "y")) %>%
      layout(showlegend = FALSE, title = list(text = ""))
  })
  
  # average spend per person
  output$plot_intensity <- renderPlotly({
    combo <- data$per_person_spend %>%
      mutate(year = as.numeric(year)) %>%
      mutate(
        label = paste0("$", round(amount, 1)),
        rank = rank(-amount),
        color = ifelse(rank <= 3, "#E31937", "#A9A9A9")
      )
    
    plot_ly(
      data = combo,
      y = ~year,
      x = ~amount,
      type = "bar",
      orientation = "h",
      marker = list(color = ~color),
      text = ~label,
      textposition = "inside"
    ) %>%
      layout(
        xaxis = list(title = "Avg. spend per person ($)"),
        yaxis = list(
          title = "Year",
          tickmode = "linear",
          dtick = 1
        ),
        plot_bgcolor = "white",
        paper_bgcolor = "white",
        showlegend = FALSE,
        title = list(text = "")
      )
  })
  
  # category growth 2010 vs 2022
  output$plot_category_growth <- renderPlotly({
    df_2010 <- data$gift_total_long %>% 
      filter(year == "2010") %>% 
      select(category, value_2010 = total_billions)
    
    df_2022 <- data$gift_total_long %>% 
      filter(year == "2022") %>% 
      select(category, value_2022 = total_billions)
    
    df <- full_join(df_2010, df_2022, by = "category") %>%
      mutate(
        value_2010 = replace_na(value_2010, 0),
        value_2022 = replace_na(value_2022, 0),
        change = value_2022 - value_2010,
        tooltip = paste0(
          "Category: ", category, "<br>",
          "2010: $", round(value_2010, 1), "B<br>",
          "2022: $", round(value_2022, 1), "B<br>",
          "Change: $", round(change, 1), "B"
        )
      )
    
    df_ordered_desc <- df %>% arrange(desc(change)) %>% pull(category)
    df_ordered_for_plot <- rev(df_ordered_desc)
    
    df_long <- df %>%
      pivot_longer(
        cols = c(value_2010, value_2022),
        names_to = "year",
        values_to = "value"
      ) %>%
      mutate(
        year = ifelse(year == "value_2010", "2010", "2022"),
        value_plot = ifelse(year == "2010", -value, value),
        category = factor(category, levels = df_ordered_for_plot),
        tooltip = tooltip
      )
    
    if (nrow(df_long) == 0 || all(df_long$value == 0)) {
      return(
        ggplot() + 
          annotate("text", x = 0, y = 0, label = "No category data for 2010") + 
          theme_void()
      )
    }
    
    max_val <- max(abs(df_long$value_plot)) * 1.1
    
    p <- ggplot(df_long, aes(
      x = category,
      y = value_plot,
      fill = year,
      text = tooltip
    )) +
      geom_col(position = "identity", width = 0.7) +
      geom_text(
        aes(
          label = paste0("$", round(abs(value), 1), "B"),
          y = value_plot + ifelse(year == "2010", -0.1, 0.1)
        ),
        hjust = ifelse(df_long$year == "2010", 1, 0),
        size = 3.5
      ) +
      geom_vline(xintercept = 0, color = "gray80", linetype = "dashed") +
      annotate(
        "text", x = -Inf, y = -max_val * 0.95,
        label = "2010", color = "#A9A9A9", size = 5, fontface = "bold", hjust = 0
      ) +
      annotate(
        "text", x = -Inf, y = max_val * 0.95,
        label = "2022", color = "#E31937", size = 5, fontface = "bold", hjust = 0
      ) +
      labs(x = "Category", y = "Spending (Billions USD)", fill = "Year") +
      theme_minimal() +
      theme(
        legend.position = "right",
        plot.title = element_text(face = "bold", size = 14, hjust = 0.5, vjust = 1),
        axis.text.y = element_text(size = 10),
        axis.title.y = element_blank()
      ) +
      scale_fill_manual(values = c("2010" = "#A9A9A9", "2022" = "#E31937")) +
      scale_y_continuous(
        labels = dollar_format(suffix = "B", prefix = "$"),
        limits = c(-max_val, max_val),
        breaks = c(0)
      ) +
      coord_flip(clip = "off")
    
    ggplotly(p, tooltip = "text") %>%
      config(displayModeBar = FALSE)
  })
}