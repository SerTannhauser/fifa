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


function(input, output, session) {
  output$res <- renderText({
    req(input$sidebarItemExpanded)
    paste("Expanded menuItem:", input$sidebarItemExpanded)
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
      theme(legend.position = 'None', panel.grid.major.y = element_blank())
  })
  
  #### Histogram
  
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
      scale_fill_brewer(name = '', palette = 'Paired') +
      theme(legend.position= 'None', panel.grid.major.y = element_blank())
  })
}