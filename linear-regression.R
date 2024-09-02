library(tidyverse)
library(modelr)
library(scatterplot3d)
library(vtable)
library(caret)

# regresie liniara simpla
lr_sales <- lm(Profit ~ Sales, data = Superstore)
lr_quantity <- lm(Profit ~ Quantity, data = Superstore)
lr_discount <- lm(Profit ~ Discount, data = Superstore)
lr_region <- lm(Profit ~ Region, data = Superstore)
lr_shipmode <- lm(Profit ~ ShipMode, data = Superstore)
lr_category <- lm(Profit ~ Category, data = Superstore)
lr_subcategory <- lm(Profit ~ Subcategory, data = Superstore)
lr_segment <- lm(Profit ~ Segment, data = Superstore)
lr_state <- lm(Profit ~ State, data = Superstore)

# rezumate
summary(lr_sales)
summary(lr_quantity)
summary(lr_discount)
summary(lr_region)
summary(lr_shipmode)
summary(lr_category)
summary(lr_subcategory)
summary(lr_segment)
summary(lr_state)

# regresie liniara multipla
mlr_all <- lm(Profit ~ Sales + Quantity + Discount + Region + State + Category + Subcategory, data = Superstore)
summary(mlr_all)

# simplificam modelul
mlr_simplified1 <- lm(Profit ~ Sales + Quantity + Discount + State + Category, data = Superstore)
mlr_simplified2 <- lm(Profit ~ Sales + Quantity + Discount + Region + Subcategory, data = Superstore)
mlr_simplified3 <- lm(Profit ~ Sales + Quantity + Discount + Region + Category, data = Superstore)
mlr_simplified4 <- lm(Profit ~ Sales + Quantity + Discount + State + Subcategory, data = Superstore)

# rezumate
summary(mlr_simplified1)
summary(mlr_simplified2) # cel mai bun model
summary(mlr_simplified3)
summary(mlr_simplified4)

# regresie liniara multipla cu interactiune intre factori
mlr_interactions1 <- lm(Profit ~ Sales * Quantity + Discount + Region + Category, data = Superstore)
mlr_interactions2 <- lm(Profit ~ Sales * Discount + Quantity + Region + Category, data = Superstore)
mlr_interactions3 <- lm(Profit ~ Sales * Quantity * Discount + Region + Category, data = Superstore)

# rezumate
summary(mlr_interactions1)
summary(mlr_interactions2)
summary(mlr_interactions3)

# obtinerea seturilor de antrenament si de test
set.seed(123)
superstore_split <- initial_split(Superstore, prop = 0.7)
superstore_train <- training(superstore_split)
superstore_test <- testing(superstore_split)

# definim 10-fold cross-validation ca metoda de validare
fitControl <- trainControl(method = "cv", number = 10)

# antrenam modelul
mlr_final_cv <- train(
  Profit ~ Sales * Discount + Quantity + Region + Category,
  data = superstore_train,
  method = "lm",
  trControl = fitControl
)
print(mlr_final_cv)

# generam predictii
pred1 <- predict(mlr_final_cv, newdata = superstore_test)

# calculam RMSE
test_rmse <- RMSE(pred = pred1, obs = superstore_test$Profit)
print(test_rmse)