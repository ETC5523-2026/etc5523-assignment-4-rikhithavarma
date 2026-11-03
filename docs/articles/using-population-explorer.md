# Using PopulationExplorer

## Introduction

PopulationExplorer is an R package that helps students and members of
the public explore changes in Australian state and territory
populations.

The main question is:

**How have Australian state and territory populations changed between
2010 and 2025?**

The package includes annual June estimated resident population data from
the Australian Bureau of Statistics (ABS), a population growth summary
function, and an interactive Shiny application.

## Installation

Install the package from GitHub using:

``` r
install.packages("remotes")

remotes::install_github(
  "ETC5523-2026/etc5523-assignment-4-rikhithavarma"
)
```

After installation, load the package:

``` r
library(PopulationExplorer)
```

## Exploring the data

The package contains a dataset called `population_tidy`.

It includes annual estimated resident population observations for
Australia’s eight states and territories from 2010 to 2025.

The variables are:

- `year`: Calendar year.
- `state`: Australian state or territory abbreviation.
- `population`: Estimated resident population, measured in persons.

View the first six observations:

``` r
data("population_tidy", package = "PopulationExplorer")

head(population_tidy)
```

    ## # A tibble: 6 × 3
    ##    year state population
    ##   <int> <chr>      <dbl>
    ## 1  2010 ACT       361766
    ## 2  2011 ACT       367985
    ## 3  2012 ACT       376539
    ## 4  2013 ACT       383257
    ## 5  2014 ACT       388799
    ## 6  2015 ACT       395813

## Calculating population growth

The exported function
[`summarise_population()`](../reference/summarise_population.md)
compares population estimates between two selected years.

For example, the following code compares 2015 and 2022:

``` r
growth <- summarise_population(
  population_tidy,
  start_year = 2015,
  end_year = 2022
)

growth
```

    ##   state start_population end_population population_change growth_percent
    ## 1   ACT           395813         461262             65449          16.54
    ## 2   NSW          7616168        8182098            565930           7.43
    ## 3    NT           244692         253100              8408           3.44
    ## 4   QLD          4777692        5310905            533213          11.16
    ## 5    SA          1700668        1824969            124301           7.31
    ## 6   TAS           515117         572300             57183          11.10
    ## 7   VIC          6022322        6615232            592910           9.85
    ## 8    WA          2540672        2793934            253262           9.97

The output contains the starting population, ending population, absolute
population change and percentage growth.

For New South Wales, the population increased from 7,616,168 in 2015 to
8,182,098 in 2022.

This represents an increase of 565,930 people, or 7.43% over the
selected period.

Percentage growth is calculated relative to the starting population. It
does not represent an annual growth rate.

## Launching the Shiny application

Launch the app using:

``` r
run_population_app()
```

The application opens in the RStudio Viewer or a web browser.

## Using the interactive controls

The app contains two main controls:

1.  **State or territory dropdown:** Select the state or territory to
    investigate.
2.  **Year-range slider:** Select the starting and ending years.

The population trend chart, growth summary and annual data table
automatically update when the selections change.

For example, select NSW and set the year range to 2015–2022.

The line chart shows how NSW’s population changed during this period.
The growth summary displays the corresponding absolute and percentage
changes.

## Interpreting the outputs

The line chart displays estimated resident population over time.

The growth summary compares population at the beginning and end of the
selected period.

For NSW between 2015 and 2022, the population increased by 565,930
people (7.43%).

The annual population table allows users to examine individual yearly
estimates.

If the same starting and ending year are selected, the application
displays an informative message because a population growth comparison
requires two different years.

## Limitations

The ABS figures are estimated resident populations rather than exact
population counts.

The data do not establish the causes of population changes, such as
migration, births or deaths.

The analysis covers June 2010 to June 2025, so it does not describe
later population changes.

Population growth percentages depend on the selected starting and ending
years.

## Data source

Australian Bureau of Statistics (ABS), *National, state and territory
population*, Table 4: Estimated Resident Population, States and
Territories.

<https://www.abs.gov.au/statistics/people/population/national-state-and-territory-population>

ABS material is reused with attribution under Creative Commons
Attribution 4.0 International, subject to applicable ABS exclusions.
