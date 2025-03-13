# STAT 301-2 Final Project
# Assess Final Model
# 8_assess_final_model.R

# load packages
library(tidyverse)
library(tidymodels)
library(here)

# load test set and final trained model
load(here("data/airbnb_test.rda"))
load(here("models/final_fit.rda"))

# predict on test data
final_preds <- predict(final_fit, new_data = airbnb_test) |> 
  bind_cols(airbnb_test)

# compute RMSE
final_rmse <- rmse(final_preds, truth = price, estimate = .pred)

# print RMSE for final model
print(final_rmse)

# save final model performance
save(final_rmse, file = here("results/final_model_performance.rda"))
