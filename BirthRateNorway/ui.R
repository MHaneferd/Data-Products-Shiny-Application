library(shiny)

# Define UI for application that draws a plot
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Estimate Birth Rate in Norway for the next ten years"),
  h4("You can simulate range of hospital beds, total population and the female percentage of the population in Norway, to see the effect of the birth rate (per 1000 persons)."),
  h4("The three predictors has been collected from The World Bank of data (http://databank.worldbank.org), and has been fitted in a glm model."),
  h4("The sliders indicates the year 2026 values. That creates a range from 2016 to 2026 which is used to fit the glm model. The predicted birthrate for next ten years is marked in red in the plot."),
                
  # Sidebar with a slider input 
  sidebarLayout(
    sidebarPanel(
          # Create sliders for the three predictors:
          sliderInput("beds",
                      "Hospital beds (per 1000 people):",
                      min = 1,
                      max = 15,
                      value = 3.3),
          sliderInput("population",
                      "Population in Norway:",
                      min = 2000000,
                      max = 10000000,
                      value = 5195921),
          sliderInput("female",
                      "Population female (% of total):",
                      min = 40,
                      max = 60,
                      value = 49.62923)
    ),
    
    # Show a plot
    mainPanel(
       plotOutput("distPlot")
    )
  )
))
