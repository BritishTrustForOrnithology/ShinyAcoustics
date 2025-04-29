#' @import shiny
#' @import shinyFiles
#' @import bslib
#' @import bsicons
#' @import shinyWidgets
#' @import shinyjs

#' @export

app_ui <- function() {
  data("splist")


  page_fluid(
    shinyjs::useShinyjs(),
    # Initialize shinyjs
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "www/styles.css"),
      tags$head(
        tags$style(HTML(".card-body { overflow: visible !important; }  "))
      )
    ),

    #add the banner, logo and title
    ui_title_panel(app_title = 'Clip validator'),


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
            card_header(class = "bg-dark", 'Step 1: Name of validator'),
            card_body(
              textInput(
                inputId = 'user',
                label = NULL,
                value = '',
                placeholder = 'Enter your name'
              )
            )
          ),
          #card
          card(
            card_header(
              class = "bg-dark",
              'Step 2: Results location'
            ),
            card_body(
              fluidRow(
                column(
                  width = 4,
                  shinyFilesButton(
                    id = 'file_db',
                    label = 'Select database',
                    title = 'Select sqlite database file',
                    multiple = FALSE,
                    class = "btn-primary"
                  )
                ),
                column(
                  width = 8,
                  div(
                    style = "color: #A42A04; font-weight: bold; font-size: small",
                    textOutput('path_database')
                  )
                )
              )
            )
          ) #card
        ), #layout_columns

        layout_columns(card(
          card_header(class = "bg-dark", 'Step 3: Parameters for this batch'),
          card_body(
            tags$p("Complete relevant parameters (or enter NA) for this batch. These will be stored with verification decisions for later analysis"),
            fluidRow(
              column(
                width = 3,
                selectizeInput(
                  inputId = 'batch_species',
                  label = 'Species:',
                  choices = c("None", splist$select_val),
                  multiple = FALSE,
                  options = list(placeholder = "Start typing...",
                                 dropdownParent = 'body'),
                  selected = 'None'
                ),
              ),
              column(
                width = 3,
                textInput(inputId = 'batch_location', label = 'Location:', value = 'NA'),
              ),
              column(
                width = 3,
                textInput(inputId = 'batch_time', label = 'Time period:', value = 'NA'),
              ),
              column(
                width = 3,
                textInput(inputId = 'batch_notes', label = 'Notes:', value = 'NA')
              )
            ),#end FR
            fluidRow(
              column(
                width = 11
                ),
              column(
                width = 1,
                actionButton(inputId = 'batch_validate', label = 'Next', class = "btn-primary")
              ),
            )
          ) #end cb
        ) #end c),
      ), #end cl
    ),  #end accordion_panel

        accordion_panel(
          value = 'verify',
          title = htmltools::HTML(
            '<span style="font-size:28px; font-weight:bold;">Verify</span>'
          ),

          layout_columns(
            card(
              card_header(
                class = "bg-dark",
                'Step 4 - Audio folder choice'
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
                      )
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
                      inputId = 'show_filename',
                      label = 'Show file name',
                      value = FALSE
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

          #add the controls UI module
          create_controlsUI("controls"),



      ), #end accordion_panel
      accordion_panel(
        value = 'utils',
        title = htmltools::HTML(
          '<span style="font-size:28px; font-weight:bold;">Utilities</span>'
        ),
        fluidRow(
          column(
            width = 3,
            createDbUI("dbcreator")
          ), #end col
          column(
            width = 3,
            exportDbUI("dbexporter")
          ) #end col
        ) #end fr
      ) #end ap
    ) #end accordion
  ) #end page_fluid
}
