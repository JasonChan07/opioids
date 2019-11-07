# loads datasets
source('./queries.R')
# cleans datasets
source('./cleaning.R')

acs_clean <- clean_acs_data(df = acs_data)
prescription_clean <- clean_prescription_data(df = prescriptions)

# join cleaned datasets
opioid <- acs_clean %>% inner_join(prescription_clean,
                                   by = 'geoid')


# which counties don't have prescription data?
