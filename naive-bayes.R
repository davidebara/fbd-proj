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

#Preprocesarea datelor
# Pastram doar variabilele relevante si modificam Profitable pentru a contine label-uri Yes/No
Superstore <- Superstore %>%
  select(Region, Subcategory, Discount, Profitable) %>%
  mutate(
    Discount = factor(Discount),
    Profitable = factor(Profitable, levels = c(0, 1), labels = c("No", "Yes"))
  )

# Impartirea setului de date in set de antrenare si set de test
set.seed(123)
split <- initial_split(Superstore, prop = 0.7, strata = "Profitable")
train <- training(split)
test <- testing(split)

table(train$Profitable)
table(test$Profitable)


#Antrenarea modelului de clasificare
features <- setdiff(names(train), "Profitable")
x <- train[,features]
y <- train$Profitable

#Stabilim o metoda de validare: 10-folds Cross Validation
train_control <- trainControl(
  method = "cv",
  number = 10 )

#Invatarea modelului Naive Bayes
mod_nb1 <- train(
  x = x,
  y = y,
  method = "nb",
  trControl = train_control )
confusionMatrix(mod_nb1)

#Parametrii de optimizat la NB
search_grid <- expand.grid(
  usekernel = c(TRUE, FALSE),
  fL = 0.5,
  adjust = seq(0, 5, by = 1) )

#Re-antrenarea modelelor folosind gridul de cautare
mod_nb2 = train(
  x = x,
  y = y,
  method = "nb",
  trControl = train_control,
  tuneGrid = search_grid,
)
confusionMatrix(mod_nb2)

#Modelele rezultate in urma cautarii
mod_nb2$results %>%
  top_n(5, wt = Accuracy) %>%
  arrange(desc(Accuracy))

#Realizarea predictiilor
pred <- predict(mod_nb1, test)
confusionMatrix(pred, test$Profitable)

# Evaluam performanta modelului folosind curba ROC
pred_prob <- predict(mod_nb2, test, type = "prob")[,2]
roc_val <- roc(test$Profitable, pred_prob)
plot(roc_val)
auc_val <- auc(roc_val)

auc_val