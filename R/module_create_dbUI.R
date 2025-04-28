createDbUI <- function(id) {
  ns <- NS(id)
  tagList(card(
    card_header(class = "bg-dark", 'Create database'),
    card_body(
      tags$p('Create an empty database ready to hold verification decisions.'),
      shinyDirButton(
        ns("dir"),
        "Choose directory",
        "Please select a folder",
        class = "btn-primary"
        ),
      div(
        style = "color: #A42A04; font-weight: bold; font-size: small",
        textOutput(ns("dir_display"))
        ),
      textInput(
        ns("filename"),
        "Database filename (must have .sqlite extension):",
        value = "verification.sqlite"
        ),
      actionButton(
        ns("create_db_btn"),
        "Create Database",
        class = "btn-primary"
        )
    )
  ))
}
