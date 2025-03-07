# STAT 301-2 Final Project
# Fitting the elastic net model
# 4_fit_en.R

# load packages
library(tidyverse)
library(tidymodels)
library(here)

# load train-test split
load(here("data/airbnb_train.rda"))
load(here("data/airbnb_test.rda"))

# load tuning results
load(here("results/elasticnet_tune.rda"))

# define basic recipe 1
recipe1_basic <- recipe(price ~ ., data = airbnb_train) |>
  step_rm(name, host_name, last_review) |>  
  step_other(all_nominal(), -all_outcomes(), threshold = 0.01) |>  
  step_unknown(all_nominal(), -all_outcomes()) |>  
  step_dummy(all_nominal(), -all_outcomes()) |>  
  step_zv(all_predictors()) |>  
  step_impute_median(all_numeric(), -all_outcomes()) |>  
  step_normalize(all_numeric(), -all_outcomes())  

# define elastic net model with best hyperparameters
elasticnet_model <- linear_reg(penalty = best_elasticnet$penalty, mixture = best_elasticnet$mixture) |>
  set_engine("glmnet") |>
  set_mode("regression")

# create workflow
elasticnet_wflow <- workflow() |>
  add_recipe(recipe1_basic) |>  
  add_model(elasticnet_model)

# fit final model
elasticnet_fit <- elasticnet_wflow |>
  fit(data = airbnb_train)

# predict on test set
elasticnet_preds <- predict(elasticnet_fit, new_data = airbnb_test) |>
  bind_cols(airbnb_test)

# calculate rmse
rmse_elasticnet <- rmse(elasticnet_preds, truth = price, estimate = .pred)

# save fitted model
save(elasticnet_fit, file = here("models/elasticnet_fit.rda"))

# save model performance
elasticnet_performance <- data.frame(Model = "Elastic Net", RMSE = rmse_elasticnet$.estimate)
save(elasticnet_performance, file = here("results/model_performance_en.rda"))

