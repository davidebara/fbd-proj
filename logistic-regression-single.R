library(caret)
library(rsample)
library(tidyverse)
# Aplicam pasul de curatare a datelor
source(file = "data-processing.R")
# Vom crea coloana "Profitable" pentru a imparti o vanzare in profitabil/neprofitabils
# 1 - profitabil
# 0 - neprofitabil
Superstore$Profitable <- ifelse(Superstore$Profit > 0, 1, 0)

# Transformam coloana "Profitable" in factor
Superstore$Profitable <- as.factor(Superstore$Profitable)

summary(Superstore)


mod_ship <- glm(data = Superstore, Superstore$Profitable ~ Superstore$ShipMode, family = binomial)
mod_segment <- glm(data = Superstore, Superstore$Profitable ~ Superstore$Segment, family = binomial)
mod_region <- glm(data = Superstore, Superstore$Profitable ~ Region, family = binomial)
mod_category <- glm(data = Superstore, Superstore$Profitable ~ Superstore$Category, family = binomial)
mod_subcat <- glm(data = Superstore, Superstore$Profitable ~ Superstore$Subcategory, family = binomial)
mod_quantity <- glm(data = Superstore, Superstore$Profitable ~ Superstore$Quantity, family = binomial)
mod_sales <-glm(data = Superstore, Superstore$Profitable ~ Superstore$Sales, family = binomial)
mod_discount <-glm(data = Superstore, Superstore$Profitable ~ Superstore$Discount, family = binomial)
summary(mod_discount)
summary(mod_segment)
summary(mod_ship)
summary(mod_region)
summary(mod_category)
summary(mod_subcat)
summary(mod_quantity)
summary(mod_sales)
