## Synopsis

This is a solution for the "Getting and Cleaning Data" Course Project.

## Files

- run_analysis.R
- CodeBook.md
- Readme.md

### run_analysis.R

This R script generates a tidy dataset out of the original dataset [2] used for the Human Activity Recognition Using Smartphones study [1] and calcualte the average of each variable for each activity and each subject and save it as a CSV File in the working directory. Only the mean and standard deviation variables are used.
If the original Data [2] is not in the working directory, it will be downloaded and unzip automatically.

### CodeBook.md

Description of the 
- variables used in the tidy dataset 
- the data itself and 
- the transformation steps incl. filter and cleaning processes

## Data Source

Human Activity Recognition database built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors

[1] http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
[2] https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## Course Project Task Definition

You should create one R script called run_analysis.R that does the following. 
* Merges the training and the test sets to create one data set.
* Extracts only the measurements on the mean and standard deviation for each measurement. 
* Uses descriptive activity names to name the activities in the data set
* Appropriately labels the data set with descriptive activity names. 
* Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
