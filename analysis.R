library(car)
library(glm)
library(AER)
library(vcd)
library(DataExplorer)
library(lmtest)
library(knitr)
library()

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
            filter(crude_death_rate != 0) %>% 
            select(-c(geoid, name, deaths, population))

png("test.png", height = 50*nrow(head(opioid)), width = 200*ncol(head(opioid)))
grid.table(head(opioid))
dev.off()

# distribution of variables
DataExplorer::plot_histogram(opioid)

# base model
base_lm <- lm(crude_death_rate ~ ., data = opioid)
summary(base_lm)

# check for multicollinearity
car::vif(base_lm)

# test for heteroskedasticity
lmtest::bptest(base_lm)

# fitted vs residuals
plot(base_lm$fitted.values, base_lm$residuals,
     xlab = 'Fitted Values', ylab = 'Residuals',
     main = 'Base Linear Model')

# regression with heteroskedastic robust errors
coeftest(base_lm, vcov = vcovHC(base_lm, type = "HC0"))


