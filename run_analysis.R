
# These commented give an example of how to get the data from the internet
# into a state where the rest of the script can be run.
# url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# download = download.file(url, destfile = "data.zip")
# unzip("data.zip")

# Load Data
subject_train = read.table("./UCI HAR Dataset/train/subject_train.txt")
x_train       = read.table("./UCI HAR Dataset/train/x_train.txt")
y_train       = read.table("./UCI HAR Dataset/train/y_train.txt")
subject_test  = read.table("./UCI HAR Dataset/test/subject_test.txt")
x_test        = read.table("./UCI HAR Dataset/test/x_test.txt")
y_test        = read.table("./UCI HAR Dataset/test/y_test.txt")

features = read.table("./UCI HAR Dataset/features.txt")
activity = read.table("./UCI HAR Dataset/activity_labels.txt")

# Merge the training and test sets
x       = rbind(x_train, x_test)
y       = rbind(y_train, y_test)
subject = rbind(subject_train, subject_test)

# Extracts only the measurements on the mean and standard deviation 
# for each measurement into "mean_std_x".
mean_cols = grep("mean", features$V2, ignore.case = FALSE)
std_cols  = grep("std", features$V2, ignore.case = TRUE)
mean_std_cols = c(mean_cols, std_cols)
mean_std_x = x[,mean_std_cols]

# Use descriptive activity names to name the activities in the data set
activities = join(y, activity)

# Appropriately label the data set with descriptive variable names.
mean_std_features = features[mean_std_cols,]
names(mean_std_x) = mean_std_features$V2

# From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.
x_activity = activities$V2
x_subject  = subject$V1

groups = list(Activity = x_activity, Subject = x_subject)

mean_std_x_means = aggregate(mean_std_x, groups, mean)

write.table(mean_std_x_means, file = "tidy.txt", row.names = FALSE)
