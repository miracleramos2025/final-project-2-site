# STAT 301-2 Final Project
# Fitting the Random Forest model
# 4_fit_rf.R

# load packages
library(tidyverse)
library(tidymodels)
library(here)

# load train-test split
load(here("data/airbnb_train.rda"))
load(here("data/airbnb_test.rda"))

# load best tuning results
load(here("results/rf_tune.rda"))

# load basic recipe 1
recipe1_basic <- recipe(price ~ ., data = airbnb_train) |>
  step_rm(name, host_name) |>  
  step_other(all_nominal(), -all_outcomes(), threshold = 0.01) |>  
  step_unknown(all_nominal(), -all_outcomes()) |>  
  step_dummy(all_nominal(), -all_outcomes()) |>  
  step_zv(all_predictors()) |>  
  step_impute_median(all_numeric(), -all_outcomes()) |>  
  step_normalize(all_numeric(), -all_outcomes())

# define final random forest model
rf_model_final <- rand_forest(
  mtry = best_rf$mtry,
  min_n = best_rf$min_n,
  trees = 500
) |> 
  set_engine("ranger") |> 
  set_mode("regression")

# create finalized workflow
rf_wflow <- workflow() |> 
  add_recipe(recipe1_basic) |>  
  add_model(rf_model_final)

# fit final model
rf_fit <- rf_wflow |>
  fit(data = airbnb_train)

# predict on test set
rf_preds <- predict(rf_fit, new_data = airbnb_test) |>
  bind_cols(airbnb_test)

# calculate RMSE
rmse_rf <- rmse(rf_preds, truth = price, estimate = .pred)

# save fitted model
save(rf_fit, file = here("models/rf_fit.rda"))

# save model performance
rf_performance <- data.frame(Model = "Random Forest", RMSE = rmse_rf$.estimate)
save(rf_performance, file = here("results/model_performance_rf.rda"))
