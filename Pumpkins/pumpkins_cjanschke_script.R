#!/usr/bin/env Rscript


### Title: Pumpkins challenge script
### Author: Chris Janschke
### Date: 11.12.2025
### Description: Code for the pumpkins challenge in the L4138 coursework. Pumpkins_09 currently inputted as dataset.


#install.packages("tidyverse")
#install.packages("viridis")
#install.packages("plotly")
#install.packages('svglite')
#install.packages('ggpubr')
library(tidyverse)
library(dplyr)
library(ggplot2)
library(viridis)
library(plotly)
library(svglite)
library(ggpubr)


# function to 'clean' data by removing rows containing NA in a specific column
# @param dataframe Name of dataframe
# @param column_name Name of column in dataframe to remove NA values default includes all columns if no column name provided
# @return dataframe The dataframe without NA values
na_remover = function(dataframe, column_name = (everything(dataframe))) {
  na_count = sum(is.na(dataframe[column_name]))
  if (sum(is.na(dataframe[column_name])) > 0) { # counts instances of NA in the column. Statment activate if 1 or more instances of NA exist
    dataframe = dataframe %>% drop_na(all_of(column_name)) #removes rows containing NA
    print(paste("The specified data been checked for instances of 'NA'. The data has been cleaned. In total,", na_count, "instances of 'NA' were removed."))
    return(dataframe)
  } else {
    print("The specified data has been checked for instances of 'NA'. The data did not require cleaning as it did not contain any instances of 'NA'.")
    return(dataframe)
  }
}

# function to read in a .csv file
# @param path File path to locate .csv file to be read in
# @return myfile The .csv file
read_file.csv = function(path) {
  tryCatch({
    myfile = read.csv(path, header = TRUE)
    return(myfile)
  },
  warning = function(w) {
    message("Warning occured during reading in .csv file. Please enter valid path.")
  })
}




#1 
# use read_file.csv function to read in the .csv file
pumpkins <- read_file.csv("/Users/christopherjanschke/GIT/COURSEWORK_LIFE4138_2526/Pumpkins/pumpkins_datasets/pumpkins_09.csv") # input path to .csv file within the quote marks



#2
# identify heaviest pumpkin and show its variety, country of origin and when it was grown
heaviest_pumpkin <- pumpkins %>%
  arrange(desc(weight_lbs)) %>% # shows heaviest pupmpkin in row 1 of dataframe
  select(weight_lbs, variety, country, id) %>% # omits irrelevant columns
  head(1) # shows the heaviest pumpkin in dataframe

# displays heaviest pumpkin
print("The heaviest pumpkin is:")
print(heaviest_pumpkin)

#3
# anonymous function to calculate pumpkin weight in kg and add as new column to pumpkins 
pumpkins_kg_weight = function() {
  pumpkins_kg = mutate(pumpkins, weight_kg = weight_lbs * 0.45359237) # creates new column ('weight_kg') with a converted weight from lbs to kg
  return(pumpkins_kg) # returns pumpkins dataset with new column displaying the weight in kg
}

pumpkins <- pumpkins_kg_weight() # assign the output of pumpkins_kg_weight function to the pumpkins dataset

head(pumpkins, 3) #shows first 3 rows of dataframe to illustrate the new column



#4
# add new column for weight class: light, medium, heavy
pumpkins <- mutate(pumpkins, weight_class = factor(case_when(
  weight_lbs < 400 ~ 'Light',
  weight_lbs < 800 ~ 'Medium',
  TRUE ~ 'Heavy'))) #adds 'weight_class' column and defines thresholds for levels


head(pumpkins, 3) # shows the first 3 rows to illustrate the new 'weight_class' column


pumpkins %>%
  count(weight_class) # shows frequency of each level in the weight_class column


#5 
# graph to show relationship between estimated weight and actual weight
estweight_vs_actweight <-ggplot(data = na_remover(pumpkins, 'est_weight'), # removes NA values from 'est_weight' column in pumpkins before loading in the data
                                aes(x = est_weight, y = weight_lbs)) +
  geom_point(aes(colour = weight_class), size = 1, alpha = 0.4) +
  theme_bw() +
  scale_colour_viridis_d() +
  labs(title = 'Relationship between Estimated Weight and Actual Weight',
       subtitle = 'Relationship break down by weight class',
       x = 'Estimated Weight (lb)',
       y = 'Actual Weight (lb)',
       color = 'Weight Class')

# save plot to coursework folder
#ggsave("estweight_vs_actweight.svg", width = 8.5, height = 5.3, path = "~/GIT/COURSEWORK_LIFE4138_2526/Pumpkins/") # file saved in svg format. Input desired path then remove # to activate code


#6
#creates new object containing filtered data from only Japan, Austria and Italy
fpumpkins_japan_austria_italy <- pumpkins %>%
  filter(country %in% c('Japan', 'Austria', 'Italy'))

#save filtered data locally as csv file
#write.csv(fpumpkins_japan_austria_italy, "~/GIT/COURSEWORK_LIFE4138_2526/Pumpkins/fpumpkins_japan_austria_italy.csv", row.names = F). Input desired path then remove # to activate code


#7
# calculating mean weight of pumpkins in Japan, Austria and Italy and showing country with highest mean weight
print("The first tibble shows the mean weight of pumpkins (lbs) for Japan, Austria and Italy")
print("The second tibble shows the country with the highest mean weight of pumpkins (lbs)")
fpumpkins_japan_austria_italy %>%
  group_by(country) %>%
  summarise(mean_weight_lbs = mean(weight_lbs, na.rm = TRUE)) %>%
  print() %>%
  arrange(desc(mean_weight_lbs)) %>%
  first() 

# calculating mean weight for each variety in Japan, Austria and Italy and showing variety and country with lowest mean weight
print("The first tibble shows the mean weight (lbs) for each variety in each country")
print("The second tibble shows the variety and country of the pumpkin with lowest mean weight")
fpumpkins_japan_austria_italy %>%
  group_by(country, variety) %>%
  summarise(mean_weight_lbs = mean(weight_lbs, na.rm = T)) %>%
  print() %>%
  arrange(mean_weight_lbs) %>%
  first()


#8
# create a boxplot of weight by country using the filtered data set

# any 'NA' values in the data are removed prior to loading in the data
weight_by_country <- ggplot(aes(x = country, y = weight_lbs, fill = country), data = na_remover(fpumpkins_japan_austria_italy, 'weight_lbs')) +
  geom_boxplot(whisker.colour = 'cadetblue', median.colour = 'blue', outlier.colour = 'darkred', alpha = 0.6) +
  theme_pubr(
    border = TRUE,
    legend = 'right',
    x.text.angle = 45
  ) +
  labs_pubr() +
  scale_fill_viridis_d() +
  labs(title = 'Pumpkin weight according to country',
       x = 'Country',
       y = 'Weight (lbs)',
       fill = 'Country')

# save plot to coursework folder
#ggsave("weight_by_country.svg", width = 6.5, height = 5.3, path = "~/GIT/COURSEWORK_LIFE4138_2526/Pumpkins/") # file saved in svg format. Input desired path then remove # to activate code

#9
# re-draw plot as facet plot showing weight distribution for
# each variety, separated by each country
weight_by_country +
  facet_wrap(~variety, ncol = 9) +
  theme_pubr(x.text.angle = 70) +
  theme(
    axis.text.x = element_blank(),
    panel.spacing = unit(0.5, 'cm'),
    panel.border = element_rect(colour = 'black'),
    panel.heights = unit(10, 'cm'),
    panel.widths = unit(35, 'cm'),
    plot.title = element_text(size = 20, face = 'bold'),
    plot.subtitle = element_text(size = 15)
  ) +
  labs(
    title = 'Pumpkin weight according to variety',
    subtitle = 'Breakdown by country',
    x = NULL
  )
