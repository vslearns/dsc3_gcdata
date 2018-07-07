if (!file.exists("UCI HAR Dataset")) stop("UCI HAR Dataset folder is missing! Did you download and unzip the data?")
message("Found data directory, starting analysis.")

library(data.table)
DF <- data.frame(matrix(ncol = 3, nrow = 0))
colnames(DF) <- c("measurement", "activity", "value")

test_table <- fread("UCI HAR Dataset/test/X_test.txt")
train_table <- fread("UCI HAR Dataset/train/X_train.txt")
feats_table <- fread("UCI HAR Dataset/features.txt")
actlab_table <- fread("UCI HAR Dataset/activity_labels.txt")

#print(head(feats_table[grep("(.*)(mean|std)(.*)", feats_table$V2)]$V2))

table <- rbindlist(list(test_table, train_table), use.names = TRUE, fill=FALSE, id=TRUE)

#stop("Paused.")

message("Calculating means and standard deviations...")
for (i in 1:ncol(table)) {
  if (i == 500) message("Row 500...")
  if (i == 1000) message("Row 1000...")
  if (i == 1500) message("Row 1500...")
  if (i == 2000) message("Row 2000...")
  if (i == 2500) message("Row 2500...")
  if (i == 3000) message("Row 3000...")
  
  mean = mean(table[[i]])
  sd = sd(table[[i]])
  
  if(length(grep("(.*)(mean|std)(.*)", feats_table[i]$V2)) == 0) next
  
  stop("Paused inside for-loop.")
  
  for (j in 1:nrow(table)) {
    rowdata <- data.frame(grep("(.*)(mean|std)(.*)", feats_table[i]$V2, value=TRUE), actlab_table[j]$V2, table[j, paste("V", i, sep="")])
    names(rowdata) <- c("measurement", "activity", "value")
    
    DF <- rbind(DF, rowdata)
    
    print(DF)
    
    #stop("Paused inside internal for-loop.")
  }
  
  stop("Paused after internal for-loop.")
}

message(paste("Finished reading", i, "rows."))
rm(i, mean, sd)

print((DF))