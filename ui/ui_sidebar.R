# sidebar ui
sidebar_ui <- function(data_list) {
  div(
    class = "dashboard-sidebar",
    id = "sidebar",
    
    # toggle button
    tags$button(
      class = "sidebar-toggle",
      id = "sidebarToggle",
      onclick = "toggleSidebar()",
      "☰"
    ),
    
    div(
      class = "sidebar-content",
      
      # navigation section
      div(
        class = "sidebar-section",
        div(class = "sidebar-section-title", "Navigation"),
        tags$ul(
          class = "sidebar-nav",
          tags$li(
            tags$a(
              href = "#",
              onclick = "showTab('home'); return false;",
              class = "nav-link",
              id = "nav-home",
              "Home"
            )
          ),
          tags$li(
            tags$a(
              href = "#",
              onclick = "showTab('picture'); return false;",
              class = "nav-link",
              id = "nav-picture",
              "The big picture"
            )
          ),
          tags$li(
            tags$a(
              href = "#",
              onclick = "showTab('category'); return false;",
              class = "nav-link",
              id = "nav-category",
              "Where money goes"
            )
          ),
          tags$li(
            tags$a(
              href = "#",
              onclick = "showTab('demographics'); return false;",
              class = "nav-link",
              id = "nav-demographics",
              "Who's driving trends"
            )
          ),
          tags$li(
            tags$a(
              href = "#",
              onclick = "showTab('explore'); return false;",
              class = "nav-link",
              id = "nav-explore",
              "What's next"
            )
          )
        )
      ),
      
      # filters section
      div(
        class = "sidebar-section",
        div(class = "sidebar-section-title", "Filters"),
        
        selectInput(
          "category",
          "Category",
          choices = c("All", unique(data_list$gift_total_long$category)),
          selected = "All",
          width = "100%"
        ),
        
        selectInput(
          "tier_filter",
          "Category tier",
          choices = c("All", tier_levels),
          selected = "All",
          width = "100%"
        ),
        
        selectInput(
          "year_select",
          "Year",
          choices = c("All" = "All", setNames(
            sort(data_list$spending_total$year),
            sort(data_list$spending_total$year)
          )),
          selected = "All",
          width = "100%"
        ),
        
        selectInput(
          "age_group",
          "Age group",
          choices = c("All", age_groups),
          selected = "All",
          width = "100%"
        ),
        
        selectInput(
          "gender",
          "Gender",
          choices = c("All", "Men", "Women"),
          selected = "All",
          width = "100%"
        )
      )
    )
  )
}