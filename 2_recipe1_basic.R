# STAT 301-2 Final Project
# Basic recipe for feature engineering
# 2_recipe1_basic.R

# load packages
library(tidyverse)
library(tidymodels)
library(here)

# load train-test split
load(here("data/airbnb_train.rda"))

# define basic recipe
recipe1_basic <- recipe(price ~ ., data = airbnb_train) |>
  step_rm(name, host_name) |>
  step_other(all_nominal(), -all_outcomes(), threshold = 0.01) |> 
  step_unknown(all_nominal(), -all_outcomes()) |> 
  step_dummy(all_nominal(), -all_outcomes()) |> 
  step_zv(all_predictors()) |>
  step_normalize(all_numeric(), -all_outcomes())  

# prep recipe
recipe1_basic <- prep(recipe1_basic)

# save / write out basic recipe
save(recipe1_basic, file = here("data/recipe1_basic.rda"))
