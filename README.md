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

![Screenshot](https://github.com/BritishTrustForOrnithology/ShinyAcoustics/blob/main/www/screengrab_clip_verifier.png)

Note, although this package is executed in the R statistical software, no prior 
knowledge of R is required and once the app is loaded, all interactions are done 
in a web browser.




# Installation

1. For users not familiar with R, following steps [here]('https://www.stats.bris.ac.uk/R/') to install the R software.
2. Start the R program using the desktop shortcut or from the start menu. 
3. At the command prompt paste the following command to install the ShinyAcoustics 
package. Note you may be prompted to update existing packages, if so select 1 (All). 
Wait while R updates itself, adds any dependencies of ShinyAcoustics and finally 
installs the ShinyAcoustics pacakge: 

```
devtools::install_github("https://github.com/BritishTrustForOrnithology/ShinyAcoustics")
```

# Running the app

1. If not already running, start the R program.
2. At the command prompt type the following, being sure to capitalise as shown here:

```
library(ShinyAcoustics)
```

3. Once the package has been loaded into memory type the following to start the app:

```
run_clip_verifier()
```

# Tips for using the app to verify audio clips

1. Enter the name of the verifier.
2. On the first use you will need to create an empty database file to hold your 
verification decisions. It is up to you where this goes and what you name it (but 
the filename must end .sqlite). Verification decisions will be automatically saved 
to this database. You may wish to create different databases for specific projects.
3. Optionally you can set various batch parameters. These are added against all 
verification decisions made in this session. A good use case would be if verifying 
all detections for a particular site or month: setting these here, and changing 
the settings when movingn to a different site or month will make it easier to use 
the results in subsequent analytical steps. 
4. Now you're ready to select a folder containing clips to verify. In the pop-up 
dialogue, navigate and select the folder in the left-hand panel, then press the 
OK button. Do not click in the right-hand panel as this doesn't select anything.
5. By default filenames are hidden and files are randomised to reduced biases 
but you can toggle on/off these as needed.
6. Press Start and you should see a spectrogram of the first clip. You can play 
the sound and then use the buttons to make a decision. For some tasks just simple 
True or False options (followed by Submit) may suffice. For more complex tasks, 
such as to indicate the correct species, you can also add multiple species by 
typing and selecting the species before hitting Submit.
7. If you've been asked to produce clips for classifier training (e.g. very clear 
single-species clips), follow the same procedure as above but press the 
Submit+Train button.
8. When all the clips in the folder have been verified you'll see a popup. Now 
you can move on to the next folder. If you've set batch parameters, remember to 
review these before starting the next batch.


# Troubleshooting and Issues

If you have any problems with the app please add them on the Issues tab at the top of this screen.

# Change log

* v0.1.0 - first version

Simon Gillings
May 2025