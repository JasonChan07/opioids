library(tidycensus)
library(tidyverse)
library(dplyr)

census_api_key("51bd9818d5b6caed096e8569639cc6e4188baa62", install = TRUE)


View(tidycensus::load_variables(2017, "acs5", cache = TRUE))


acs_data <- tidycensus::get_acs(geography = 'county',
                                 variables = c(total_female = "B01001_026",
                                               total_male = "B01001_002",
                                               below_100_percent_poverty = "B06012_002",
                                               high_school_grads = "B06009_003",
                                               has_bachelors = "B06009_005",
                                               uninsured_19_25_male = "B27001_011")
)



                                 
                                 