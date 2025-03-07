# STAT 301-2 Final Project
# Advanced recipe 2 for feature engineering
# 3_recipe2_advanced.R

# load packages
library(tidyverse)
library(tidymodels)
library(here)

# load train-test split
load(here("data/airbnb_train.rda"))

# identify numeric variables with sufficient unique values
numeric_vars <- airbnb_train |>
  select(where(is.numeric)) |>
  summarise(across(everything(), n_distinct)) |>
  pivot_longer(everything(), names_to = "variable", values_to = "unique_values") |>
  filter(unique_values > 2) |>
  pull(variable)

# define advanced recipe 2
recipe2_advanced <- recipe(price ~ ., data = airbnb_train) |>
  step_rm(name, host_name) |>  
  step_other(all_nominal(), -all_outcomes(), threshold = 0.01) |>  
  step_unknown(all_nominal(), -all_outcomes()) |> 
  step_dummy(all_nominal(), -all_outcomes()) |>  
  step_zv(all_predictors()) |>  
  step_impute_median(all_numeric(), -all_outcomes()) |>  
  step_normalize(all_numeric(), -all_outcomes()) |>  
  step_interact(terms = ~ latitude:longitude) |>  
  step_poly(all_of(numeric_vars), degree = 2)  

# prep recipe
recipe2_advanced <- prep(recipe2_advanced)

# save / write out advanced recipe 2
save(recipe2_advanced, file = here("data/recipe2_advanced.rda"))
