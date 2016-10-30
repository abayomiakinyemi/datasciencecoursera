# Collecting Data and saving in the course Project Directory

# Set working directory

setwd("C:/Users/Akinyemi Abayomi/datasciencecoursera")

if(!file.exists("Course_Project")){
  
  dir.create("Course_Project")
}

# Download and extract zipped data file

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(fileUrl, destfile="./Course_Project/data.zip")

unzip(zipfile="./Course_Project/data.zip", exdir="./Course_Project")


# Files unzipped into "UCI HAR Dataset" folder

# View the unzipped file list

f_path <- file.path("./Course_Project" , "UCI HAR Dataset" )

files <- list.files(f_path, recursive=TRUE)


# Stage 1

# Merging the training and test sets to create one data set

###############################################################################

# Read test and training data sets into variables "Activity", "Subject" and "Features"

# Read "Activity" data

Test_data_Activity  <- read.table(file.path(f_path, "test" , "Y_test.txt" ),header = FALSE)

Train_data_Activity <- read.table(file.path(f_path, "train", "Y_train.txt"),header = FALSE)


# Read "Subject" data

Test_data_Subject <- read.table(file.path(f_path, "test", "subject_test.txt"),header = FALSE)

Train_data_Subject  <- read.table(file.path(f_path, "train" , "subject_train.txt"),header = FALSE)


# Read "Features"

Test_data_Features  <- read.table(file.path(f_path, "test" , "X_test.txt" ),header = FALSE)

Train_data_Features <- read.table(file.path(f_path, "train", "X_train.txt"),header = FALSE)


# Merge test and train datasets by rows

Activity_data <- rbind(Test_data_Activity, Train_data_Activity)

Subject_data <- rbind(Test_data_Subject, Train_data_Subject)

Features_data <- rbind(Test_data_Features, Train_data_Features)


# Assign variable names to merged datasets

names(Activity_data) <- c("activity")

names(Subject_data) <- c("subject")

dataFeaturesNames <- read.table(file.path(f_path, "features.txt"),head=FALSE)

names(Features_data)<- dataFeaturesNames$V2


# Merge datasets into a dataframe

# View the dimensions of the dataframe

datasets <- cbind(Subject_data, Activity_data)

df_Data <- cbind(Features_data, datasets)



# Stage 2

# Extract only the measurements on the mean and standard deviation for each measurement

###############################################################################


# Subset dataframe by Name of Features with "mean()" or "std()"

subFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]

Names_selected<-c(as.character(subFeaturesNames), "subject", "activity" )

Data<-subset(df_Data,select=Names_selected)



# Stage 3

# Use descriptive activity names to name the activities in the data set

###############################################################################

# Read descriptive activity names from "activity_labels.txt"

activity_labels <- read.table(file.path(f_path, "activity_labels.txt"),header = FALSE)


# Factorize activity variable in dataframe with activity labels

Data$activity <- factor(x=Data$activity, levels=1:6, labels=activity_labels[,2])


# Stage 4

# Appropriately label the data set with descriptive variable names

###############################################################################

# prefix t is replaced by time

# prefix f is replaced by frequency

# Acc is replaced by Accelerometer

# Gyro is replaced by Gyroscope

# Mag is replaced by Magnitude

# BodyBody is replaced by Body


names(Data)<-gsub("^t", "time", names(Data))

names(Data)<-gsub("^f", "frequency", names(Data))

names(Data)<-gsub("Acc", "Accelerometer", names(Data))

names(Data)<-gsub("Gyro", "Gyroscope", names(Data))

names(Data)<-gsub("Mag", "Magnitude", names(Data))

names(Data)<-gsub("BodyBody", "Body", names(Data))


# View the descriptive variable names

names(Data)



# Stage 5

# Create a second, independent tidy data set with the average of each variable

# for each activity and each subject

###############################################################################


# load the plyr library

library(plyr)

tidy_Data<-aggregate(. ~subject + activity, Data, mean)

tidy_Data<-tidy_Data[order(tidy_Data$subject,tidy_Data$activity),]

write.table(tidy_Data, file = "./Course_Project/tidydata.txt", row.name=FALSE)


# View tidy data

tidydata <- read.table(file = "./Course_Project/tidydata.txt", header=TRUE)

View(tidydata)