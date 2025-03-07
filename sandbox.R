# STAT 301-2 Final Project
# Data Exploration

# load packages
library(tidyverse)
library(skimr)
library(janitor)
library(here)

# load data
airbnb_data <- read_csv("data/AB_NYC_2019.csv")

# clean column names
airbnb_data <- airbnb_data |> clean_names()

# dataset dimensions
num_observations <- nrow(airbnb_data)
num_variables <- ncol(airbnb_data)

# calculate missing values percentage
missing_values <- colSums(is.na(airbnb_data))
missing_percentage <- round((missing_values / num_observations) * 100, 3)

# dataset summary table
dataset_summary <- tibble(
  Dataset = "AB_NYC_2019",
  Observations = num_observations,
  Variables = num_variables,
  `Missingness %` = mean(missing_percentage)
)

# variable types
var_types <- airbnb_data %>% 
  summarise_all(class) %>% 
  pivot_longer(everything(), names_to = "Variable", values_to = "Type")

# rename cols
var_types$Type <- ifelse(var_types$Type == "character", "Categorical", var_types$Type)

# variable type names capitalized
var_types$Type <- str_to_title(var_types$Type)

# count each variable type
var_type_summary <- var_types %>% 
  count(Type, name = "Count")

# save data check summaries
save(dataset_summary, file = here("data/dataset_summary.rda"))
save(var_type_summary, file = here("data/var_type_summary.rda"))


