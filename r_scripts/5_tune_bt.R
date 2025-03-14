# STAT 301-2 Final Project
# Tuning the Boosted Trees model
# 5_tune_bt.R

# load packages
library(tidyverse)
library(tidymodels)
library(here)
library(doParallel) 

# set up parallel processing
cl <- makePSOCKcluster(parallel::detectCores() - 1)
registerDoParallel(cl)

# load training data
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

# define boosted trees model with tuning parameters
bt_model <- boost_tree(
  trees = 500,
  mtry = tune(),
  min_n = tune(),
  learn_rate = tune()
) |> 
  set_engine("xgboost") |> 
  set_mode("regression")

# make workflow
bt_wflow <- workflow() |> 
  add_recipe(recipe1_basic) |>  
  add_model(bt_model)

# set up cross-validation
set.seed(123)
cv_folds <- vfold_cv(airbnb_train, v = 3, repeats = 3)

# define grid for tuning (adjusted learn_rate max to 0.3)
bt_grid <- grid_regular(
  mtry(range = c(2, 10)), 
  min_n(range = c(2, 10)), 
  learn_rate(range = c(0.001, 0.3), trans = scales::log10_trans()),  
  levels = 5  
)

# tune hyperparameters
bt_tune <- tune_grid(
  bt_wflow,
  resamples = cv_folds,
  grid = bt_grid,
  metrics = metric_set(rmse),  
  control = control_grid(save_pred = TRUE, verbose = TRUE)  
)

# extract best hyperparameters
best_bt <- select_best(bt_tune, metric = "rmse")

# save / write out tuning results and best hyperparameters
save(bt_tune, best_bt, file = here("results/bt_tune.rda"))

# stop parallel processing
stopCluster(cl)
registerDoSEQ()  
gc()  
