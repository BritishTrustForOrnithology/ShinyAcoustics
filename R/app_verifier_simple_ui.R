#' @import shiny
#' @import shinyFiles
#' @import bslib
#@import bsicons
#@import shinyWidgets
#' @importFrom shinyjs useShinyjs

app_verifier_simple_ui <- function() {
  data("splist")


  page_fluid(
    shinyjs::useShinyjs(),
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "www/styles.css"),
      #allow dropdown to overflow card
      tags$style(HTML(".card-body { overflow: visible !important; }  "))
    ),
    
    #add the banner, logo and title
    ui_title_panel(app_title = 'Simple clip verifier'),

    accordion(
      id = 'acc',
      open = 'config',
      multiple = FALSE,
    
      accordion_panel(
        value = 'config',
        title = htmltools::HTML(
          '<span style="font-size:28px; font-weight:bold;">Audit settings</span>'
        ),
        layout_columns(
          card(
            card_header(
              class = "bg-dark",
              'Audio folder choice & blinding options'
            ),
            card_body(
              fluidRow(
                column(
                  width = 3,
                  shinyFiles::shinyDirButton(
                    id = 'path_audio',
                    label = ' Select audio folder',
                    icon = icon('folder-open', verify_fa = FALSE),
                    title = 'Select folder containing original audio files',
                    class = "btn-primary"
                  ),
                  textInput(inputId = 'path_audio_str', label = 'Or, copy-paste path here (use with care!)', width = 600),
                ),
                column(
                  width = 3,
                  div(
                    style = "color: #A42A04; font-weight: bold; font-size: small",
                    textOutput('path_audio')
                  )
                ),
                column(
                  width = 3,
                  checkboxInput(
                    inputId = 'random_order',
                    label = 'Randomise clip order',
                    value = TRUE
                  ),
                  checkboxInput(
                    inputId = 'hide_wavname',
                    label = 'Hide wav name',
                    value = TRUE
                  )
                ),
                column(
                  width = 3,
                  actionButton(
                    inputId = 'btn_start',
                    label = div('Start', icon('play', verify_fa = FALSE)),
                    class = "btn-primary"
                  )
                )
              ) #end FR
            ) #cb
          ) #c
        ), #lc
        
      ), #ap
    ), #a
      
    #add the controls UI module
    create_controls_simpleUI("controls"),
      
  ) #end page_fluid
}
