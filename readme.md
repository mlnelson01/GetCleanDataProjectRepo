---
title: "Readme"
author: "M. Nelson"
date: "Friday, September 19, 2014"
output: html_document
---

This is an R Markdown document. Markdown is a simple formatting syntax for authoring HTML, PDF, and MS Word documents. For more details on using R Markdown see <http://rmarkdown.rstudio.com>.

When you click the **Knit** button a document will be generated that includes both content as well as the output of any embedded R code chunks within the document. You can embed an R code chunk like this:

```{r}
summary(cars)
```

You can also embed plots, for example:

```{r, echo=FALSE}
plot(cars)
```

Note that the `echo = FALSE` parameter was added to the code chunk to prevent printing of the R code that generated the plot.

This repo includes the following:

1. This Readme file.  Graders, please read through to understand what I did.  

2. run_analysis.R - is the R Script that analyses the data in accordance with the project instructions. The analysis proceeds through the steps outlined in the assignment, in order. Comments in the code help with understanding what is being done, and further detail appears below.

3. Codebook.txt - which describes the final dataset created in Stpe 5 of the project instructions (and step 5 f the script) 

4. ___.txt, a copy of the dataset submitted in the Coursera site.  I included this here for completeness of the repo.  

What does the script do?

The script assumes that the downloaded data ZIP file has been extracted, folder structure intact, into your R working directory.  So either extract the ZIP file within your working directory, or change your working directory to the root of the extracted folder structure (i.e. where ther README.TXT file is), whichever is easiest for you. 

Step zero of the R script (the script is commened with step numbers) reads all the data into tables. The two files that have labels in them, features.txt and activity_lables.txt, are read in with "as.is" parameters so that I can manipulate them later as character vectors and then turn them into factors once I have them the way I want them. Leaving this value off resuted in erroneous factor values in the imported activities file and made manipulating the features text much harder.)

In Step 1, I add two columns to the train and test data frames using cbind. The first of these is the "Y" data, which is the activity number associated with each observation.  The second is the subject identifier for each row.  Then, I use rbind to combine the observations of the train and test data files into a single data frame, All_Data, that includes both.

In Step 2, I need to use the features vector, which provides names all the variable columns, to determine which columns house the requested means and standaard deviations. To do that, I identify, within the features vector, which values contain either the string "mean" or the string "std" (I used several interactive commands to look at the data and make the decision thaat this method would net the desired result. I also examined the features.txt file in a text editor to confirm.)  I created a numeric vector call "Extract_Columns" which included only the columns I wanted. I then added the columns for activity (562) and SUbject (563) to the vector - those columns were not included in the original features.txt list, because they are columns I added in Step 1.  (Note - in my script I also extract names for all the columns in preparation for step 4.  I left these here, raather than moving them to step 4, because I think keeping them together with the column extraction, which uses the exact same process, is easier to understand.)

The final command in the Step 2 section subsets All_Data to include only the columns we care about, those containing means and standard deviations.

In Step 3, we need to use the activity_labels.txt data, which assigns labels to the activity numbers, to give each row a label that corresponds properly to the number in column 562.  Because the activities file is already in numeric order by the first column, I don't need to sort it first to apply factor labels to the levels appropriately.  In this code, I assign the appropriate labels to each number and then make column 562 a factor. Done! (Note - I verified labels were applied correctly.  I did this using table commands interactively in R both before and and after applying the labels.)

In step 4 I create nice variable names for my columns. I already extracted the correct feature names to match my mean and std columns from features and stored them in a vector - Extract_CNames. See step 2.  In this step, I clean up the names a bit by stripping out the meaningless parens and changing t to "time" and f to "frequency" in the prefixes. I also replaced "-mean" with "Mean" and -std" with "Std" because I thought those variabel woulld be easier to type.  While I could have gone further, for example replacing "Acc" with "accelerometer" and "Gyro" with "gyroscope" I felt these changes would sacrifice is of use (readability and typing) for long English descriptions.   My goals here was to demonstrate I knnow how to manipulate the text descriptions without making the rest of the assignment more difficult! 




