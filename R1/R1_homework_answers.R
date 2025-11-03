###################################
#                                 #
#      R session 1 homework.      #
#              Answers            #
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

# note my numbers might be out of date now!
England <- 56550138
Ireland <- 1895510
Scotland <- 5466000
Wales <- 3169586

# 2. Use the countries objects to calculate the total population of the UK. Assign this output to a new variable called totalUKpop.

totalUKpop <- England + Ireland + Scotland + Wales
     # or
totalUKpop <- sum(England, Ireland, Scotland, Wales)
totalUKpop

# 3. Using the countries objects and the UK population total, calculate the proportion of the total popualtion that each country represents.

# note I've done the % rather than proportion, not having the *100 will give the "proper" definition of proportion, but either is fine
(England/totalUKpop)*100 #England
(Ireand/totalUKpop)*100 #Ireland
(Scotland/totalUKpop)*100 #Scotland
(Wales/totalUKpop)*100 #Wales



## Part 2: Working with numeric vectors ----

# 1. Using the seq() function, create a numeric vector of 1 to 10,000, and call it numbers.

numbers <- seq(from = 1, to = 10000, by = 1)
    # or
numbers <- seq(1, 10000, 1)

# 2. Print the 20th number form the vector you created.

numbers[20]

# 3. Print the 50th to the 70th numbers from the vector you created.

numbers[50:70]



## Part 3: Working with string vectors ----

# Theodosius Dobzhansky famously said "Nothing in biology makes sense except in the light of evolution".

# Create a string vector of words from this quote:
quote1 <- c("Nothing", "biology", "in", "makes", "sense")
quote2 <- c("evolution", "in", "the", "light", "of", "except")

# 1. Rearrange the words in your vectors so that the quote matches the original when you print them one after the other.

quote1 <- quote1[c(1, 3, 2, 4, 5)]
quote2 <- quote2[c(6, 2, 3, 4, 5, 1)]
print(c(quote1, quote2))

# 2. Use the paste() function to create a new object that pastes the two parts together in the correct order, into a single string vector.

quote_full <- paste(c(quote1, quote2))
quote_full



## Part 4: Working with dataframes ----

# Install and library the Palmer Penguins package into your environment, and load the datframe.

install.packages("palmerpenguins")
library(palmerpenguins)
data(penguins)

# 1. Display the top rows of the penguins dataframe using the head() function.

head(penguins)


# 2. Calculate the means of bill length, bill depth, and flipper length across the entire dataset using the mean() function.

mean(penguins$bill_length_mm, na.rm = T)
mean(penguins$bill_depth_mm, na.rm = T)
mean(penguins$flipper_length_mm, na.rm = T)


# 3. How many different species are in the penguins dataset?

unique(penguins$species)
    # or
levels(penguins$species)


# 4. Add a column to the penguins dataframe called bill_area which multiplies bill length by bill depth. 

penguins$bill_area <- penguins$bill_depth_mm * penguins$bill_length_mm

#    Look at the top of the dataframe with head() to check the output.

head(penguins)


# 5. Make a new dataframe that contains only the data for the Adelie penguins using the subset() function. Use View() to check your work.

new_penguins <- subset(penguins, species == "Adelie")
View(new_penguins)



## Part 5: Plotting with baseR ----

# 1. Make a boxplot showing the differences in bill length between species, then do the same with flipper length.

boxplot(bill_length_mm ~ species, data = penguins)
boxplot(flipper_length_mm ~ species, data = penguins)

# 2. Make a scatter plot of bill length vs bill depth.

plot(penguins$bill_length_mm, penguins$bill_depth_mm)

# 3. Make a histogram of bill length, and then another of flipper length.

hist(penguins$bill_length_mm)
hist(penguins$flipper_length_mm)
