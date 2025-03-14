# STAT 301-2 Final Project
# Basic recipe 2 for feature engineering
# 3_recipe2_basic.R

# load packages
library(tidyverse)
library(tidymodels)
library(here)

# load train-test split
load(here("data/airbnb_train.rda"))

# define basic recipe 2
recipe2_basic <- recipe(price ~ ., data = airbnb_train) |>
  step_rm(name, host_name) |>  
  step_other(all_nominal(), -all_outcomes(), threshold = 0.01) |>  
  step_unknown(all_nominal(), -all_outcomes()) |>  
  step_dummy(all_nominal(), -all_outcomes()) |>  
  step_zv(all_predictors()) |>  
  step_impute_median(all_numeric(), -all_outcomes()) |>  
  step_normalize(all_numeric(), -all_outcomes())  

# prep recipe
recipe2_basic <- prep(recipe2_basic)

# save / write. out basic recipe 2
save(recipe2_basic, file = here("data/recipe2_basic.rda"))
