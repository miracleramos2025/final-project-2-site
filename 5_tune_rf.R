# STAT 301-2 Final Project
# Tuning the Random Forest model
# 5_tune_rf.R

# load packages
library(tidyverse)
library(tidymodels)
library(here)

# load train split
load(here("data/airbnb_train.rda"))

# define basic recipe 1
recipe1_basic <- recipe(price ~ ., data = airbnb_train) |>
  step_rm(name, host_name) |>  
  step_other(all_nominal(), -all_outcomes(), threshold = 0.01) |>  
  step_unknown(all_nominal(), -all_outcomes()) |>  
  step_dummy(all_nominal(), -all_outcomes()) |>  
  step_zv(all_predictors()) |>  
  step_impute_median(all_numeric(), -all_outcomes()) |>  
  step_normalize(all_numeric(), -all_outcomes())

# define random forest model with tuning parameters
rf_model <- rand_forest(
  mtry = tune(),
  min_n = tune(),
  trees = 500
) |> 
  set_engine("ranger") |> 
  set_mode("regression")

# create workflow
rf_wflow <- workflow() |> 
  add_recipe(recipe1_basic) |>  
  add_model(rf_model)

# set up cross-validation
set.seed(123)
cv_folds <- vfold_cv(airbnb_train, v = 3, repeats = 3)

# define grid for tuning
rf_grid <- grid_regular(mtry(range = c(2, 10)), min_n(range = c(2, 10)), levels = 5)

# tune hyperparameters
rf_tune <- tune_grid(
  rf_wflow,
  resamples = cv_folds,
  grid = rf_grid,
  metrics = metric_set(rmse)
)

# extract best hyperparameters
best_rf <- select_best(rf_tune, metric = "rmse")

# save tuning results and best hyperparameters
save(rf_tune, best_rf, file = here("results/rf_tune.rda"))
