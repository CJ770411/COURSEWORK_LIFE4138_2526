###################################
#                                 #
#      R session 1 homework.      #
#                                 #
#                                 #
###################################


## Introduction ----

# In this script file, you'll find a series of practical R problems for you to attempt as "homework".
# I will release the answers soon!

# You should write your answers beneath the questions provided.
# Note: You'll need to run any code blocks which I provide to you as you go, as these will load
# or create the objects you will need into your environment.


## Part 1: assigning objects ----

# 1. Create four objects, one for each of the four countries of the UK and assign the correct population figure to each country.

# 2. Use the countries objects to calculate the total population of the UK. Assign this output to a new variable called totalUKpop.

# 3. Using the countries objects and the UK population total, calculate the proportion of the total popualtion that each country represents.



## Part 2: Working with numeric vectors ----

# 1. Using the seq() function, create a numeric vector of 1 to 10,000, and call it numbers.

# 2. Print the 20th number form the vector you created.

# 3. Print the 50th to the 70th numbers from the vector you created.



## Part 3: Working with string vectors ----

# Theodosius Dobzhansky famously said "Nothing in biology makes sense except in the light of evolution".

# Create a string vector of words from this quote:
quote1 <- c("Nothing", "biology", "in", "makes", "sense")
quote2 <- c("evolution", "in", "the", "light", "of", "except")

# 1. Rearrange the words in your vectors so that the quote matches the original when you print them one after the other.

# 2. Use the paste() function to create a new object that pastes the two parts together in the correct order, into a single string vector.



## Part 4: Working with dataframes ----

# Install and library the Palmer Penguins package into your environment, and load the datframe.

install.packages("palmerpenguins")
library(palmerpenguins)
data(penguins)

# 1. Display the top rows of the penguins dataframe using the head() function.

# 2. Calculate the means of bill length, bill depth, and flipper length across the entire dataset using the mean() function.

# 3. How many different species are in the penguins dataset?

# 4. Add a column to the penguins dataframe called bill_area which multiplies bill length by bill depth. 
#    Look at the top of the dataframe with head() to check the output.

# 5. Make a new dataframe that contains only the data for the Adelie penguins using the subset() function. Use View() to check your work.



## Part 5: Plotting with baseR ----

# 1. Make a boxplot showing the differences in bill length between species, then do the same with flipper length.

# 2. Make a scatter plot of bill length vs bill depth.

# 3. Make a histogram of bill length, and then another of flipper length.