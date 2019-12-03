library(tidycensus)
library(tidyverse)

key <- Sys.getenv('CENSUS_API_KEY')
census_api_key(key)

v17 <- load_variables(2017, "acs5", cache = TRUE)


# query acs for 2017 data
acs_data <- tidycensus::get_acs(geography = 'county',
                                variables = c(total_pop = "B06012_001",
                                              total_female = "B01001_026",
                                              total_male = "B01001_002",
                                              below_100_percent_poverty = "B06012_002",
                                              high_school_grads = "B06009_003",
                                              has_bachelors = "B06009_005",
                                              uninsured_26_34_male = "B27001_014",
                                              uninsured_26_34_female = "B27001_042",
                                              median_income = 'B06011_001')
)

# opioid prescription data
prescriptions <- read.csv('./opioid_prescribing_rate.csv')

# overdose data
overdoses <- read.csv('./overdoses.csv')
