# STAT 301-2 Final Project
# Tuning the Elastic Net model
# 5_tune_en.R

# load packages
library(tidyverse)
library(tidymodels)
library(here)

# load train split
load(here("data/airbnb_train.rda"))

# define basic recipe 1
recipe1_basic <- recipe(price ~ ., data = airbnb_train) |>
  step_rm(name, host_name, last_review) |>  
  step_other(all_nominal(), -all_outcomes(), threshold = 0.01) |>  
  step_unknown(all_nominal(), -all_outcomes()) |>  
  step_dummy(all_nominal(), -all_outcomes()) |>  
  step_zv(all_predictors()) |>  
  step_impute_median(all_numeric(), -all_outcomes()) |>  
  step_normalize(all_numeric(), -all_outcomes())  

# define Elastic Net model with tuning parameters
en_model <- linear_reg(penalty = tune(), mixture = tune()) |>
  set_engine("glmnet") |>
  set_mode("regression")

# create workflow
en_wflow <- workflow() |>
  add_recipe(recipe1_basic) |>  
  add_model(en_model)

# set up cross-validation
set.seed(123)
cv_folds <- vfold_cv(airbnb_train, v = 3, repeats = 3)

# define grid for tuning
en_grid <- grid_regular(penalty(), mixture(), levels = 10)

# tune hyperparameters
en_tune <- tune_grid(
  en_wflow,
  resamples = cv_folds,
  grid = en_grid,
  metrics = metric_set(rmse)
)

# extract best hyperparameters
best_en <- select_best(en_tune, metric = "rmse")

# save tuning results and best hyperparameters
save(en_tune, best_en, file = here("results/en_tune.rda"))
