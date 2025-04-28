exportDbUI <- function(id) {
  ns <- NS(id)
  tagList(card(
    card_header(class = "bg-dark", 'Export database'),
    card_body(
      tags$p('Select the database to export.'),
      shinyFilesButton(
        ns("db2export"),
        label = 'Select database file',
        title = 'Select sqlite database file',
        multiple = FALSE,
        class = "btn-primary"
        ),
      actionButton(
        ns("export_db_btn"),
        "Export Database",
        class = "btn-primary"
        )
    )
  ))
}
