
# ETC5523 Assignment 4
# Australian Population Growth Explorer
# Shiny application


library(shiny)
library(PopulationExplorer)
library(dplyr)
library(ggplot2)

data("population_tidy", package = "PopulationExplorer")


# User interface
ui <- fluidPage(

  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
  ),

  titlePanel("Australian Population Growth Explorer"),

  h4("Who is this app for?"),
  p("Students and members of the public interested in Australian population trends."),

  h4("What question does this app investigate?"),
  p("How have populations changed across Australian states and territories between 2010 and 2025?"),


  hr(),

  h4("Explore population by state or territory"),

  selectInput(
    inputId = "selected_state",
    label = "Choose a state or territory:",
    choices = c(
      "ACT", "NSW", "NT", "QLD",
      "SA", "TAS", "VIC", "WA"
    ),
    selected = "VIC"
  ),


  sliderInput(
    inputId = "selected_years",
    label = "Select the years to explore:",
    min = 2010,
    max = 2025,
    value = c(2010, 2025),
    step = 1,
    sep = ""
  ),



  h4("How to use this explorer"),

  p("Choose a state or territory using the dropdown menu. Use the
year slider to select the period you want to investigate.
The chart, growth summary and data table update automatically."),

  h4("About the data"),

  p("The figures are estimated resident populations from the
Australian Bureau of Statistics, measured in persons at June
of each year from 2010 to 2025."),

  p("The line chart shows population levels over time.
Population change is the difference between the ending and
starting populations. Percentage growth expresses this
change relative to the starting population."),

  textOutput("trend_heading"),


  plotOutput("population_plot", height = "350px"),


  h4("Population growth summary"),

  p("Compare population at the beginning and end of your selected period."),

  tableOutput("growth_table"),

  h4("What do these results mean?"),

  textOutput("growth_interpretation"),


  h4("Annual population data"),

  tableOutput("population_table"),

  hr(),

  h4("Important limitations"),


  p("These figures are estimated resident populations, not
exact population counts. Changes in population do not
indicate what caused the change, such as migration,
births or deaths. Percentage growth depends on the
selected starting and ending years and should not
be interpreted as an annual growth rate.
The dataset covers June 2010 to June 2025,
so it does not describe later population changes."),


  p("Source: Australian Bureau of Statistics,
National, state and territory population,
Table 4: Estimated Resident Population.")

)

# Server

server <- function(input, output, session) {


  # Update the heading to match the selected years
  output$trend_heading <- renderText({

    paste(
      "Population trend:",
      input$selected_years[1],
      "to",
      input$selected_years[2]
    )

  })


  # Filter population data using the selected state

  filtered_population <- reactive({

    population_tidy %>%
      dplyr::filter(
        state == input$selected_state,
        year >= input$selected_years[1],
        year <= input$selected_years[2]
      )

  })


  # Calculate growth for the selected state and years
  growth_summary <- reactive({

    validate(
      need(
        input$selected_years[1] < input$selected_years[2],
        "Please select at least two different years to calculate population growth."
      )
    )

    summarise_population(
      data = filtered_population(),
      start_year = input$selected_years[1],
      end_year = input$selected_years[2]
    )

  })


  # Display the growth summary

  output$growth_table <- renderTable({

    growth <- growth_summary()

    growth %>%
      dplyr::mutate(
        start_population = format(
          start_population, big.mark = ",", scientific = FALSE
        ),
        end_population = format(
          end_population, big.mark = ",", scientific = FALSE
        ),
        population_change = format(
          population_change, big.mark = ",", scientific = FALSE
        ),
        growth_percent = paste0(growth_percent, "%")
      ) %>%
      dplyr::rename(
        State = state,
        `Starting population` = start_population,
        `Ending population` = end_population,
        `Population change` = population_change,
        `Growth (%)` = growth_percent
      )

  }, striped = TRUE, bordered = FALSE)



  # the population growth result
  output$growth_interpretation <- renderText({

    growth <- growth_summary()

    change <- growth$population_change[1]
    percent <- growth$growth_percent[1]

    direction <- if (change >= 0) "increased" else "decreased"

    paste0(
      "Between ", input$selected_years[1],
      " and ", input$selected_years[2],
      ", the population of ", input$selected_state,
      " ", direction, " by ",
      format(abs(change), big.mark = ",", scientific = FALSE),
      " people (",
      abs(percent),
      "%). This represents the total population change ",
      "over the selected period, not an annual growth rate."
    )

  })





  # Plot population trend for the selected state
  output$population_plot <- renderPlot({


    validate(
      need(
        input$selected_years[1] < input$selected_years[2],
        "Select at least two different years to display a population trend."
      )
    )

    ggplot(
      filtered_population(),
      aes(x = year, y = population)
    ) +
      geom_line(color = "#117C83", linewidth = 1.2) +
      geom_point(color = "#117C83", size = 2) +
      scale_y_continuous(
        labels = scales::label_comma()
      ) +
      labs(
        title = paste(
          "Population trend:",
          input$selected_state
        ),
        x = "Year",
        y = "Estimated resident population (persons)",
        caption = "Source: Australian Bureau of Statistics"
      ) +
      theme_minimal(base_size = 13)

  })


  # Display annual population data with readable numbers
  output$population_table <- renderTable({

    filtered_population() %>%
      dplyr::mutate(
        population = format(
          population, big.mark = ",", scientific = FALSE
        )
      ) %>%
      dplyr::rename(
        Year = year,
        State = state,
        Population = population
      )

  }, striped = TRUE, bordered = FALSE)


}


# Launch the app
shinyApp(ui = ui, server = server)
