# Models Folder

This folder contains the fitted machine learning models used for predicting Airbnb prices in New York City.

## **Contents**

### **1. Fitted Models**
- `baseline_fit.rda` – Fitted baseline model.
- `lm_fit.rda` – Fitted Linear Model.
- `en_fit.rda` – Fitted Elastic Net Model.
- `knn_fit.rda` – Fitted k-Nearest Neighbors Model.
- `rf_fit.rda` – Fitted Random Forest Model.
- `bt_fit.rda` – Fitted Boosted Trees Model.

### **2. Final Model**
- `final_fit.rda` – Fitted final selected model.

## **Usage**
- Load any fitted model in R using:
  ```r
  load("models/lm_fit.rda")
