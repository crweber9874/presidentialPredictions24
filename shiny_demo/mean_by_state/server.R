#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#
dat = read.csv("~/Dropbox/github_repos/pol683/electionPrediction/presidentialPredictions24/data_clean.csv") 
  
library(shiny)

# Define server logic required to draw a histogram
server = function(input, output, session) {

    output$state <- renderPlot({
      dat %>%
      filter(answer == "Trump" & state %in% input$state) %>%
        
        group_by(state) %>%
        summarise(mean = mean(pct),
                  high = quantile(pct, 0.975),
                  low = quantile(pct, 0.025)
        ) %>%
        ggplot(aes(x = state, y = mean)) +
        geom_point(aes(color = ifelse(mean > 0.2, "black", "blue"))) +
        geom_errorbar(aes(ymin = low, ymax = high), width = 0.25) +
        scale_color_identity() +
        theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
        labs(title = "Trump's predicted vote share by state",
             x = "State",
             y = "Predicted vote share")

    })

}
