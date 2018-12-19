#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#


#dashboardPage(header, sidebar, body),

# UI for app
ui<-(dashboardPage(
  

  
  # title
 dashboardHeader(title = "Opioid Data"),
  
  #input
  dashboardSidebar
  (
    # Input: Select a file ----
    
    fileInput("file1", "Choose CSV File",
              multiple = TRUE,
              accept = c("text/csv",
                         "text/comma-separated-values,text/plain",
                         ".csv")),
    # Input: Checkbox if file has header ----
    checkboxInput("header", "Header", TRUE),
    
    # Input: Select separator ----
    radioButtons("sep", "Separator",
                 choices = c(Semicolon = ";",
                             Comma = ",",
                             Tab = "\t"),
                 selected = ","),
    # Horizontal line ----
    tags$hr(),
    
    
    # Input: Select what to display
    selectInput("dataset","Data:",
                choices =list(Overdose_Data = "overdoses", Prescriber_Data = "prescribers_gathered",   TN_County_Data_2016 = "all_county_data_16",
                              uploaded_file = "inFile"), selected=NULL),
    selectInput("variable","Variable:", choices = NULL),
    selectInput("group","Group:", choices = NULL),
    selectInput("plot.type","Plot Type:",
                list(boxplot = "boxplot", histogram = "histogram", density = "density", bar = "bar")
    ),
    tags$style("
      .checkbox { /* checkbox is a div class*/
             line-height: 30px;
             margin-bottom: 40px; /*set the margin, so boxes don't overlap*/
             }
             input[type='checkbox']{ /* style for checkboxes */
             width: 30px; /*Desired width*/
             height: 30px; /*Desired height*/
             line-height: 30px; 
             }
             span { 
             margin-left: 15px;  /*set the margin, so boxes don't overlap labels*/
             line-height: 30px; 
             }
             "),
    checkboxInput("show.points", "show points", TRUE)
   
  ),
  
  # output
  dashboardBody(
    h3(textOutput("caption")),
    #h3(htmlOutput("caption")),
    uiOutput("plot") # depends on input
  )
))
