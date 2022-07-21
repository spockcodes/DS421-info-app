# Build a consolidated table of submissions

formName <- "2022-fall-Capstone-info"
resultsDir <- file.path("shiny-apps/request-basic-info/data", formName)
  ### This code chunk reads all submitted responses and will have to change
  ### based on where we store persistent data
  infoFiles <- list.files(resultsDir)
  allInfo <- lapply(infoFiles, function(x) {
    read.csv(file.path(resultsDir, x))
  })
  ### End of reading data
  
  #allInfo <- data.frame(rbind_all(allInfo)) # dplyr version
  #allInfo <- data.frame(rbindlist(allInfo)) # data.table version
  allInfo <- data.frame(do.call(rbind, allInfo))
  if (nrow(allInfo) == 0) {
    allInfo <- data.frame(matrix(nrow = 1, ncol = length(fieldNames),
                                 dimnames = list(list(), fieldNames)))
  }
  
  fileName <- paste0(
    paste(
      getFormattedTimestamp(),
      "all_subs",
      sep = "_"
    ),
    ".csv"
  )
  
  write.csv(x = allInfo, file = file.path(resultsDir, fileName),
            row.names = FALSE)

  