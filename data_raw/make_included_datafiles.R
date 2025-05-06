#' make included datafiles
#'
library(devtools)

load('data_raw/splist.Rdata')
#output
use_data(splist, overwrite = TRUE)
