library(shiny)

data <- read.csv("data/dec14.csv", sep=",", header=TRUE)
data$Date <- as.Date(data$Date,"%m/%d/%Y")

# Define a server for the Shiny app
shinyServer(function(input, output) {
                
        # a parallel coordinate plot showing the three crime variables
        output$plot <- renderPlot({        
                
                # filter based on input
                data <- data[data$Date >= input$dateRange[1] & data$Date <= input$dateRange[2],]
                if (input$Offense.Type != "All"){
                        data <- data[data$Offense.Type == input$Offense.Type,]
                }                        
                
                if (input$Offense.Type == "All"){
                        
                        col=c("darkred","red", "darkorange", "brown", "grey20","grey40", "black")  
                        par(mar=c(9,4,4,4))
                        
                        if(input$chartType == 1){                                
                                plot(data$Offense.Type, col=col, las=2, ylab="Incidents")
                        }
                        else {
                                counts <- table(data$Hour)                                
                                barplot(counts, col = c("darkred"), xlab="Hour of Day", ylab="Incidents")                                
                        }
                }
                else {
                        counts <- table(data$Hour)
                        par(mar=c(6,4,4,4))
                        barplot(counts, col = c("darkred"), xlab="Hour of Day", ylab="Incidents")
                }
        })
        
        # Filter data based on selections
        output$table <- renderDataTable({
                
                data <- data[data$Date >= input$dateRange[1] & data$Date <= input$dateRange[2],]
                if (input$Offense.Type != "All"){
                        data <- data[data$Offense.Type == input$Offense.Type,]
                }
                
                data
        }
        ,options = list(pageLength = 10)
        )
        
        output$value <- renderPrint({
                paste("Querying Crime Incidents from", 
                      paste(as.character(input$dateRange), collapse = " to ")
                )
        }
        )
        
})

