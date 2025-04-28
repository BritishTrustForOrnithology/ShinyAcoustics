#' run the main app
#' @import shiny
#' @import shinyFiles

#' @export


run_app <- function(vols) {

  #get the drive letters
  #volumes <<- shinyFiles::getVolumes()()
  #volumes <<- c("Home" = fs::path_home(), "C" = "C:/")
  shiny::addResourcePath("www", system.file("www", package = "ShinyAcoustics"))
  shiny::shinyApp(ui = app_ui, server = app_server)
}
