# Script: run_analysis.R
#
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each
# measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive activity names. 
# 5. Creates a second, independent tidy data set with the average of each
# variable for each activity and each subject.


# Function to read the necessary data files per directory
# Arguments:
# fileset = "test" or "train" represents the test dataset and train dataset
# fcolnames = index vector of the filtered columns
read.and.create <- function(fileset, fcolnames) {
        dirname <- paste0(dataDir, "/", fileset, "/")

        # load activity file for fileset train|test
        dataFile <- paste0(dirname, "y_", fileset, ".txt")
        yData <- read.table(dataFile, header=FALSE, 
                            col.names=c("activityLabelId"))
        
        # load subject file for fileset train|test
        dataFile <- paste0(dirname, "subject_", fileset, ".txt")
        subject <- read.table(dataFile, header=FALSE, 
                              col.names=c("subjectId"))
        
        # load calculated measures for fileset train|test
        dataFile <- paste0(dirname, "X_", fileset, ".txt")
        xData <- read.table(dataFile, header=FALSE)
        colnames(xData) <- featureDF$featureName
        
        # pre-filter the measurements
        xData <- xData[ , fcolnames]
        
        # append the activityId and subjectId columns
        xData$activityLabelId <- yData$activityLabelId
        xData$subjectId <- subject$subjectId
        
        # return the extracted measurements
        cat("finish reading the", paste0(fileset,"ing"), "dataset ...\n")
        xData
}

filename = "tidydataset.txt"
dataDir <- "./UCI HAR Dataset"

cat("Generate a tidy dataset and write it to the file", filename, "!\nPlease wait ...\n")

if(!file.exists(dataDir)){
        cat("Download and unzip data in current working directory:\n", getwd(), "\n...\n")
        temp <- tempfile()
        fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(fileUrl, temp)
        unzip(temp)
        unlink(temp)
        dateDownloaded <- date()
}

# read features file to use it later as column name
featureDF <- read.table(paste0(dataDir, "/", "features.txt"), header=FALSE, 
                        stringsAsFactors=FALSE, 
                        col.names=c("featureId", "featureName"))

# filter only the measurements on the mean and standard deviation
filter.data.cols <- grep("mean\\(\\)|std\\(\\)", featureDF$featureName)

# extract activity labels into a data.frame
activityDF <- read.table(paste0(dataDir, "/", "activity_labels.txt"), header=FALSE, 
                         stringsAsFactors=TRUE,
                         col.names=c("activityLabelId", "activityLabelName"))

# merge/bind test and train dataset by row
data <- rbind(read.and.create("test", filter.data.cols), 
              read.and.create("train", filter.data.cols))

# Appropriately labels the data set with descriptive activity names. 
# not using lowercase because of readability, instead using Camel Case names
data.cols <- colnames(data)
data.cols.n <- gsub("mean\\(\\)", "Mean", data.cols) # mean() to Mean
data.cols.n <- gsub("std\\(\\)", "Std", data.cols.n) # std() to Std
data.cols.n <- gsub("-", "", data.cols.n)            # eliminate hyphen-minus
data.cols.n <- gsub("^f", "freq", data.cols.n)       # f for frequency
data.cols.n <- gsub("^t", "time", data.cols.n)       # t for time
colnames(data) <- data.cols.n

# Uses descriptive activity names to name the activities in the data set
# by using a join/merge
data <- merge(data, activityDF, by="activityLabelId")
data$activityLabelId <- NULL   # activityLabelId not needed anymore

# using the reshape2 package for melting and dcasting
if (!"reshape2" %in% installed.packages()) install.packages(reshape2)
library(reshape2)

# Creates a second, independent tidy data set with the average of each variable
# for each activity and each subject by using melt() and dcast().
# melting the data
m.ids = c("subjectId", "activityLabelName")
m.vars = data.cols.n[1:(length(data.cols.n)-2)]   # all columns except the ids
m.data <- melt(data, id=m.ids, measure.vars=m.vars)

# rebuild the data and calculate the average of each variable for each activity
tidy.data <- dcast(m.data, subjectId + activityLabelName ~ variable, mean)    

# remove melted data out of memory
rm("m.data")

# write tidy.data to file in csv format
write.csv(tidy.data, filename, row.names = FALSE, quote = FALSE)

cat(nrow(tidy.data), "rows written to file", filename, "\nend.\n")

