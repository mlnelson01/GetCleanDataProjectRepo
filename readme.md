---
title: "Readme"
author: "M. Nelson"
date: "Friday, September 19, 2014"
output: markdown
---

This repo includes the following:

1. This Readme.md file.  Graders, please read through to understand what I did.  

2. run_analysis.R - is the R Script that analyses the data in accordance with the project instructions. The analysis proceeds through the steps outlined in the assignment, in order. Comments in the code help with understanding what is being done, and further detail appears below.

3. Codebook.txt - which describes the final dataset created in Step 5 of the project instructions (and step 5 of the script) Copies also in docx and PDF format.

4. tidydata.txt, a copy of the dataset I submitted in the Coursera site.  I included this here for completeness of the repo, evven though the instructions called for it to be submitted in Coursera only.  

What does the R script do?

The script assumes that the downloaded source data ZIP file has been extracted, folder structure intact, into your R working directory.  So either extract the ZIP file within your working directory, or change your working directory to the root of the folder where you extracted the data (i.e. where the README.TXT file is), whichever is easiest. 

Step zero of the R script (the script has step numbers in the comments) reads all the data into tables. The two files that have contain labels, features.txt and activity_lables.txt, are read in with "as.is" parameters so that I can manipulate them later as character vectors and then turn them into factors once I have them the way I want them. Leaving this value off resuted in factors, but they were not assigned the right integer values in the imported activities file. I found it easier to load them as characters and make them factors explicitly, rather than trying to change pre-existing factors to match what I needed.  

In Step 1, I added two columns to the train and test data frames using cbind. The first of these is the "Y" data, which is the activity number associated with each observation.  The second is the subject identifier for each observation.  Then, I used rbind to combine the observations of the train and test data files into a single data frame, All_Data, that includes both.

In Step 2, I used the features vector, which provides names for all the measurement columns, to determine which columns house the requested means and standaard deviations. To do that, I identified, within the features vector, which values contain either the string "mean" or the string "std". (I used several interactive commands to look at the data and make the decision that this method would net the desired result. I also examined the features.txt file in a text editor to confirm.)  I created a numeric vector called "Extract_Columns" which included only the columns I wanted. I then added the columns for activity (562) and SUbject (563) to the vector, since those columns were not included in the original features.txt list, because they are columns I added in Step 1.  (Note - in my script I also extract names for all the columns in preparation for step 4.  I left these commands here in step 2, rather than moving them to step 4, because I think keeping them together with the column extraction, which uses the exact same process, is easier to understand.)

The final command in the Step 2 section subsets All_Data to include only the columns we care about, those containing means and standard deviations.

In Step 3, I used the activity_labels.txt data, which assigns labels to the activity numbers, to give each row a label that corresponds properly to the number in column 562.  Because the activities file is already in numeric order by the first column, I did not need to sort it first to apply factor labels to the levels appropriately.  In this code, I assigned the appropriate labels to each number and then convert column 562 a factor. Done! (Note - I verified labels were applied correctly.  I did this using table commands interactively in R both before and and after applying the labels.)

In step 4 I create nice variable names for my columns. I already extracted the correct feature names to match my mean and std columns from features.txt and stored them in a vector called Extract_CNames. See step 2.  In step 4, I cleaned up the names a bit by stripping out the meaningless parentheses, changing t to "time" and f to "frequency". I also replaced "-mean" with "Mean" and -std" with "Std" because I thought those variable names would be easier to type.  While I could have edited further - converted to lover case, replaced "Acc" with "accelerometer" and "Gyro" with "gyroscope"  - I felt these changes would actually sacrifice is of use by making the names harder to type and, perhaps, less legible.  My goal here was to demonstrate I know how to manipulate the text descriptions without making the rest of the assignment more difficult! 

In Step 5, I needed to compute an average for each measured variable, by activty, within subject. Since there are 30 subjects and 6 activities, my tidy data set should have 180 rows (subject times activity). I want each variable in its own column for tidiness' sake, so the data set should have 81 columns (79 measurements, plus one column each for subject number and activity). 

I found that the most effective method for me was to use a "for" loop to process each subject's data independently.  I subsetted out the data for each subject, melted the resulting data frame to make it easier to process, used ddply to compute the average for each activity/variable pairing, and then used dcast to reshape the data frame into the desired tidy form (6 rows by 81 columns). One wrinkle I encountered was that the dcast dropped off the SubjectNumber column.  I then used rbind to add the data to the output data frame, reattaching a column for Subject Number in the process. 

The last step was to write the data frame, and I chose to call it "tidydata.txt".  I used a standard write.table command. To read the file, copy it to your working directory and use the command

...r
tidydata <- read.table("tidydata.txt", header=TRUE)
view(tidydata)

References: many thanks to David Hood for posting his "David's Project FAQ" in the Discussion forum.  
