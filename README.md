# Getting and cleaning data - Course Project
This work is a pre-grade assignment from the "Getting and Cleaning Data" Course from Coursera. In this repository you will find an R script named run_analysis.R.
#Prerequisites
To run this script you need to download the following zip file: 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

When the zip was downloaded please unzip it and copy the directory "UCI HAR Dataset" 
inside your working directory in R.

#Description
This script works with test and training data included in the zip file, to generate the following:
* Merge the test and training data sets in one
* Extracts only the measures on the mean and standard deviation for each measurement
* Descriptive activity names are used in the output datasets
* Data labels are named with descriptive variable names
* A second dataset is generated from the merged one, group by activity and subject
* Both datases are saved as text files, mergedData.txt the first one and meanData.txt the grouped one
