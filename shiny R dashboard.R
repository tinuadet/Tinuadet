# Shiny App
install.packages("shiny")
install.packages("data.table")
install.packages("caret")
install.packages("randomForest")
library(shiny)
library(data.table)
library(caret)
library(randomForest)

# Model loading
model<-readRDS("model.rds")


####################################
# User interface                   #
####################################

ui <- pageWithSidebar(
  
  # Page header
  headerPanel('Iris Flower Prediction'),
  
  # Input values
  sidebarPanel(
    #HTML("<h3>Input parameters</h3>"),
    tags$label(h3('Input parameters')),
    numericInput("sepal.length", 
                 label = "sepal length", 
                 value = 5.1),
    numericInput("sepal.width", 
                 label = "sepal width", 
                 value = 3.6),
    numericInput("petal.length", 
                 label = "petal length", 
                 value = 1.4),
    numericInput("petal.width", 
                 label = "petal width", 
                 value = 0.2),
    
    actionButton("submitbutton", "Submit", 
                 class = "btn btn-primary")
  ),
  
  mainPanel(
    tags$label(h3('Status/Output')), # Status/Output Text Box
    verbatimTextOutput('contents'),
    tableOutput('tabledata') # Prediction results table
    
  )
)

####################################
# Server                           #
####################################

server<- function(input, output, session) {
  
  # Input Data
  datasetInput <- reactive({  
    
    df <- data.frame(
      Name = c("sepal length",
               "sepal width",
               "petal length",
               "petal width"),
      Value = as.character(c(input$sepal.length,
                             input$sepal.width,
                             input$petal.length,
                             input$petal.width)),
      stringsAsFactors = FALSE)
    
    specie <- 0
    df <- rbind(df, specie)
    input <- transpose(df)
    write.table(input,"input.csv", sep=",", quote = FALSE, row.names = FALSE, col.names = FALSE)
    
    test <- read.csv(paste("input", ".csv", sep=""), header = TRUE)
    
    Output <- data.frame(Prediction=predict(model,test), round(predict(model,test,type="prob"), 3))
    print(Output)
    
  })
  
  # Status/Output Text Box
  output$contents <- renderPrint({
    if (input$submitbutton>0) { 
      isolate("Calculation complete.") 
    } else {
      return("Server is ready for calculation.")
    }
  })
  
  # Prediction results table
  output$tabledata <- renderTable({
    if (input$submitbutton>0) { 
      isolate(datasetInput()) 
    } 
  })
  
}

####################################
# Create the shiny app             #
####################################
shinyApp(ui = ui, server = server)