# Getting and Cleaning Data
## Week 4 Peer-graded Assignment
## Code Book.

### This document lists and describes all the variables used in the assignment.

 
* fileURL: url of the zip file to download

* trainingSet: training dataset

* trainingSubject: subject data for training dataset

* trainingActLabels: data for activity for training dataset

* testSet: holds the test dataset

* testActLabels: data for activity for training dataset

* testSubject: 

* features: holds the features (column names) dataset

* nFeatures: beacause some of the feature names seemed to be duplicated, this variable holds the features with three-digit number prefixed 

* nfname: a vector of just the feature names

* nfnameReq: the feature names of only means and standard deviations

* testSetReq: the test dataset with only mean and standard deviation values

* trainingSetReq: the training data set with only mean and standard deviation values

* testAct: test dataset with activity numbers added

* trainingAct: training dataset with activity numbers added

* allData: merged datasets

* good: vector that holds the numbers of the columns needed (activity, subject, means, and standard deviations)

* dataNames: vector holds all the column names 

* activity_labels: holds the names for the activities

* allDataReqMean: dataset that holds the means of all data by activity and subject