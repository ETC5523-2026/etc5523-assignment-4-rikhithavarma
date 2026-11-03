
#' Summarise Population Growth
#'
#' Calculate population changes between two selected years
#' for Australian states and territories.
#'
#' @param data A data frame containing year, state and population.
#' @param start_year The starting year for comparison.
#' @param end_year The ending year for comparison.
#'
#' @return A data frame containing the starting population,
#' ending population, absolute change and percentage growth.
#'
#' @export
summarise_population <- function(data, start_year, end_year) {

  # Check that the years are in the correct order
  if (start_year >= end_year) {
    stop("The starting year must be earlier than the ending year.")
  }

  # Check that both years exist
  if (!start_year %in% data$year ||
      !end_year %in% data$year) {
    stop("Both selected years must be available in the dataset.")
  }

  # Select population observations for each year
  start_data <- data[data$year == start_year, c("state", "population")]
  end_data <- data[data$year == end_year, c("state", "population")]

  # Match states between the two years
  result <- merge(
    start_data,
    end_data,
    by = "state",
    suffixes = c("_start", "_end")
  )

  # Calculate population growth
  result$population_change <-
    result$population_end - result$population_start

  result$growth_percent <- round(
    100 * result$population_change / result$population_start,
    2
  )

  # Use clear column names
  names(result)[names(result) == "population_start"] <-
    "start_population"

  names(result)[names(result) == "population_end"] <-
    "end_population"

  return(result)
}
