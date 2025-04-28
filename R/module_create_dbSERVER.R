createDbServer <- function(id) {
  moduleServer(id, function(input, output, session) {

    shinyDirChoose(input, "dir", roots = volumes)

    selected_dir <- reactiveVal(NULL)

    observeEvent(input$dir, {
      dir_path <- parseDirPath(volumes, input$dir)
      selected_dir(dir_path)
    })

    output$dir_display <- renderText({
      req(selected_dir())
      paste("Selected directory:", selected_dir())
    })

    observeEvent(input$create_db_btn, {
      req(selected_dir(), input$filename)
      outcome <- database_create(path_db = selected_dir(), name_db = input$filename)
      if(outcome==0) showNotification("Database already exists, cannot overwrite. Please try again!", type = "message")
      if(outcome==1) showNotification("Database created!", type = "message")
    })
  })
}
