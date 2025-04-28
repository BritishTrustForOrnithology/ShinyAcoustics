library(DBI)
library(RSQLite)


#module for controls
create_controlsSERVER <- function(id,
                                  con,
                                  batch_params,
                                  path_audio,
                                  start_click,
                                  randomise
                                  ) {
  moduleServer(id, function(input, output, session) {


    # Create a container for all reactive state
    state <- reactiveValues(
      audio_files = NULL,
      n_files = NULL,
      file_counter = NULL,
      file_current = NULL
    )

    #on click, get list of audio files, set index to first file
    observeEvent(start_click(), {
      req(path_audio())

      # list .wav files
      state$audio_files <- list.files(path_audio(), pattern = "\\.wav$", full.names = FALSE)
      state$n_files <- length(state$audio_files)
      state$file_counter <- NULL
      state$file_current <- NULL

      # print(state$n_files)

      #randomise file order?
      if(randomise() == TRUE & state$n_files>0) {
        state$audio_files <- sample(state$audio_files, size = state$n_files)
      }


      if(state$n_files==0) {
        showNotification("No wav files in selected directory!", type = "message")
        # shinyalert(title = "Error",
        #            text = "No audio files at this location",
        #            type = "error",
        #            callbackR = message('Callback: No such path for audio')
        # )
      } else {
        addResourcePath("audio", path_audio())
        state$file_counter <- 1
        nav_button_toggles(numfiles = state$n_files,
                           nthfile = state$file_counter)
        state$file_current <- state$audio_files[state$file_counter]
        # print(state$file_counter)
        # print(state$file_current)
      }
    })


    #observers for the file navigation buttons
    # Navigation buttons
    observeEvent(input$btn_first, {
      req(state$n_files)
      state$file_counter <- 1
      state$file_current <- state$audio_files[state$file_counter]
      nav_button_toggles(numfiles = state$n_files, nthfile = state$file_counter)
    })

    observeEvent(input$btn_previous, {
      req(state$n_files)
      state$file_counter <- max(1, state$file_counter - 1)
      state$file_current <- state$audio_files[state$file_counter]
      nav_button_toggles(numfiles = state$n_files, nthfile = state$file_counter)
    })

    observeEvent(input$btn_next, {
      req(state$n_files)
      state$file_counter <- min(state$file_counter + 1, state$n_files)
      state$file_current <- state$audio_files[state$file_counter]
      nav_button_toggles(numfiles = state$n_files, nthfile = state$file_counter)
    })

    observeEvent(input$btn_last, {
      req(state$n_files)
      state$file_counter <- state$n_files
      state$file_current <- state$audio_files[state$file_counter]
      nav_button_toggles(numfiles = state$n_files, nthfile = state$file_counter)
    })




    # Reactive to load and prepare the wav
    wav_data <- reactive({

      req(path_audio(), state$file_current)

      file1 <- file.path(path_audio(), state$file_current)
      if (!file.exists(file1)) {
        validate(need(FALSE, "Audio file not found"))
      }

      wavdata <- tryCatch(
        {
          audio::load.wave(file1)
        },
        error = function(e) {
          message("audio::load.wave failed, attempting tuneR::readWave...")
          tryCatch(tuneR::readWave(file1), error = function(e2) NULL)
        }
      )

      if (is.null(wavdata)) {
        validate(need(FALSE, "Cannot load audio file"))
      }

      # unpack
      if (inherits(wavdata, "Wave")) {
        signal <- wavdata@left
        sr <- wavdata@samp.rate
      } else {
        signal <- wavdata
        sr <- signal$rate
        if (!is.null(dim(signal))) {
          signal <- apply(signal, 2, mean)
        }
      }


      req(length(signal) > 0)
      req(sr > 0)

      clip_duration <- length(signal) / sr
      if (clip_duration > 10) {
        validate(need(FALSE, "Clip too long to plot"))
      }

      # Return a *list* of processed results
      list(signal = signal, sr = sr)
    })



    output$spec <- renderPlot({

      wav <- wav_data()  # reactively pull it

      if (is.null(wav)) {
        # Plot a dummy placeholder
        #par(mar = c(0,0,2,0))
        plot.new()
        frame()  # Ensure the frame is initialized
        title(main = "Waiting for audio...select audio folder and press Start", cex.main = 2)
        #return()
      } else {

        signal <- wav$signal
        sr <- wav$sr
        spec_fast(
          signal = signal,
          sr = sr,
          window_size = 1024,
          overlap = 0.75,
          theme = 'Viridis',
          ylim = c(0, 10000)
        )
      }


    })





    #create the audio player
    output$player <- renderUI({
      req(state$file_current)

      tags$audio(src = file.path( 'audio/', state$file_current ),
                 controls=NA,
                 type='audio/wav')
    })

    # Store recent labels
    recent_labels <- reactiveVal(character(0))


    # When user clicks "Add to Table"
    # observeEvent(input$btn_submit, {
    #   req(state$file_current)
    #   req(input$select_label)
    #
    #   #get the codes for these species
    #   selected_species <- subset(splist, select_val %in% input$select_label)
    #   #construct the label string
    #   label <- paste0('[',paste0("'", selected_species$code, "'", collapse = ','), ']')
    #
    #
    #   #create the database row content
    #   db_row_data <- list(batch_params$user,
    #                       batch_params$species,
    #                       batch_params$location,
    #                       batch_params$time,
    #                       file.path(path_audio(), state$file_current),
    #                       label,
    #                       FALSE,
    #                       Sys.time())
    #
    #   #add the decision to the database
    #   rs <- dbSendQuery(con(), 'INSERT INTO verifications (name_validator, batch_species, batch_location, batch_time, file_audio, identity, for_training, timestamp) VALUES (?, ?, ?, ?, ?, ?, ?, ?);', db_row_data)
    #   #clear the returned set to free memory
    #   dbClearResult(rs)
    #
    #   # Update recent labels (max 5)
    #   new_label <- input$select_label
    #   if (nzchar(new_label)) {
    #     updated <- unique(c(new_label, recent_labels()))
    #     recent_labels(head(updated, 5))  # Keep only last 5 unique
    #   }
    #   #clear form
    #   updateSelectizeInput(session, "select_label", selected = "")
    # })
    #

    observeEvent(input$btn_submit, {
      submit_decision(
        state = state,
        input = input,
        session = session,
        splist = splist,
        batch_params = batch_params,
        path_audio = path_audio,
        con = con,
        recent_labels = recent_labels,
        for_training = FALSE
      )
    })

    observeEvent(input$btn_submit4train, {
      submit_decision(
        state = state,
        input = input,
        session = session,
        splist = splist,
        batch_params = batch_params,
        path_audio = path_audio,
        con = con,
        recent_labels = recent_labels,
        for_training = TRUE
      )
    })


    observe({
      lapply(seq_along(recent_labels()), function(i) {
        observeEvent(input[[paste0("recent_label_", i)]], {
          updateSelectizeInput(session, "select_label", selected = c(isolate(input$select_label), recent_labels()[i]))
        }, ignoreInit = TRUE)
      })
    })

    output$recentLabelsUI <- renderUI({
      labels <- recent_labels()
      if (length(labels) == 0) return(NULL)

      tags$div(
        tags$h5("Recent Labels:"),
        lapply(seq_along(labels), function(i) {
          actionButton(
            inputId = session$ns(paste0("recent_label_", i)),
            label = labels[i],
            class = "btn-secondary btn-sm m-1"
          )
        })
      )
    })

    return(state)
  })
}
