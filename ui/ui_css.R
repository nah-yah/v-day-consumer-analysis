# css style
dashboard_css <- function() {
  tags$style(
  HTML(
    "
      /* main layout structure */
      body {
        margin: 0;
        padding: 0;
        font-family: ui-serif, georgia, cambria, times new roman, times, serif;
      }

      /* header styling */
      .dashboard-header {
        background: linear-gradient(135deg, #E31937 0%, #C41230 100%);
        color: white;
        padding: 15px 30px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.15);
        position: fixed;
        top: 0;
        left: 200px;
        right: 0;
        z-index: 999;
        height: 70px;
        transition: left 0.3s ease;
      }

      .dashboard-header.sidebar-collapsed {
        left: 60px;
      }

      .header-title {
        margin: 0;
        font-size: 26px;
        font-weight: 600;
        letter-spacing: -0.5px;
      }

      .header-subtitle {
        margin: 3px 0 0 0;
        font-size: 13px;
        opacity: 0.95;
        font-weight: 400;
      }

      /* sidebar styling */
      .dashboard-sidebar {
        position: fixed;
        left: 0;
        top: 0;
        bottom: 0;
        width: 220px;
        background-color: #2c3e50;
        color: white;
        padding: 20px 0;
        box-shadow: 2px 0 8px rgba(0,0,0,0.1);
        overflow-y: auto;
        overflow-x: hidden;
        z-index: 1000;
        transition: width 0.3s ease;
      }

      .dashboard-sidebar.collapsed {
        width: 60px;
      }

      .sidebar-toggle {
        position: absolute;
        top: 20px;
        right: 15px;
        background: rgba(255,255,255,0.1);
        border: none;
        color: white;
        padding: 8px 12px;
        border-radius: 6px;
        cursor: pointer;
        font-size: 18px;
        transition: all 0.2s;
        z-index: 1001;
      }

      .sidebar-toggle:hover {
        background: rgba(255,255,255,0.2);
      }

      .sidebar-content {
        margin-top: 50px;
      }

      .sidebar-section {
        padding: 0 12px;
        margin-bottom: 20px;
        transition: opacity 0.3s;
      }

      .collapsed .sidebar-section {
        opacity: 0;
        pointer-events: none;
      }

      .sidebar-section-title {
        font-size: 10px;
        text-transform: uppercase;
        letter-spacing: 1px;
        color: #95a5a6;
        margin-bottom: 10px;
        font-weight: 600;
        white-space: nowrap;
      }

      .sidebar-nav {
        list-style: none;
        padding: 0;
        margin: 0;
      }

      .sidebar-nav li {
        margin-bottom: 4px;
      }

      .sidebar-nav a {
        display: block;
        padding: 10px 12px;
        color: #ecf0f1;
        text-decoration: none;
        border-radius: 6px;
        transition: all 0.2s;
        font-size: 13px;
        white-space: nowrap;
        cursor: pointer;
      }

      .sidebar-nav a:hover {
        background-color: rgba(255,255,255,0.1);
        padding-left: 16px;
      }

      /* replace your current .sidebar-nav a.active rule with this */
      .dashboard-sidebar .sidebar-nav a.active,
      .dashboard-sidebar .sidebar-nav a.nav-link.active {
        background-color: #e31937 !important;
        font-weight: 600 !important;
        color: white !important;
      }

      /* make select inputs in sidebar smaller */
      .sidebar-section select {
        font-size: 12px;
        padding: 6px;
      }

      .sidebar-section label {
        font-size: 12px;
        margin-bottom: 3px;
      }

      /* main content area */
      .dashboard-content {
        margin-left: 200px;
        margin-top: 70px;
        padding: 20px 20px;
        background-color: #fff5f7;
        min-height: calc(100vh - 70px);
        transition: margin-left 0.3s ease;
        max-width: 100%;
      }

      .dashboard-content.sidebar-collapsed {
        margin-left: 60px;
      }

      .content-panel {
        background-color: white;
        border-radius: 12px;
        padding: 20px 20px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        margin-bottom: 25px;
        max-width: 1200px;
        max-width: 100%;
        margin-left: auto;
        margin-right: auto;
      }

      .content-panel h3 {
        margin-bottom: 25px;
      }

      .content-panel h4 {
        margin-top: 30px;
        margin-bottom: 20px;
      }

      .content-panel hr {
        margin: 35px 0;
        border: none;
        border-top: 1px solid #e0e0e0;
      }

      .content-panel .row {
        margin-bottom: 25px;
        margin-left: -5px;
        margin-right: -5px;
      }

      .content-panel .row > div {
        padding-left: 5px;
        padding-right: 5px;
      }

      /* chart titles and subtitles */
      .chart-container {
        margin-bottom: 20px;
        border: 1px solid #dee2e6;
        border-radius: 8px;
        overflow: hidden;
        background-color: white;
      }

      /* chart header */
      .chart-header {
        background-color: #f8f9fa;
        padding: 12px 15px;
        border-bottom: 1px dotted #dee2e6;
      }

      .chart-title {
        font-size: 16px;
        font-weight: 600;
        color: #2c3e50;
        margin: 0 0 4px 0;
        text-align: left;
      }

      .chart-subtitle {
        font-size: 13px;
        color: #6c757d;
        margin: 0;
        text-align: left;
      }

      /* chart divider */
      .chart-divider {
        display: none;
      }

      /* chart body */
      .chart-body {
        padding: 10px 10px 10px 10px; /* Add padding around the plot */
        background-color: white;
      }

      /* ensure plotly charts fill their containers */
      .plotly, .js-plotly-plot {
        width: 100% !important;
        height: 450px !important;
        margin: 0 !important;
        padding: 0 !important;
      }

      /* remove spacing from plotly containers */
      .js-plotly-plot {
        margin: 0 !important;
        padding: 0 !important;
      }

      /* remove spacing from chart body and its children */
      .chart-body > div {
        margin: 0 !important;
        padding: 0 !important;
      }

      .chart-body .shiny-plot-output {
        margin: 0 !important;
        padding: 0 !important;
      }

      /* hide plotly chart titles since we have our own */
      .gtitle {
        display: none !important;
      }

      .plotly .gtitle {
        display: none !important;
      }

      /* filter section */
      .filters-container {
        background-color: #f8f9fa;
        border-radius: 8px;
        padding: 20px;
        margin-bottom: 25px;
      }

      .filter-title {
        font-size: 14px;
        font-weight: 600;
        color: #495057;
        margin-bottom: 15px;
      }

      /* responsive adjustments */
      @media (max-width: 768px) {
        .dashboard-sidebar {
          width: 250px;
        }
        .dashboard-content {
          margin-left: 250px;
        }
      }

      /* tab styling override */
      .nav-tabs {
        display: none !important;
      }

      .tab-content {
        display: block !important;
      }

      /* cards */
      .metric-card {
        background-color: #f8f9fa;
        padding: 0 !important;
        border-radius: 8px;
        margin: 0 !important;
        box-sizing: border-box;
      }

      .metric-card h4 {
        font-size: 16px;
        margin: 0;
        padding: 10px 15px 5px 15px;
        color: #2c3e50;
      }

      .metric-card p {
        margin: 0;
        padding: 0 15px 10px 15px;
        font-size: 14px;
        color: #6c757d;
      }

      .section-group {
        background-color: #ffffff;
        border: 1px solid #e0e0e0;
        border-radius: 12px;
        padding: 0 20px 0 20px; /* top | right | bottom | left */
        margin-bottom: 30px;
        position: relative;
      }

      .section-group-title {
        font-size: 18px;
        font-weight: 600;
        color: #2c3e50;
        margin: 0;
        /* control distance from top edge */
        padding-top: 0;
        /* space to subtitle */
        padding-bottom: 0;
      }

      .section-group-subtitle {
        font-size: 14px;
        color: #6c757d;
        /* remove default margin */
        margin: 0;
        /* only bottom padding for divider gap */
        padding: 0;
      }

      .section-group-divider {
        height: 1px;
        border-bottom: 1px dotted #d0d0d0;
        margin: 0 -20px 20px -20px;
      }

      .demographics-section {
      /* Default: all visible */
        display: block;
        margin-bottom: 25px;
      }

      /* Sub-tab button styling */
      .subtab-btn {
        padding: 8px 16px;
        border: none;
        border-radius: 6px;
        background-color: #f0f0f0;
        color: #2c3e50;
        font-size: 13px;
        cursor: pointer;
        margin-right: 8px;
        outline: none;
      }
      .subtab-btn:hover {
        background-color: #e0e0e0;
      }
      .subtab-btn.active {
        background-color: #E31937 !important;
        color: white !important;
        font-weight: 600;
      }
      "
    )
  )
}