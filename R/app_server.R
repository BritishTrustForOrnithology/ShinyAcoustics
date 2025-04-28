#' main server function
#' @import shiny
#' @import shinyFiles
#' @import shinyjs

#' @export

app_server <- function(input, output, session) {

  #SHINYFILES STUFF
  shinyFileChoose(input, 'file_db', roots = volumes, session = session, filetypes=c('sqlite'))
  shinyDirChoose(input, 'path_audio', roots = volumes, session = session, filetypes = c(''))



  # file_database <- reactiveVal(parseFilePaths(volumes, input$file_db))
  # path_audio <- reactiveVal(parseDirPath(volumes, input$path_audio))

  #MODULES


  file_database <- reactiveVal(NULL)
  db_connection <- reactiveVal(NULL)
  observeEvent(input$file_db, {
    # Parse the file path
    fileinfo <- parseFilePaths(volumes, input$file_db)

    # Defensive check: if nothing is selected, don't proceed
    if (nrow(fileinfo) == 0) {
      return()  # Exit quietly
    }

    # Now you can safely use it
    filepath <- as.character(fileinfo$datapath[1])

    # Optionally, double-check
    if (!file.exists(filepath)) {
      showNotification("Selected file does not exist", type = "error")
      return()
    }

    file_database(filepath)
    # Now safe to connect
    db_connection(DBI::dbConnect(RSQLite::SQLite(), filepath))
  })





  path_audio <- reactiveVal(NULL)
  observeEvent(input$path_audio, {
    path_audio(parseDirPath(volumes, input$path_audio))
  })


  #capture the batch parameters
  batch_params <- reactiveValues(
    user = NULL,
    species = NULL,
    location = NULL,
    time = NULL,
    optfield = NULL
  )
  observe({
    batch_params$user <- input$user
    batch_params$species <- input$batch_species
    batch_params$location <- input$batch_location
    batch_params$time     <- input$batch_time
    batch_params$optfield <- input$batch_option
  })



  #create and manage the controls for the current folder
  state_controls <- create_controlsSERVER(id = "controls",
                                          con = db_connection,
                                          batch_params,
                                          path_audio,
                                          start_click = reactive(input$btn_start),
                                          randomise = reactive(input$random_order)
                                          )
















  #OUTPUTS
  output$path_database <- renderText({
    req(input$file_db)
    file_database()
  })

  output$path_audio <- renderText({
    req(input$path_audio)
    path_audio()
  })



  createDbServer("dbcreator")
  exportDbServer("dbexporter", con = db_connection)


}
