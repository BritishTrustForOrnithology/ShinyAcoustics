#' main server function
#' @import shiny
#' @import shinyFiles
#' @importFrom shinyjs show
#' @importFrom shinyjs hide
#' @importFrom shinyjs enable
#' @importFrom shinyjs disable
#' @import bslib
#' @import ggplot2

app_verifier_simple_server <- function(input, output, session) {

  #SHINYFILES STUFF
  shinyDirChoose(input, 'path_audio', roots = volumes, session = session)

  #capture the path for audio, either from button press, or from manual text field
  path_audio <- reactiveVal(NULL)
  observeEvent(input$path_audio, {
    req(input$path_audio)
    parsed <- tryCatch({
      shinyFiles::parseDirPath(volumes, input$path_audio)
    }, error = function(e) NULL)
    if (!is.null(parsed)) {
      path_audio(parsed)
    }
  })
  # Update when a manual path is entered
  observeEvent(input$path_audio_str, {
    req(nzchar(input$path_audio_str))  # ensure it's not empty
    #fix slashes
    cleaned_path <- chartr("\\", "/", input$path_audio_str)
    path_audio(cleaned_path)
  })
  
  #create and manage the controls for the current folder
  state_controls <- create_controls_simpleSERVER(id = "controls",
                                          path_audio,
                                          start_click = reactive(input$btn_start),
                                          randomise = reactive(input$random_order),
                                          blind = reactive(input$hide_wavname)
  )
  
  #OUTPUTS
  output$path_audio <- renderText({
    req(input$path_audio)
    path_audio()
  })
}
