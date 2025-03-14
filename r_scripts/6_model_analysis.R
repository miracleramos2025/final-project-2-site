# STAT 301-2 Final Project
# Model Analysis and Selection
# 6_model_analysis.R

# load libraries
library(tidyverse)
library(tidymodels)
library(here)

# load model performances
load(here("results/model_performance_baseline.rda"))
load(here("results/model_performance_lm.rda"))
load(here("results/model_performance_en.rda"))
load(here("results/model_performance_knn.rda"))
load(here("results/model_performance_rf.rda"))
load(here("results/model_performance_bt.rda"))

# combine results into a single dataframe
model_performance <- bind_rows(
  baseline_performance,
  lm_performance,
  en_performance,
  knn_performance,
  rf_performance,
  bt_performance
)

# add best tuning parameters
load(here("results/en_tune.rda"))
load(here("results/knn_tune.rda"))
load(here("results/rf_tune.rda"))
load(here("results/bt_tune.rda"))

# format tuning parameters as a separate column
model_performance <- model_performance %>%
  mutate(
    tuning_parameter = case_when(
      Model == "Elastic Net" ~ paste("mixture:", round(best_en$mixture, 3), "penalty:", best_en$penalty),
      Model == "KNN" ~ paste("neighbors:", best_knn$neighbors),
      Model == "Random Forest" ~ paste("mtry:", best_rf$mtry, "min_n:", best_rf$min_n),
      Model == "Boosted Trees" ~ paste("mtry:", best_bt$mtry, "min_n:", best_bt$min_n, "learn_rate:", round(best_bt$learn_rate, 4)),
      TRUE ~ "N/A"
    )
  )

# reorder columns for better readability
model_performance <- model_performance %>%
  select(Model, RMSE, tuning_parameter)

# display model results
print(model_performance)

# save table
save(model_performance, file = here("results/model_performance_summary.rda"))

# select final model (lowest RMSE)
final_model <- model_performance |>
  arrange(RMSE) |>
  slice(1)

# save final model choice
save(final_model, file = here("results/final_model.rda"))

# print final model choice
print(final_model)
