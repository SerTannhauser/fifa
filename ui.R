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
    sidebarMenuOutput("menu"),
    textOutput("res")
    ),
  
  #### Dashboard Body
  dashboardBody(
    tabItems(
      tabItem(tabName = "overview", titlePanel("Overview"),
              box(title = "Background", height = 525,
                  img(src="http://img.photobucket.com/albums/v669/5CN/FIFA%20logo_zps39tja4ga.jpg?t=1539447072", width = "95%"),
                  br(),
                  p(paste("FIFA was founded in 1904 to oversee international competitions by the national associations of Belgium, Denmark, France, Germany, the Netherlands, Spain, Sweden, and Switzerland.  Headquartered in Zurich, Switzerland, FIFA considers itself to be the international governing body for association football, futsal, and beach soccer.  While not in control over the rules of the game of football (soccer), FIFA is responsible for the organization and promotion of a number of tournament - most important of which is the World Cup."))),
              box(title = "Confederations", height = 525,
                  img(src="http://img.photobucket.com/albums/v669/5CN/fifa_zpswzdlqdpg.png?t=1539447089", width = "95%"),
                  br(),
                  p(paste("Today, FIFA is composed of 211 member nations divided into six geographic confederations that roughly correspond to the six populated continents:"),
                    tags$ul(
                      tags$li("AFC - Asia Football Confederation"),
                      tags$li("CAF - Confederation Africaine de Football"),
                      tags$li("CONCACAF - Confederation of North, Central American and Caribbean Association Football"),
                      tags$li("CONMEBOL - Confederacion Sudamericana de Futbol"),
                      tags$li("OFC - Oceania Footbal Confederation"),
                      tags$li("UEFA - Union of European Football Associations"))
                    ))),
      tabItem(tabName = "fifa_rankings", titlePanel("FIFA Rankings"), 
              plotOutput(outputId = "fifa_histo", height = 2000)),
      tabItem(tabName = "confederations", titlePanel("Rankings by Confederation - June 7, 2018"),
              sidebarLayout(
                sidebarPanel(
                  selectInput("confed", "Confederation:", choices = c('AFC','CAF','CONCACAF','CONMEBOL','OFC','UEFA')),
                  hr(),
                  helpText("Select Confederation")),
                mainPanel(
                  plotOutput("confed_histo", height = 800)),
                position = "right")),
      tabItem(tabName = "confed_comparison", titlePanel("Confederation Comparisons"),
              tabsetPanel(type = "tabs",
                          tabPanel("Points",
                                   plotOutput(outputId= "point_boxplot")),
                          tabPanel("Ranking",
                                   plotOutput(outputId= "ranking_boxplot")))),
      tabItem(tabName = "nation_rankings", titlePanel("Historical Rankings by Confederation"),
              fluidRow(
                box(
                  selectInput("nation_confed", "Historical Rankings (1993-2018):", choices = c('AFC','CAF','CONCACAF','CONMEBOL','OFC','UEFA')),
                  hr(),
                  helpText("Select Confederation"))),
              fluidRow(
                box(width = "100%",
                    plotOutput("nations_histo", height = 1000)))),
      tabItem(tabName = "average_rankings", titlePanel("Average Ranking of Nations"),
              fluidRow(
                box(
                  sliderInput("rank_max", "Average Rankings Range:", min = 1, max = 211, value = c(10)),
                  hr(),
                  helpText("Select Maximum Rank for Range"))),
              fluidRow(
                box(width = "100%",
                  plotOutput("nations_rank", height = 1200)))),
      tabItem(tabName = "findings",
              tabsetPanel(
                tabPanel(title = "Research Questions",
                         br(),
                         p(tags$ol(
                           tags$li("How do the confederations rank when considering their member nations?"),
                           tags$li("Which nations have performed consistently well since 1993?"),
                           tags$li("Which nations within each confederation have performed consistently well?"),
                           tags$li("Which nations have improved (or worsened) since 1993?")))),
                tabPanel(title = "Findings",
                         br(),
                         p(tags$ul(
                           tags$li("While the highest ranked nation is from Europe (Germany), South America ranks higher on average."),
                           tags$li("UEFA's average ranking and points is heavily skewed by a number of smaller, outlier nations."),
                           tags$li("CONCACAF is bottom heavy because of the smaller nations in the Caribbean and Central America."),
                           tags$li("OFC is by far the weakest confederation."),
                           tags$li("Nations that have ranked #1 include Argentina, Belgium, Brazil, France,Germany, the Netherlands, Italy, and Spain.  Of these nations, only Belgium (won third placed) and the Netherlands (reached two finals) have failed to win the World Cup." ),
                           tags$li("Outside of the traditional European and South America footballing powers, most of the confederations have been dominated by a handful of countries:",
                                   tags$li("Asia has been dominated by Australia, Iran, Japan, and South Korea."),
                                   tags$li("Africa has been dominated by North Africa (Algeria, Egypt, Tunisia) and West Africa (Cameroon, Ghana, Ivory Coast, Nigeria, Senegal)."),
                                   tags$li("CONCACAF has been dominated by Mexico and the United States."),
                                   tags$li("New Zealand is the only Oceania country to have done well.")),
                           tags$li("The smaller nations of the world, especially the island nations perform abysmally."),
                           tags$li("Kuwait, Singapore and Thailand have dropped percipituously."),
                           tags$li("Cape Verde is on the rise, while Angola, Zambia, and Zimbabwe have fallen."),
                           tags$li("Costa Rica has risen, overtaking the United States as number two in CONCACAF after the American failure to qualify for the 2018 World Cup."),
                           tags$li("Peru and Chile are on the rise in South America."),
                           tags$li("The nations that formerly made up Yugoslavia have all done well as independent teams."),
                           tags$li("Cuba and New Zealand have had the most volatile rise and fall in rankings."))))))
    )
  )
)