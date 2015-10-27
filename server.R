library(shiny);library(leaflet);library(ggmap);
library(XLConnect);library(ggplot2);library(data.table);library(DT);library(htmltools)

datamap <- readWorksheetFromFile("Accidents.xlsx",sheet="Sheet2",header=T)
datamap$long <- NA
datamap$lat <- NA
for (x in 1:nrow(datamap)){
  
  a <- as.numeric(geocode((datamap[x,1]))) ### fill long and lat loop
  datamap$long[x] <- a[1]
  datamap$lat[x] <- a[2]
}


server <- function(input, output, session) {
  
  output$text <- renderText({
    paste0(input$Year," ",input$Type)
  })
  
  output$plot <- renderPlot({
    toplot <- as.data.frame(datamap[,c("District",paste0(input$Type,".",input$Year))])
    qplot(x=District, y=eval(parse(text=paste0(input$Type,".",input$Year))),data=toplot, geom="bar", stat="identity",position="stack")+
      labs(x = "District")+labs(y = paste0(input$Type,".",input$Year))+
      theme(axis.text.x=element_text(angle=-45))
  })
  
  output$text1 <- renderText({
    paste0(input$Year," ",input$Result)
  })
  
  output$plot1 <- renderPlot({
    toplot1 <- as.data.frame(datamap[,c("District",paste0(input$Result,".",input$Year))])
    qplot(x=District, y=eval(parse(text=paste0(input$Result,".",input$Year))),data=toplot1, geom="bar", stat="identity",position="stack")+
      labs(x = "District")+labs(y = paste0(input$Result,".",input$Year))+
      theme(axis.text.x=element_text(angle=-45))
  })
  
#   points <- eventReactive(input$recalc, {
#     cbind(datamap$long, datamap$lat)
#   }, ignoreNULL = FALSE)
  
  district_popup <- paste0("<strong>District: </strong>", 
                        datamap$District," "
                        ,"<br>Sum of Lethal Accidents 2009: "
                        ,datamap$ALL.accidents.2009
                        , "<br>Sum of Lethal Accidents 2010: "
                        ,datamap$ALL.Accidents.2010)
  
  output$mymap <- renderLeaflet({
    leaflet() %>%
      addProviderTiles("Stamen.Toner",
                       options = providerTileOptions(noWrap = TRUE)
      ) %>%
      addMarkers(datamap$long,datamap$lat,popup=district_popup)
  })
  
  output$mytable1 <- DT::renderDataTable({
    datamap1 <-  datamap[,-c((ncol(datamap)-1):ncol(datamap))]
  })
  
}
