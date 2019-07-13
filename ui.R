#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)


shinyUI(fluidPage(
  theme = shinytheme('darkly'),
  titlePanel('Russiantroll Analysis Web App'),
  sidebarLayout(
    sidebarPanel(
      sliderInput('ngramCount', 'Number of Grams for wordcloud', min = 1, max = 5, value = 2),
      hr(),
      sliderInput('cloudCount', 'Number of Words for wordcloud', min = 5, max = 100, value = 25),
      hr(),
      hr(),
      hr(),
      hr(),
      sliderInput('topicCount', 'Number of topics for topicplot', min = 1, max = 15, value = 10)
    ),
    mainPanel(
      plotOutput('wordcloud'), 
      plotOutput('topicplot')
    )
  )
))