# STAT 301-2 Final Project
# Tuning the Lasso Regression Model
# 5_tune_lasso.R

# load packages
library(tidyverse)
library(tidymodels)
library(here)

# load train data
load(here("data/airbnb_train.rda"))

# define lasso regression model with tuning parameter
lasso_model <- linear_reg(penalty = tune(), mixture = 1) |>  
  set_engine("glmnet") |>
  set_mode("regression")

# create workflow
lasso_wflow <- workflow() |>
  add_recipe(recipe1_basic) |>  # Uses basic recipe
  add_model(lasso_model)

# set up cross-validation
set.seed(123)
cv_folds <- vfold_cv(airbnb_train, v = 3, repeats = 3)

# define grid for tuning
lasso_grid <- grid_regular(penalty(), levels = 10)

# tune hyperparameters
lasso_tune <- tune_grid(
  lasso_wflow,
  resamples = cv_folds,
  grid = lasso_grid,
  metrics = metric_set(rmse)
)

# extract best hyperparameters
best_lasso <- select_best(lasso_tune, metric = "rmse")

# save / write out tuning results and best hyperparameters
save(lasso_tune, best_lasso, file = here("results/lasso_tune.rda"))
