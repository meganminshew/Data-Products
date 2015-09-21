library(shiny)
library(dplyr)

#load the sample measurement data -- using one mooring, one year
h2o <- read.csv("CCE2_121W_34N_Mar2012_Mar2013.csv")

#clean up the column names
colnames(h2o)[1] <- 'Mooring'
colnames(h2o)[6] <- 'CO2_Ocean_Wet'
colnames(h2o)[7] <- 'CO2_Ocean_dataquality'
colnames(h2o)[8] <- 'H2O_Ocean'
colnames(h2o)[9] <- 'CO2_Air_Wet'
colnames(h2o)[10] <- 'CO2_Air_dataquality'
colnames(h2o)[11] <- 'H2O_Air'
colnames(h2o)[12] <- 'Atmospheric_Pressure'
colnames(h2o)[13] <- 'Air_Temperature'
colnames(h2o)[14] <- 'Oxygen_Pct'
colnames(h2o)[15] <- 'Sea_Surface_Temperature'
colnames(h2o)[16] <- 'Sea_Surface_Salinity'
colnames(h2o)[17] <- 'CO2_Ocean_Dry'
colnames(h2o)[18] <- 'CO2_Air_Dry'
colnames(h2o)[19] <- 'CO2_Ocean'
colnames(h2o)[20] <- 'CO2_Air'
colnames(h2o)[21] <- 'CO2_Ocean_Minus_CO2_Air'

#make date into a date
h2o$Date <- as.Date(h2o$Date, format = "%m/%d/%y")

#drop the columns that aren't needed
h2o <- subset(h2o, select=c(4,6:21))

#group the vectors by date and average the measures
h2o_group <- group_by(h2o, Date)
h2o_dailymean <- summarise(h2o_group, 
                           CO2_Ocean_Wet = mean(CO2_Ocean_Wet, na.rm=TRUE), 
                           CO2_Ocean_dataquality = mean(CO2_Ocean_dataquality, na.rm=TRUE), 
                           H2O_Ocean = mean(H2O_Ocean, na.rm=TRUE), 
                           CO2_Air_Wet = mean(CO2_Air_Wet, na.rm=TRUE), 
                           CO2_Air_dataquality = mean(CO2_Air_dataquality, na.rm=TRUE), 
                           H2O_Air = mean(H2O_Air, na.rm=TRUE), 
                           Atmospheric_Pressure = mean(Atmospheric_Pressure, na.rm=TRUE), 
                           Air_Temperature = mean(Air_Temperature, na.rm=TRUE), 
                           Oxygen_Pct = mean(Oxygen_Pct, na.rm=TRUE), 
                           Sea_Surface_Temperature = mean(Sea_Surface_Temperature, na.rm=TRUE), 
                           Sea_Surface_Salinity = mean(Sea_Surface_Salinity, na.rm=TRUE), 
                           CO2_Ocean_Dry = mean(CO2_Ocean_Dry, na.rm=TRUE), 
                           CO2_Air_Dry = mean(CO2_Air_Dry, na.rm=TRUE), 
                           CO2_Ocean = mean(CO2_Ocean, na.rm=TRUE), 
                           CO2_Air = mean(CO2_Air, na.rm=TRUE), 
                           CO2_Ocean_Minus_CO2_Air = mean(CO2_Ocean_Minus_CO2_Air, na.rm=TRUE))


shinyServer(function(input, output) {
  
  #construct the plot and label syntax from the input choice
  dataName <- reactive({
    paste(input$variableA, " ~ ", input$variableB)
  })
  
  detailA <- reactive({
    paste(input$variableA, " ~ Date")
  })
  
  detailB <- reactive({
    paste(input$variableB, " ~ Date")
  })
  
  #write a warning if the same value is picked in both drop downs
  output$caption <- renderText({
    if (input$variableA == input$variableB) {
      "You have chosen the same measure in both lists. Pick a different Measure Two for a valid comparison"
    } 
    else {gsub("_"," ", dataName())}}
  )
  #write the plot parameters out
  output$captionA <- renderText({gsub("_"," ", detailA())})
  output$captionB <- renderText({gsub("_"," ", detailB())})
  

  #and build the plot with toggle for outlier choice
  output$h2oplot <- renderPlot({
    if (input$grp == "h2o") {
    boxplot(as.formula(dataName()), 
            data = h2o, 
            outline = input$outliers, labels=row.names, col="red")
    } else {
      boxplot(as.formula(dataName()), 
              data = h2o_dailymean, 
              outline = input$outliers, labels=row.names, col="orange")}
    
  })
  output$MeasureAPlot <- renderPlot({
    if (input$grp == "h2o") {
    boxplot(as.formula(detailA()), 
            data = h2o, 
            outline = input$outliers, labels=row.names, col="blue")
    
    } else {
      boxplot(as.formula(detailA()), 
              data = h2o_dailymean, 
              outline = input$outliers, labels=row.names, col="lightblue")}
    })
  output$MeasureBPlot <- renderPlot({
    if (input$grp == "h2o") {
    boxplot(as.formula(detailB()), 
            data = h2o, 
            outline = input$outliers, labels=row.names, col="green")
    
    } else {
      boxplot(as.formula(detailA()), 
              data = h2o_dailymean, 
              outline = input$outliers, labels=row.names, col="lightgreen")}
    })
  
})
  