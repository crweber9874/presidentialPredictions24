
### POL 683: Midterm Elections Project ###
### Model Specifications and Predicted Probs ###
### Updates 21 Oct 2024 ###
### Casas, Lee, Tadele, Yanik Koc



install.packages('shiny')
library(readxl)
library(foreign)
library(tidyverse)
library(ggeffects)
library(lmtest)
library(dplyr)
library(ggeffects)
library(haven)
library(Hmisc)
library(MASS)
library(ordinal)
library(sandwich)
library(tidyr)
library(readr)
library(RColorBrewer)
library(reshape2)
library(shiny)




setwd("/Users/aliannacasas/Desktop/Election/Data")


finaldata <- read_csv("electionforecast_FINAL.csv")


## Recoding Variables (DV)


## Creating ratio for disbursement and white/non-white population


  # Disbursement

  
finaldata$log_trump_disbursement <- log(finaldata$trump_disbursement)
finaldata$log_harris_disbursement <- log(finaldata$harris_disbursement)

finaldata$disburse_ratio <- finaldata$log_harris_disbursement/finaldata$log_trump_disbursement


  
  # White/Non-white 
  
  
  
  finaldata$wnw_ratio <- finaldata$white_population/finaldata$nonwhite_population
  
  
  # Take the log of housing prices
  
  finaldata$house_price <- log(finaldata$house_price)
  
  
  
# Save Data
  
write.csv(finaldata, "finaldata_recode.csv")



## OLS Models
  
  
  # Harris (DV)
  

  # Including mean_border_patrol

  harris <- lm(fivethirtyeight_dem ~ house_price + state_ideology + affective_polarization + disburse_ratio + mean_border_patrol + nonwhite_population  + religion_evan , data = finaldata)
  coeftest(harris, vcov. = vcovCL(harris, cluster = finaldata$state, type = "HC0"))
  
  # Including mean_abortion
  
  harris_abort <- lm(fivethirtyeight_dem ~ house_price + state_ideology + affective_polarization + disburse_ratio + mean_abortion + nonwhite_population  + religion_evan , data = finaldata)
  coeftest(harris_abort, vcov. = vcovCL(harris_abort, cluster = finaldata$state, type = "HC0"))
  
  # Border Patrol Militarization specification seems to best predict democrat vote share

    
  harris_milit <- lm(fivethirtyeight_dem ~ house_price + state_ideology + affective_polarization + disburse_ratio + mean_border_milit + nonwhite_population  + religion_evan , data = finaldata)
  coeftest(harris_milit, vcov. = vcovCL(harris_milit, cluster = finaldata$state, type = "HC0"))
  
  # Including mean_border_legal 
  harris_legal <- lm(fivethirtyeight_dem ~ house_price + state_ideology + affective_polarization + disburse_ratio + mean_border_legal + nonwhite_population  + religion_evan , data = finaldata)
  coeftest(harris_legal, vcov. = vcovCL(harris_legal, cluster = finaldata$state, type = "HC0"))
  
  
  
# Model Comparisons
  
  
  AIC(harris)
  AIC(harris_milit)
  AIC(harris_legal)
  AIC(harris_abort)
  
  BIC(harris)
  BIC(harris_milit)
  BIC(harris_legal)
  BIC(harris_abort) 
  
  # Trump (DV)
  
  
  # Main trump specification appears to best predict republican vote share
  
  trump <- lm(fivethirtyeight_rep ~ house_price + state_ideology + affective_polarization  + mean_border_patrol + disburse_ratio + white_population  + religion_evan , data = finaldata)
  coeftest(trump, vcov. = vcovCL(trump, cluster = finaldata$state, type = "HC0"))
  

  # Including mean_border_milit  
  trump_milit <- lm(fivethirtyeight_rep ~ house_price + state_ideology + affective_polarization  + mean_border_milit + disburse_ratio + white_population  + religion_evan , data = finaldata)
  coeftest(trump_milit, vcov. = vcovCL(trump_milit, cluster = finaldata$state, type = "HC0"))
  

  # Including mean_border_legal
  
  trump_legal <- lm(fivethirtyeight_rep ~ house_price + state_ideology + affective_polarization  + mean_border_legal + disburse_ratio + white_population  + religion_evan , data = finaldata)
  coeftest(trump_legal, vcov. = vcovCL(trump_legal, cluster = finaldata$state, type = "HC0"))
  
  # Including mean_abortion
  
  trump_abort <- lm(fivethirtyeight_rep ~ house_price + state_ideology + affective_polarization  + mean_abortion + disburse_ratio + white_population  + religion_evan , data = finaldata)
  coeftest(trump_abort, vcov. = vcovCL(trump_abort, cluster = finaldata$state, type = "HC0"))
  

# Model Comparisons 
  
  AIC(trump)
  AIC(trump_milit)
  AIC(trump_legal)
  AIC(trump_abort)
  
  
  
  BIC(trump)
  BIC(trump_milit)
  BIC(trump_legal)
  BIC(trump_abort)
  

  
## Predicted Vote Share By State
  
  
  # Generating State-level predictions
  
  
  # Trump Specification


  # Generate new data by state (Trump)
  
  newdata_trump <- finaldata %>%
    group_by(state) %>%
    summarise(
      house_price = mean(house_price, na.rm = TRUE),
      state_ideology = median(state_ideology, na.rm = TRUE),
      affective_polarization = mean(affective_polarization, na.rm = TRUE),
      mean_border_patrol = mean(mean_border_patrol, na.rm = TRUE),
      disburse_ratio = mean(disburse_ratio, na.rm = TRUE),
      white_population = mean(white_population, na.rm = TRUE),
      religion_evan = mean(religion_evan, na.rm = TRUE),
      .groups = "drop")
  
  # Generate predictions for Trump specification
 
   predict_trump <- predict(trump, newdata = newdata_trump)
  
  # Combine predictions for republican vote share with new data
   
  predictions_rep <- newdata_trump %>%
    mutate(predicted_rep = predict_trump)
  
  print(predictions_rep)

  
  # Harris (military) Specification
  
  
  # Generate new data by state (Harris)
  
  newdata_harris <- finaldata %>%
    group_by(state) %>%
    summarise(
      house_price = mean(house_price, na.rm = TRUE),
      state_ideology = median(state_ideology, na.rm = TRUE),
      affective_polarization = mean(affective_polarization, na.rm = TRUE),
      mean_border_milit = mean(mean_border_patrol, na.rm = TRUE),
      disburse_ratio = mean(disburse_ratio, na.rm = TRUE),
      nonwhite_population = mean(white_population, na.rm = TRUE),
      religion_evan = mean(religion_evan, na.rm = TRUE),
      .groups = "drop")
  
  # Generate predictions for Harris specification
  
  predict_harris <- predict(harris_milit, newdata = newdata_harris)
  
  # Combine predictions for democrats vote share with new data
  
  predictions_dem <- newdata_harris %>%
    mutate(predicted_dem = predict_harris)
  
  print(predictions_dem)
  

  
  
## How does the two-party prediction map onto electoral returns 
  
    # If a candidate gets over 50%, gets electoral college vote. If less than 50%, then not. 

  
    # Excluding Maine and Nebraska (?) 
  
  
  