# STAT 301-2 Final Project
# Fitting the linear model
# 4_fit_lm.R

# load packages
library(tidyverse)
library(tidymodels)
library(here)

# load train-test split
load(here("data/airbnb_train.rda"))
load(here("data/airbnb_test.rda"))

# define basic recipe 1 
recipe1_basic <- recipe(price ~ ., data = airbnb_train) |>
  step_rm(name, host_name) |>  
  step_other(all_nominal(), -all_outcomes(), threshold = 0.01) |>  
  step_unknown(all_nominal(), -all_outcomes()) |>  
  step_dummy(all_nominal(), -all_outcomes()) |>  
  step_zv(all_predictors()) |>  
  step_impute_median(all_numeric(), -all_outcomes()) |>  
  step_normalize(all_numeric(), -all_outcomes())  

# define linear model
lm_model <- linear_reg() |>
  set_engine("lm") |>
  set_mode("regression")

# create workflow
lm_wflow <- workflow() |>
  add_recipe(recipe1_basic) |>  
  add_model(lm_model)

# fit model
lm_fit <- lm_wflow |>
  fit(data = airbnb_train)

# predict on test set
lm_preds <- predict(lm_fit, new_data = airbnb_test) |>
  bind_cols(airbnb_test)

# calculate rmse
rmse_lm <- rmse(lm_preds, truth = price, estimate = .pred)

# save / write out fitted model
save(lm_fit, file = here("models/lm_fit.rda"))

# save / write out model performance
lm_performance <- data.frame(Model = "Linear Model", RMSE = rmse_lm$.estimate)
save(lm_performance, file = here("results/model_performance_lm.rda"))
