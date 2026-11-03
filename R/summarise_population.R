
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

  if (start_year >= end_year) {
    stop("The starting year must be earlier than the ending year.")
  }

  if (!start_year %in% data$year ||
      !end_year %in% data$year) {
    stop("Both selected years must be available in the dataset.")
  }

  data %>%
    dplyr::filter(year %in% c(start_year, end_year)) %>%
    dplyr::select(state, year, population) %>%
    tidyr::pivot_wider(
      names_from = year,
      values_from = population,
      names_prefix = "year_"
    ) %>%
    dplyr::mutate(
      start_population = .data[[paste0("year_", start_year)]],
      end_population = .data[[paste0("year_", end_year)]],
      population_change = end_population - start_population,
      growth_percent = round(
        100 * population_change / start_population, 2
      )
    ) %>%
    dplyr::select(
      state, start_population, end_population,
      population_change, growth_percent
    )
}
