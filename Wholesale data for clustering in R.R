### Wholesale data for clustering
whole<-read.csv("wholesale_data.csv", header= TRUE)


# install.packages('corrplot')
library(corrplot)
# Clustering
library(cluster) 
library(factoextra)
head(whole,5)
whole <- na.omit(whole)
str(whole)
summary(whole)
corrmatrix <- cor(whole)
corrplot(corrmatrix, method = 'number')
data <- whole[-c(1,2)]
head(data,5)
fviz_nbclust(data, kmeans, method='silhouette')
fviz_nbclust(data, kmeans, method='wss')
fviz_nbclust(data, kmeans, method='gap_stat')

km_check <- kmeans(data, 2)
## Total Within cluster sum of square
km_check$tot.withinss

## Cluster sizes
km_check$size

whole$cluster <- km_check$cluster
head(whole, 5)

fviz_cluster(km_check, data=data)
clusplot(whole, whole$cluster, color=TRUE, shade = TRUE, label=2)