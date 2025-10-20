#' run the main app
#' @import shiny
#' 
#' @param version = 'full' or 'simple'
#' 
#' @export


run_clip_verifier <- function(version = 'simple') {
  if(!version %in% c('simple','full')) stop('version must be either simple or full')
  
  #get the drive letters
  volumes <<- shinyFiles::getVolumes()()
  volumes <<- c(volumes, "Home" = fs::path_home(), "R Project" = getwd())
  
  #register the www path for images and css
  shiny::addResourcePath("www", 
                         system.file("www", package = "ShinyAcoustics"))
  
  #initialise the app
  if(version == 'simple') {
    shiny::shinyApp(ui = app_verifier_simple_ui, 
                    server = app_verifier_simple_server, 
                    options = list(launch.browser=TRUE))
  }
  if(version == 'full') {
    shiny::shinyApp(ui = app_verifier_full_ui, 
                    server = app_verifier_full_server, 
                    options = list(launch.browser=TRUE))
  }
}
