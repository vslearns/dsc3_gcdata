# Code Book
This is VS's Code Book for the Getting and Cleaning Data Project for Coursera course of the same name.
This Markdown document contains and explains the variables created and transformations performed on the original dataset.

## Original Dataset
The original dataset was retrieved from [this link](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).
The authors of the dataset included [this information](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) about their project.

## Quick Look
A complete explanation of the dataset and its intent can be found in the 'README.txt' file contained inside the original dataset's ZIP folder. The following information comes the UC Irvine webpage linked above.

* "The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist."
* "Using [the phone's] embedded accelerometer and gyroscope, [the researchers] captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually."
  * A sample of the recorded video can be found in [this YouTube video](https://youtu.be/XOEN9W05_4A)
* "The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data."
* "The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain."

## Features in this Dataset
The features in this dataset were calculated from the accelerometer and gyroscope's raw 3-axial signals: tAcc-XYZ and tGyro-XYZ, where XYZ denotes three sets of data, one in each of the X/Y/Z directions.

* Time domain signals were captured at 50 Hz (denoted in the dataset by the "t" prefix).
* The signals were noise-filtered.
* The acceleration signal was split into:
  * tBodyAcc-XYZ, the body's acceleration
  * tGravityAcc-XYZ, the gravitational acceleration
* The body's acceleration and angular velocity were then time-derived for Jerk signals:
  * tBodyAccJerk-XYZ
  * tBodyGyroJerk-XYZ
* The Euclidean form was applied to calculate the magnitude of each signal:
  * tBodyAccMag
  * tBodyAccJerkMag
  * tGravityAccMag
  * tBodyGyroMag
  * tBodyGyroJerkMag
* And lastly, a Fast Fourier Transform was applied selectively for frequency domain signals (denoted in the dataset by the "f" prefix):
  * fBodyAcc-XYZ
  * fBodyAccJerk-XYZ
  * fBodyGyro-XYZ
  * fBodyAccMag
  * fBodyAccJerkMag
  * fBodyGyroMag
  * fBodyGyroJerkMag

Each feature was accompanied by estimates such as mean, standard deviation, smallest value, largest value, and so on. A list of all 17 estimates applied on all 33 features (splitting directions) can be found in features.txt in the original dataset ZIP. More information on the features and estimates can be found in features_info.txt in the original dataset ZIP.

## Transformations Applied
Consistent with the requirements of this project, the following transformations were made to the "dirty" dataset to produce a "tidy" dataset. The functions and variables referenced from hereon appear in [run_analysis.R](https://github.com/vslearns/dsc3_gcdata/blob/master/run_analysis.R).

1. The training and testing datasets were merged into one `dirty_data` set.
2. The `dirty_data` set was filtered so that only the mean and standard deviations were considered in the `dirty_ms_data` set.
3. The subject and activity labels were assigned, and feature labels were adjusted, by the `subject_descript()`, `activity_descript()`, and `feature_descript()` functions, respectively.
4. Finally, a `tidy_data` set was generated and written into `tidy_data.txt` as required and `tidy_data.csv` for convenience and pleasure.

The feature names were adjusted to replace dashes with underscores and to remove parentheses.