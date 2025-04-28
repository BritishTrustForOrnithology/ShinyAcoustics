#' A module to add controls like nav buttons for the spectrogram part of the app
#'
#' @param id, id
#'

create_controlsUI <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(
      textOutput(ns("n_files")),
      div(
        style="text-align:center;",
        actionButton(inputId = ns("btn_first"),
                     label = div(icon('caret-left', verify_fa=FALSE), "First"),
                     style="margin-top:10px; margin-bottom:10px; background-color: green; color: white;"),
        actionButton(inputId = ns("btn_previous"),
                     label = div(icon('angle-left', verify_fa=FALSE), "Previous"),
                     style="margin-top:10px; margin-bottom:10px; background-color: green; color: white;"),
        actionButton(inputId = ns('btn_next'),
                     label = div("Next", icon('angle-right', verify_fa=FALSE)),
                     style="margin-top:10px; margin-bottom:10px; background-color: green; color: white;"),
        actionButton(inputId = ns('btn_last'),
                     label = div("Last", icon('caret-right', verify_fa=FALSE)),
                     style="margin-top:10px; margin-bottom:10px; background-color: green; color: white;")
      ),
    ), #endFR


    fluidRow(
      id = ns('main'),
      #left column
      column(
        width = 6,
        plotOutput(
          ns("spec"), height = "400px", width = "600px",
          #inline = TRUE
          )
      ),
      #right column
      column(
        width = 6,
        fluidRow(
          uiOutput(outputId = ns('player'))
        ),
        fluidRow(
          tags$p('Enter one or more species names or codes...')
        ),
        fluidRow(
          column(
            width = 6,
            selectizeInput(
              inputId = ns('select_label'),
              label = NULL,
              choices = c("", splist$select_val),
              #choices = splist$select_val,
              multiple = TRUE,
              options = list(placeholder = "Start typing...")
            ),
            uiOutput(ns("recentLabelsUI")),
          ),
          column(
            width = 6,
            actionButton(
              inputId = ns('btn_submit'),
              class = "btn-primary",
              #icon = icon('plus', verify_fa = FALSE),
              label = "Submit",
              style = "width: 150px; height: 33.6px; padding: 0; line-height: 33px",
            ),
            actionButton(
              inputId = ns('btn_submit4train'),
              class = "btn-primary",
              #icon = icon('plus', verify_fa = FALSE),
              label = "Submit+Train",
              style = "width: 150px; height: 33.6px; padding: 0; line-height: 33px",
            )
          )
        ),
        # fluidRow(
        #   tags$p("Or use select one of the following general categories:"),
        #   uiOutput(ns("validation_buttons"))
        # ),
        # fluidRow(
        #   id = ns('row_undo_button'),
        #   actionButton(
        #     inputId = ns('btn_undo'),
        #     class = "btn-danger",
        #     label = div('Undo last submission', icon('rotate-left', verify_fa = FALSE)),
        #     style = "width: 300px; margin-top:10px; text-align: center;"
        #   )
        # )

      ) #end right column
    ) #end fluidRow


  )
}
