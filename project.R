library(tidycensus)
library(tidyverse)
library(dplyr)

census_api_key("51bd9818d5b6caed096e8569639cc6e4188baa62", install = TRUE)


View(tidycensus::load_variables(2017, "acs5", cache = TRUE))


acs_query <- tidycensus::get_acs(geography = 'county',
                                 variables = c(male_private_health = "B27002_010")
)
                                 
                                 