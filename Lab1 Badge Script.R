######PREPARE###########

#loading packages
library(tidyverse)
library(tidytext)


######WRANGLE##########

#reading data into r
opd_survey <- read_csv("lab-1/data/opd_survey.csv")

#viewing data 
view(opd_survey)

#reducing data to a few variables including Q21 most beneficial/valuable aspect
opd_selected <- select(opd_survey, Role, Resource...6, Q21)

#remaining Q21 to meaningful variable name
opd_renamed <- rename(opd_selected, Resource = Resource...6, valueofpd = Q21)

#eliminating crazy Qualtrics rows that ALWAYS get in the way
#"-" sign indicates to drop rows 1 and 2
opd_sliced <- slice(opd_renamed, -1, -2)

#omitting cases with missing data 
opd_complete <- na.omit(opd_sliced)

#filtering data for cases where Role==Teacher
opd_teacher <- filter(opd_complete, Role == "Teacher")

#unnesting data into tokens
opd_tidy <- unnest_tokens(opd_teacher, word, valueofpd)

#removing stop words
opd_clean <- anti_join(opd_tidy, stop_words)


######EXPLORE########

#loading dplyr package
library(dplyr)

#word counts for valueofpd
opd_counts <- count(opd_clean, word, sort = TRUE)
opd_counts

#removing unimportant words
unimportant <- data.frame("word" = c("beneficial", "easy", "understand", "provided", "helpful", "aspect", "valuable", "enjoyed", "easily","convenient", "importance","line"))
opd_clean2 <- anti_join(opd_counts, unimportant)

#loading wordcloud library
library(wordcloud2)

#creating wordcloud for opd_clean2
wordcloud2(opd_clean2)
