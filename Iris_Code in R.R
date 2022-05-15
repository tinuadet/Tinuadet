library(caret)
library(RCurl) 
library(randomForest)
iris<-read.csv("C:/Users/tinuade/Desktop/Data/iris-data.csv")
# Factoring the dependent variable
iris$specie<-as.factor(iris$specie)
# Summary statistics
summary(iris)
summary(iris$specie)
#Missing Observations
sum(is.na(iris))
# Panel plots
plot(iris)
plot(iris, col = "green")

# Model Building in R



# Splitting the dataset
Training <- createDataPartition(iris$specie, p=0.7, list = FALSE)
TrainSet <- iris[Training,] # Training Set
TestSet <- iris[-Training,] # Test Set

write.csv(TrainSet, "training.csv")
write.csv(TestSet, "testing.csv")

TrainSet <- read.csv("training.csv", header = TRUE)
TrainSet <- TrainSet[,-1]

# Building Random forest model
model <- randomForest(iris$specie ~ ., data = TrainSet, ntree=500, mtry=4,  importance = TRUE)

# Predicting the test set
model_predict <- predict(model, TestSet)
print(confusionMatrix(model_predict, TestSet$specie))

# Save model to RDS file
saveRDS(model, "model.rds")

