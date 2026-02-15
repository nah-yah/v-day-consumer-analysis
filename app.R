# valentine's day market dashboard
# main app file

# load libraries
library(shiny)
library(readxl)
library(readr)
library(dplyr)
library(tidyr)
library(tibble)
library(ggplot2)
library(plotly)
library(scales)
library(purrr)
library(shinycssloaders)

# source utilities
source("utils/constants.R")
source("utils/helper_functions.R")
source("utils/data_loading.R")

# source ui components
source("ui/ui_css.R")
source("ui/ui_sidebar.R")
source("ui/ui_home.R")        
source("ui/ui_bigpicture.R")  
source("ui/ui_category.R")    
source("ui/ui_demographics.R") 
source("ui/ui_forecast.R")    

# source server components
source("server/server_reactive.R")  
source("server/server_cards.R")     
source("server/server_plots_main.R") 
source("server/server_plots_category.R") 
source("server/server_plots_demo.R") 
source("server/server_plots_forecast.R") 
source("server/server_downloads.R") 

# load & prepare data
message("Starting application...")

# load raw data
data <- load_valentines_data()

# calculate derived datasets
data <- calculate_derived_data(data)

# generate forecasts
data <- generate_forecasts(data)

message("All data loaded and preprocessed!")

# ui definition
ui <- fluidPage(
  # CSS
  tags$head(dashboard_css()),
  
  # sidebar
  sidebar_ui(data),
  
  # header
  div(
    class = "dashboard-header",
    id = "header",
    h1(class = "header-title", "The Valentine's Day Market"),
    p(
      class = "header-subtitle",
      "America's annual celebration of love translates to billions in spending"
    )
  ),
  
  # main content area
  div(
    class = "dashboard-content",
    id = "content",
    tabsetPanel(
      id = "main_tabs",
      type = "hidden",
      tabPanel("home", home_ui()),
      tabPanel("picture", bigpicture_ui()),
      tabPanel("category", category_ui()),
      tabPanel("demographics", demographics_ui()),
      tabPanel("explore", forecast_ui())
    )
  ),
  
  # JS
  tags$script(
    HTML(
      "
function toggleSidebar() {
  const sidebar = document.getElementById('sidebar');
  const content = document.getElementById('content');
  const header = document.getElementById('header');
  sidebar.classList.toggle('collapsed');
  content.classList.toggle('sidebar-collapsed');
  header.classList.toggle('sidebar-collapsed');
}

function showTab(tabName) {
  document.querySelectorAll('.sidebar-nav a').forEach(link => {
    link.classList.remove('active');
  });
  const navLink = document.getElementById('nav-' + tabName);
  if (navLink) {
    navLink.classList.add('active');
  }
  Shiny.setInputValue('switch_tab', tabName, {priority: 'event'});
}

function showSubTab(tabName) {
  document.querySelectorAll('.subtab-btn').forEach(btn => {
    btn.classList.remove('active');
  });
  const subBtn = document.getElementById('subtab-' + tabName);
  if (subBtn) {
    subBtn.classList.add('active');
  }
  
  const sectionMap = {
    'age': 'section-age',
    'gender': 'section-gender',
    'emerging': 'section-emerging'
  };
  
  if (tabName === 'all') {
    Object.values(sectionMap).forEach(id => {
      const el = document.getElementById(id);
      if (el) el.style.display = 'block';
    });
  } else {
    Object.values(sectionMap).forEach(id => {
      const el = document.getElementById(id);
      if (el) el.style.display = 'none';
    });
    const targetId = sectionMap[tabName];
    if (targetId) {
      const el = document.getElementById(targetId);
      if (el) el.style.display = 'block';
    }
  }
}
"
    )
  )
)

# server definition
server <- function(input, output, session) {
  
  # handle tab switching
  observeEvent(input$switch_tab, {
    updateTabsetPanel(session, "main_tabs", selected = input$switch_tab)
  })
  
  # create reactive values (from server_reactive.r)
  rv <- create_reactive_values(input, data)
  
  # generate metric cards (from server_cards.r)
  generate_metric_cards(output, input, rv, data)
  
  # generate main plots (from server_plots_main.r)
  generate_main_plots(output, rv, data)
  
  # generate category plots (from server_plots_category.r)
  generate_category_plots(output, input, rv, data)
  
  # generate demographic plots (from server_plots_demo.r)
  generate_demo_plots(output, input, rv, data)
  
  # generate forecast plots (from server_plots_forecast.r)
  generate_forecast_plots(output, data)
  
  # generate download handlers (from server_downloads.r)
  generate_downloads(output, data)
}

# run application
shinyApp(ui = ui, server = server)
