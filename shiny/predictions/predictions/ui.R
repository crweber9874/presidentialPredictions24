library(shiny)
library(leaflet)
library(shinydashboard)
library(DT)
library(plotly)

source('global.R')

# Define UI
ui <- dashboardPage(
  dashboardHeader(title = "The 2024 Election Prediction Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("The Challenge", tabName = "cover", icon = icon("home")),
      menuItem("Weber Prediction", tabName = "Chris", icon = icon("dashboard")),
      menuItem("Group 1 Prediction", tabName = "Group1", icon = icon("dashboard")),
      menuItem("Group 2 Prediction", tabName = "Group2", icon = icon("dashboard")),
      selectizeInput(inputId= "state", "Select State(s):", choices = unique(predictions$state), 
                     selected = c("Arizona", "Ohio", "Florida"), multiple = TRUE)
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "cover",
              fluidRow(
                column(width = 12, 
                       h2("The 2024 Presidential Election"),
                       h4("The midterm project for POL 683 consisted of a challenge – forecast the 2024 presidential election; in particular, the electoral vote share. Parts of this assignment was completed individually, other parts were completed in groups. The end result is a prediction by each group, which can be viewed by navigating to a page in the dashboard. The instructor -- Chris Weber -- also completed a prediction."),
                       h3("Use the sidebar to navigate through different forecasts")
                )
              )
      ),
      tabItem(tabName = "Chris",
             
              fluidRow(
                column(12,
                       h3("Weber's Predictions")
                )),
              fluidRow(
                box(width = 12, DTOutput(outputId = "predictions_table"))
              ),
              fluidRow(
                box(width = 12,
                    title = "Methodology",
                    h4("I estimated a latent growth curve model in BRMS, using non-informative priors. State voting trajectories are modeled as quadratic growth curves, which can be visualized below.")
                )
              ),
              fluidRow(
                column(width = 12, 
                       plotlyOutput(outputId = "trajectory"))
              ),
              fluidRow(
                column(width = 12, 
                       uiOutput("Prediction"))
              )
      ),
      tabItem(tabName = "Group1",
              fluidRow(
                column(12,
                       h3("Group 1 Predictions")
                )),
              fluidRow(
                column(12,
                       h3("Joshua, Joohyun, Emmanual, Ali")
                )),
              fluidRow(
                box(width = 12, DTOutput(outputId = "predictions_tableg1"))
              ),
              fluidRow(
                box(width = 12,
                    title = "Methodology",
                    h4("We utilize ordinary least squares regression modeling with clustered standard errors by state. We specify two models:

Model (1) predicts the vote share for Kamala Harris (Average FiveThirtyEight Polling Data). For the Harris Specification, our independent variables include average feeling thermometer towards the use of military force at the border, affective polarization, disburse ratio, housing prices, religious ideology, state ideology, and ratio of the non-white population.

Model (2) predicts the vote share for Donald Trump (Average FiveThirtyEight Polling Data). For the Trump Specification, our independent variables include average feeling thermometer towards border control, affective polarization, disburse ratio, housing prices, religious ideology, state ideology, and ratio of the white population.")
                )
              ),
              fluidRow(
                box(width = 12, uiOutput(outputId = "Predictiong1"))
              )
      ),
      tabItem(tabName = "Group2",
              fluidRow(
                column(5,
                       h3("Group 2 Predictions")
                )),
              fluidRow(
                column(5,
                       h3("Alianna, Doyun, Rediet, Selin")
                )
              ),
              fluidRow(
                box(width = 12, DTOutput(outputId = "pred_gr2"))
              ),
              fluidRow(
                box(width = 12,
                    title = "Methodology",
                    h4("We are following Hummel and Rothschild’s (2014) method of developing fundamental models of casting state-level elections as a guide for our project. They emphasize the importance of approval ratings and economic indicators in their model. While we want to veer away from strictly using a fundamental model (as we want to include public opinion data). They make a compelling argument for using state-level data, and we plan on constructing some of our variables (such as president approval and state ideology) using their method.

We developed a linear model with the 538 data as our DV and our IVs include the following state, 2020 electoral result, state ideology, expenditures per pupil for the 2020-2021 school year for each state, average house prices for each state and percentage of residents below poverty level for each state and 4-year change in unemployment rate for each state."
                    )
                )),
              fluidRow(
                box(width = 12, uiOutput(outputId = "Predictiong2"))
              )
      )
    )
  )
)
