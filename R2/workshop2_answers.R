###############################################################################
#                                                                             #
#  LIFE4138: R Workshop 2 – "Have a Go" Questions                             #
#                                                                             #
#  Author: Hannah Jackson                                                     #
#  Date: 14th Oct 2025                                                        #
#                                                                             #
#  Description:                                                               #
#  This script contains worked solutions to the "Have a Go" questions         #
#  from the second R workshop in LIFE4138.                                    #
#                                                                             #
###############################################################################


### Have a go part 1 ----

# All of these questions relate to the Starwars dataset from dplyr
# library(tidyverse)
# data(starwars)

# 1. Select the name and hair_color columns

starwars %>%
  select(name, hair_color)

# 2. Using pipes, select only columns which start with 'h'

starwars %>%
  select(starts_with('h'))

# 3. Using no pipes, filter the dataset to contain only those from the planet Naboo
filter(starwars, homeworld == "Naboo")

# 4. Subset the data to contain only the name and birthyear for all humans
starwars %>%
  filter(species == "Human") %>%
  select(name, birth_year)

  # OR

select(filter(starwars, species == "Human"), name, birth_year)

# 5. Summarise the number of records for each home planet in the starwars dataset
starwars %>%
  group_by(homeworld) %>%
  tally()

  # OR

starwars %>%
  count(homeworld)

# 6. Brucey bonus: use group_by() and summarise_at() to get the means of all the 
#    numeric variables for each species in the starwars dataset

starwars %>%
  group_by(species) %>%
  summarise_at(vars(height, mass, birth_year), mean)



### Have a go part 2 ----

# 1. Make a scatter plot of height and birth_year

ggplot(aes(x = height, y = birth_year), data = starwars) +
  geom_point()

# 2. Brucey bonus: Colour the points by species hint: you’ll have to use the aes() arugment

ggplot(aes(x = height, y = birth_year, colour = species), data = starwars)+
  geom_point()
# note that we have to use colour rather than fill because the defualt points are solid (i.e. don't have a fill option)

# 3. Use dplyr to find who is very old and very short…

starwars %>%
  filter(birth_year > 750, height < 100) %>%
  select(name, height, birth_year)

# 4. Make a histogram of heights, and change the bin widths until you think it’s appropriate

ggplot(aes(x = height), data = starwars) +
  geom_histogram(binwidth = 10, fill = "lightblue", colour = "black")

# 5. Use dplyr and ggplot2 to make a boxplot of the mass of three species of your choice 
#    hint: pick common ones

starwars %>%
  count(species) %>%
  arrange(desc(n))

starwars %>%
  filter(species == "Human" | species == "Droid" | species == "Gungan") %>%
  ggplot(aes(x = species, y = mass)) +
  geom_boxplot(fill = "lightblue")

# 6. Use the mtcars dataset, select the mpg, wt, and hp columns, and turn them into long data. 
#.   hint: be careful of row names!

mtcars$id <- row.names(mtcars)
mtcarslong <- mtcars %>%
  select(id, mpg, hp, wt) %>%
  pivot_longer(cols = c(2:4), names_to = "measure")
head(mtcarslong)

# 7. Turn this long data into a boxplot of car species against ‘value’, and facet wrap 
#.   using ‘measure’

# note; I have subset this to make it a bit nicer!
# also note; this doesn't really work as there is only a single value for each car type!
ggplot(data = mtcarslong[1:18,], aes(x = id, y = value))+
  geom_boxplot()+
  facet_wrap(~measure)


# 8. Brucey bonus: Change some of the themeing to remove the grey backgrounds, change fill of 
#.   the facet strip, and the angle of the text on the x axis. hint: look at the code for the 
#.   pretty facet-wrapped boxplot I showed you earlier…

ggplot(data = mtcarslong[1:18,], aes(x = id, y = value))+
  geom_boxplot()+
  facet_wrap(~measure)+
  labs(x = NULL, y = NULL)+
  theme(
    panel.grid = element_blank(),
    panel.background = element_blank(),
    panel.border = element_rect(colour = "black", fill = NA),
    strip.background = element_rect(fill = "salmon", colour = "darkred"),
    strip.text = element_text(face = "bold", size = 14),
    axis.text.x = element_text(angle = 90, hjust = 1, size = 14, colour = "black"),
    axis.text.y = element_text(colour = "grey20", size = 10),
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_line(colour = "grey95"),
    plot.margin = margin(10, 20, 10, 20),
    panel.spacing = unit(1, "lines")
  )
