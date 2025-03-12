# STAT 301-2 Final Project
# Tuning the elastic net model
# 4_tune_en.R

# load packages
library(tidyverse)
library(tidymodels)
library(here)

# load train-test split
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

# define elastic net model with tuning parameters
elasticnet_model <- linear_reg(penalty = tune(), mixture = tune()) |>
  set_engine("glmnet") |>
  set_mode("regression")

# create workflow
elasticnet_wflow <- workflow() |>
  add_recipe(recipe1_basic) |>  
  add_model(elasticnet_model)

# set up cross-validation
set.seed(123)
cv_folds <- vfold_cv(airbnb_train, v = 3, repeats = 3)

# define grid for tuning
elasticnet_grid <- grid_regular(penalty(), mixture(), levels = 10)

# tune hyperparameters
elasticnet_tune <- tune_grid(
  elasticnet_wflow,
  resamples = cv_folds,
  grid = elasticnet_grid,
  metrics = metric_set(rmse)
)

# extract best hyperparameters (fix argument)
best_elasticnet <- select_best(elasticnet_tune, metric = "rmse")

# save / write out tuning results and best hyperparameters
save(elasticnet_tune, best_elasticnet, file = here("results/elasticnet_tune.rda"))



