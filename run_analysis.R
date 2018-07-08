check_data_dir <- function() {
  message("Checking data directory.")
  
  if (!file.exists("UCI HAR Dataset") & !file.exists("galaxy.zip")) {
    message("Downloading data directory.")
    
    source_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    dest_file <- "galaxy.zip"
    download.file(source_url, destfile = dest_file, method = "curl")
    
    message("Unzipping data directory.")
    unzip(dest_file)
  } else if (!file.exists("UCI HAR Dataset")) {
    message("Unzipping data directory.")
    unzip(dest_file)
  }
  
  message("Success!\n")
}

load_libs <- function() {
  message("Installing/Loading libraries.")
  
  if (!"dplyr" %in% installed.packages()) install.packages("dplyr")
  if (!"reshape2" %in% installed.packages()) install.packages("reshape2")
  
  library("dplyr")
  library("reshape2")
  
  message("Success!\n")
}

dd.open <- function(filename) {
  message(paste("Opening ", filename, ".", sep=""))
  
  filename <- paste("UCI HAR Dataset", filename, sep="/")
  file_as_table <- read.table(filename, header = FALSE)
  
  message("Success!\n")
  file_as_table
}

feature_descript <- function(dataset) {
  message("Describing features.")
  
  feature_lbl <- dd.open("features.txt")
  
  columns <- gsub("-", "_", feature_lbl$V2)
  columns <- gsub("[^a-zA-Z\\d_]", "", columns)
  
  names(dataset) <- make.names(names = columns, unique = TRUE, allow_ = TRUE)
  
  message("Success!\n")
  dataset
}

activity_descript <- function(dataset) {
  message("Describing activities.")
  
  activity_lbl <- dd.open("activity_labels.txt")
  
  names(dataset) <- "activity"
  dataset$activity <- factor(dataset$activity, levels = activity_lbl$V1, labels = activity_lbl$V2)
  
  message("Success!\n")
  dataset
}

subject_descript <- function(dataset) {
  message("Describing subjects.")
  
  names(dataset) <- "subject"
  
  message("Success!\n")
  dataset
}

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

write <- function(dataset, filename) {
  message(paste("Writing dataset to file ", filename, ".", sep=""))
  write.table(dataset, file = filename, sep = ",", row.names = FALSE)
  message("Success!\n")
}

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
}

run_analysis()