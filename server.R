#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(wordcloud)
library(tidyverse)
library(tidytext)
library(janeaustenr)
library(dplyr)
library(tm)

shinyCorpus <- readRDS("myCorpus.Rds")
shinytweetsdf <- readRDS("tweetsdf.Rds")
dtm5 <- TermDocumentMatrix(shinyCorpus);

shinyServer(function(input, output) {
  ngrams  <- reactive({
    input$ngramCount
  })
  output$wordcloud  <- renderPlot({

    m <- as.matrix(dtm5);
    v <- sort(rowSums(m),decreasing=TRUE)
    d <- data.frame(word = names(v),freq=v)
    set.seed(1234)
    
    d %>%
    select(word) %>%
    tidytext::unnest_tokens(ngram, word, token="ngrams", n=ngrams()) %>%
    count(ngram) %>%
    with(wordcloud(words = ngram, n, max.words=input$cloudCount, scale=c(1.2,.1), rot.per=.1, random.color=TRUE, random.order=FALSE, colors=brewer.pal(8, "Dark2")))  
    
  })
  
  output$topicplot  <- renderPlot({
    dtm6 <- TermDocumentMatrix(shinyCorpus)
    
    set.seed(1256)
    ui = unique(dtm6$i)
    dtm6.new = dtm6[ui,]
    shinytweetsdf.new = shinytweetsdf[ui,]
    library(topicmodels)
    lda <- LDA(dtm6.new, k = input$topicCount) # find topics from ui
    (term <- terms(lda, 10)) # first 10 terms of every topic
    # first topic identified for every document (tweet)
    topic <- topics(lda, 1)
    library(data.table)
    topics <- data.frame(date=as.IDate(shinytweetsdf.new$dateTS), topic)
    
    qplot(date, ..count.., data=topics, geom="density",
          fill=term[topic], position="stack")  
  })
  
})
