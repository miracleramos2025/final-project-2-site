# Results Folder

This folder contains the saved results from model performance evaluations, hyperparameter tuning, and final model predictions for the Airbnb price prediction final project.

## **Contents**

### **1. Model Performance Metrics**
- `model_performance_baseline.rda` – Performance metrics for the baseline model.
- `model_performance_lm.rda` – Performance metrics for the Linear Model.
- `model_performance_en.rda` – Performance metrics for the Elastic Net Model.
- `model_performance_knn.rda` – Performance metrics for the k-Nearest Neighbors Model.
- `model_performance_rf.rda` – Performance metrics for the Random Forest Model.
- `model_performance_bt.rda` – Performance metrics for the Boosted Trees Model.
- `model_performance_summary.rda` – Summary file containing performance metrics for all models.

### **2. Hyperparameter Tuning Results**
- `en_tune.rda` – Tuning results for Elastic Net.
- `knn_tune.rda` – Tuning results for k-Nearest Neighbors.
- `rf_tune.rda` – Tuning results for Random Forest.
- `bt_tune.rda` – Tuning results for Boosted Trees.

### **3. Final Model & Predictions**
- `final_model.rda` – Saved final trained model.
- `final_model_performance.rda` – Performance metrics for the final selected model.
- `final_preds.rda` – Predictions made by the final model on the test set.

## **Usage**
- Load any `.rda` file in R using:
  ```r
  load("results/model_performance_lm.rda")
