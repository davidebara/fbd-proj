library(rsample)
library(tidyverse)
library(dplyr)
library(rpart)
library(rpart.plot)
library(caret)


# RANDOM FOREST - RANDOMFOREST
set.seed(123)
library(randomForest)

# crearea modelului
m1_rf <- randomForest(
  formula = Profit ~ .,
  data = superstore_train
)

# afisarea rezumatului
m1_rf

# identificarea celui mai performant arbore
plot(m1_rf)
m1_rf$mse
which.min(m1_rf$mse)

# calcularea RMSE
sqrt(m1_rf$mse[which.min(m1_rf$mse)])
#

pred <- predict(m1_rf, newdata = superstore_test)

# Calculate the RMSE
test_rmse <- RMSE(pred, superstore_test$Profit)
print(test_rmse)

# RF TUNING
# stabilirea predictorilor
features <- setdiff(names(superstore_train), "Profit")
set.seed(123)


m2_rf_tunned <- tuneRF(
  x = superstore_train[features],
  y = superstore_train$Profit,
  ntreeTry = 500,
  mtryStart = 5,  #starts with 5 variables and increase by 1.5
  stepFactor = 1.5,# saltul e prea mare, am fi rigurosi daca am face un for de la 10 la 22
  improve = 0.01, #stop when improvement is less that 1%
  trace = FALSE
)
m2_rf_tunned
plot(m2_rf_tunned[,1], m2_rf_tunned[,2])
sqrt(m2_rf_tunned[which.min(m2_rf_tunned[,2]),2])



# RANDOM FOREST - RANGER
library(ranger)

# hypergrid cu parametri
hyper_grid <- expand.grid(
  mtry = seq(2, 9, by = 1),
  node_size = seq(6, 15, by = 2),
  sample_size = c(.55, .632, .7, .8),
  OOB_RMSE = 0
)
nrow(hyper_grid)

# antrenarea modelului
for (i in 1:nrow(hyper_grid)) {
  model <- ranger(
    formula = Profit ~ .,
    data = superstore_train,
    num.trees = 500, 
    mtry = hyper_grid$mtry[i],
    min.node.size = hyper_grid$node_size[i],
    sample.fraction = hyper_grid$sample_size[i],
    seed = 123
  )
  hyper_grid$OOB_RMSE[i] <- sqrt(model$prediction.error)
}

# ordoneaza modelele in functie de OOB_RMSE
hyper_grid %>%
  arrange(desc(OOB_RMSE)) %>%
  top_n(-10)

# refits random forest de mai multe ori si calculeaza RMSE
OOB_RMSE <- vector(mode = "numeric", length = 100)
for(i in seq_along(OOB_RMSE)) {
  optimal_ranger <- ranger(
    formula         = Profit ~ ., 
    data            = superstore_train, 
    num.trees       = 500,
    mtry            = 7,
    min.node.size   = 6,
    sample.fraction = .8,
    importance      = 'impurity'
  )
  
  OOB_RMSE[i] <- sqrt(optimal_ranger$prediction.error)
}

# afiseaza histograma
hist(OOB_RMSE, breaks = 20)
mean(OOB_RMSE)

# afisarea celor mai importante variabile
library(generics)
library(rsample)
library(recipes)
library(ggplot2)

# convertim importantele factorilor in dataframe
importance_df <- data.frame(
  name = names(optimal_ranger$variable.importance),
  importance = optimal_ranger$variable.importance
)

# folosim acest dataframe pentru crearea graficului
importance_df %>%
  arrange(desc(importance)) %>%
  top_n(5, importance) %>%
  ggplot(aes(reorder(name, importance), importance)) + 
  geom_col() + 
  coord_flip() + 
  labs(x = "Variabila", y = "Importanta", title = "Top 5 Cele Mai Importante Variabile")

# generam predictii si afisam RMSE
pred_ranger <- predict(optimal_ranger, superstore_test)  
head(pred_ranger$predictions)
RMSE(pred_ranger$predictions, superstore_test$Profit)
