setwd("/Users/aliannacasas/Desktop/Election/Data")

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

personal_income <- read.csv("personal_income.csv" )
annual_unemp <- read_excel("annual_unemp.xlsx")



###### Personal (Disposable) Income per Capita #########

  # Viewing the Data #

    view(personal_income)

    summary(personal_income)
    
    head(personal_income)
    
    tail(personal_income)
    
    dim(personal_income)
    
  # We want the most recent personal income data
    
    # Since this is ACS data, the most recenly available data is from 2023.

      # Subset the data, keep GeoFIPS, State, X2023
      
      pi_subset <- subset(personal_income, select = c("GeoFIPS", "State", "X2023"))
      
      # Rename X2023, "PI_Per_Capita"
      
      pi_subset <- pi_subset %>%
        rename(PI_Per_Capita = X2023)
      
      # Save subset as Personal_Income_2023.csv
      
      write.csv(pi_subset, "Personal_Income_2023.csv")
      
      
      
    # We can also transform the data from wide to long 
      
      pi_transformed <- personal_income %>%
        pivot_longer(
          cols = starts_with("X"),  
          names_to = "Year",             
          values_to = "PI_Per_Capita"             
        )
      
      print(pi_transformed)
      
      
      # Also, let's rename values for 2020, 2021, 2022, 2023
      
      pi_transformed$Year <- ifelse(pi_transformed$Year == "X2020", "2020",
                                    ifelse(pi_transformed$Year == "X2021", "2021",
                                           ifelse(pi_transformed$Year == "X2022", "2022", "2023")))
      
    
      # save as personal_income_cleaned.csv
      
      write.csv(pi_transformed, "personal_income_cleaned.csv")
    
###### Annual Unemployment #########
      
      # Viewing the Data #
      
      view(annual_unemp)
      
      summary(annual_unemp)
      
      head(annual_unemp)
      
      tail(annual_unemp)
      
      dim(annual_unemp)
    
    
      # We only want the last four years of unemployment data
      
      annual_unemp <- subset(annual_unemp, select = c("State", "2019", "2020", "2021", "2022", "2023"))
      
      
  
      
      # Transform the data from wide to long 
      
      unemp_transformed <- annual_unemp %>%
        pivot_longer(
          cols = starts_with("20"),  
          names_to = "Year",             
          values_to = "Annual_Unemployment_Rate"             
        )
      
      print(unemp_transformed)

      
      # save as unemp_cleaned.csv
      
      write.csv(unemp_transformed, "unemp_cleaned.csv")    
           
              
##### Merging Personal Income and Unemployment Data   
      
      pi_unemp <- pi_transformed %>% left_join(unemp_transformed, by = c("State", "Year"))
      
      print(pi_unemp)
      
##### Poverty Rate Data #########
      
      
      # Load in Poverty Rate data from ACS
      # Pre-cleaned data so that I am left with the state and percentage estimate.
      
      poverty_rate <- read_excel("poverty_rate.xlsx")
      View(poverty_rate)

      ##### Merging Personal Income and Unemployment Data   
      
      merged_data <- pi_unemp %>% left_join(poverty_rate, by = c("State", "Year"))
      
      print(merged_data)      
            
        # Okay, merge initially not working.
      
        # Convert "Year" into character:
      
      
      # Convert Year in poverty_rate to character
      
        poverty_rate <- poverty_rate %>% mutate(Year = as.character(Year))

      
      # And re-run
        
## Finalize cleaned, merged data 
        
        merged_data_final <- subset(merged_data, select = c("GeoFIPS", "State", "Year", "PI_Per_Capita", 
                                                            "Annual_Unemployment_Rate", "Below_Poverty_Level"))
        # Change Unemployment
        
        merged_data_final <- merged_data_final %>%
          arrange(GeoFIPS, Year) %>%
          group_by(GeoFIPS, State) %>%  
          mutate(OneYearChange_Unemployment = Annual_Unemployment_Rate - lag(Annual_Unemployment_Rate)) %>%
          ungroup()  
        
        # View the updated data frame
        print(merged_data_final)
        
        # Since the data only goes back to 2020, if I want to take the four-year change- I'll have to do this manually (either in excel because it's so much easier) or pivot unemployment data and take the 2023-2019 change in unemployment.
        # I just did it in excel because this started to hurt my brain.
        
        
