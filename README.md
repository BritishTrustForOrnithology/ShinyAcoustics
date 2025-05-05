# ShinyAcoustics

ShinyAcoustics is an R package that deploys local Shiny web applications to 
facilitate the verification and labelling of audio files to support passive acoustic 
monitoring projects. The Clip Verification app allows users to view and play 
individual short audio clips and make decisions about their contents. A simple use
case would be to have a folder of clips that an automated process has identified 
as containing species X, and the app allows for efficient checking of those clips 
to mark them as True or False (or to label with species). Results are saved in 
a local sqlite database and can be exported to csv format. Options are provided 
to add metadata such as location and time period for downstream use.

Note, although this package is executed in the R statistical software, no prior 
knowledge of R is required and once the app is loaded, all interactions are done 
in a web browser.

# Installation

1. For users not familiar with R, following steps (here)['https://www.stats.bris.ac.uk/R/'] to install the R software.
2. Start the R program using the desktop shortcut or from the start menu. 
3. At the command prompt paste the following command to install the ShinyAcoustics 
package. Note you may be prompted to update existing packages, if so select 1 (All). 
Wait while R updates itself, adds any dependencies of ShinyAcoustics and finally installs the ShinyAcoustics pacakge: 

```
devtools::install_github("https://github.com/BritishTrustForOrnithology/ShinyAcoustics")
```

 



# Running the app

1. Start the R programme.
2. At the command prompt type the following, being sure to capitalise as shown here:

```
library(ShinyAcoustics)
```

3. Once the package has been loaded into memory type the following to start the app:

```
run_clip_verifier()
```

# Tips for using the app to verify audio clips


# Troubleshooting and Issues

If you have any issues with the app please register them here.

# Change log

* v0.1.0 - first version

Simon Gillings