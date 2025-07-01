#' make included datafiles
#'
library(devtools)
library(BTOTools)

#create the species df that will drive dropdown menus
#should include all taxa plus some other classes like Noise, Human, Vehicle
#two columns, "select_val" contains the values to be shown in the dropdown, "code" contains the value to be written to the DB

data("global_species_lookup")

#limit to species
gsl <- subset(global_species_lookup, taxon_rank_id == 100)

#sort taxonomically
gsl <- gsl[order(gsl$sort_order),]

#format some codes
gsl$pipeline_code <- toupper(gsl$pipeline_code)
gsl$code2ltr <- gsub(".", "_", gsl$code2ltr, fixed = TRUE)
gsl$code5ltr <- gsub(".", "_", gsl$code5ltr, fixed = TRUE)

#create code column
gsl$code <- gsl$code2ltr
gsl$code <- ifelse(is.na(gsl$code), gsl$code5ltr, gsl$code)
gsl$code <- ifelse(is.na(gsl$code), gsl$pipeline_code, gsl$code)


twoletter <- setNames(gsl[!is.na(gsl$code2ltr), c("master_taxon_id", "code2ltr", 'code')], c('master_taxon_id', 'select_val', 'code'))
fiveletter <- setNames(gsl[!is.na(gsl$code5ltr), c("master_taxon_id", "code5ltr", 'code')], c('master_taxon_id', 'select_val', 'code'))
pipelinecode <- setNames(gsl[!is.na(gsl$pipeline_code), c("master_taxon_id", "pipeline_code", 'code')], c('master_taxon_id', 'select_val', 'code'))
ename <- setNames(gsl[!is.na(gsl$code), c("master_taxon_id", "english_name", 'code')], c('master_taxon_id', 'select_val', 'code'))

#append
splist <- rbind(twoletter, fiveletter,pipelinecode, ename)
splist$master_taxon_id <- NULL

#manual non-taxa additions
adds <- data.frame(select_val = c('ZZ','Noise','Human','Vehicle','Insect'),
                   code = c('ZZ','ZZ', 'HUMAN', 'VEHICLE','INSECT'))
splist <- rbind(splist, adds)


#output
use_data(splist, overwrite = TRUE)
