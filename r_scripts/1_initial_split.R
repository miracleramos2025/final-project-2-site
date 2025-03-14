# STAT 301-2 Final Project
# Initial data checks & data splitting

# load packages
library(tidyverse)
library(tidymodels)
library(here)
library(patchwork)

# load data
airbnb_data <- read_csv("data/AB_NYC_2019.csv")

# handle common conflicts
tidymodels_prefer()

# set seed
set.seed(123)  

# data splitting: 80% train, 20% test
airbnb_split <- initial_split(airbnb_data, prop = 0.8, strata = price)
airbnb_train <- training(airbnb_split)
airbnb_test <- testing(airbnb_split)

# save / write out train-test split
save(airbnb_split, file = here("data/airbnb_split.rda"))
save(airbnb_train, file = here("data/airbnb_train.rda"))
save(airbnb_test, file = here("data/airbnb_test.rda"))

