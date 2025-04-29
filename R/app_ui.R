#' @import shiny
#' @import shinyFiles
#' @import bslib
#' @import bsicons
#' @import shinyWidgets
#' @import shinyjs

app_ui <- function() {
  data("splist")


  page_fluid(
    shinyjs::useShinyjs(),
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "www/styles.css"),
      #allow dropdown to overflow card
      tags$style(HTML(".card-body { overflow: visible !important; }  "))
    ),
    
    #script needed to register the shinyDirButton outside modal
    tags$script(HTML("Shiny.addCustomMessageHandler('clickDirChooser', function(id) {
            document.getElementById(id).click();
          });")
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
          col_widths = c(3,9),
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
              tags$p('Create a new database to hold verification results, or select an existing one:'),
              fluidRow(
                column(
                  width = 3,
                  # Hidden directory chooser outside the modal
                  div(
                    style = "display:none;",
                    shinyDirButton("dir", "Choose directory", "Please select a folder")
                  ),
                  #button to trigger modal popup for db creation
                  actionButton(
                    inputId = 'btn_db_popup',
                    label = 'Create new database',
                    class = 'btn-primary',
                    style = "margin: 5px;"
                  )
                ),
                column(
                  width = 3,
                  shinyFilesButton(
                    id = 'file_db',
                    label = 'Select existing database',
                    title = 'Select sqlite database file',
                    multiple = FALSE,
                    class = "btn-primary",
                    style = "margin: 5px;"
                  )
                ),
                column(
                  width = 6,
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
            tags$p("Complete relevant parameters (or enter NA) for this batch. These will be stored with verification decisions for later analysis."),
            fluidRow(
              column(
                width = 3,
                selectizeInput(
                  inputId = 'batch_species',
                  label = 'Species:',
                  choices = c("Various", splist$select_val),
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
                'Step 4 - Audio folder choice & blinding options'
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
            exportDbUI("dbexporter")
          ) #end col
        ) #end fr
      ) #end ap
    ) #end accordion
  ) #end page_fluid
}
