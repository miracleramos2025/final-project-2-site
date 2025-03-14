# STAT 301-2 Final Project
# Tuning the K-Nearest Neighbors (KNN) model
# 5_tune_knn.R

# load packages
library(tidyverse)
library(tidymodels)
library(here)
library(doParallel)

# set up parallel processing
cl <- makePSOCKcluster(parallel::detectCores() - 1)
registerDoParallel(cl)

# load training data
load(here("data/airbnb_train.rda"))

# define basic recipe 1
recipe1_basic <- recipe(price ~ ., data = airbnb_train) |>
  step_rm(name, host_name, last_review) |>  
  step_other(all_nominal(), -all_outcomes(), threshold = 0.01) |>  
  step_unknown(all_nominal(), -all_outcomes()) |>  
  step_dummy(all_nominal(), -all_outcomes()) |>  
  step_zv(all_predictors()) |>  
  step_impute_median(all_numeric(), -all_outcomes()) |>  
  step_normalize(all_numeric(), -all_outcomes())

# define KNN model with tuning parameters
knn_model <- nearest_neighbor(
  neighbors = tune(),  # Tune the number of neighbors
  weight_func = "rectangular",
  dist_power = 2
) |> 
  set_engine("kknn") |> 
  set_mode("regression")

# make workflow
knn_wflow <- workflow() |> 
  add_recipe(recipe1_basic) |>  
  add_model(knn_model)

# set up cross-validation
set.seed(123)
cv_folds <- vfold_cv(airbnb_train, v = 3, repeats = 3)

# define grid for tuning
knn_grid <- grid_regular(neighbors(range = c(3, 50)), levels = 10)  

# tune hyperparameters
knn_tune <- tune_grid(
  knn_wflow,
  resamples = cv_folds,
  grid = knn_grid,
  metrics = metric_set(rmse),  
  control = control_grid(save_pred = TRUE, verbose = TRUE)  
)

# extract best hyperparameters
best_knn <- select_best(knn_tune, metric = "rmse")

# save tuning results and best hyperparameters
save(knn_tune, best_knn, file = here("results/knn_tune.rda"))

# stop parallel processing
stopCluster(cl)
registerDoSEQ()
gc()
