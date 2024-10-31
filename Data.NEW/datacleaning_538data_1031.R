# POL683 Election Forecast
# Data cleaning - FiveThirtyEight polling data
# Doyun Lee

getwd()
setwd("~/Library/Mobile Documents/com~apple~CloudDocs/R/POL683/Election forecast/Latest prediction")
list.files()

library(tidyr)
library(dplyr)
library(lubridate)


poll <- read.csv("president_polls.csv")


head(poll)

poll_r <- poll %>%
  select(state, start_date, end_date, sample_size, answer, pct, pollster, transparency_score) %>%
  filter(state != "",
         answer %in% c("Harris", "Trump", "Biden")) %>% # Filter responses for Harris, Trump, and Biden
  mutate(start_date = mdy(start_date), # Convert character to date
         end_date = mdy(end_date),
         state = ifelse(state %in% c("Maine CD-1", "Maine CD-2"), "Maine", # Combine "Maine", "Maine CD-1", and "Maine CD-2" into "Maine"
                                       ifelse(state == "Nebraska CD-2", "Nebraska", state))) %>% # Combine "Nebraska" and "Nebraska CD-2" into "Nebraska"
  group_by(state)


### poll_post
# data for states where polls were conducted *after* Biden's resignation

poll_post <- poll_r %>%
  filter(start_date >= ymd("2024-07-21"), # Filter polls that started after Biden's resignation
         answer %in% c("Harris", "Trump")) %>%
  group_by(state, answer) %>%
  summarize(mean(pct)) # Calculate the average of polls per state and answer

state_post <- unique(poll_post$state) # Save the names of states with polls conducted after the resignation


### poll_pre
# data for states where polls were conducted *before* Biden's resignation

poll_pre <- poll_r %>%
  filter(start_date < ymd("2024-07-21"),
         end_date < ymd("2024-07-21"),
         !state %in% state_post, # Filter states not included in poll_after
         start_date == max(start_date)) %>% # Select the most recent polls
  group_by(state, answer) %>%
  summarize(mean(pct)) # Calculate the average of polls per state and answer


### Combine data for post- and pre-resignation

poll_post_r <- poll_post %>%
  pivot_wider(names_from = answer, values_from = `mean(pct)`) %>%
  mutate(Dem = Harris, Rep = Trump)

poll_pre_r <- poll_pre %>%
  pivot_wider(names_from = answer, values_from = `mean(pct)`) %>%
  mutate(Dem = Biden, Rep = Trump) # Respondents answered Biden instead of Harris before his resignation

poll_clean <- rbind(poll_post_r, poll_pre_r)[,c("state", "Dem", "Rep")] %>% 
  arrange(state)


write.csv(poll_clean, file = "presidential_polls_1031.csv")

View(poll_clean)
