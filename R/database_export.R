#' export database
#'
#' @import RSQLite
#' @import DBI
#'
#' @param con = database connection object
#' @param file_db = reactive object giving path and name of database 
database_export <- function(con, file_db) {

  #get the data
  con <- dbConnect(DBI::dbConnect(RSQLite::SQLite(), file_db))
  df <- dbGetQuery(con, paste0("SELECT * FROM verifications"))
  dbDisconnect(con)
  now <- format(Sys.time(), "_exported_%Y%m%d_%H%M%S")
  file_csv <- gsub('.sqlite', paste0(now,'.csv'), file_db)
  write.csv(df, file_csv, row.names = FALSE)
  return(1)
}
