###############################################################################
#                                                                             #
#  LIFE4138: R Workshop 3 – "Have a Go" Questions                             #
#                                                                             #
#  Author: Hannah Jackson                                                     #
#  Date: 14th Oct 2025                                                        #
#                                                                             #
#  Description:                                                               #
#  This script contains worked solutions to the "Have a Go" questions         #
#  from the third R workshop in LIFE4138.                                     #
#                                                                             #
###############################################################################

## Have a go:

# 1.  Write a for loop to iterate over the numbers 1 to 100, multiply each one by 5, and print the output

for (i in 1:100){
  print(i * 5)
}

# 2.  Write an if statement to multiply a number by 10, **but** only if it is under 100

num <- 2
if (num < 100){
  print(num * 10)
}

# 3.  Write an `ifelse()` statement to out "x is big" if x is greater than or equal to 20, 
# and "x is small" if x is less than 20

x = 20
ifelse(x >= 20, "x is big", "x is small")

# 4.  Write a function to divide one input by another, and return an output

division <- function(x, y){
  return(x/y)
}

division(10, 2)

# 5.  Modify that function to have a defualt value for one input

division <- function(x, y = 2){
  return(x/y)
}

division(20)

# 6.  Write a function to add 50 to an input, **but** only if that input is less than 50

add_50 <- function(x){
  if (x < 50){
    print(x + 50)
  }
}

add_50(10)
add_50(100)

# 7.  **brucey bonus:** use nested `ifelse()` statements to add a new factor variable to the airquality dataset, 
# which has a value of "early" if the day is 10 or under, "middle" if the day is 11-12, and "late" if the day 
# is 21 or greater (this one is tricky!)

data("airquality")
airquality$category <- ifelse(airquality$Day <= 10, "early",
       ifelse((airquality$Day == 11 | airquality$Day == 12), "middle", "late")
       )
 head(airquality)
 
 
# ## Have a go:
# 
# 1.  Create a new list, with 5 named elements. 
# Make sure you include logical, chacater, two numeric elements, and at least one dataframe.

 my_list <- list(
   logic = c(TRUE, FALSE, TRUE),
   number = 1:100,
   more_numbers = 1:20,
   character = c("pig", "goat", "sloth", "badger"),
   sausages = data.frame(
     Name = c("Cumberland", "Chorizo", "Bratwurst"),
     Origin = c("UK", "Spain", "Germany"),
     Meat = c("Pork", "Pork", "Pork and Veal"),
     Spiciness = c("Mild", "Spicy", "Mild"),
     Price_per_kg = c(8.50, 10.00, 9.20)
   )
 )
 
# 2.  Using its number, access the second element in the list, and return it (as a list!)

my_list[2]
 
# 3.  Using its number, access the second element in the list, and return it as a vector or dataframe (whichever it would be outside of the context of the list)

my_list[[2]]
 
# 4.  Using its name, access the 5th element of the list

my_list$sausages
 
# 5.  Using `apply()`, find the total sums of each column in the `airquality` dataset 
# (note: you'll need to reload the dataset to remove the column we added to it earlier)

data(airquality) 
apply(airquality, 2, sum, na.rm = T)

# 6.  Using `lapply()`, print the classes of the items in the list that you made in question 1.

lapply(my_list, class)
 
# 7.  **Brucey bonus:** Using `apply()`, paired with your own custom function, output the square root 
# of the lengths of each item in the list you created in question 1

sapply(my_list, function(x){
  sqrt(length(x))
}, simplify = T)
