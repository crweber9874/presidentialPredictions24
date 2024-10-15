#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

# Load the data
data <- read.csv("~/Dropbox/github_repos/pol683/electionPrediction/presidentialPredictions24/data_clean.csv")

# Define UI
ui <- fluidPage(
  titlePanel("Trump's Predicted Vote Share by State"),
  sidebarLayout(
    sidebarPanel(
      selectizeInput("state", "Select State:", choices = unique(data$state), selected = c("Minnesota", "Arizona", "Louisiana", "New York", "Wisconsin"),
                     multiple = TRUE)
    ),
    mainPanel(
      plotOutput("state")
    )
  )
)
