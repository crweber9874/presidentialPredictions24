library(dplyr)
library(sf)
library(ggplot2)
library(leaflet.extras)
library(plotly)
library(jsonlite)
library(tidyr)
library(RColorBrewer)
library(lubridate)
library(dplyr)

# setwd("~/Dropbox/github_repos/pol683/electionPrediction/presidentialPredictions24/shiny/predictions/predictions/")

load("models.rda")
load("group2.rda")

poll = read.csv('poll.csv')

predictions = read.csv("electoral_predictions.csv")
load("chrispred.rda")

predictiong1 = read.csv("group1.csv")[,1:5]
names(predictiong1) <- c("state", "harris_vg1", "trump_vg1", "harris_eg1", "trump_eg1")

predictions = predictions %>%
  left_join(predictiong1, by = c("state" = "state")) %>%
  mutate(g1_prediction = ifelse(harris_vg1 > trump_vg1, "Kamala Harris", "Donald Trump")) %>%
  left_join(TeamB_predictions, by = "state") %>%
  mutate(trump_vg1  =  as.numeric(trump_vg1),
         harris_vg1 =  as.numeric(harris_vg1),
         g2_prediction = ifelse(winner == "Trump", "Donald Trump", "Kamala Harris"),
         g2_trumpEV = ifelse(winner == "Trump",   electoral_votes, 0),
         g2_HarrisEV = ifelse(winner == "Harris",  electoral_votes, 0)
)
                          
                           
# bind_rows(
#   poll %>%  
#   tidybayes::add_epred_draws(models$harris) %>%
#   group_by(day_id, state) %>%
#   summarize(
#     .value = mean(.epred),
#     .lower = quantile(.epred, 0.025),
#     .upper = quantile(.epred, 0.975)
#   ) %>%
#   mutate(candidate_name = "Kamala Harris"),
# poll %>%
#   tidybayes::add_epred_draws(models$trump) %>%
#   group_by(day_id, state) %>%
#   summarize(
#     .value = mean(.epred),
#     .lower = quantile(.epred, 0.025),
#     .upper = quantile(.epred, 0.975)
#   ) %>%
#   mutate(candidate_name = "Donald Trump")
# ) %>% as.data.frame() -> plot_dat