# STAT 301-2 Final Project
# Fitting the Boosted Trees model
# 4_fit_bt.R

# load packages
library(tidyverse)
library(tidymodels)
library(here)

# load train-test split
load(here("data/airbnb_train.rda"))
load(here("data/airbnb_test.rda"))

# load best tuning results
load(here("results/bt_tune.rda"))

# load basic recipe 1
recipe1_basic <- recipe(price ~ ., data = airbnb_train) |>
  step_rm(name, host_name, last_review) |>  
  step_other(all_nominal(), -all_outcomes(), threshold = 0.01) |>  
  step_unknown(all_nominal(), -all_outcomes()) |>  
  step_dummy(all_nominal(), -all_outcomes()) |>  
  step_zv(all_predictors()) |>  
  step_impute_median(all_numeric(), -all_outcomes()) |>  
  step_normalize(all_numeric(), -all_outcomes())

# define final boosted trees model
bt_model_final <- boost_tree(
  trees = 500,
  mtry = best_bt$mtry,
  min_n = best_bt$min_n,
  learn_rate = best_bt$learn_rate
) |> 
  set_engine("xgboost") |> 
  set_mode("regression")

# create finalized workflow
bt_wflow <- workflow() |> 
  add_recipe(recipe1_basic) |>  
  add_model(bt_model_final)

# fit final model
bt_fit <- bt_wflow |>
  fit(data = airbnb_train)

# predict on test set
bt_preds <- predict(bt_fit, new_data = airbnb_test) |>
  bind_cols(airbnb_test)

# calculate RMSE
rmse_bt <- rmse(bt_preds, truth = price, estimate = .pred)

# save fitted model
save(bt_fit, file = here("models/bt_fit.rda"))

# save / write out model performance
bt_performance <- data.frame(Model = "Boosted Trees", RMSE = rmse_bt$.estimate)
save(bt_performance, file = here("results/model_performance_bt.rda"))
