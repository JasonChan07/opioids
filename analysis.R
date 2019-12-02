library(car)
library(glm)
library(AER)
library(vcd)

# loads datasets
source('./queries.R')
# cleans datasets
source('./cleaning.R')


acs_clean <- clean_acs_data(df = acs_data)
prescription_clean <- clean_prescription_data(df = prescriptions)
overdoses_clean <- clean_overdose_data(df = overdoses)

# join cleaned datasets
opioid <- acs_clean %>% 
            inner_join(prescription_clean,
                       by = 'geoid') %>%
            inner_join(overdoses_clean,
                       by = 'geoid') %>%
            filter(crude_death_rate != 0)

# correlation between variables
pairs(opioid[, 3:8])
cor(opioid[, 3:8], method = 'spearman')

# which counties don't have prescription data?


# base poisson model
poisson <- glm(deaths ~ percent_college_grad + percent_below_100_poverty +
                percent_male_19_25_uninsured + prescriptions_per_100, offset = log(population),
                family = poisson(link = "log"), data = opioid)


summary(poisson)

# fitted vs residuals
plot(poisson$fitted.values, poisson$residuals)

# chi-sq test
anova(poisson, test="Chisq")

# distplot
distplot(opioid$deaths, type = 'poisson')

