
#' Launch the Australian Population Growth Explorer
#'
#' Opens the interactive Shiny application for exploring
#' Australian state and territory population trends.
#'
#' @return Launches a Shiny application.
#'
#' @examples
#' \dontrun{
#' run_population_app()
#' }
#'
#' @export
run_population_app <- function() {

  # Check that the packages used by the app are available
  if (!requireNamespace("ggplot2", quietly = TRUE) ||
      !requireNamespace("scales", quietly = TRUE)) {
    stop("The Shiny app requires ggplot2 and scales.")
  }



  app_dir <- system.file(
    "shiny",
    package = "PopulationExplorer"
  )

  if (app_dir == "") {
    stop("Shiny application files could not be found.")
  }

  shiny::runApp(app_dir)
}
