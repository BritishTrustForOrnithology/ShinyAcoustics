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
      tags$p('Click the button below to create a csv extract from the database, in the same folder, with a time-stamped filename.'),
      actionButton(
        ns("export_db_btn"),
        "Export Database",
        class = "btn-primary"
        )
    )
  ))
}
