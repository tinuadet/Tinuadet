# Association Rule with Cross Sell 
data<-read.csv("C:/Users/tinuade/Desktop/CatalogCrossSell.csv", header=T, colClasses="factor")
str(data)
summary(data)

# Finding association rules
library(arules)
rule_1 <- apriori(data)
summary(rule_1)
inspect(rule_1)

# Graphs and Charts for all the Rules:
library(arulesViz)
plot(rule_1)
plot(rule_1,method="grouped")
plot(rule_1,method="graph",control=list(type="items"))

# Rules with specified parameter value
rules1 <- apriori(data,parameter = list(minlen=2, maxlen=3 ,supp=.07, conf=.8))
summary(rules1)

summary(data)

# Finding interesting rules-1
rules2 <- apriori(data,parameter = list(minlen=2, maxlen=3,supp=.06, conf=.7),appearance=list(rhs=c("Personal.Electronics.Division=1"),lhs=c("Clothing.Division=1", "Housewares.Division=1", "Automotive.Division=1", "Computers.Division=1", "Garden.Division=1", "Novelty.Gift.Division=1", "Jewelry.Division=1"),default="lhs"))

summary(rules2)
quality(rules2)<-round(quality(rules2),digits=3)
inspect(rules2)
rules2.sorted <- sort(rules2, by="lift")
inspect(rules2.sorted)

# Graphs and Charts for the Final Pruned rules: 
library(arulesViz)
plot(rules2.pruned)
plot(rules2.pruned,method="grouped")




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



# Loading package
library(arules)
library(arulesViz)
# Loading data
data <- read.transactions('Market_Basket_Optimisation.csv', 
                          sep = ',', rm.duplicates = TRUE)

# Structure 
str(data)

summary(data)

itemFrequencyPlot(data, topN = 10, type = 'absolute')
itemFrequencyPlot(data, topN = 10, type = 'relative')
rules <- apriori(data, parameter = list(supp=0.009, conf=0.8, 
                                        target = "rules", maxlen = 4))
summary(rules)

data_rules <- sort(rules, by = 'confidence', decreasing = TRUE)
inspect(data_rules[1:5])

# Fitting model
set.seed = 124 # Seed setting
associa_rules = apriori(data = data, 
                        parameter = list(support = 0.004, 
                                         confidence = 0.2, maxlen=2))

# Plot
itemFrequencyPlot(data, topN = 10)

# Visualising the results
inspect(sort(associa_rules, by = 'lift')[1:10])
# Visualising the results
inspect(sort(associa_rules, by = 'support')[1:10])
# Visualising the results
inspect(sort(associa_rules, by = 'confidence')[1:10])
plot(associa_rules, method = "graph", 
     measure = "confidence", shading = "lift", interactive=TRUE)
