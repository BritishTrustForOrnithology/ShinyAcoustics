# ShinyAcoustics

ShinyAcoustics is an R package that deploys local Shiny web applications to 
facilitate the verification and labelling of audio files to support passive acoustic 
monitoring project. The Clip Verification app allows users to view and play 
individual short audio clips and make decsions about their contents. A simple use
case would be to have a folder of clips that an automated process has identified 
as containing species X, and the app allows for efficient checking of those clips 
to mark them as True or False. Results are saved in a local sqlite database and 
can be exported to csv format. Options are provided to add metadata such as 
location and time period for downstream use.

Note, although this package is executed in the R statistical software, no prior 
knowledge of R is required and once the app is loaded, all interactions are done 
in a web browser.

# Installation

1. For users not familiar with R, following steps here to install the R software: 
2. Start the R programme. At the command prompt paste the following command to install the ShinyAcoustics package: 

devtools::install_github("https://github.com/BritishTrustForOrnithology/ShinyAcoustics")

You may be prompted to update existing packages, if so select 1 (All). RStudio should then update these and install any other dependencies.



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