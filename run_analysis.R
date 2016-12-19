##
## Coursera "Getting and Cleaning Data Course Project"
## Jorge Barrientos
## Script name: run_analysis.R
##
## Prerequisites: To run this script you need to download the following zip file: 
## https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
## When the zip was downloaded please unzip it and copy the directory "UCI HAR Dataset" 
## inside your working directory in R 
##
## Description: This script works with test and training data included in the zip file, to generate the 
## following:
##      1 - Merge the test and training data sets in one
##      2 - Extracts only the measures on the mean and standard deviation for each measurement
##      3 - Descriptive activity names are used in the output datasets
##      4 - Data labels are named with descriptive variable names
##      5 - A second dataset is generated from the merged one, group by activity and subject
##      6 - Both datases are saved as text files, mergedData.txt the first one and meanData.txt the grouped one
##
## Begin of the script
# Clean the environment
rm(list=ls())
# Features 
features <- read.table("features.txt")
# Features colnames
featuresCols <- features[,2]
# Remove parenthesis
featuresCols <- gsub("[()]","",featuresCols)

# Activity Labels
activityLabels <- read.table("./activity_labels.txt")
# Set column names
colnames(activityLabels) <- c("ActivityId", "Activity")

# Paths to files to merge 
paths <- c("test","train")

merged <- list()

# A loop is used, so the files distribution is similar, only change if it is test or training
for(path in paths)
{
        # Dataset for subjects
        subjects <- read.table(paste("./",path,"/subject_",path,".txt", sep = ""))
        # Dataset for each measure
        x <- read.table(paste("./",path,"/X_",path,".txt", sep = ""))
        # Dataset for activity Id's
        y <- read.table(paste("./",path,"/Y_",path,".txt", sep = ""))
        
        # Set column names in observations
        colnames(x) <- featuresCols
        # Set column name in activities dataset
        colnames(y) <- c("ActivityId")
        # To get the activity description
        activities <- merge(y, activityLabels, by = "ActivityId", all.x = TRUE)
        colnames(activities)[2] <- c("Activity")
        
        colnames(subjects) <- c("SubjectId")
        
        # Remove columns that aren't .*mean.* | .*std.*
        colsToPreserve <- grep(".*std.*|.*mean.*", featuresCols)
        x <- x[colsToPreserve]
        
        # Datasets binding (Subjects + Activities + Observations)
        data <- cbind(subjects, activities$Activity, x)
        
        # Set column name for the 2nd one
        colnames(data)[2] <- "Activity"
        
        # Row binding to the list
        
        merged <- rbind(merged, data)
        
}

# Appropriate Column names 
cols <- colnames(merged)
cols <- gsub("^f", "",cols)
cols <- gsub("^t", "",cols)
cols <- gsub("mean", "Mean", cols)
cols <- gsub("std", "Std", cols)
cols <- gsub("BodyBody", "Body", cols)
cols <- gsub("-", "",cols )
# Set column names to the dataset
colnames(merged) <- cols

# Mean calculate group by Subject Id and Activity 
meanData <- aggregate(merged[, 3:length(cols)], list(merged$SubjectId, merged$Activity), mean)
# Setting column names for the grouped dataset
colnames(meanData)[1:2] <- c("Subject", "Activity")
# Order by activity
meanData[order(meanData$Activity)]
# Text files generation
write.table(merged, file = "mergedData.txt", row.names = FALSE, quote = FALSE)
write.table(meanData, file = "meanData.txt", row.names = FALSE, quote = FALSE)