library(tidyverse)
library(dplyr)
library(janitor)

clean_acs_data <- function(df) {

    
    # convert acs data to wide format
    acs_wide <- df %>% 
        clean_names() %>%
        select(-moe) %>%
        pivot_wider(names_from = variable,
                    values_from = estimate)
    
    # generate features from acs wide data
    acs_clean <- acs_wide %>%
        mutate(total_pop = total_male + total_female,
               percent_hs_grad = high_school_grads / total_pop,
               percent_college_grad = has_bachelors / total_pop,
               percent_below_100_poverty = below_100_percent_poverty / total_pop,
               percent_male_19_25_uninsured = uninsured_19_25_male / total_male,
    # replace first character of geoids that start with 0 with empty string
               geoid = as.integer(ifelse(substr(geoid, 1, 1) == 0, sub("^.", "", geoid), geoid))) %>%
    # multiplying percentages by 100
        mutate_at(vars(matches('percent')), function(x) {x * 100}) %>%
        select(c(geoid, 
                 name, 
                 percent_hs_grad, 
                 percent_college_grad,
                 percent_below_100_poverty,
                 percent_male_19_25_uninsured)
    )
    
    return(acs_clean)
}

clean_prescription_data <- function(df) {
    
    # correct FIPS codes to match acs geoid
    prescriptions_clean <- df %>%
        clean_names() %>%
        select(geoid = state_county_fips_code, 
               prescriptions_per_100 = x2017)
    
    return(prescriptions_clean)
}

clean_overdose_data <- function(df) {
    
    # correct FIPS codes
    overdose_clean <- df %>%
        clean_names() %>%
        mutate(crude_rate = suppressWarnings(as.numeric(as.character(crude_rate))),
               deaths =  suppressWarnings(as.numeric(as.character(deaths))),
               population = suppressWarnings(as.numeric(as.character(population)))) %>%
        select(geoid = county_code,
               crude_death_rate = crude_rate,
               deaths,
               population)
    
    return(overdose_clean)

}




                                 