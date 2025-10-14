###############################################################################
#                                                                             #
#  LIFE4138: R Workshop 1 – "Have a Go" Questions                             #
#                                                                             #
#  Author: Hannah Jackson                                                     #
#  Date: 14th Oct 2025                                                        #
#                                                                             #
#  Description:                                                               #
#  This script contains worked solutions to the "Have a Go" questions         #
#  from the first R workshop in LIFE4138.                                     #
#                                                                             #
###############################################################################


### Have a go part 1 ----

## 1.  Create a vector, with 10 numbers. Print it to the console.

# there are a couple of options here:
x <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
x

x <-1:10
x

x <- seq(from = 1, to = 10, by = 1)
x

## 2.  What is the length of your new vector?

# use length() to work ths out
length(x)

## 3.  Replace the 4th element of your vector with the number 53.

# access the 4th element, and assign the value 53 to it.
x[4] <- 53
x

## 4.  Create another numeric vector, combine them to create a matrix. Print it to the console.

y <- 31:40

# combine vectors with cbind, or rbind
m <- cbind(x, y)
m

## 5.  What are the dimensions of your new matrix?

# check with dim
dim(m)

## 6.  Create a data frame with 4 variables - make them a mixture of the data classes.

# you could create the vectors individually, but more efficient to do it like this:

df <- data.frame(
  animals = c("badger", "snail", "hegdehog", "chicken", "spider"),
  legs = c(4, 0, 4, 2, 8),
  furry = c(TRUE, FALSE, FALSE, FALSE, FALSE)
)

# check its a dataframe
is.data.frame(df)

## 7.  Print your 2nd variable to the screen using 2 different methods!

df[,2]
df$legs
df[,"legs"]

## 8.  **Brucey bonus**: Replace the second variable in your data frame with a new one!

df$legs <- c("some", "none", "some", "some", "too many")
df

### Have a go part 2 ----

## 1.  Clear your environment

rm(list=ls())

## 2.  Create a dataframe with 3 variables, one character, one numeric, one logical

df <- data.frame(
  name = c("Scooby", "Donald", "Pluto"),
  age = c(7, 45, 9),
  dog = c(TRUE, FALSE, TRUE)
)

## 3.  Save the dataframe to your project directory, then remove it from your environment

write.csv(df, "dogs.csv", row.names = FALSE)
rm(df)

## 4.  Read the dataframe back in! (`use read.csv()`)

df <- read.csv("dogs.csv")

## 5.  **Brucey bonus**: Remove the dataframe again, and read it back in using `read.table()` and see if you can troubleshoot the issues!

rm(df)
df <- read.table("dogs.csv", header = TRUE, sep = ",")
# you need to include header = TRUE because R automatically assumes that the names 
# of your dataset are the first row of data. You also need to define how the file
# separates data with sep - csv files use commas.

## 6.  Create 2 numeric vectors and make a scatter plot, give it a title

x <- 1:20
y <- x^3
plot(x, y)

## 7.  Load the `ToothGrowth` dataset and make a boxplot (note the data name is case sensitive)

data(ToothGrowth)
head(ToothGrowth) # have a look at the data
boxplot(ToothGrowth$len ~ ToothGrowth$supp)

## 8.  **Brucey bonus**: Add axis labels, a title, and make it a pretty colour!
boxplot(ToothGrowth$len ~ ToothGrowth$supp, 
        main = "Length of tooth vs treatment",
        xlab = "Supplement",
        ylab = "Length",
        col = "plum")
