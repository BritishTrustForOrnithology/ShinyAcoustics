#' Toggle enable/disable of nav buttons depending on state
#' 
#' @description Toggle enable/disable feature of navigation buttons
#' @param numfiles = the total number of audio files
#' @param nthfile = which file is currently active
#' 
#' @importFrom shinyjs enable
#' @importFrom shinyjs disable
#' 
nav_button_toggles <- function(numfiles, nthfile) {
  if(nthfile==1) shinyjs::disable('btn_first') else shinyjs::enable('btn_first')
  if(nthfile==1) shinyjs::disable('btn_previous') else shinyjs::enable('btn_previous')
  if(nthfile==numfiles) shinyjs::disable('btn_last') else shinyjs::enable('btn_last')
  if(nthfile==numfiles) shinyjs::disable('btn_next') else shinyjs::enable('btn_next')
}