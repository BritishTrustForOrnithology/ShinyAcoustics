#' run the simple clip verifier app
#' 
#' @import shiny
#' 
#' @param audiodirs = named list providing alternative drives and shortcuts
#' @param choices = optional list to populate verification buttons. Defaults to 
#' True, False and Unknown if not provided
#' 
#' @export
#' @examples
#' run_simple_clip_verifier(audiodirs = c("clips", "E:/myaudio/clips"), choices = c('BT','GT','ST','SG))
#' 

run_simple_clip_verifier <- function(audiodirs=NULL, choices = NULL) {
  
  #get the drive letters
  if(!is.null(audiodirs)) volumes <<- audiodirs
  if(is.null(audiodirs)) {
    volumes <<- shinyFiles::getVolumes()()
    volumes <<- c(volumes, "Home" = fs::path_home(), "R Project" = getwd())
  }
  
  #use default choices if none provided
  if(!is.null(choices)) verification_choices <<- choices
  if(is.null(choices)) verification_choices <<- c('True','False','Unknown')
  
  #register the www path for images and css
  shiny::addResourcePath("www", 
                         system.file("www", package = "ShinyAcoustics"))
  
  shiny::shinyApp(ui = app_verifier_simple_ui, 
                  server = app_verifier_simple_server, 
                  options = list(launch.browser=TRUE))
}
