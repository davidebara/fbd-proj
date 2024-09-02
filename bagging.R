library(rsample)
library(tidyverse)
library(dplyr)
library(rpart)
library(rpart.plot)
library(ipred)
library(caret)

# IPRED
# cream ansambluri de 100-150 de arbori
# am pastrat doar aceasta sectiune pentru a scurta timpul de executie, inainte de aceasta etapa am creat ansambluri de 10-500 de arbori
ntree <- 100:150
rmse <- vector(mode = "numeric", length = length(ntree))
for (i in seq_along(ntree)) {
  set.seed(123)
  model <- bagging(
    formula = Profit ~ .,
    data = superstore_train,
    coob = TRUE,
    nbagg = ntree[i]
  )
  rmse[i] = model$err
}

# obtinem numarul optim de arbori
min_index <- which.min(rmse)
optimal_ntree <- ntree[min_index]

# generam graficul evolutiei RMSE pe masura cresterii numarului de arbori
plot(ntree, rmse, type ="l", lwd=2)
abline(v=optimal_ntree, col = "red", lty="dashed")

# crearea celui mai bun model
set.seed(123)
best_model <- bagging(
  formula = Profit ~ .,
  data = superstore_train,
  coob = TRUE,
  nbagg = 129
)

# generarea predictiilor
pred3 <- predict(best_model, superstore_test)
RMSE(pred3, superstore_test$Profit)

# CARET
# stabilim ten-fold cross validation pentru resampling
fitControl <- trainControl(
  method = "cv",
  number = 10
)

# crearea modelului
set.seed(123)
bagged_cv <- train(
  Profit ~.,
  data = superstore_train,
  method = "treebag",
  trControl = fitControl,
  importance = TRUE,
  nbagg = 129
)

# afisam rezumatul modelului si variabilele in ordinea importantei lor
bagged_cv
plot(varImp(bagged_cv), 20)

# calculam predictii pe setul de test si calculam RMSE
pred4 <- predict(bagged_cv, superstore_test)
RMSE(pred4, superstore_test$Profit)

# AFISARE PREDICTII
# pregatim datele pentru afisare
for_plotting <- tibble(
  i = 1:2999,
  pred1 = pred1[],
  pred2 = pred2[],
  pred3 = pred3[],
  actual = superstore_test$Profit
)

# afisam predictia si valoarea actuala
ggplot(for_plotting, aes(x = i)) +
  geom_point(aes(y = actual, color = "Actual")) +
  geom_point(aes(y = pred1, color = "LinearRegression")) +
  geom_point(aes(y = pred3, color = "Bagging")) +
  geom_point(aes(y = pred2, color = "DecisionTree")) +
  scale_color_manual(name = "Legend", values = c("LinearRegression" = "green", "Bagging" = "yellow", "DecisionTree" = "orange", "Actual" = "blue"))
