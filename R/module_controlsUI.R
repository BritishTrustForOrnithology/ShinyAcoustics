#' A module to add controls like nav buttons for the spectrogram part of the app
#'
#' @param id, id
#'

create_controlsUI <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(
      column(
        width = 4,
        textOutput(ns("n_files")),
      ),
      column(
        width = 4,
        uiOutput(ns('nav_buttons'))
        # div(
        #   style="text-align:center;",
        #   actionButton(
        #     inputId = ns("btn_first"),
        #     label = div(icon('caret-left', verify_fa = FALSE), "First"),
        #     style = "margin-top:10px; margin-bottom:10px; background-color: green; color: white; line-height: 15px"
        #   ), actionButton(
        #     inputId = ns("btn_previous"),
        #     label = div(icon('angle-left', verify_fa = FALSE), "Previous"),
        #     style = "margin-top:10px; margin-bottom:10px; background-color: green; color: white; line-height: 15px"
        #   ), actionButton(
        #     inputId = ns('btn_next'),
        #     label = div("Next", icon('angle-right', verify_fa = FALSE)),
        #     style = "margin-top:10px; margin-bottom:10px; background-color: green; color: white; line-height: 15px"
        #   ), actionButton(
        #     inputId = ns('btn_last'),
        #     label = div("Last", icon('caret-right', verify_fa = FALSE)),
        #     style = "margin-top:10px; margin-bottom:10px; background-color: green; color: white; line-height: 15px"
        #   )
        # ),
      ),
      column(
        width = 4,
        renderText(ns('filename'))
      )
    ), #endFR


    fluidRow(
      id = ns('main'),
      #left column
      column(
        width = 7,
        plotOutput(
          ns("spec"), height = "500px", width = "800px"
          )
      ),
      #right column
      column(
        width = 5,
        
        #player row
        fluidRow(
          div(
            style="text-align:center;",
            uiOutput(outputId = ns('player'))
          )
        ),
        
        #standard button row
        fluidRow(
          tags$p('Select one of these standard options:'),
          div(
            style = "text-align: center;",
            actionButton(
              inputId = ns('btn_true'),
              label = 'True',
              class = "btn-primary",
              style = "width: 100px; height: 30px; margin: 0px 5px 10px; padding: 0;"
            ), 
            actionButton(
              inputId = ns('btn_false'),
              label = 'False',
              class = "btn-primary",
              style = "width: 100px; height: 30px; margin: 0px 5px 10px; line-height: 14px; padding: 0;"
            ), 
            actionButton(
              inputId = ns('btn_unknown'),
              label = 'Unknown',
              class = "btn-primary",
              style = "width: 100px; height: 30px; margin: 0px 5px 10px; line-height: 15px; padding: 0;"
              )
            ) #div
          ), #fr
        
        fluidRow(
          column(
            width = 8,
            tags$p('Or enter one or more species names or codes...'),
            selectizeInput(
              inputId = ns('select_label'),
              label = NULL,
              choices = c("", "True", "False", "Unknown", splist$select_val),
              multiple = TRUE,
              options = list(placeholder = "Start typing..."),
              width = "400px"
              ),
            uiOutput(ns("recentLabelsUI")),
          ),
        column(
          width = 4,
          div(
            style = "text-align: center;",
            actionButton(
              inputId = ns('btn_submit'),
              class = "btn-primary",
              #icon = icon('plus', verify_fa = FALSE),
              label = "Submit",
              style = "width: 100px; height: 30px; margin: 50px 5px 10px; line-height: 15px; padding: 0; background-color: orange;",
              ),
            actionButton(
              inputId = ns('btn_submit4train'),
              class = "btn-primary",
              #icon = icon('plus', verify_fa = FALSE),
              label = "Submit+Train",
              style = "width: 120px; height: 30px; margin: 0px 5px 10px; line-height: 15px; padding: 0; background-color: orange;",
              )
            )
          )
        )
        # fluidRow(
        #   column(
        #     width = 6,
        #     selectizeInput(
        #       inputId = ns('select_label'),
        #       label = NULL,
        #       choices = c("", splist$select_val),
        #       #choices = splist$select_val,
        #       multiple = TRUE,
        #       options = list(placeholder = "Start typing...")
        #     ),
        #     uiOutput(ns("recentLabelsUI")),
        #   ),
        #   column(
        #     width = 6,
        #     actionButton(
        #       inputId = ns('btn_submit'),
        #       class = "btn-primary",
        #       #icon = icon('plus', verify_fa = FALSE),
        #       label = "Submit",
        #       style = "width: 150px; height: 33.6px; padding: 0; line-height: 33px",
        #     ),
        #     actionButton(
        #       inputId = ns('btn_submit4train'),
        #       class = "btn-primary",
        #       #icon = icon('plus', verify_fa = FALSE),
        #       label = "Submit+Train",
        #       style = "width: 150px; height: 33.6px; padding: 0; line-height: 33px",
        #     )
        #   )
        # ),
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
