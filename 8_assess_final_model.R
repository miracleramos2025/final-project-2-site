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

# Check if price was transformed during training
if ("log_price" %in% colnames(airbnb_train)) {
  # Ensure all predictions are valid before back-transforming
  final_preds <- final_preds |> 
    mutate(.pred = ifelse(.pred < 0, NA, 10^.pred - 1))  # Set invalid predictions to NA
}

# Remove non-finite values before computing metrics
final_preds_clean <- final_preds |> 
  filter(!is.na(.pred), !is.infinite(.pred), !is.na(price), !is.infinite(price))

# Cap extreme predictions at the 99th percentile to prevent instability
upper_bound <- quantile(final_preds_clean$.pred, 0.99, na.rm = TRUE)
final_preds_clean <- final_preds_clean |> mutate(.pred = pmin(.pred, upper_bound))

# Compute evaluation metrics on original price scale
final_rmse <- rmse(final_preds_clean, truth = price, estimate = .pred)
final_mae <- mae(final_preds_clean, truth = price, estimate = .pred)
final_rsq <- rsq(final_preds_clean, truth = price, estimate = .pred)

# Print model performance metrics
print(final_rmse)
print(final_mae)
print(final_rsq)

# Save final model performance
final_model_performance <- data.frame(
  Metric = c("RMSE", "MAE", "R²"),
  Value = c(final_rmse$.estimate, final_mae$.estimate, final_rsq$.estimate)
)
save(final_model_performance, file = here("results/final_model_performance.rda"))

# Save final predictions for visualization
save(final_preds_clean, file = here("results/final_preds.rda"))
