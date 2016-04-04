#
# 1. Merging training and test sets into one data set
#
# Read data
#
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
X_test  <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
y_test  <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
subject_test  <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)
activities    <- read.table("./UCI HAR Dataset/activity_labels.txt")
# 
# Append rows
#
x <- rbind(x_train, X_test)
y <- rbind(y_train, y_test)
s <- rbind(subject_train, subject_test)
#
# 2. Extracting means and standard deviations
#
features <- read.table("./UCI HAR Dataset/features.txt")
#
# Assign labels to features column
#
names(features) <- c('feature_id', 'feature_name')
#
# Search for mean and std ocurrences
#
index_features <- grep("-mean\\(\\)|-std\\(\\)", features$feature_name) 
x <- x[, index_features] 
#
# Replaces all matches of a string features 
#
names(x) <- gsub("\\(|\\)", "", (features[index_features, 2]))
#
# 3. Using descriptive activity names & 4. Labeling
#
# Assign labels to activities column
#
names(activities) <- c('act_id', 'act_name')
y[, 1] = activities[y[, 1], 2]
names(y) <- "Activity"
names(s) <- "Subject"
#
# Merge tables by columns
#
tidyDataSet <- cbind(s, y, x)
#
# 5. Creating a 2nd independent tidy data set with averages of each variable for each activity and each subject
#
x <- tidyDataSet[, 3:dim(tidyDataSet)[2]] 
tidyAverageDataSet <- aggregate(x,list(tidyDataSet$Subject, tidyDataSet$Activity), mean)
#
# Activity and Subject name of columns 
#
names(tidyAverageDataSet)[1] <- "Subject"
names(tidyAverageDataSet)[2] <- "Activity"# Created csv (tidy data set) in diretory
#
# Created tidy datasets
#
# write.table(tidyDataSet, file='./UCI HAR Dataset/tidy_DataFile.txt')
write.table(tidyAverageDataSet, file='./UCI HAR Dataset/tidy_Average_DataFile.txt')
