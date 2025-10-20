#' run the full verification app
#' 
#' @import shiny
#' 
#' @param audiodirs = named list providing alternative drives and shortcuts to audio directories
#' 
#' @export


run_clip_verifier <- function(audiodirs=NULL) {

  #get the drive letters
  if(!is.null(audiodirs)) volumes <<- audiodirs
  if(is.null(audiodirs)) {
    volumes <<- shinyFiles::getVolumes()()
    volumes <<- c(volumes, "Home" = fs::path_home(), "R Project" = getwd())
  }
  
  #register the www path for images and css
  shiny::addResourcePath("www", 
                         system.file("www", package = "ShinyAcoustics"))
  
  shiny::shinyApp(ui = app_verifier_full_ui, 
                  server = app_verifier_full_server, 
                  options = list(launch.browser=TRUE))
}
