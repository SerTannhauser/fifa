# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)

dashboardPage(
  #### Header
  dashboardHeader(title = "FIFA"),
  
  #### Sidebar
  dashboardSidebar(
    sidebarMenu(
      menuItem("Home", tabName = "home", icon = icon("dashboard")),
      menuItem("Background", tabName = "background", icon = icon("futbol")),
      menuItem("Confederations", tabName = "confederations", icon = icon("trophy")),
      menuItem("Confederation Rankings", tabName = "confederation rankings", icon = icon("th"))
               )
      ),
    textOutput("res")
    )
  
  #### Dashboard Body
  dashboardBody(
    tabItems(
      tabItem("home", img(src="https://upload.wikimedia.org/wikipedia/commons/a/aa/FIFA_logo_without_slogan.svg", 
                                  width="100%")),
      
      tabItem("background", "History", style = "font-size:25px",
              br(),
              img(src="https://upload.wikimedia.org/wikipedia/commons/thumb/2/26/World_Map_FIFA.svg/1200px-World_Map_FIFA.svg.png"),
              br(),
              p(paste("FIFA was founded in 1904 to oversee international competitions by the national associations of Belgium, Denmark, France, Germany, the Netherlands, Spain, Sweden, and Switzerland.  Headquartered in Zurich, Switzerland, FIFA now consists of 211 national associations divided into 6 regional confederations.  While not in control over the rules of the game of football (soccer), FIFA is responsible for the organization and promotion of a number of tournament - most important of which is the World Cup."))),
      tabItem("confederation rankings",
              inputPanel(
                selectInput("confed", "Confederation:", choices = c('AFC','CAF','CONCACAF','CONMEBOL','OFC','UEFA')),
                hr(),
                helpText("Select Confederation")),
              mainPanel(
                plotOutput("confed_histo", height = 700))),
      tabItem("confederation rankings",
              inputPanel(
                selectInput("confed", "Confederation:", choices = c('AFC','CAF','CONCACAF','CONMEBOL','OFC','UEFA')),
                hr(),
                helpText("Select Confederation")),
              mainPanel(
                plotOutput("confed_histo", height = 700)))
      )
    )
  )