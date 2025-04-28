#' run the main app
#' @import shiny
#' @import shinyFiles

#' @export


run_app <- function() {
  
  #get the drive letters
  volumes <<- shinyFiles::getVolumes()()
  volumes <<- c(volumes, "Home" = fs::path_home(), "R Project" = getwd())
  
  #register the www path for images and css
  shiny::addResourcePath("www", system.file("www", package = "ShinyAcoustics"))
  
  #initialise the app
  shiny::shinyApp(ui = app_ui, server = app_server)
}
