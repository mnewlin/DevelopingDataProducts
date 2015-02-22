library(shiny)

data <- read.csv("data/dec14.csv", sep=",", header=TRUE)
data$Date <- as.Date(data$Date,"%m/%d/%Y")

shinyUI(
        navbarPage("Houston Crimes Reported December 2014",

                tabPanel("Documentation", includeHTML("doc.html")),

                tabPanel("Application",

                        sidebarPanel(
                                 dateRangeInput("dateRange", label = h4("Reported incident date")
                                               ,min="2014-01-01", start="2014-11-01", end="2014-12-31", max="2014-12-31")
                                ,selectInput("Offense.Type", "Offense type", c("All", unique(as.character(data$Offense.Type))))
                                ,radioButtons("chartType", label = h4("Chart Type"),
                                              choices = list("Offense Type" = 1, "Incidents by hour of day" = 2), 
                                              selected = 1)
                                ,submitButton('Submit')
                                ,hr()
                                ,h4("Data provided by city of Houston, Texas")
                                ,h5("http://www.houstontx.gov/police/cs/stats2.htm")
                                ),

                        mainPanel(

                                verbatimTextOutput("value"),
                                plotOutput('plot'),
                                hr(),
                                dataTableOutput(outputId="table")
                                )
                        )

                )
        )
