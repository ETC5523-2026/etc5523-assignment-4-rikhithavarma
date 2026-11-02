
# ETC5523 Assignment 4
# Australian Population Growth Explorer
# Data source: Australian Bureau of Statistics
# Table 4: Estimated Resident Population, States and Territories


library(readxl)
library(dplyr)
library(tidyr)

# Read the ABS population data
raw_population <- read_excel(
  "data-raw/310104.xlsx",
  sheet = "Data1",
  col_names = FALSE,
  skip = 10,
  col_types = "numeric"
)

# Check the imported data
dim(raw_population)
head(raw_population)


# Convert Excel dates and select state population data
population_selected <- raw_population %>%
  transmute(
    date = as.Date(...1, origin = "1899-12-30"),
    NSW = ...20,
    VIC = ...21,
    QLD = ...22,
    SA = ...23,
    WA = ...24,
    TAS = ...25,
    NT = ...26,
    ACT = ...27
  )

# Check the result
head(population_selected)


# Keep June population estimates from 2010 to 2025
population_annual <- population_selected %>%
  mutate(
    year = as.integer(format(date, "%Y")),
    month = as.integer(format(date, "%m"))
  ) %>%
  filter(
    year >= 2010,
    year <= 2025,
    month == 6
  ) %>%
  select(-month)

# Check the annual dataset
head(population_annual)
dim(population_annual)


# Convert state columns into tidy (long) format
population_tidy <- population_annual %>%
  select(year, NSW:ACT) %>%
  pivot_longer(
    cols = NSW:ACT,
    names_to = "state",
    values_to = "population"
  ) %>%
  arrange(state, year)

# Check the tidy dataset
head(population_tidy)
dim(population_tidy)


# Saving the prepared dataset inside the R package
usethis::use_data(
  population_tidy,
  overwrite = TRUE
)







