# Dean Attali -- September 2014

# Adapted by Matt Davis (July 2022) for use in USAFA's DS421 Capstone course.

# This is the ui portion of a shiny app that "mimics" a Google form, in the
# sense that it lets users enter some predefined fields and saves the answer
# as a .csv file.  

source("helpers.R")

library(shiny)

shinyUI(fluidPage(
  
  # add external JS and CSS
  singleton(
    tags$head(includeScript(file.path('www', 'message-handler.js')),
              includeCSS(file.path('www', 'style.css'))
    )
  ),

  title = "DS 421 Basic Student Info",
  h2("DS 421 Basic Student Info"),
  
  conditionalPanel(
    # only show this form before the form is submitted
    condition = "!output.formSubmitted",
    
    # form instructions
    verticalLayout(
      img(src="giphy.gif", align = "left",height='125px',width='250px'),
    hr(),
    
    p("In order to facilitate collaboration among your teammates and classmates, it would help me
      tremendously if you could provide some basic information."),
    p("The fields marked with * are mandatory,
      and the rest are optional but highly recommended."),
    strong("Help me help you.")
    ),
    
    shiny::hr(),
    
    # form fields
    textInput(inputId = "firstName", label = "First name (as it appears on the roster) *"),
    textInput(inputId = "lastName", label = "Last name (as it appears on the roster) *"),
    textInput(inputId = "email", label = "first.last@afacademy.af.edu"),
    selectInput(inputId = "codeType", label = "Preferred Coding Language",
                choices = c("", "C", "R", "Python", "Java",
                            "Other"),
                selected = ""),  
    textInput(inputId = "gitName", label = "GitHub username"),
    uiOutput("gitTest"),
    textInput(inputId = "afsc", label = "Projected or Preferred AFSC"),
    br(),
    actionButton(inputId = "submitBtn", label = "Submit")
    
 
  ),
  
  conditionalPanel(
    # thank you screen after form is submitted
    condition = "output.formSubmitted",
    
    h3(textOutput("thanksName"))
  ),
  
  # author info
  shiny::hr(),
  em(
    span("Created by "),
    a("Dean Attali", href = "http://deanattali.com"),
    span(", Sept 2014"),
    br(), br(),
    span("Modified by "),
    a("Matt Davis"),
    span(", July 2022"),
  )
))
