exportDbServer <- function(id, con) {
  moduleServer(id, function(input, output, session) {

    shinyFileChoose(input, 'db2export', roots = volumes, session = session, filetypes=c('sqlite'))
    selected_db <- reactiveVal(NULL)

    observeEvent(input$db2export, {
      db_path <- parseFilePaths(volumes, input$db2export)
      selected_db(db_path$datapath)
    })

    observeEvent(input$export_db_btn, {
      req(selected_db())
      outcome <- database_export(con, file_db = selected_db())
      if(outcome==0) showNotification("Database does not exists", type = "message")
      if(outcome==1) showNotification("Database exported!", type = "message")
    })
  })
}
