library(dplyr)
library(sf)
library(ggplot2)
library(leaflet.extras)
library(plotly)
library(jsonlite)
library(tidyr)
library(RColorBrewer)
library(lubridate)



# setwd("~/Dropbox/github_repos/pol683/electionPrediction/presidentialPredictions24/shiny/predictions/predictions/")

load("models.rda")
poll = read.csv('poll.csv')

predictions = read.csv("electoral_predictions.csv")
load("chrispred.rda")

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