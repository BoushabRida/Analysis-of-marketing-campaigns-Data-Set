#Rida Boushab
#M1 Big Data
#2020/2021

#Libraries 
library(shiny)
library(corrplot)
library(ggplot2)
library(lattice)
library(rpart)
library(rpart.plot)
library(tidyverse)
#reading the data
bank <- read.csv("bank.csv", header=T)
#eliminate all null rows
all.empty = rowSums(is.na(bank))==ncol(bank)
bankData = bank[!all.empty,]

shinyServer(
  
  function(input,output,session)
  {
    #function of the prediction (model: the decision tree )
    output$tree<-renderText({
      p<-2
     while(input$do)
     {
      DataP=bankData[,]
      #Data for prediction
      
      DataP[nrow(DataP)+1,]<-c(as.numeric(input$var1),input$var2,input$var3,input$var4,
                                input$var5,as.numeric(input$var6),input$var7,input$var8,
                                input$var9,as.numeric(input$var10),input$var11,as.numeric(input$var12),
                                as.numeric(input$var13),as.numeric(input$var14),as.numeric(input$var15),
                                input$var16,'null')
       
      #encoding categorial variables
      DataP$job<-as.numeric(as.factor(DataP$job))
      
      DataP$marital<-as.numeric(as.factor(DataP$job))
      
      DataP$education<-as.numeric(as.factor(DataP$education))
      
      DataP$default<-as.numeric(as.factor(DataP$default))
      
      DataP$housing<-as.numeric(as.factor(DataP$housing))
      
      DataP$contact<-as.numeric(as.factor(DataP$contact))
      
      DataP$month<-as.numeric(as.factor(DataP$month))
      
      DataP$loan<-as.numeric(as.factor(DataP$loan))
      
      DataP$poutcome<-as.numeric(as.factor(DataP$poutcome))
      DataPred=DataP[nrow(DataP),1:16]
      DataP<-DataP[-nrow(DataP),]
      
        #le model tree
      var<- rpart(DataP$deposit~.,DataP ,method ="class")
      p<- predict(var,DataPred,type="class")
      break
     }
      if(p=='yes')
      {
        print('YES,  this client will subscribe')
      }
      else if(p=='no')
      {
        print('NO,  this client will NOT subscribe')
      }
      else
      {
        print('Please, click on the button "run" below, to show the prediction of this client')
      }
    })
    
    #hide a nav bar
    hide("hide1")
    #take one column of the the data frame bankData
    x<-reactive({
      bankData[,as.numeric(input$varx)]
    })
    #convert column of the the data frame bankData to numeric
    clm<-reactive({
      as.numeric(input$varx)
    })
    #give information about the data like (min, max, avg etc.)
    output$suma<-renderPrint({
      summary(bankData)
    })
    #examine the data give you a nutshell about the structure of the data
    output$info2<-renderPrint({
      str(bankData)
    })
    #Correlation plot to see the correlation between variables
    output$cure<-renderPlot({
      corrdata<-data.frame(bankData[, lapply(bankData, is.numeric) == TRUE])
      cory<-cor(corrdata)
      corrplot(cory)
    })
    #return the 5 first rows in the data
    output$datas<-renderTable({
      head(bankData)
    })
    #les plots
    #Histogram plot
    output$histo <- renderPlot({
        mx <- mean(x())
        hist(x(),breaks = seq(0,max(x()),l=input$bins+1),c="#375A7F",main="Histogram of data",xlab = names(bankData[clm()]))
        abline(v = mx, col = "#df9995", lwd = 2)
      })
    #scatter plot
    output$scat<-renderPlot({
      ggplot(bankData ,aes(x=balance ,y= job))+geom_point( color ="#375A7F")
      
    })
    #boxplot plot
    output$box1<-renderPlot({
      boxplot(bankData$age, col="#375A7F",xaxt="n",
              xlab="Age Distribution", horizontal=TRUE)
      axis(side=1, at=fivenum(bankData$age), labels=TRUE,las=2)
      text(fivenum(bankData$age),rep(1.2,5),srt=90,adj=0,
           labels=c("Min","Lower","Median","Upper","max"))
    })
    #bar plot
    output$hist1<-renderPlot({
      ggplot (bankData ,aes (x=marital)) + geom_bar(fill="#375A7F")
    })
    
    output$hist2<-renderPlot({
      ggplot (bankData ,aes (x=education)) + geom_bar(fill="#375A7F") 
    })
    #histogram of Central Limit Theorem: clients who Deposited "yes" and their age <= 60
    output$histf <- renderPlot({
      deposit_filter <- filter(bankData, bankData$deposit == "yes")
      deposit_below_60<- filter(deposit_filter, deposit_filter$age <= 60)
      mean<-mean(deposit_below_60$age)
      sd<-sd(deposit_below_60$age)
      hist(deposit_below_60$age, prob=TRUE, col="#375A7F",main="Histogram of clents who deposit under 60 years")
      abline(v = mean, col = "#df9995", lwd = 2)
    })
    
    #make a test of the hypothesis with Student Test
    output$test<-renderPrint({
      with(data=bankData,t.test(balance[deposit=="no"],balance[deposit=="yes"],var.equal=TRUE))
    })
    
  }
)