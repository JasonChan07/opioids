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
               percent_male_19_25_uninsured = uninsured_19_25_male / total_male) %>%
        select(c(geoid, name, 
                 percent_hs_grad, 
                 percent_college_grad,
                 percent_below_100_poverty,
                 percent_male_19_25_uninsured)
    )
    
    # consider multiplying percentages by 100
    return(acs_clean)
}

clean_prescription_data <- function(df) {
    
    # correct FIPS codes to match acs geoid
    prescriptions_clean <- df %>%
        clean_names() %>%
        select(geoid = state_county_fips_code, 
               prescriptions_per_100 = x2017) %>%
        mutate(geoid = paste0("0", geoid)
    )
               
    return(prescriptions_clean)
}







                                 