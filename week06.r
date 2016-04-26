# ==========================================================================

# SLU Data Science Seminar - Spring 2016 - Week 06

# ==========================================================================

rm(list = ls()) # clear workspace

# ==========================================================================

# file name - week06.R

# project name - Spring 2016

# purpose - Illustrate Functions for Working with Strings

# created - 26 Apr 2016

# updated - 26 Apr 2016

# author - CHRIS

# ==========================================================================

# full description - 
# This script illustrates multiple functions for manipulating strings
# in R.

# updates - 
# none

# ==========================================================================

# superordinates  - 
# auto.csv, downloaded from GitHub

# subordinates - 
# none

# ==========================================================================

# 1. Getting Started

# get working directory
getwd()

# change working directory
# setwd("E:\Users\prenercg\Documents")
setwd("/Users/prenercg/Desktop")

# load data
# using the stringsAsFactors=FALSE option so that string data are preserved
# when the .csv file is read into R
cars <- read.csv("auto.csv", header=TRUE, stringsAsFactors=FALSE)

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# check out structure of data
str(cars)

# list first five observations
head(cars)

# confirm that the variables make and foreign are character
is.character(cars$make)
is.character(cars$foreign)

# ==========================================================================

# 2. Basic String Operations

# count number of characters in a string
nchar(cars$make)

# sometimes our strings come without consistent upper or lower case text
cars$makeU <- toupper(cars$make)
cars$makeL <- tolower(cars$make)


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# search within a string
# by default, this is case sensitive
grep("AMC", cars$make)

# can override case sensitive behavior:
grep("amc", cars$make, ignore.case = TRUE)

# these return the observations that have particular strings
# if we want to return the actual values:
grep("AMC", cars$make, ignore.case = TRUE, value = TRUE)

# if we want a logical test of whether or not data exist in a string:
grepl("amc", cars$make, ignore.case = TRUE)

# ==========================================================================

# 3. convert simple strings to factors
cars$foreignFac <- as.factor(cars$foreign)

# ==========================================================================

# 4. Create logical vector if string contains particular data
cars$amc <- grepl("amc", cars$make, ignore.case = TRUE)

# we can extend this with a list of cars we want to be considered TRUE
cars$amcBuick <- grepl("amc|buick", cars$make, ignore.case = TRUE)

# ==========================================================================

# 5. Replace Data within String
cars$make2 <- sub("AMC", "American Motors", cars$make, ignore.case = TRUE)

# ==========================================================================

# 6. Extract first word from string

# need stringr package
install.packages("stringr")
library(stringr)

# now to create variable
cars$brand <- word(cars$make, 1)

# clean up brands
cars$brand <- sub("Buick", "GMC", cars$brand, ignore.case = TRUE)
cars$brand <- sub("Cad.", "GMC", cars$brand, ignore.case = TRUE)
cars$brand <- sub("Chev.", "GMC", cars$brand, ignore.case = TRUE)
cars$brand <- sub("Olds", "GMC", cars$brand, ignore.case = TRUE)
cars$brand <- sub("Pont.", "GMC", cars$brand, ignore.case = TRUE)

cars$brand <- sub("Linc.", "Ford", cars$brand, ignore.case = TRUE)
cars$brand <- sub("Merc.", "Ford", cars$brand, ignore.case = TRUE)

cars$brand <- sub("Dodge", "Chrysler", cars$brand, ignore.case = TRUE)
cars$brand <- sub("Plym.", "Chrysler", cars$brand, ignore.case = TRUE)

# ==========================================================================