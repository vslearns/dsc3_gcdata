## run_analysis.R
## This script tidies the data provided by the UCI HAR Dataset.
## For a step-by-step walkthrough of how this code works, see https://github.com/vslearns/dsc3_gcdata#walkthrough


## Ensure the data is downloaded and unzipped.
check_data_dir <- function() {
  message("Checking data directory.")
  
  if (!file.exists("UCI HAR Dataset") & !file.exists("ucihardataset.zip")) {
    message("Downloading data directory.")
    
    source_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    dest_file <- "ucihardataset.zip"
    download.file(source_url, destfile = dest_file, method = "curl")
    
    message("Unzipping data directory.")
    unzip(dest_file)
  } else if (!file.exists("UCI HAR Dataset")) {
    message("Unzipping data directory.")
    unzip(dest_file)
  }
  
  message("Success!\n")
}

## Install and load the dplyr and reshape2 packages as necessary.
load_libs <- function() {
  message("Installing/Loading libraries.")
  
  if (!"dplyr" %in% installed.packages()) install.packages("dplyr")
  if (!"reshape2" %in% installed.packages()) install.packages("reshape2")
  
  library("dplyr")
  library("reshape2")
  
  message("Success!\n")
}

## Open filename and return it as a table
dd.open <- function(filename) {
  message(paste("Opening ", filename, ".", sep=""))
  
  filename <- paste("UCI HAR Dataset", filename, sep="/")
  file_as_table <- read.table(filename, header = FALSE)
  
  message("Success!\n")
  file_as_table
}

## Attach adjusted feature names to the dataset column names.
feature_descript <- function(dataset) {
  message("Describing features.")
  
  feature_lbl <- dd.open("features.txt")
  
  columns <- gsub("-", "_", feature_lbl$V2)
  columns <- gsub("[^a-zA-Z\\d_]", "", columns)
  
  names(dataset) <- make.names(names = columns, unique = TRUE, allow_ = TRUE)
  
  message("Success!\n")
  dataset
}

## Attach "activity" names to the dataset column names.
activity_descript <- function(dataset) {
  message("Describing activities.")
  
  activity_lbl <- dd.open("activity_labels.txt")
  
  names(dataset) <- "activity"
  dataset$activity <- factor(dataset$activity, levels = activity_lbl$V1, labels = activity_lbl$V2)
  
  message("Success!\n")
  dataset
}

## Attach "subject" to the dataset column names.
subject_descript <- function(dataset) {
  message("Describing subjects.")
  
  names(dataset) <- "subject"
  
  message("Success!\n")
  dataset
}

## Load the raw dataset and return the mean and standard deviation dataset.
load_data_get_ms <- function() {
  message("Loading data.")
  
  training_set <- dd.open("train/X_train.txt") %>% feature_descript
  training_act <- dd.open("train/y_train.txt") %>% activity_descript
  training_sub <- dd.open("train/subject_train.txt") %>% subject_descript
  
  testing_set <- dd.open("test/X_test.txt") %>% feature_descript
  testing_act <- dd.open("test/y_test.txt") %>% activity_descript
  testing_sub <- dd.open("test/subject_test.txt") %>% subject_descript
  
  message("Success!\n")
  
  message("Creating dirty dataset for all columns.")
  dirty_data <- rbind(cbind(training_set, training_act, training_sub),
                           cbind(testing_set, testing_act, testing_sub))
  message("Success!\n")
  
  message("Creating dirty dataset for mean and standard deviation columns.")
  dirty_ms_data <- select(dirty_data, matches("mean|std"), one_of("subject", "activity"))
  message("Success!\n")
  
  message("Deleting dirty dataset for all columns.")
  rm(dirty_data)
  message("Success!\n")
  
  dirty_ms_data
}

## Tidy the dirty dataset!
tidy <- function(dirty) {
  identifiers <- c("subject", "activity")
  
  message("Melting dirty dataset.")
  melted_data <- melt(dirty, id = identifiers, measure.vars = setdiff(colnames(dirty), identifiers))
  message("Success!\n")
  
  message("Çreating tidy dataset.")
  tidy_data <- dcast(melted_data, subject + activity ~ variable, mean)
  message("Success!\n")
  
  message("Deleting melted dirty dataset.")
  rm(melted_data)
  message("Success!\n")
  
  message("Deleting dirty dataset.")
  rm(dirty)
  message("Success!\n")
  
  tidy_data
}

## Write the dataset to filename.
write <- function(dataset, filename) {
  message(paste("Writing dataset to file ", filename, ".", sep=""))
  write.table(dataset, file = filename, sep = ",", row.names = FALSE)
  message("Success!\n")
}

## Run the script and create a global 'tidy_data' variable.
## Equivalent to a program's 'main' function.
run_analysis <- function() {
  message("Running environment checks...")
  check_data_dir()
  load_libs()
  message("Environment checks complete.\n\n")
  
  message("Running analysis...")
  dirty_dataset <- load_data_get_ms()
  tidy_dataset <- tidy(dirty_dataset)
  
  write(tidy_dataset, "tidy_data.txt")
  write(tidy_dataset, "tidy_data.csv")
  
  message("Analysis complete.")
  
  assign("tidy_data", tidy_dataset, envir = .GlobalEnv)
}

## The only raw executable statement in the entire file. Starts the script.
run_analysis()