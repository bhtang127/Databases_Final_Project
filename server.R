library(shiny)
library(RMySQL)

shinyServer(function(input, output, session) {
  current_player = reactive({
    req(input$player_name)
    find_player_by_name(input$player_name)
  })

  court_plot = reactive({
    req(input$player_name)
    plot_court(default_theme)
  })
  
  shots = reactive({
    req(current_player())
    
    
    fetch_shots_by_name(
      current_player()$name
    )
  })

  filtered_shots = reactive({
    req(shots()$player)

    filter(shots()$player,
      shot_zone_range != "Back Court Shot",
      is.na(input$date_range[1]) | game_date >= input$date_range[1],
      is.na(input$date_range[2]) | game_date <= input$date_range[2]
    )
  })

  hexbin_data = reactive({
    req(filtered_shots(), shots(), hexbinwidths(), input$hex_radius)

    calculate_hexbins_from_shots(filtered_shots(), shots()$league_averages,
                                 binwidths = hexbinwidths(),
                                 min_radius_factor = input$hex_radius)
  })

  output$hexbinwidth_slider = renderUI({
    req(shots()$player)

    sliderInput("hexbinwidth",
                "Hexagon Size (feet)",
                min = 0.5,
                max = 4,
                value = 1.5,
                step = 0.25)
  })

  hexbinwidths = reactive({
    req(input$hexbinwidth)
    rep(input$hexbinwidth, 2)
  })

  output$hex_radius_slider = renderUI({
    req(shots()$player)

    sliderInput("hex_radius",
                "Min Hexagon Size Adjustment",
                min = 0,
                max = 1,
                value = 0.4,
                step = 0.05)
  })

  alpha_range = reactive({
    req(shots()$player, input$hex_radius)
    max_alpha = 0.98
    min_alpha = max_alpha - 0.25 * input$hex_radius
    c(min_alpha, max_alpha)
  })

  output$hex_metric_buttons = renderUI({
    req(shots()$player)

    selectInput("hex_metric",
                "Hexagon Colors",
                choices = c("FG% vs. League Avg" = "bounded_fg_diff",
                            "FG%" = "bounded_fg_pct",
                            "Points Per Shot" = "bounded_points_per_shot"),
                selected = "bounded_fg_diff",
                selectize = FALSE)
  })

  shot_chart = reactive({
    req(
      filtered_shots(),
      current_player(),
      court_plot()
    )

    filters_applied()

    req(input$hex_metric, alpha_range())

    generate_hex_chart(
      hex_data = hexbin_data(),
      base_court = court_plot(),
      court_theme = default_theme,
      metric = sym(input$hex_metric),
      alpha_range = alpha_range()
    )
  })

  output$shot_chart_css = renderUI({
    tags$style(paste0(
      ".shot-chart-container {",
        "background-color: ", default_theme$court, "; ",
        "color: ", default_theme$text,
      "}"
    ))
  })

  output$chart_header_player = renderText({
    req(current_player())
    current_player()$name
  })

  output$chart_header_info = renderText({
    req(shots())
    paste(default_season, "Season")
  })

  output$chart_header_team = renderText({
    req(shots()$player)
    paste(current_player()$team_city, current_player()$team_name)
  })

  output$player_photo = renderUI({
    if (input$player_name == "") {
      tags$img(src = "https://i.imgur.com/hXWPTOF.png", alt = "photo")
    } else if (req(current_player()$person_id)) {
      tags$img(src = photo_by_id(current_player()$person_id), alt = "photo")
    }
  })

  output$court = renderPlot({
    req(shot_chart())
    withProgress({
      shot_chart()
    }, message = "Calculating...")
  }, height = 450, width = 600, bg = "transparent")

  filters_applied = reactive({
    req(filtered_shots())
    filters = list()

    if (!is.na(input$date_range[1]) | !is.na(input$date_range[2])) {
      dates = format(input$date_range, "%m/%d/%y")
      dates[is.na(dates)] = ""

      filters[["Dates"]] = paste("Dates:", paste(dates, collapse = "–"))
    }

    filters
  })

  output$shot_filters_applied = renderUI({
    req(length(filters_applied()) > 0)

    div(class = "shot-filters",
      tags$h5("Shot Filters Applied"),
      lapply(filters_applied(), function(text) {
        div(text)
      })
    )
  })

  output$summary_stats_header = renderText({
    req(current_player())
    paste(current_player()$name, default_season, "Summary Stats")
  })

  output$summary_stats = renderTable({
    req(filtered_shots(), shots())
    effi = stats_by_name(current_player()$name, input$date_range[1], input$date_range[2])
    effi$rankPTS = as.integer(effi$rankPTS)
    effi$rankAST = as.integer(effi$rankAST)
    effi$rankTRB = as.integer(effi$rankTRB)
    effi$rankSTL = as.integer(effi$rankSTL)
    effi$PTS = as.integer(effi$PTS)
    effi$AST = as.integer(effi$AST)
    effi$TRB = as.integer(effi$TRB)
    effi$STL = as.integer(effi$STL)
    effi
  })
})


