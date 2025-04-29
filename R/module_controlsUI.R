#' A module to add controls like nav buttons for the spectrogram part of the app
#'
#' @param id, id
#'

create_controlsUI <- function(id) {
  ns <- NS(id)

  tagList(
    fluidRow(
      column(
        width = 3,
        div(
          style = "color: #A42A04; font-weight: bold; font-size: small",
          textOutput(ns("n_files"))
        ),
      ),
      column(
        width = 4,
        uiOutput(ns('nav_buttons'))
      ),
      column(
        width = 5,
        div(
          style = "color: #A42A04; font-weight: bold; font-size: small",
          textOutput(ns('wav_name'))
        )
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
              style = "width: 120px; height: 30px; margin: 50px 5px 10px; line-height: 15px; padding: 0; background-color: orange;",
              ),
            actionButton(
              inputId = ns('btn_submit4train'),
              class = "btn-primary",
              #icon = icon('plus', verify_fa = FALSE),
              label = "Submit+Train",
              style = "width: 120px; height: 30px; margin: 0px 5px 10px; line-height: 15px; padding: 0; background-color: orange;",
              ),
            actionButton(
              inputId = ns('btn_undo'),
              class = "btn-danger",
              label = div('Undo', icon('rotate-left', verify_fa = FALSE)),
              style = "width: 120px; height: 30px; margin: 50px 5px 10px; line-height: 15px; padding: 0;"
              )
            )
          )
        ),
        fluidRow(
          div(
            style = "text-align: center;",
            actionButton(
              inputId = ns('btn_peek'),
              label = 'Plot results',
              class = "btn-primary",
              style = "width: 120px; height: 30px; margin: 50px 5px 10px; line-height: 15px; padding: 0;",
            )
          )
        )
      ) #end right column
    ) #end fluidRow


  )
}
