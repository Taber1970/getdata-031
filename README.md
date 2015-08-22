### Process for getting the "tidy" data

## 1) I loaded the required data into R with these commands:

# Load Data
subject_train = read.table("./UCI HAR Dataset/train/subject_train.txt")
x_train       = read.table("./UCI HAR Dataset/train/x_train.txt")
y_train       = read.table("./UCI HAR Dataset/train/y_train.txt")
subject_test  = read.table("./UCI HAR Dataset/test/subject_test.txt")
x_test        = read.table("./UCI HAR Dataset/test/x_test.txt")
y_test        = read.table("./UCI HAR Dataset/test/y_test.txt")

features = read.table("./UCI HAR Dataset/features.txt")
activity = read.table("./UCI HAR Dataset/activity_labels.txt")

## 2) I used rbind to merge the test and train data into a single set of data frames with these commands:

# Merge the training and test sets
x       = rbind(x_train, x_test)
y       = rbind(y_train, y_test)
subject = rbind(subject_train, subject_tes

## 3) I used grep with the "features" data frame to determine what columns where "Mean" columns and what columns were "std" or standard deviation columns.  Then I 
## added them togeather.  Finally I created a new data frame, which was a copy of x, but with only the desired columns.

# Extracts only the measurements on the mean and standard deviation 
# for each measurement into "mean_std_x".
mean_cols = grep("mean", features$V2, ignore.case = FALSE)
std_cols  = grep("std", features$V2, ignore.case = FALSE)
mean_std_cols = c(mean_cols, std_cols)
mean_std_x = x[,mean_std_cols]

## 4) I used the join function to create a data frame which held one line for each measurement in x.  And that line went from containing a number for the activity, as ## in "y", to containing a text description of that activity, as in "activities".  I could have added the text version of the activities to the main data frame at ## this point, but then it would have been hard to add the english column names later.

# Use descriptive activity names to name the activities in the data set
activities = join(y, activity)

## 5) To add english descriptions to the columns of the data, I had to first get only the "Mean" and "std" descriptions, so that I had the right list to add to the
## data, which had already been cleaned of non "Mean" and "std" columns.

# Appropriately label the data set with descriptive variable names.
mean_std_features = features[mean_std_cols,]
names(mean_std_x) = mean_std_features$V2

## 6) Since I now have a data object with the english text activities and one with subject data for each observation, I could add them to the main data frame, 
## but it is easier to get the mean of each value in the data for each combination of activities and subjects by keepign them seperate and usign them in the aggregate
## function to get the final required tidy data.

# From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.
x_activity = activities$V2
x_subject  = subject$V1

groups = list(Activity = x_activity, Subject = x_subject)

mean_std_x_means = aggregate(mean_std_x, groups, mean)

write.table(mean_std_x_means, file = "tidy.txt", row.names = FALSE)
