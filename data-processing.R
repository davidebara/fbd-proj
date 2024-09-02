library(tidyverse)
library(modelr)
library(scatterplot3d)
library(dplyr)
library(tidyr)
library(ggplot2)
library(patchwork)

# incarcam setul de date
Superstore <- read_csv("dataset.csv")

# redenumim atributele
names(Superstore) <- c(
  "RowID",
  "OrderID",
  "OrderDate",
  "ShipDate",
  "ShipMode",
  "CustomerID",
  "CustomerName",
  "Segment",
  "Country",
  "City",
  "State",
  "PostalCode",
  "Region",
  "ProductID",
  "Category",
  "Subcategory",
  "ProductName",
  "Sales",
  "Quantity",
  "Discount",
  "Profit"
)

# vizualizam atributele pentru a vedea daca le putem transforma in factori
unique(Superstore$ShipMode)
unique(Superstore$Segment)
unique(Superstore$State)
unique(Superstore$Region)
unique(Superstore$Category)
unique(Superstore$Subcategory)
unique(Superstore$Discount)
unique(Superstore$Quantity)

# transformam anumite atribute in factori
for (col in c("ShipMode", "Segment", "State", "Region", "Category", "Subcategory", "Discount", "Quantity")) {
  Superstore[[col]] <- factor(Superstore[[col]])
}

# eliminam atributele de care nu avem nevoie
Superstore <- subset(Superstore, select = -c(RowID, Country, OrderID, CustomerID, ProductID, ProductName, CustomerName, PostalCode, City, OrderDate, ShipDate))

# cream graficele individuale
plot1 <- Superstore %>%
  ggplot(aes(Sales, Profit)) +
  geom_point()

plot2 <- Superstore %>%
  ggplot(aes(State, Profit)) +
  geom_point() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

plot3 <- Superstore %>%
  ggplot(aes(Subcategory, Profit)) +
  geom_point() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

plot4 <- Superstore %>%
  ggplot(aes(ShipMode, Profit)) +
  geom_point()

plot5 <- Superstore %>%
  ggplot(aes(Region, Profit)) +
  geom_point()

plot6 <- Superstore %>%
  ggplot(aes(State, Profit)) +
  geom_point() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

plot7 <- Superstore %>%
  ggplot(aes(Category, Profit)) +
  geom_point()

plot8 <- Superstore %>%
  ggplot(aes(Discount, Profit)) +
  geom_point()

plot9 <- Superstore %>%
  ggplot(aes(Quantity, Profit)) +
  geom_point()

# afisare unificata
combined_plot <- plot1 + plot2 + plot3 + plot4 + plot5 + plot6 + plot7 + plot8 + plot9 +
  plot_layout(ncol = 3)

