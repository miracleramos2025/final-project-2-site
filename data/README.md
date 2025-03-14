# Data Folder

This folder contains the dataset and preprocessed data used for the Airbnb price prediction final project.

## **Contents**

### **1. Raw Dataset**
- `AB_NYC_2019.csv` – Original dataset containing Airbnb listings in New York City.

### **2. Processed Data**
- `airbnb_split.rda` – Contains the initial data split into training and testing sets.
- `airbnb_train.rda` – Training dataset used for model development.
- `airbnb_test.rda` – Testing dataset used for final model evaluation.

### **3. Feature Engineering Recipes**
- `recipe1_basic.rda` – Basic feature engineering for Recipe 1.
- `recipe1_advanced.rda` – Advanced feature engineering for Recipe 1.
- `recipe2_basic.rda` – Basic feature engineering for Recipe 2.
- `recipe2_advanced.rda` – Advanced feature engineering for Recipe 2.

### **4. Data Summaries**
- `dataset_summary.rda` – Summary statistics of the dataset.
- `var_type_summary.rda` – Summary of variable types (categorical, numerical, etc.).

## **Usage**
- Load any `.rda` file in R using:
  ```r
  load("data/airbnb_train.rda")
