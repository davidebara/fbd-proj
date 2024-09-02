# Superstore Activity Analysis and Forecasting

This repository contains various machine learning models implemented in R, including data preprocessing steps and a sample dataset, specifically created for superstore activity analysis and forecasting. The project showcases the implementation of common machine learning algorithms, such as regression models, decision trees, and ensemble methods. This work was completed as part of a university course on Big Data, in collaboration with a colleague.

## Project Structure

- **R Scripts**:
  - `bagging.R`: Implements the Bagging ensemble technique.
  - `data-processing.R`: Handles the preprocessing of the dataset, including data cleaning and transformation.
  - `decision-tree.R`: Implements a Decision Tree model for classification or regression.
  - `linear-regression.R`: Implements a Linear Regression model for predicting a continuous target variable.
  - `logistic-regression-single.R`: Implements Logistic Regression with a single predictor variable.
  - `logistic-regression.R`: Implements Logistic Regression with multiple predictor variables.
  - `naive-bayes.R`: Implements a Naive Bayes classifier.
  - `random-forests.R`: Implements a Random Forests classifier, an ensemble method that uses multiple decision trees.

- **Dataset**:
  - `dataset.csv`: The dataset used across the different models. The dataset is based on a Superstore and was obtained from [Kaggle](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final). Make sure to preprocess it using `data-processing.R` before feeding it into the models.

- **R Project File**:
  - `fbd-proj.Rproj`: R project file to manage the project environment in RStudio.

## Prerequisites

Before running the scripts, ensure you have the following R packages installed:

- `caret`
- `e1071`
- `randomForest`
- `rpart`
- `ggplot2`

You can install them using the following command:

```r
install.packages(c("caret", "e1071", "randomForest", "rpart", "ggplot2"))
```

## How to Run the Scripts

1. **Data Preprocessing**:
   Start by running `data-processing.R` to preprocess the dataset. This script will clean the data and prepare it for model training.

   ```r
   source("data-processing.R")
   ```

2. **Model Training and Evaluation**:
   You can run any of the model scripts individually to train and evaluate the corresponding machine learning model. For example, to run the decision tree model, use:

   ```r
   source("decision-tree.R")
   ```

   Similarly, you can run other scripts like `random-forests.R`, `logistic-regression.R`, etc.

## Acknowledgements

This project was developed as a learning resource for understanding and implementing machine learning models in R. Special thanks to the contributors of the R community and the developers of the packages used in this project, as well as the provider of the [Superstore dataset](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final) on Kaggle.