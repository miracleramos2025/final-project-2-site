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

# compute additional metrics for more evaluation
final_mae <- mae(final_preds, truth = price, estimate = .pred)
final_rsq <- rsq(final_preds, truth = price, estimate = .pred)

# print model performance metrics
print(final_rmse)
print(final_mae)
print(final_rsq)

# save final model performance
final_model_performance <- data.frame(
  Metric = c("RMSE", "MAE", "R-squared"),
  Value = c(final_rmse$.estimate, final_mae$.estimate, final_rsq$.estimate)
)
save(final_model_performance, file = here("results/final_model_performance.rda"))

# visualize predictions vs actual values
library(ggplot2)

ggplot(final_preds, aes(x = .pred, y = price)) +
  geom_point(alpha = 0.3) +
  geom_abline(slope = 1, intercept = 0, color = "blue") +
  labs(
    title = "Predicted vs. Actual Prices",
    x = "Predicted Price",
    y = "Actual Price"
  ) +
  theme_minimal()

# save plot
ggsave(here("results/final_model_predictions.png"))

