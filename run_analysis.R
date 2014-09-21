#Step0 - read all the data
X_test <- read.table(".//test/X_test.txt")
y_test <- read.table(".//test/y_test.txt")
sub_test <- read.table(".//test/subject_test.txt")
X_train <- read.table(".//train/X_train.txt")
y_train <- read.table(".//train/y_train.txt")
sub_train <- read.table(".//train/subject_train.txt")
features <- read.table("features.txt", as.is = 2)
activities <- read.table("activity_labels.txt",as.is = 2)

#Step1 - Merge test and train sets
X_test <- cbind(X_test,y_test,sub_test)
X_train <- cbind(X_train,y_train,sub_train)
All_Data <- rbind (X_test,X_train)
#remove unneeded data sets to preserve memory
rm(X_test,X_train,y_test,y_train,sub_test,sub_train)

#Step 2 - Extract mean and std values from each measurement.
#Add a column to features that shows whether or not the feature is a mean or std (result will be a Logical value)
features$V3<-grepl("mean",features$V2)|grepl("std",features$V2)
#Create a vector of column numbers we want to extract (those where V3 is TRUE; there will be 79 of these)
Extract_Columns <- features[(features$V3==TRUE),1]
Extract_CNames <- features[(features$V3==TRUE),2]
#Make sure to include the two columns added from y_ and subject_, the last two columns
Extract_Columns <- c(Extract_Columns, 562,563)
Extract_CNames <- c(Extract_CNames, "Activity","SubjectNumber")
#Now subset out the columns we've identified that we care about.
All_Data <- All_Data[,Extract_Columns]

#Step 3, add activity labels to the observations.  Activty Numbers are in Col 562 of All_Data.
#The following assigns the factors to the correct numbers according to their order in the Activity_Label file.
activities$V2 <- factor(activities$V2,levels=activities$V2)
#then we can convert the values in column 562, called V1.1 at this point, into factors with the right names.
All_Data$V1.1<-factor(All_Data$V1.1,labels=activities$V2)

#Step 4. Label the variables with meaningful names. WWe already created the vector of applicable names in Step 2.
#Now just clean up those names 
Extract_CNames <- sub("\\(","",Extract_CNames) 
Extract_CNames <- sub("\\)","",Extract_CNames) 
Extract_CNames <- sub("-mean","Mean",Extract_CNames) 
Extract_CNames <- sub("-std","Std",Extract_CNames) 
Extract_CNames <- sub("^t","time",Extract_CNames)
Extract_CNames <- sub("^f","frequency",Extract_CNames)
#And  apply them to All_Data.
colnames(All_Data) <- Extract_CNames

#Step 5. Create tidy dataset and write it out.
library(reshape2)
library(plyr)
#Set up an empty data frame for the tidy dataset.
Final_Data <- data.frame()
##There are 30 subjects in the study, so we need to loop through them. temp dataframes hold the data between steps.
for (s in 1:30) {
  temp <- All_Data[All_Data$SubjectNumber==s,]
  #Melt the dataframe.
  tempmelt<-melt(temp,id=c("SubjectNumber","Activity"))
  #Apply an average to each variable with in each activity.
  tempplyed <- ddply(tempmelt,.(SubjectNumber,Activity,variable),summarize,Average=mean(value))
  #dcast it back into six activity rows for this subject. Note, this throws a warning but is doing the right thing.
  tempdone <- dcast(tempplyed,Activity~variable)
  #Add back the SubjectNumber, then rbind it to the output data frame Final_Data.
Final_Data <- rbind(Final_Data, cbind(temp$SubjectNumber[1],tempdone))
}

#Write the tidy dataset Final_Data.
destURL <- "tidydata.txt"
write.table (Final_Data,destURL)

