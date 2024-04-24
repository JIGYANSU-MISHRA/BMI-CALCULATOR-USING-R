install.packages("shinythemes")
install.packages("markdown")


library(shiny)
library(shinythemes)

# User Interface
ui <- fluidPage(theme = shinytheme("united"), navbarPage("BMI Calculator:",tabPanel("Home",sidebarPanel(
                                      HTML("<h3>Input parameters</h3>"),sliderInput("height",label = "Height", 
                                                  value = 175,min = 40,max = 250),
                                      sliderInput("weight",label = "Weight",value = 70,min = 20,max = 100),
                                      actionButton("submitbutton","Submit",class = "btn btn-primary")),
                                    mainPanel(
                                      tags$label(h3('Status/Output')), 
                                      verbatimTextOutput('contents'),
                                      tableOutput('tabledata'))), 
                                    tabPanel("About",titlePanel("About"),div(includeMarkdown("What is BMI?
Body Mass Index (BMI) is essentially a value obtained from the weight and height of a person.
Calculating the BMI: BMI can be computed by dividing the person's weight (kg) by their squared height (m) as follows:
BMI = kg/m^2    
where kg represents the person's weight and m^2 the person's squared height."),align="justify")))) 


server <- function(input, output, session) {
  
  datasetInput <- reactive({  
    bmi <- input$weight/( (input$height/100) * (input$height/100) )
    bmi <- data.frame(bmi)
    names(bmi) <- "BMI"
    bmi$class <- ifelse(bmi$BMI >= 18.5 & bmi$BMI <= 24.9, "Healthy",
                        ifelse(bmi$BMI < 18.5, "Underweight", "Overweight"))
    print(bmi)
  })
  
  output$contents <- renderPrint({
    if (input$submitbutton > 0) { 
      isolate("Calculation complete.") 
    } else {
      return("Server is ready for calculation.")
    }
  })
  

  output$tabledata <- renderTable({
    if (input$submitbutton > 0) { 
      isolate(datasetInput()) 
    } 
  })
}

shinyApp(ui = ui, server = server)