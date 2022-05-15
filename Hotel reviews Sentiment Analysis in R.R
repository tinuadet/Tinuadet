# Sentiment Analysis in R
data <- read.csv("C:/Users/Gratiam Suam/Downloads/tourist_accommodation_reviews.csv")
set1<-select(filter(data, Hotel.Restaurant.name=="Bite in"), c(Review:Location))
set2<-select(filter(data, Hotel.Restaurant.name=="Benny's American Bar & Grill"), c(Review:Location))
set3<-select(filter(data, Hotel.Restaurant.name=="Thong Dee The Kathu Brasserie"), c(Review:Location))
set4<-select(filter(data, Hotel.Restaurant.name=="Odysseus Greek Organic Restaurant"), c(Review:Location))
set5<-select(filter(data, Hotel.Restaurant.name=="Dee Plee - Anantara Layan Phuket Resort"), c(Review:Location))
set6<-select(filter(data, Hotel.Restaurant.name=="The Tavern"), c(Review:Location))
set7<-select(filter(data, Hotel.Restaurant.name=="EAT. bar & grill"), c(Review:Location))
set8<-select(filter(data, Hotel.Restaurant.name=="Surf and Turf by Soul Kitchen"), c(Review:Location))
set9<-select(filter(data, Hotel.Restaurant.name=="Siam Supper Club"), c(Review:Location))
set10<-select(filter(data, Hotel.Restaurant.name=="Sam's Steaks and Grill"), c(Review:Location))
set11<-select(filter(data, Hotel.Restaurant.name=="Istanbul Turkish Restaurant"), c(Review:Location))
set12<-select(filter(data, Hotel.Restaurant.name=="The Corner Restaurant"), c(Review:Location))
set13<-select(filter(data, Hotel.Restaurant.name=="Kataturk Turkish Restaurant"), c(Review:Location))
set14<-select(filter(data, Hotel.Restaurant.name=="Sala Sawasdee Lobby Bar"), c(Review:Location))
set15<-select(filter(data, Hotel.Restaurant.name=="The Palm Cuisine"), c(Review:Location))
set16<-select(filter(data, Hotel.Restaurant.name=="Highway Curry Indian & Thai Cuisine"), c(Review:Location))
set17<-select(filter(data, Hotel.Restaurant.name=="Tandoori Flames"), c(Review:Location))
set18<-select(filter(data, Hotel.Restaurant.name=="Pad Thai Shop"), c(Review:Location))
set19<-select(filter(data, Hotel.Restaurant.name=="Golden Paradise Restaurant"), c(Review:Location))
set20<-select(filter(data, Hotel.Restaurant.name=="Mr.Coffee"), c(Review:Location))
set21<-select(filter(data, Hotel.Restaurant.name=="Flavor Phuket"), c(Review:Location))
set22<-select(filter(data, Hotel.Restaurant.name=="Ban Noy Restaurant"), c(Review:Location))
set23<-select(filter(data, Hotel.Restaurant.name=="Ao Chalong Yacht Club Restaurant"), c(Review:Location))
set24<-select(filter(data, Hotel.Restaurant.name=="Naughty Nuri's Phuket"), c(Review:Location))
set25<-select(filter(data, Hotel.Restaurant.name=="Surin Chill House"), c(Review:Location))
set26<-select(filter(data, Hotel.Restaurant.name=="Natural Efe Macrobiotic World"), c(Review:Location))
set27<-select(filter(data, Hotel.Restaurant.name=="Honeymoon Thai Restaurant by Kenya"), c(Review:Location))
set28<-select(filter(data, Hotel.Restaurant.name=="O-OH Farm Ta-Eiad"), c(Review:Location))
set29<-select(filter(data, Hotel.Restaurant.name=="Da Puccio Restaurant"), c(Review:Location))
set30<-select(filter(data, Hotel.Restaurant.name=="Sizzle Rooftop Restaurant"), c(Review:Location))

d <- rbind(set1,set2,set3,set4,set5,set6,set7,set8,set9,set10,set11,set12,set13,
           set14,set15,set16,set17,set18,set19,set20,set21,set22,set23,set24,set25,set26,
           set27,set28,set29,set30)
View(d)
write.csv(d,"Hotel.csv")


data <- read.csv("C:/Users/Gratiam Suam/Documents/Hotel.csv")
data$Review = gsub("[^[:alnum:][:blank:]?&/\\-]", "", data$Review)

data$Review <- data$Review
Encoding <-"latin1"
data$Review<- iconv(data$Review, "latin1", "UTF-8", sub='')

library(tm)
library(syuzhet)
library(wordcloud)

corpus<-iconv(data$Review, to = "UTF-8")
corpus<-Corpus(VectorSource(corpus))
inspect(corpus[1:5])

corpus<-tm_map(corpus,removePunctuation)
inspect(corpus[1:5])
corpus<-tm_map(corpus, tolower)
corpus<-tm_map(corpus, removeNumbers)
inspect(corpus[1:5])
corpus<-tm_map(corpus, removeWords, stopwords("english"))
inspect(corpus[1:5])
corpus<-tm_map(corpus, removeWords, c("baht", "always", "first","however", "fufuuafufuuafufuuafufuua"))
corpus<-tm_map(corpus, stripWhitespace)
inspect(corpus[1:5])

# Obtaining the Term Document Frequency
tdm<-TermDocumentMatrix(corpus)
tdm<-as.matrix(tdm)
v<-sort(rowSums(tdm), decreasing = TRUE)
d<-data.frame(word=names(v), freq=v)
wordcloud(d$word, d$freq,random.order=FALSE, rot.per=0.3,scale=c(4,.5),
          max.words=101,colors=brewer.pal(8,"Dark2"))
tdm[1:10,1:5]

Hotel<-rowSums(tdm)
Hotel<-subset(Hotel, Hotel >= 25)
barplot(Hotel, las = 2, col = "blue")

set.seed(12345)
wordcloud(words=names(Hotel), max.words = 50, random.order = T, 
          min.freq = 5, colors = brewer.pal(8, "Dark2"), scale = c(3, 0.3))
# Sentiment Analysis
sentiment_data<-iconv(data$Review)
sent <- get_nrc_sentiment(sentiment_data)
# Calculating review score
sent$score <- sent$positive - sent$negative
sent[1:10,]


sentiment<-get_nrc_sentiment(sentiment_data)
sent<-data.frame(colSums(sentiment))
SentimentScores<-data.frame(colSums(sentimenty[,]))
names(SentimentScores) <- "Score"
SentimentScores <- cbind("sentiment" = rownames(SentimentScores), SentimentScores)
rownames(SentimentScores) <- NULL
ggplot(data = SentimentScores, aes(x = sentiment, y = Score)) + geom_bar(aes(fill = sentiment), stat = "identity") + theme(legend.position = "none") + xlab("Sentiment") + ylab("Score") + ggtitle("Sentiment Analysis of Hotel Reviews")
