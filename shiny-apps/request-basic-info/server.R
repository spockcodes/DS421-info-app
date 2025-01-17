## Modified by Matt Davis
## July 2022


#Original code by:
#######################################
# Dean Attali
# September 2014

# This is the server portion of a shiny app that "mimics" a Google form, in the
# sense that it lets users enter some predefined fields and saves the answer
# as a .csv file.  Every submission is saved in its own file, so the results
# must be concatenated together at the end
############################################


# This server side now writes new submissions to the end of a single file 
# rather than individual .csv's.  Results no longer need to be concatenated 
# separately.

library(shiny)
library(digest) # digest() Create hash function digests for R objects
library(Microsoft365R)

formName <- "2022-fall-Capstone-info"
resultsDir <- file.path("data", formName)
dir.create(resultsDir, recursive = TRUE, showWarnings = FALSE)

# names of the fields on the form we want to save
fieldNames <- c("submitTime",
                "firstName",
                "lastName",
                "email",
                "gobyName",
                "gitName",
                "afsc",
                "codeType"
                )

shinyServer(function(input, output, session) {

  # only enable the Submit button when the mandatory fields are validated
  observe({
    if (input$firstName == '' || input$lastName == '' ||
          input$email == '' || input$gitName == '') {
      session$sendCustomMessage(type = "disableBtn", list(id = "submitBtn"))
    } else {
      session$sendCustomMessage(type = "enableBtn", list(id = "submitBtn"))
    }
  })
  
  # the name to show in the Thank you confirmation page
  output$thanksName <- renderText({
    paste0("Thank you ", input$firstName, "!")
  })
  
  # we need to have a quasi-variable flag to indicate when the form was submitted
  output$formSubmitted <- reactive({
    FALSE
  })
  outputOptions(output, 'formSubmitted', suspendWhenHidden = FALSE)

  # show a link to test the GitHub name
  output$gitTest <- renderUI({
    if (input$gitName == '') return(NULL)
    a("Click here to test GitHub name", target = "_blank",
      href = paste0("https://github.com/", input$gitName),
      class = "left-space")
  })
  
  # submit the form  
  observe({
    #if (input$submitConfirmDlg < 1) return(NULL)
    if (input$submitBtn < 1) return(NULL)
    
    # read the info into a dataframe
    isolate(
      infoList <- t(sapply(fieldNames, function(x) x = input[[x]]))
    )
    
    # Add submission time to the data being written to the log
    isolate(
      infoList[1,1] <- format(Sys.time(), "%d.%m.%Y %H:%M")
    )
    
    # generate a file name based on timestamp, user name, and form contents
    isolate(
      fileName <- paste0(
        paste(
          getFormattedTimestamp(),
          input$lastName,
          input$firstName,
          digest(infoList, algo = "md5"),
          sep = "_"
        ),
        ".csv"
      )
    )
    
    write.csv(x = infoList, file = file.path(resultsDir, fileName),
              row.names = FALSE)
    
    
    # Append the results to the existing table
    ### This code chunk writes a response and will have to change
    ### based on where we store persistent data (update the file name)
    
    
    ############# 
    # This statement appends new data to the end of an existing file
    
    #write.table(x = infoList, file = file.path(resultsDir, "Test Data.csv"),
     #  row.names = FALSE, append = TRUE, sep = ",", col.names = FALSE)
    
    #############
    
    
    
    
    ### End of writing data
    
    # indicate the the form was submitted to show a thank you page so that the
    # user knows they're done
    output$formSubmitted <- reactive({ TRUE })
    
    
  })
  
 
})
