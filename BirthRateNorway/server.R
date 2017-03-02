#
# This is the server logic of the Shiny web application 
#

# Load libraries
library(shiny)
library(DMwR)
library(randomForest)

# Read the sourcefile 
filedata <- read.table("data.csv", header = TRUE, sep = ";", dec = ",", quote = "\"")

# Do some cleanup
rows <- (c("hospital.beds.per.1000","birth.rate.per.1000","population.growth.percent", "population.total","population.female"))
filedata <- filedata[,-c(1:4)]
df <- cbind(rows, filedata)
rows <- c("rows",1960:2016)
colnames(df) <- rows
df <- df[, -58]

# transpose the data:
df <- as.data.frame(t(df))
rows <- (c("hospital.beds.per.1000","birth.rate.per.1000","population.growth.percent", "population.total","population.female"))
colnames(df) <- rows
df <- df[-1, ]

#transform to numeric function
asNumeric <- function(x) as.numeric(as.character(x))
factorsNumeric <- function(d) modifyList(d, lapply(d[, sapply(d, is.factor)],asNumeric))

# Change the factors to numeric
df <- factorsNumeric(df)
df <- df[,-3 ] # Remove population growth in percent

#impute NA's
df_imputed <- knnImputation(df,k=2)

#Do a glm
fit <- glm(birth.rate.per.1000~., data=df_imputed)

# Define server logic required to display the predicted output:
shinyServer(function(input, output) {
         
      
output$distPlot <- renderPlot({
    
        
        # Create newdata based on the range of ten years starting at offset, ending
        # where the sliders stop :-)
        df2 = df_imputed[47:56,]
        df2$hospital.beds.per.1000 <- seq(3.3,input$beds, length.out = 10)
        df2$population.total <- seq(5195921,input$population,length.out = 10)
        df2$population.female <- seq(49.62923,input$female,length.out = 10)
        rownames(df2) <- c(2016:2025) #New years :-)

        # Predict birthrate based on random forest model:
        df2$birth.rate.per.1000 <- predict.glm(fit,df2)
        
        # Do some additional cleanup and formatting
        df3 <- rbind(df_imputed,df2)
        df3 <- cbind(df3,as.numeric(rownames(df3)))
        colnames(df3)[5] <- "year"
        df2 <- cbind(df2,as.numeric(rownames(df2)))
        colnames(df2)[5] <- "year"
        
        
        # Plot the birthrate and the predicted ten last years in Red.
        plot(df3$year, df3$birth.rate.per.1000, 
             type="l", 
             col = "blue",
             xlab = "Year",
             ylab = "Birth Rate per 1000 people in Norway"
             )
        lines(x = df2$year,y = df2$birth.rate.per.1000, col="red", lwd=3)
        
  })
  
})
