library(rsample)
library(tidyverse)
library(dplyr)
library(rpart)
library(rpart.plot)
library(caret)

# impartirea datelor in seturile de antrenare si testare
set.seed(123)
superstore_split <- initial_split(Superstore, prop = 0.7)
superstore_train <- training(superstore_split)
superstore_test <- testing(superstore_split)

# cream un hypergrid cu combinatii intre minsplit si maxdepth
hyper_grid <- expand.grid(
  minsplit = seq(3, 30, 1),
  maxdepth = seq(5, 20, 1)
)

# verificam datele introduse
head(hyper_grid) 

# cream cate un model pentru fiecare combinatie si il stocam intr-o lista
models <- list()
for (i in 1:nrow(hyper_grid)) {
  minsplit <- hyper_grid$minsplit[i]
  maxdepth <- hyper_grid$maxdepth[i]
  models[[i]] <- rpart(
    formula = Profit ~. ,
    data = superstore_train,
    method = "anova",
    control = list(minsplit = minsplit, maxdepth = maxdepth)
  )
}

# definim cate o functie pentru extragerea celor mai mici cp si xerror
get_cp <- function(x) {
  min <- which.min(x$cptable[,"xerror"])
  cp <- x$cptable[min, "CP"]
}
get_min_error <- function(x) {
  min <- which.min(x$cptable[, "xerror"])
  xerror <- x$cptable[min, "xerror"]
}

# aplicam functiile tuturor modelelor si atasam rezultatele in atributele cp si error in hypergrid
mutated_grid <- hyper_grid %>%
  mutate(
    cp = purrr::map_dbl(models, get_cp),
    error = purrr::map_dbl(models, get_min_error)
  )  

# ordoneaza modelele in ordinea crescatoare a erorii si le selecteaza pe primele 5
mutated_grid %>%
  arrange(error) %>%
  top_n(-5, wt=error)

# folosim datele obtinute pentru crearea arborelui optimal
set.seed(123)
optimal_tree <- rpart(
  formula = Profit ~ .,
  data = superstore_train,
  method = "anova",
  control = list(minsplit = 9, maxdepth = 15, cp = 0.01, xval = 10)
)
rpart.plot(optimal_tree)

# generarea predictiilor
pred2 <- predict(optimal_tree, newdata = superstore_test)
RMSE(pred = pred2, obs = superstore_test$Profit)