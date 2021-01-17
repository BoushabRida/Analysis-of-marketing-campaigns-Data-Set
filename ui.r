#Libraries
library(shiny)
library(shinyjs)
library(shinythemes)

shinyUI(fluidPage(
  useShinyjs(),
  theme = shinytheme("darkly"),
  navbarPage(title="Projet R: Banking markting",windowTitle = "Rida Boushab/ M1 Big Data",
            id="nav1",
  tabPanel("Info",value="Info",
  sidebarLayout(
    div(id="hide1",sidebarPanel()),
    #main
    mainPanel(
      tabsetPanel(
              type="pills",
              tabPanel("Summary",verbatimTextOutput("suma"),verbatimTextOutput("info2")),
              tabPanel("Data",tableOutput("datas")),
              tabPanel("Correlation",plotOutput("cure"),align="center")
              )
      )
  )),
  tabPanel("Plots",value="plots",
           sidebarLayout(
             
             sidebarPanel(
               selectInput("varx","1.Select the variables of the data",choices =c("age"=1,"campaign"=13) ),
               br(),
               sliderInput("bins","2. Select the number of bins for Histogram",min=0,max=100,value=10),
              
             ),
             #main
             mainPanel(
               tabsetPanel(
                 tabPanel("Plots",plotOutput("box1"),plotOutput("histo"),plotOutput("scat"),plotOutput("hist1"),plotOutput("hist2"),
                          plotOutput("histf"))
        
               )
               
             )
           )
),
tabPanel("Test",value="test",
         sidebarLayout(
           
           sidebarPanel("Does the balance effect on the term deposit?",br(),br(),
          "H0: balance doesn't have any effect on term deposit",br(),br(),
          "H1 : balance has effect on term deposit"

            
            
           ),
           #main
           mainPanel(
             tabsetPanel(
               tabPanel("Test",verbatimTextOutput("test"))
               
             )
             
           )
         )
),
tabPanel("Prediction",value="prediction",
         sidebarLayout(
  
           sidebarPanel("     prediction of the deposit:   ",
             br(),br(),
             textInput("var1","Enter the age",value ='50'),
             br(),
             textInput("var2","Enter the job",value ='technician'),
             br(),
             textInput("var3","Enter the marital",value ='married'),
             br(),
             textInput("var4","Enter the education",value ='secondary'),
             br(),
             textInput("var5","Enter the default",value ='no'),
             br(),
             textInput("var6","Enter the balance",value ='1270'),
             br(),
             textInput("var7","Enter the housing",value ='yes'),
             br(),
             textInput("var8","Enter the loan",value ='no'),
             br(),
             textInput("var9","Enter the contact",value ='unknown'),
             br(),
             textInput("var10","Enter the day",value ='5'),
             br(),
             textInput("var11","Enter the month",value ='may'),
             br(),
             textInput("var12","Enter the duration",value ='1389'),
             br(),
             textInput("var13","Enter the campaign",value ='1'),
             br(),
             textInput("var14","Enter the pdays",value ='-1'),
             br(),
             textInput("var15","Enter the previous",value ='0'),
             br(),
             textInput("var16","Enter the poutcome",value ='unknown'),
             br(),
             actionButton("do","Run")
             
           ),
           #main
           mainPanel(
             tabsetPanel(
               tabPanel("the client will subscribe (yes/no)",textOutput("tree")),
               #image inserting for Decision Tree Rule
               tabPanel("Decision Tree Rule",img(src='Rplot02.png',align="right"))
               
             )
             
           )
         )
)

),#footer
fluidPage(br(),br(),br(),br(),"Rida Boushab",br(),"M1 Big data UPPA",br(),"2020/2021")
)
)