#' Function to submit the verification decision
#'
#' @param for_training, bool, whether the clip should be nominated for training
#' @export

submit_decision <- function(state, input, session, splist, batch_params, path_audio, con, recent_labels, for_training = FALSE) {
  req(state$file_current)
  req(input$select_label)

  # Get the codes for these species
  selected_species <- subset(splist, select_val %in% input$select_label)

  # Construct the label string
  label <- paste0('[', paste0("'", selected_species$code, "'", collapse = ','), ']')

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

  # Update recent labels (max 5)
  new_label <- input$select_label
  if (any(nzchar(new_label))) {
    updated <- unique(c(new_label, recent_labels()))
    recent_labels(head(updated, 5))  # Keep only last 5 unique
  }

  # Clear form
  updateSelectizeInput(session, "select_label", selected = "")
}
