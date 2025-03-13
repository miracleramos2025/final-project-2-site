# STAT 301-2 Final Project
# Fitting the K-Nearest Neighbors (KNN) model
# 4_fit_knn.R

# load packages
library(tidyverse)
library(tidymodels)
library(here)

# load train-test split
load(here("data/airbnb_train.rda"))
load(here("data/airbnb_test.rda"))

# load best tuning results
load(here("results/knn_tune.rda"))

# define final KNN model using best hyperparameters
knn_model_final <- nearest_neighbor(
  neighbors = best_knn$neighbors,
  weight_func = "rectangular",
  dist_power = 2
) |> 
  set_engine("kknn") |> 
  set_mode("regression")

# create finalized workflow
knn_wflow <- workflow() |> 
  add_recipe(recipe1_basic) |>  
  add_model(knn_model_final)

# fit final model
knn_fit <- knn_wflow |>
  fit(data = airbnb_train)

# predict on test set
knn_preds <- predict(knn_fit, new_data = airbnb_test) |>
  bind_cols(airbnb_test)

# calculate RMSE
rmse_knn <- rmse(knn_preds, truth = price, estimate = .pred)

# save fitted model
save(knn_fit, file = here("models/knn_fit.rda"))

# save model performance
knn_performance <- data.frame(Model = "KNN", RMSE = rmse_knn$.estimate)
save(knn_performance, file = here("results/model_performance_knn.rda"))
