# STAT 301-2 Final Project
# Train Final Model
# 7_train_final_model.R

# load packages
library(tidyverse)
library(tidymodels)
library(here)

# load train-test split
load(here("data/airbnb_train.rda"))
load(here("results/final_model.rda"))  

# define basic recipe 1 (same preprocessing)
recipe1_basic <- recipe(price ~ ., data = airbnb_train) |>
  step_rm(name, host_name, last_review) |>  
  step_other(all_nominal(), -all_outcomes(), threshold = 0.01) |>  
  step_unknown(all_nominal(), -all_outcomes()) |>  
  step_dummy(all_nominal(), -all_outcomes()) |>  
  step_zv(all_predictors()) |>  
  step_impute_median(all_numeric(), -all_outcomes()) |>  
  step_normalize(all_numeric(), -all_outcomes())

# check which model won
final_model_name <- trimws(final_model$Model[1])  

# define final model based on the selected one
if (final_model_name == "Linear Model") {
  final_model <- linear_reg() |> set_engine("lm")
} else if (final_model_name == "Elastic Net") {
  final_model <- linear_reg(penalty = best_en$penalty, mixture = best_en$mixture) |> 
    set_engine("glmnet")
} else if (final_model_name == "KNN") {
  final_model <- nearest_neighbor(neighbors = best_knn$neighbors) |> 
    set_engine("kknn")
} else if (final_model_name == "Random Forest") {
  final_model <- rand_forest(mtry = best_rf$mtry, min_n = best_rf$min_n, trees = 500) |> 
    set_engine("ranger")
} else if (final_model_name == "Boosted Trees") {
  final_model <- boost_tree(mtry = best_bt$mtry, min_n = best_bt$min_n, learn_rate = best_bt$learn_rate, trees = 500) |> 
    set_engine("xgboost")
} else {
  stop(paste("Unknown final model selected:", final_model_name))
}

# Set mode for regression
final_model <- final_model |> set_mode("regression")

# create workflow
final_wflow <- workflow() |> 
  add_recipe(recipe1_basic) |>  
  add_model(final_model)

# fit final model
final_fit <- final_wflow |> 
  fit(data = airbnb_train)

# save the final fitted model
save(final_fit, file = here("models/final_fit.rda"))

