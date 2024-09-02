  library(rsample)
  library(tidyverse)
  library(caret)
  library(corrplot)
  library(pROC)
  # Aplicam pasul de curatare a datelor
  source(file = "data-processing.R")
  # Vom crea coloana "Profitable" pentru a imparti o vanzare in profitabil/neprofitabils
  # 1 - profitabil
  # 0 - neprofitabil
  Superstore$Profitable <- ifelse(Superstore$Profit > 0, 1, 0)
  
  # Transformam coloana "Profitable" in factor
  Superstore$Profitable <- as.factor(Superstore$Profitable)
  
  # Preprocesarea datelor
  # Pastram doar variabilele relevante si modificam Profitable pentru a contine label-uri Yes/No
  Superstore <- Superstore %>%
    select(Region, Subcategory, Discount, Profitable) %>%
    mutate(
      Discount = factor(Discount),
      Profitable = factor(Profitable, levels = c(0, 1), labels = c("No", "Yes"))
    )
  
  # Impartim setul de date in set de test si de training
  set.seed(123)
  split <- initial_split(Superstore, prop = 0.7, strata = "Profitable")
  train <- training(split)
  test <- testing(split)
  
  table(train$Profitable)
  table(test$Profitable)
  
  # Pregatim setul de training
  features <- setdiff(names(train), "Profitable")
  x <- train[, features]
  y <- train$Profitable
  
  # Folosim 10-fold Cross Validation
  train_control <- trainControl(
    method = "cv",
    number = 10,
    classProbs = TRUE,
    summaryFunction = twoClassSummary
  )
  
  # Antrenam modelul de regresie logistica
  mod_logit <- train(
    x = x,
    y = y,
    method = "glm",
    family = "binomial",
    trControl = train_control,
    metric = "ROC"
  )
  
  # Evaluarea modelului
  confusionMatrix(mod_logit)
  
  # Facem predictii folosind setul de date de antrenare
  pred <- predict(mod_logit, test)
  confusionMatrix(pred, test$Profitable)
  
  # Evaluam performanta modelului folosind curba ROC
  pred_prob <- predict(mod_logit, test, type = "prob")[,2]
  roc_val <- roc(test$Profitable, pred_prob)
  plot(roc_val)
  auc_val <- auc(roc_val)
  auc_val
