library(shiny);library(leaflet);library(ggmap);
library(XLConnect);library(data.table);library(DT);library(htmltools)


r_colors <- rgb(t(col2rgb(colors()) / 255))
names(r_colors) <- colors()

ui <- fluidPage(
  titlePanel(h2("Hellenic Road Accidents Mapper")),
  sidebarLayout(
    sidebarPanel(
      flowLayout(
        selectInput("Year", label = h3("Year"), 
                    choices = list("2009","2010"), selected = "2009")
      ),
      flowLayout(
        
        selectInput("Type", label = h3("Type of Accident"), 
                    choices = list("Lethal", "Serious","Light","ALL.accidents"), selected = "ALL")
      ),
      flowLayout(
        
        selectInput("Result", label = h3("Result of Accident"), 
                    choices = list("Deaths", "Heavily.Injured", "Light.Injuries","ALL.Individual"), selected = "ALL.Individual")
        
      ),
      br(),
      br(),
      p("Official data were retrived from the hellenic open data",
        a("portal",href="http://geodata.gov.gr/geodata/"))
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Map",
                 leafletOutput("mymap"),
                 p(),
                 actionButton("recalc", "Resize")),
        tabPanel("BarPlots",
                 h3(textOutput("text")),
                 plotOutput("plot"),
                 h3(textOutput("text1")),
                 plotOutput("plot1")),
        tabPanel("Data Table",  DT::dataTableOutput("mytable1"))
      )
    )
  )
)