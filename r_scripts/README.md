# R Scripts for Airbnb Price Prediction

This folder contains all R scripts used for data preprocessing, feature engineering, model training, hyperparameter tuning, and model evaluation in the Airbnb price prediction final project.

## **Script Descriptions**
### **1. Data Preparation**
- `1_initial_split.R` – Splits data into training and test sets.

### **2. Feature Engineering (Recipes)**
- `2_recipe1_basic.R` – Basic feature engineering for Recipe 1.
- `2_recipe1_advanced.R` – Advanced feature engineering for Recipe 1.
- `3_recipe2_basic.R` – Basic feature engineering for Recipe 2.
- `3_recipe2_advanced.R` – Advanced feature engineering for Recipe 2.

### **3. Model Training**
- `4_fit_baseline.R` – Fits a baseline model for comparison.
- `4_fit_lm.R` – Fits a Linear Model.
- `4_fit_en.R` – Fits an Elastic Net Model.
- `4_fit_knn.R` – Fits a k-Nearest Neighbors (k-NN) Model.
- `4_fit_rf.R` – Fits a Random Forest Model.
- `4_fit_bt.R` – Fits a Boosted Trees Model.

### **4. Hyperparameter Tuning**
- `5_tune_en.R` – Hyperparameter tuning for Elastic Net.
- `5_tune_knn.R` – Hyperparameter tuning for k-Nearest Neighbors.
- `5_tune_rf.R` – Hyperparameter tuning for Random Forest.
- `5_tune_bt.R` – Hyperparameter tuning for Boosted Trees.

### **5. Model Evaluation & Final Model Selection**
- `6_model_analysis.R` – Evaluates model performance and compares results.
- `7_train_final_model.R` – Trains the final selected model.
- `8_assess_final_model.R` – Assesses the final model’s performance on the test set.

### **Other Scripts**
- `sandbox.R` – Used for testing and debugging code snippets.

## **Usage**
1. Run `1_initial_split.R` to split the data.
2. Execute feature engineering scripts (`2_recipe*` and `3_recipe*`).
3. Train models using the `4_fit_*` scripts.
4. Tune hyperparameters with `5_tune_*` scripts.
5. Compare models using `6_model_analysis.R`.
6. Train the final model with `7_train_final_model.R`.
7. Evaluate final model performance using `8_assess_final_model.R`.

This folder is structured to maintain **a clear workflow** from data preparation to model evaluation. 

