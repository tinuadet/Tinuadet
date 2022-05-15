# Classification Task: Breast cancer prediction using machine learning

library(tidyverse)
library(dplyr)
library(car)
library(corrplot)
library(pROC)
library(MLmetrics)
library(rpart)
library(rpart.plot) 
library(randomForest)
library(varImp)
library(gbm)
library(caret)
url <- "https://archive.ics.uci.edu/ml/machine-learning-databases/breast-cancer-wisconsin/breast-cancer-wisconsin.data"
data <- read.csv(file = url, header = FALSE,
                 col.names = c("ID","clump_thickness", "uniformity_size", "uniformity_shape", "marginal_adhesion", "single_epithelial_cell_size", "bare_nuclei", "bland_chromatin", "normal_nucleoli","mitoses", "diagnosis"))
write.csv(data,"breast_cancer.csv")
data<-read.csv("C:/Users/tinuade/Desktop/breast_cancer.csv", row.names = NULL, header = T)
str(data)
View(data)

sum(data$bare_nuclei == "?")

data <- data[data$bare_nuclei != "?",] %>% mutate(bare_nuclei = as.integer(as.character((bare_nuclei))))
data$bare_nuclei<-as.numeric(data$bare_nuclei)

data <- select(data, -1)
# The dependent variable diagnosis is now denoted as 2 that stands for "benign" 
#and 4 that stands for "malignant". We'll convert it into a binary variable of 
# 0 and 1 respectively.

data <- data %>% mutate(diagnosis = ifelse(diagnosis == 2, "Benign", "Malignant"),
                        diagnosis = as.factor(diagnosis))
summary(data)

# Distribution of Diagnosis in the Entire Data set
ggplot(data, aes(x = diagnosis)) +
  geom_bar(fill = "#fc9272") +
  ggtitle("Distribution of Diagnosis in the Entire Dataset") +
  theme_minimal() +
  theme(legend.position = "none")
# Correlation plot
correlation <- cor(data[,-10])
corrplot(correlation, type = "lower", col = c("#fcbba1", "#b2d2e8"), addCoef.col = "black", tl.col = "black")  

data$clump_thickness<-as.numeric(data$clump_thickness)
data$uniformity_shape<-as.numeric(data$uniformity_shape)
data$marginal_adhesion<-as.numeric(data$marginal_adhesion)
data$single_epithelial_cell_size<-as.numeric(data$single_epithelial_cell_size)
data$bare_nuclei<-as.numeric(data$bare_nuclei)
data$bland_chromatin<-as.numeric(data$bland_chromatin)
data$normal_nucleoli<-as.numeric(data$normal_nucleoli)
data$mitoses<-as.numeric(data$mitoses)