# STAT 301-2 Final Project
# Fitting the baseline model
# 4_fit_baseline.R

# load packages
library(tidyverse)
library(tidymodels)
library(here)

# load train-test split
load(here("data/airbnb_train.rda"))
load(here("data/airbnb_test.rda"))

# define baseline model (predicts mean price)
baseline_model <- linear_reg() |>
  set_engine("lm") |>
  set_mode("regression")

# fit model
baseline_fit <- baseline_model |>
  fit(price ~ 1, data = airbnb_train)

# predict on test set
baseline_preds <- predict(baseline_fit, new_data = airbnb_test) |>
  bind_cols(airbnb_test)

# calculate rmse
rmse_baseline <- rmse(baseline_preds, truth = price, estimate = .pred)

# save fitted model in models/
save(baseline_fit, file = here("models/baseline_fit.rda"))

# save / write out model performance 
baseline_performance <- data.frame(Model = "Baseline", RMSE = rmse_baseline$.estimate)
save(baseline_performance, file = here("results/model_performance_baseline.rda"))


