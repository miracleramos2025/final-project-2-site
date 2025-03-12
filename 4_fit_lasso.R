# STAT 301-2 Final Project
# Fitting the Lasso Regression Model
# 4_fit_lasso.R

# load packages
library(tidyverse)
library(tidymodels)
library(here)

# load train-test split
load(here("data/airbnb_train.rda"))
load(here("data/airbnb_test.rda"))

# load tuning results
load(here("results/lasso_tune.rda"))

# define lasso model using best hyperparameters
lasso_final <- linear_reg(penalty = best_lasso$penalty, mixture = 1) |>  
  set_engine("glmnet") |>
  set_mode("regression")

# create finalized workflow
lasso_wflow <- workflow() |>
  add_recipe(recipe1_basic) |>  
  add_model(lasso_final)

# fit model on training data
lasso_fit <- lasso_wflow |>
  fit(data = airbnb_train)

# predict on test set
lasso_preds <- predict(lasso_fit, new_data = airbnb_test) |>  
  bind_cols(airbnb_test)

# calculate RMSE
rmse_lasso <- rmse(lasso_preds, truth = price, estimate = .pred)

# save / write out fitted model
save(lasso_fit, file = here("models/lasso_fit.rda"))

# save / write out model performance
lasso_performance <- data.frame(Model = "Lasso Regression", RMSE = rmse_lasso$.estimate)
save(lasso_performance, file = here("results/model_performance_lasso.rda"))
