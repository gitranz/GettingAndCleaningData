## The Study and the original Data

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. 

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

- tBodyAcc-XYZ
- tGravityAcc-XYZ
- tBodyAccJerk-XYZ
- tBodyGyro-XYZ
- tBodyGyroJerk-XYZ
- tBodyAccMag
- tGravityAccMag
- tBodyAccJerkMag
- tBodyGyroMag
- tBodyGyroJerkMag
- fBodyAcc-XYZ
- fBodyAccJerk-XYZ
- fBodyGyro-XYZ
- fBodyAccMag
- fBodyAccJerkMag
- fBodyGyroMag
- fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

- mean(): Mean value
- std(): Standard deviation
- mad(): Median absolute deviation 
- max(): Largest value in array
- min(): Smallest value in array
- sma(): Signal magnitude area
- energy(): Energy measure. Sum of the squares divided by the number of values. 
- iqr(): Interquartile range 
- entropy(): Signal entropy
- arCoeff(): Autorregresion coefficients with Burg order equal to 4
- correlation(): correlation coefficient between two signals
- maxInds(): index of the frequency component with largest magnitude
- meanFreq(): Weighted average of the frequency components to obtain a mean frequency
- skewness(): skewness of the frequency domain signal 
- kurtosis(): kurtosis of the frequency domain signal 
- bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
- angle(): Angle between to vectors.

[Human Activity Recognition Using Smartphones Data Set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

[Data Source](http://archive.ics.uci.edu/ml/machine-learning-databases/00240/)

## Used set of variables and measurements

- mean(): Mean value
- std(): Standard deviation

So only the **mean** and **standard deviation** variables were used for the tidy data set (result of the `run_analysis.R` script)

## Not used Data

* 'Inertial Signals/total_acc_x_train|test.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'.
* 'Inertial Signals/body_acc_x_train|test.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 
* 'Inertial Signals/body_gyro_x_train|test.txt': The angular velocity vector measured by the gyroscope for each window sample.

## Data Transformation in the R script (step by step)

1. If the original Data are not in the Working Directory, the script download the data and unzip it automatically.
2. Read the features.txt file into the featureDF dataframe to use it later as column name for the tidy dataset and use only the mean and std variables
3. Read the activity labels (activity_labels.txt) into the dataframe activityDF
4. For each fileset (the training set and the test set)
	- Read the activity label id file (train/y_train.txt and test/y_test.txt) into the yData dataframe
	- Read the subject id file (train/subject_train.txt and test/subject_test.txt) into the subject dataframe
	- Read the measurements file (train/X_train.txt and test/X_test.txt) into the xData dataframe
	- Assign the featureDF as column names of the measurement dataframe
	- subset only the mean and standard deviation columns of the measurement dataframe using the filtered featureDF (save memory)
	- add the activity label id and the subject id to the xData
	- all this substeps are realized by the read.and.create() function
5. Merge respectively bind the training and test set by row
6. Beautify the column names by using the [CamelCase Syntax](http://en.wikipedia.org/wiki/CamelCase "CamelCase@Wiki")
	- eliminate parentheses
	- eliminate hyphen-minus
	- replace 't' at the beginning of the column name with 'time' (meaning time domain)
	- replace 'f' at the beginning of the column name with 'freq' (meaning frequency domain)
7. Join the measurements dataframe xData with the activityDF by activity label id (corresponds to `SELECT * FROM xData, activityDF WHERE xData.activityLabelId = activityDF.activityLabelId`)
8. Melting the data with the melt() function in the reshape2 package (if not installed, the script will download and install the package) by the two id variables subjectId and activityLabelName
9. Calculate the average of each measure variable for each activity and each subject and rebuild the tidy data with the dcast() function (also part of the reshape2 package)
10. Delete the melted dataframe (no use anymore)
11. Write the tidy dataset to the working directory ("tidydataset.txt") using a comma separated file format with no string quotes.

## Variables in the tidy dataset

* subjectId ... Subject ID of the 30 volunteers within an age bracket of 19-48 years.
* activityLabelName ... Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING). These labels are generated with the join/merge as described at point 7 in the Transformation chapter.

1. subjectId
2. activityLableName
3. timeBodyAccMeanX
4. timeBodyAccMeanY
5. timeBodyAccMeanZ
6. timeBodyAccStdX
7. timeBodyAccStdY
8. timeBodyAccStdZ
9. timeGravityAccMeanX
10. timeGravityAccMeanY
11. timeGravityAccMeanZ
12. timeGravityAccStdX
13. timeGravityAccStdY
14. timeGravityAccStdZ
15. timeBodyAccJerkMeanX
16. timeBodyAccJerkMeanY
17. timeBodyAccJerkMeanZ
18. timeBodyAccJerkStdX
19. timeBodyAccJerkStdY
20. timeBodyAccJerkStdZ
21. timeBodyGyroMeanX
22. timeBodyGyroMeanY
23. timeBodyGyroMeanZ
24. timeBodyGyroStdX
25. timeBodyGyroStdY
26. timeBodyGyroStdZ
27. timeBodyGyroJerkMeanX
28. timeBodyGyroJerkMeanY
29. timeBodyGyroJerkMeanZ
30. timeBodyGyroJerkStdX
31. timeBodyGyroJerkStdY
32. timeBodyGyroJerkStdZ
33. timeBodyAccMagMean
34. timeBodyAccMagStd
35. timeGravityAccMagMean
36. timeGravityAccMagStd
37. timeBodyAccJerkMagMean
38. timeBodyAccJerkMagStd
39. timeBodyGyroMagMean
40. timeBodyGyroMagStd
41. timeBodyGyroJerkMagMean
42. timeBodyGyroJerkMagStd
43. freqBodyAccMeanX
44. freqBodyAccMeanY
45. freqBodyAccMeanZ
46. freqBodyAccStdX
47. freqBodyAccStdY
48. freqBodyAccStdZ
49. freqBodyAccJerkMeanX
50. freqBodyAccJerkMeanY
51. freqBodyAccJerkMeanZ
52. freqBodyAccJerkStdX
53. freqBodyAccJerkStdY
54. freqBodyAccJerkStdZ
55. freqBodyGyroMeanX
56. freqBodyGyroMeanY
57. freqBodyGyroMeanZ
58. freqBodyGyroStdX
59. freqBodyGyroStdY
60. freqBodyGyroStdZ
61. freqBodyAccMagMean
62. freqBodyAccMagStd
63. freqBodyBodyAccJerkMagMean
64. freqBodyBodyAccJerkMagStd
65. freqBodyBodyGyroMagMean
66. freqBodyBodyGyroMagStd
67. freqBodyBodyGyroJerkMagMean
68. freqBodyBodyGyroJerkMagStd
