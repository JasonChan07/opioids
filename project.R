library(tidycensus)
library(tidyverse)
library(dplyr)
library(janitor)

key <- Sys.getenv('CENSUS_API_KEY')
census_api_key(key)

View(tidycensus::load_variables(2017, "acs5", cache = TRUE))

# query acs for 2017 data
acs_data <- tidycensus::get_acs(geography = 'county',
                                 variables = c(total_female = "B01001_026",
                                               total_male = "B01001_002",
                                               below_100_percent_poverty = "B06012_002",
                                               high_school_grads = "B06009_003",
                                               has_bachelors = "B06009_005",
                                               uninsured_19_25_male = "B27001_011")
)

# convert acs data to wide format
acs_wide <- acs_data %>% 
                clean_names() %>%
                select(-moe) %>%
                pivot_wider(names_from = variable,
                            values_from = estimate)

# generate features

                                 