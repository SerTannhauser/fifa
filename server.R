#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(dplyr)
library(tidyr)
library(ggplot2)
library(rsconnect)
rsconnect::setAccountInfo(name='tannhauser',
                          token='BAE50659F928DCB45C85CED1A1A1DC49',
                          secret='WVmGACkj2a9GBwpwQep9KQVMyY7gCDWfHR97dSo8')
library(gridExtra)
library(RColorBrewer)
library(ggthemes)
library(reshape2)
library(gridExtra)
library(rworldmap)
library(lubridate)


function(input, output, session) {
  output$res <- renderText({
    req(input$sidebarItemExpanded)
    paste("Expanded menuItem:", input$sidebarItemExpanded)
  })
  
  #### Dashboard
  
  output$menu <- renderMenu({
    sidebarMenu(
      id = "tabs",
      menuItem("Overview", tabName = "overview", icon = icon("info")),
      menuItem("Fifa Rankings", tabName = "fifa_rankings", icon = icon("globe")),
      menuItem("Confederations", tabName = "confederations", icon = icon("cloud")),
      menuItem("Confederation Comparison", tabName = "confed_comparison", icon = icon("bars")),
      menuItem("Historical Rankings", tabName = "nation_rankings", icon = icon("clone")),
      menuItem("Average Rankings", tabName = "average_rankings", icon = icon("align-justify")),
      menuItem("Findings", tabName = "findings", icon = icon("cog"))
    )
  })
  
  #### FIFA Histogram
  
  fifa_18 <- data.frame(fifa %>%
                          dplyr::filter(rank_date == '6/7/2018') %>% 
                          dplyr::select(country_full, country_abrv, confederation, rank, total_points) %>%
                          arrange(country_full))

  output$fifa_histo <- renderPlot({
    fifa_18 %>%
      ggplot(aes(x = reorder(country_full, -rank), y = total_points, fill = confederation)) +
      geom_bar(stat = 'identity') + coord_flip() + theme_economist(10) + 
      scale_fill_brewer(name = '', palette = 'Paired') + 
      theme(legend.position = 'None', panel.grid.major.y = element_blank()) +
      xlab("Country Name") + ylab("Points")
  })
  
  #### Confederation Histogram
  
  selectInput <- reactive ({
    switch(input$confed,
           "AFC" = AFC,
           "CAF" = CAF,
           "CONCACAF" = CONCACAF,
           "CONMEBOL" = CONMEBOL,
           "OFC" = OFC,
           "UEFA" = UEFA)
  })
  
  output$confed_histo <- renderPlot ({
    fifa_confed <- data.frame(fifa_18 %>%
                                dplyr::filter(confederation == input$confed))
    
    ggplot(fifa_confed, aes(x = reorder(country_full, -rank), y = total_points, fill = confederation)) +
      geom_bar(stat = 'identity') + coord_flip() + theme_economist(10) +
      scale_fill_discrete() +
      theme(legend.position= 'None', panel.grid.major.y = element_blank()) +
      xlab("Country Name") + ylab("Total Points")
  })
  
  #### Confederation Boxplot
  
  output$point_boxplot <- renderPlot ({
    fifa_18 %>%
      ggplot(aes(x = reorder(confederation, total_points, FUN = mean), y = total_points, fill = confederation)) +
      geom_boxplot(alpha=.75,size=.25) +
      geom_jitter(shape = 16, position = position_jitter(0.25), size = 1, alpha = .5) +
      theme_fivethirtyeight() + theme(legend.position = 'None') +
      scale_fill_discrete() +
      coord_flip()
  })
  
  output$ranking_boxplot <- renderPlot ({
    fifa_18 %>%
      ggplot(aes(x = reorder(confederation, -rank, FUN = mean), y = -rank, fill = confederation)) +
      geom_boxplot(alpha=.75,size=.25) +
      geom_jitter(shape = 16, position = position_jitter(0.25), size = 1, alpha = .5) +
      theme_fivethirtyeight() + theme(legend.position = 'None') +
      scale_fill_discrete() +
      coord_flip()
  })
  
  #### Nation Rankings by Confederation Histogram
  
  selectInput <- reactive ({
    switch(input$nation_confed,
           "AFC" = AFC,
           "CAF" = CAF,
           "CONCACAF" = CONCACAF,
           "CONMEBOL" = CONMEBOL,
           "OFC" = OFC,
           "UEFA" = UEFA)
  })
  
  output$nations_histo <- renderPlot ({
    
    nation_confed <- data.frame(fifa %>%
                                  dplyr::filter(confederation == input$nation_confed) %>%
                                  dplyr::mutate(rank_date = as.Date(rank_date, format = "%m/%d/%Y"), "%Y") %>%
                                  dplyr::group_by(rank, rank_date, country_full) %>%
                                  dplyr::summarise(meanRank = mean(rank)))
    
    nation_confed %>%
      ggplot(aes(x = rank_date, y = meanRank, color = meanRank)) + 
      geom_line(aes(group = 1), alpha = 1, size = 1.) + 
      theme_fivethirtyeight(10) +
      scale_y_reverse() + ylim(220, 0) +
      facet_wrap(~ country_full, ncol = 4)
  })
  
  #### Average Rankings Boxplots
  
  output$nations_rank <- renderPlot ({
    nation_rank <- data.frame(fifa %>%
                                dplyr::mutate(rank_date = as.Date(rank_date, format = "%m/%d/%Y"), "%Y") %>%
                                dplyr::mutate(country_full = as.character(country_full)) %>% 
                                dplyr::group_by(rank, rank_date, country_abrv, country_full) %>%
                                dplyr::summarise(meanRank = mean(rank)) %>%
                                dplyr::filter(meanRank < input$rank_max))
    
    nation_rank %>%
      ggplot(aes(x = reorder(country_full, -rank), y = -meanRank, fill = country_full)) +
      geom_boxplot(alpha = .75, size = .5) +
      geom_jitter(shape = 16, position = position_jitter(0.2), size = 1, alpha = .5) +
      theme_economist(8) + theme(legend.position = 'None') +
      scale_fill_discrete() +
      coord_flip() + 
      xlab("Country") + ylab("Rank")
  })
}