# STAT 301-2 Final Project
# Fitting the Elastic Net model
# 4_fit_en.R

# load packages
library(tidyverse)
library(tidymodels)
library(here)

# load train-test split
load(here("data/airbnb_train.rda"))
load(here("data/airbnb_test.rda"))

# load tuning results
load(here("results/en_tune.rda"))

# define basic recipe 1
recipe1_basic <- recipe(price ~ ., data = airbnb_train) |>
  step_rm(name, host_name, last_review) |>  
  step_other(all_nominal(), -all_outcomes(), threshold = 0.01) |>  
  step_unknown(all_nominal(), -all_outcomes()) |>  
  step_dummy(all_nominal(), -all_outcomes()) |>  
  step_zv(all_predictors()) |>  
  step_impute_median(all_numeric(), -all_outcomes()) |>  
  step_normalize(all_numeric(), -all_outcomes())  

# define Elastic Net model with best hyperparameters
en_model_final <- linear_reg(penalty = best_en$penalty, mixture = best_en$mixture) |>
  set_engine("glmnet") |>
  set_mode("regression")

# create workflow
en_wflow <- workflow() |>
  add_recipe(recipe1_basic) |>  
  add_model(en_model_final)

# fit final model
en_fit <- en_wflow |>
  fit(data = airbnb_train)

# predict on test set
en_preds <- predict(en_fit, new_data = airbnb_test) |>
  bind_cols(airbnb_test)

# calculate RMSE
rmse_en <- rmse(en_preds, truth = price, estimate = .pred)

# save fitted model
save(en_fit, file = here("models/en_fit.rda"))

# save model performance
en_performance <- data.frame(Model = "Elastic Net", RMSE = rmse_en$.estimate)
save(en_performance, file = here("results/model_performance_en.rda"))
