# Getting and cleaning Data
# This is the code for the Peer-graded Assignment  
# Getting and Cleaning Data Week 4 


# get the downloaded file URL
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# create the data directory if does not exist
if(!file.exists("./data")){dir.create("./data")}

# download the file to the data directory
download.file(fileURL, destfile = "./data/project.zip")

unzip("./data/project.zip", list = TRUE) ## extracts file names to a list
unzip("./data/project.zip", exdir = "./data/projectFiles") ## extracts files

# load the two necessary libraries
library(stringr); library(dplyr)

# read traing data set
trainingSet <- read.table("./data/projectFiles/UCI HAR Dataset/train/X_train.txt")
# read training subjects
trainingSubject <- read.table("./data/projectFiles/UCI HAR Dataset/train/subject_train.txt")

# read trainging activity labels
trainingActLabels <- read.table("./data/projectFiles/UCI HAR Dataset/train/y_train.txt")

# read test data set
testSet <- read.table("./data/projectFiles/UCI HAR Dataset/test/X_test.txt")

# read test activity labels
testActLabels <- read.table("./data/projectFiles/UCI HAR Dataset/test/y_test.txt")

# read test subject labels
testSubject <- read.table("./data/projectFiles/UCI HAR Dataset/test/subject_test.txt")

#read features
features <- read.table("./data/projectFiles/UCI HAR Dataset/features.txt")

# name the feature columns
names(features) <- c("index", "fname")

# some of the features seem to be duplicates. 
# To avoid duplicates three-digit numbers were 
# added to the front of each name
nFeatures <- mutate(features, nfname = 
                        paste(str_pad(features$index,3, side = "left", 
                        pad = "0"), fname))

# a vector of just the feature names
nfname <- nFeatures$nfname

# the required features are the means and std deviations
nfnameReq <- grep("*mean*|*std*", ignore.case =  TRUE, nFeatures$fname)

# add the feature names to the training data set
names(trainingSet) <- nfname

# add the feature names to the test data set
names(testSet) <- nfname

# select only required features
testSetReq <- select(testSet,  nfnameReq)
trainingSetReq <- select(trainingSet, nfnameReq)

# add activity numbers and subjects to both data sets
trainingSetReq <- mutate(trainingSetReq, Actv = trainingActLabels$V1, subject = trainingSubject$V1)
testSetReq <- mutate(testSetReq, Actv = testActLabels$V1, subject = testSubject$V1)

# Add Name to test subject and training subject tables
names(testSubject) <- "subject"
names(trainingSubject) <- "subject"

#add names to test and training activity tables
names(testActLabels) <- "actLabels"
names(trainingActLabels) <- "actLabels"

# add activity and  subject columns to training and test sets
testAct <- mutate(testSet, Actv = testActLabels$actLabels)
trainingAct <- mutate(trainingSet, Actv = trainingActLabels$actLabels)
testAct <- mutate(testAct, Subj = testSubject$subject)
trainingAct <- mutate(trainingAct, Subj = trainingSubject$subject)

# merge the two data sets
allData <- rbind(testAct, trainingAct)

# select only required features
good <- c(562, 563, grep("*mean*|*std*", names(allData)))
allDataReq <- select(allData, good)

# set data names into a vector
dataNames <- names(allDataReq)

# remove the three-digit numbers from the names
dataNames <- sub("^[0-9][0-9][0-9] ", "", dataNames)

# second name is set to subject
dataNames[2] <- "Subject"

# this next group makes nice data names for the features
dataNames <- sub("^t", "Time", dataNames)
dataNames <- sub("^f", "Freq.", dataNames)
dataNames <- sub("Acc", "Acceleration", dataNames) 
dataNames <- sub("\\(\\)", "", dataNames) 
dataNames <- sub("Gyro", "Gyroscope", dataNames) 
dataNames <- sub("-std", "Std.Dev.", dataNames) 
dataNames <- sub(" -mean-", "Mean", dataNames) 
dataNames <- sub("-", "", dataNames)
dataNames <- sub("JerkMag", "Jerk.Mag", dataNames) 
dataNames <- sub("mean", "Mean", dataNames) 
dataNames <- sub("Mag", "Magnitude", dataNames) 
dataNames <- sub("BodyBody", "Body-Body", dataNames)

# set the data names to the required data
names(allDataReq) <- dataNames

# read the activity labels
activity_labels <- read.table("./data/projectFiles/UCI HAR Dataset/activity_labels.txt")

# add "Activity" to the activity label names
names(activity_labels) <- c("Actv", "Activity")

# merge the Activity names with to the data set
allDataReq <- merge(allDataReq, activity_labels, by = "Actv" )

# reorder the columns, Activity names first  eliminates activity numbers 
allDataReq <- select(allDataReq, c(82, 2:81))

# give the names to the data set
names(allDataReq) <- make.names(names(allDataReq))

# Write Data to .csv file
write.csv(allDataReq, "./data/ActivityTracking.csv")

# Calculate average of each variable by activity and subject
allDataReqMean <- allDataReq %>%
    group_by(Activity, Subject) %>% summarize_each(funs(mean))    

# Write Data to .csv file
write.csv(allDataReqMean, "./data/ActivityTrackingMeans.csv")
