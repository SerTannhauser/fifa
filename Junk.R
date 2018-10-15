selectizePanel("continent", "Confederation:", choice = c('AFC','AFC','CAF','CONCACAF','CONMEBOL','OFC','UEFA')),
hr(),
helpText("Select Confederation")),
inputPanel(
  selectInput("asia", "AFC Nations:", choices = c('Afghanistan','Australia','Bahrain','Bangladesh','Bhutan','Brunei','Cambodia',
                                                  'China PR','Chinese Taipei','Timor-Leste','Guam','Hong Kong','India','Indonesia',
                                                  'Iran','Iraq','Jordan','Korea DPR','Korea Republic','Kuwait','Kyrgyzstan',
                                                  'Laos','Lebanon','Macau','Malaysia','Maldives','Mongolia','Myanmar',
                                                  'Nepal','Oman','Pakistan','Palestine','Philippines','Qatar','Saudi Arabia',
                                                  'Singapore','Sri Lanka','Tajikistan','Thailand','Turkmenistan','United Arab Emirates',
                                                  'Uzbekistan','Vietnam','Yemen')),

  
  
  selectInput <- reactive ({
    switch(input$asia,
           "Afghanistan" = Afghanistan,
           "Australia" = Australia,
           "Bahrain" = Bahrain,
           "Bangladesh" = Bangladesh,
           "Bhutan" = Bhutan,
           "Brunei" = Brunei,
           "Cambodia" = Cambodia,
           "China PR" = 'China PR',
           "Taiwan" = 'Chinese Taipei',
           "Timor-Leste" = Timor-Leste,
           "Guam" = Guam,
           "Hong Kong" = 'Hong Kong',
           "India" = India,
           "Indonesia" = Indonesia,
           "Iran" = 'IR Iran',
           "Iraq" = Iraq,
           "Jordan" = Jordan,
           "Korea DPR" = 'Korea DPR',
           "Korea Republic" = 'Korea Republic',
           "Kuwait","Kyrgyzstan",
           "Laos" = Laos,
           "Lebanon" = Lebanon,
           "Macau" = Macau,
           "Malaysia" = Malaysia,
           "Maldives" = Maldives,
           "Mongolia" = Mongolia,
           "Myanmar" = Myanmar,
           "Nepal" = Nepal,
           "Oman" = Oman,
           "Pakistan" = Pakistan,
           "Palestine" = Palestine,
           "Philippines" = Philippines,
           "Qatar" = Qatar,
           "Saudi Arabia" = 'Saudi Arabia',
           "Singapore" = Singapore,
           "Sri Lanka" = 'Sri Lanka',
           "Tajikistan" = Tajikistan,
           "Thailand" = Thailand,
           "Turkmenistan" = Turkmenistan,
           "United Arab Emirates" = 'United Arab Emirates',
           "Uzbekistan" = Uzbekistan,
           "Vietnam" = Vietnam,
           "Yemen" = Yemen)
  })
  
  #### FIFA Rankings Map
  
  countries_map <- data.frame(map_data("world"))
  countries_map$region <- data.frame(countries_map %>%
                                       tolower(countries_map$region))
  fifa_map <- data.frame(left_join(countries_map, fifa_18 %>% 
                                     select(region, confederation), by = 'region'))
  
  output$fifamap <- renderPlot({
    fifa_map %>%
      ggplot() + geom_polygon(aes(x = long, y = lat, group = group, fill = rank)) +
      theme_fivethirtyeight() +
      scale_fill_brewer(name = '', palette = 'Paired', na.value = 'black') +
      theme(
        panel.grid.major = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank(), 
        legend.text = element_text(size = 10), legend.key.size = unit(.3, "cm")) +
      coord_fixed(1.3)
  })