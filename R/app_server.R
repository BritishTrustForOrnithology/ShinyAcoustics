#' main server function
#' @import shiny
#' @import shinyFiles
#' @importFrom shinyjs show
#' @importFrom shinyjs hide
#' @importFrom shinyjs enable
#' @importFrom shinyjs disable
#' @import bslib
#' @import ggplot2

app_server <- function(input, output, session) {


  
  
  #SHINYFILES STUFF
  shinyFileChoose(input, 'file_db', roots = volumes, session = session, filetypes=c('sqlite'))
  shinyDirChoose(input, 'path_audio', roots = volumes, session = session)
  shinyDirChoose(input, "dir", roots = volumes, session = session)
  
  selected_dir <- reactiveVal(NULL)
  file_database <- reactiveVal(NULL)
  db_connection <- reactiveVal(NULL)
  

  observeEvent(input$dir, {
    dir_path <- parseDirPath(volumes, input$dir)
    selected_dir(dir_path)
  })
  
  observeEvent(input$trigger_dir, {
    # Programmatically click the hidden dir button
    session$sendCustomMessage("clickDirChooser", "dir")
  })
  
  observeEvent(input$btn_create_db, {
    req(selected_dir(), input$new_db_filename)
    outcome <- database_create(path_db = selected_dir(), name_db = input$new_db_filename)

    if(outcome==0) {
      showNotification("Database already exists, cannot overwrite. Please try again!", type = "error")
    }
    if(outcome==1) {
      #register and connect this new db
      filepath <- file.path(selected_dir(), input$new_db_filename)
      print(filepath)
      file_database(filepath)
      db_connection(DBI::dbConnect(RSQLite::SQLite(), filepath))
      showNotification("Database created and connected. Ready to start verification", type = "message")
    }
  })
  


  
  observeEvent(input$btn_db_popup, {
    showModal(modalDialog(
      title = "Create new database",
      tags$p("Create an empty database ready to hold verification decisions."),
      
      actionButton("trigger_dir", "Choose directory", class = "btn-primary"),
      
      textInput(
        inputId = "new_db_filename",
        label = "Database filename (must have .sqlite extension):",
        value = "verification.sqlite"
      ),
      
      actionButton("btn_create_db", "Create database", class = "btn-primary")
    ))
  })
    
   
  


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
    showNotification("Database connected, ready to start verification", type = "message")
  })





  path_audio <- reactiveVal(NULL)
  observeEvent(input$path_audio, {
    path_audio(parseDirPath(volumes, input$path_audio))
  })


  #validate the batch parameters
  observeEvent(input$batch_validate, {
    success <- 1
    message <- 'Before you can proceed you must:'
    if(is.null(file_database() )) {
      success <- 0
      message <- paste(message,("<br>- create or select a results database."))
    }
    if(!nzchar(input$user)) {
      success <- 0
      message <- paste(message,("<br>- enter your name."))
    }
    if(!nzchar(input$batch_species)) {
      success <- 0
      message <- paste(message,("<br>- select a species (or select None)."))
    }
    if(!nzchar(input$batch_location)) {
      success <- 0
      message <- paste(message,("<br>- enter a location (or NA)."))
    }
    if(!nzchar(input$batch_time)) {
      success <- 0
      message <- paste(message,("<br>- enter a time period (or NA)."))
    }
    if(success == 0) {
      showNotification(HTML(message), type = "error")
    } else {
      bslib::accordion_panel_open(id = "acc", value = "verify")
    }
  })
  
  #capture the batch parameters
  batch_params <- reactiveValues(
    user = NULL,
    species = NULL,
    location = NULL,
    time = NULL,
    notes = NULL
  )
  observe({
    batch_params$user <- input$user
    batch_params$species <- input$batch_species
    batch_params$location <- input$batch_location
    batch_params$time     <- input$batch_time
    batch_params$notes <- input$batch_notes
  })



  #create and manage the controls for the current folder
  state_controls <- create_controlsSERVER(id = "controls",
                                          file_database,
                                          con = db_connection,
                                          batch_params,
                                          path_audio,
                                          start_click = reactive(input$btn_start),
                                          randomise = reactive(input$random_order),
                                          blind = reactive(input$hide_wavname)
                                          )
















  #OUTPUTS
  output$path_database <- renderText({
    req(file_database())
    file_database()
  })

  output$path_audio <- renderText({
    req(input$path_audio)
    path_audio()
  })


  #UTILITIES MODULES
  #createDbServer("dbcreator")
  exportDbServer("dbexporter", con = db_connection)


}
