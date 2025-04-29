#' Function to submit the verification decision
#'
#' @param for_training, bool, whether the clip should be nominated for training


submit_decision <- function(state, 
                            input, 
                            session, 
                            splist, 
                            batch_params, 
                            path_audio, 
                            con, 
                            recent_labels, 
                            for_training = FALSE) {
  req(state$file_current)
  req(input$select_label)

  # Get the codes for these species
  selected_species <- subset(splist, select_val %in% input$select_label)

  # Construct the label string
  # if(selected_species %in% c('TRUE','FALSE','UNKNOWN')) {
  #   label <- selected_species
  # } else {
    label <- paste0('[', paste0("'", selected_species$code, "'", collapse = ','), ']')
  # }

  # Create the database row content
  db_row_data <- list(
    batch_params$user,
    batch_params$species,
    batch_params$location,
    batch_params$time,
    file.path(path_audio(), state$file_current),
    label,
    for_training,
    Sys.time()
  )

  # Add the decision to the database
  rs <- dbSendQuery(con(), 'INSERT INTO verifications (name_validator, batch_species, batch_location, batch_time, file_audio, identity, for_training, timestamp) VALUES (?, ?, ?, ?, ?, ?, ?, ?);', db_row_data)
  dbClearResult(rs)

  # Update recent labels (max 10)
  new_label <- input$select_label
  if (any(nzchar(new_label))) {
    updated <- unique(c(new_label, recent_labels()))
    recent_labels(head(updated, 10))  # Keep only last n unique
  }

  # Clear form
  updateSelectizeInput(session, "select_label", selected = "")
  
  
  #move file and increment counters etc
  old_loc <- file.path(path_audio(), state$file_current )
  new_loc <- file.path(state$path_checked, state$file_current )
  file.rename(from = old_loc, to = new_loc)
  
  #remove file from list
  state$audio_files <- state$audio_files[state$audio_files != state$file_current]
  #reduce number of files by one
  state$n_files <- state$n_files - 1
  
  #update file_current if still files to check and not on last file in list
  if(state$n_files > 0 & state$file_counter <= state$n_files) {
    state$file_current <- state$audio_files[state$file_counter]
  }
  
  #update file_current if still files to check and on last file in list
  if(state$n_files > 0 & state$file_counter > state$n_files) {
    #must reduce counter by one more to move it back a step to the last remaining file
    state$file_counter <- state$file_counter - 1
    state$file_current <- state$audio_files[state$file_counter]
  }
  #no files left
  if(state$n_files == 0) {
    state$file_counter <- 0
    state$file_current <- NULL
    showNotification("All clips in folder checked!", type = "message")
  }

  #update history
  state$history <- state$history + 1
  
}
