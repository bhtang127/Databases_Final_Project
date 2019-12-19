library(shiny)
library(ggplot2)
library(hexbin)
library(dplyr)
library(httr)
library(jsonlite)

source("helpers.R")
source("plot_court.R")
source("player_photo.R")
source("fetch_shots.R")
source("hex_chart.R")

shinyUI(
  fixedPage(
    theme = "flatly.css",
    title = "BallR: Interactive NBA Shot Charts with R and Shiny",

    tags$head(
      tags$link(rel = "apple-touch-icon", href = "basketball.png"),
      tags$link(rel = "icon", href = "basketball.png"),
      tags$link(rel = "stylesheet", type = "text/css", href = "shared/selectize/css/selectize.bootstrap3.css"),
      tags$link(rel = "stylesheet", type = "text/css", href = "https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.10.0/css/bootstrap-select.min.css"),
      tags$link(rel = "stylesheet", type = "text/css", href = "custom_styles.css"),
      tags$script(src = "https://cdnjs.cloudflare.com/ajax/libs/html2canvas/0.4.1/html2canvas.min.js"),
      tags$script(src = "https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.10.0/js/bootstrap-select.min.js"),
      tags$script(src = "shared/selectize/js/selectize.min.js"),
      tags$script(src = "ballr.js"),
      uiOutput("shot_chart_css"),
      includeScript("www/google-analytics.js")
    ),

    HTML('
      <nav class="navbar navbar-default navbar-static-top">
        <div class="container">
          <div>
            <ul class="nav navbar-nav col-xs-12">
              <li class="col-xs-8 col-md-9">
                <a><span class="hidden-xs">Interactive NBA Shot Charts</span></a>
              </li>
            </ul>
          </div>
        </div>
      </nav>
    '),

    fixedRow(class = "primary-content",
      div(class = "col-sm-4 col-md-3",
        div(class = "shot-chart-inputs",
          uiOutput("player_photo"),

          selectInput(inputId = "player_name",
                      label = "Player",
                      choices = c("Enter a player..." = "", players$name),
                      selected = default_player$name,
                      selectize = FALSE),

          dateRangeInput(inputId = "date_range",
                         label = "Date range",
                         start  = "2018-10-16",
                         end    = "2019-11-01",
                         min    = "2018-10-16",
                         max    = "2019-6-13",
                         format = "mm/dd/yy",
                         separator = " - "),

          uiOutput("hex_metric_buttons"),
          uiOutput("hexbinwidth_slider"),
          uiOutput("hex_radius_slider")
        )
      ),
      div(class = "col-sm-8 col-md-9",
          div(class = "shot-chart-container",
              div(class = "shot-chart-header",
                  h2(textOutput("chart_header_player")),
                  h4(textOutput("chart_header_info")),
                  h4(textOutput("chart_header_team"))
              ),
              
              plotOutput("court", width = 600, height = "auto"),
              
              uiOutput("shot_filters_applied")
          ),
          h3(textOutput("summary_stats_header")),
          tableOutput("summary_stats")
      )
    )
  )
)
