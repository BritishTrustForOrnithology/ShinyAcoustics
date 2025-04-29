#' create an empty SQLite database with a table to hold verification decisions
#'
#' @import RSQLite
#' @import DBI
#'
#' @export

database_create <- function(path_db, name_db = 'verifications.sqlite') {

  #check path exists
  if(!dir.exists(path_db)) stop('path for database does not exist')

  #create path to file
  file_db <- file.path(path_db, name_db)

  if(file.exists(file_db)) {
    return(0)
  }
  if(!file.exists(file_db)) {
    #create database at this location
    vdb <- dbConnect(RSQLite::SQLite(), file_db)

    #make an empty table to hold the decisions
    empty_decisions <- data.frame(name_validator = as.character(NULL),
                                  batch_species = as.character(NULL),
                                  batch_location = as.character(NULL),
                                  batch_time = as.character(NULL),
                                  batch_notes = as.character(NULL),
                                  file_audio = as.character(NULL),
                                  identity = as.character(NULL),
                                  for_training = as.logical(NULL),
                                  timestamp = as.character(NULL))
    dbWriteTable(vdb, "verifications", empty_decisions)

    #close
    dbDisconnect(vdb)

    return(1)
  }
}
