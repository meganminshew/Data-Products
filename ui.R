library(shiny)

shinyUI(fluidPage(
  
  titlePanel("Ocean Carbon Dioxide Measurements by Date"),
  
  # Sidebar with controls to select the variable to plot against mpg
  # and to specify whether outliers should be included
  sidebarLayout(
      sidebarPanel(
        selectInput("variableA", "Measure One:",
                list("atmospheric temperature" = "Air_Temperature",
                     "atmospheric pressure" = "Atmospheric_Pressure",
                     "sea surface temperature" = "Sea_Surface_Temperature",
                     "sea surface salinity" = "Sea_Surface_Salinity",
                     "percent oxygen" = "Oxygen_Pct",
                     "molality fraction of CO2 in sea water in wet gas" = "CO2_Ocean_Wet",
                     "molality fraction of CO2 in sea water in dry gas" = "CO2_Ocean_Dry",
                     "molality fraction of CO2 in air in wet gas" = "CO2_Air_Wet",
                     "molality fraction of CO2 in air in dry gas" = "CO2_Air_Dry",
                     "molality fraction of H2O in sea water" = "H2O_Ocean",
                     "molality fraction of H2O in air" = "H2O_Air",
                     "fugasity of CO2 in sea water" = "CO2_Ocean",
                     "fugasity of CO2 in air" = "CO2_Air",
                     "difference between CO2 sea water and CO2 air" = "CO2_Ocean_Minus_CO2_Air")),
        selectInput("variableB", "Measure Two:",
                list("difference between CO2 sea water and CO2 air" = "CO2_Ocean_Minus_CO2_Air",
                     "atmospheric pressure" = "Atmospheric_Pressure",
                     "atmospheric temperature" = "Air_Temperature",
                     "percent oxygen" = "Oxygen_Pct",
                     "sea surface temperature" = "Sea_Surface_Temperature",
                     "sea surface salinity" = "Sea_Surface_Salinity",
                     "molality fraction of CO2 in sea water in wet gas" = "CO2_Ocean_Wet",
                     "molality fraction of CO2 in sea water in dry gas" = "CO2_Ocean_Dry",
                     "molality fraction of CO2 in air in wet gas" = "CO2_Air_Wet",
                     "molality fraction of CO2 in air in dry gas" = "CO2_Air_Dry",
                     "molality fraction of H2O in sea water" = "H2O_Ocean",
                     "molality fraction of H2O in air" = "H2O_Air",
                     "fugasity of CO2 in sea water" = "CO2_Ocean",
                     "fugasity of CO2 in air" = "CO2_Air")),
        radioButtons("grp", "Daily Grouping Action:", c("None -- plot all data points" = "h2o",
                                                        "Average -- plot the daily mean" = "h2o_dailymean")),
        checkboxInput("outliers", "Show outliers", FALSE),
        HTML("<br><br>Pick measures from the two drop down lists to see the change of each measure over time.<br><br>A correlation of both measures is displayed first to highlight affinity between measures.<br><br>To view normalized data, ensure that 'Show outliers' is not selected.<br><br><br><font size='1'>Data source citation:<br>Sutton, A., C. Sabine, S. Maenner, S. Musielewicz, R. Bott, and J. Osborne. 2013.<br>High-resolution ocean and atmosphere pCO2 time-series measurements from mooring CCE2_121W_34N.<br>cdiac.esd.ornl.gov/ftp/oceans/Moorings/CCE2_121W_34N/.<br>Carbon Dioxide Information Analysis Center, Oak Ridge National Laboratory, US Department of Energy, Oak Ridge, Tennessee.</font>")
),
    mainPanel(
      h3(textOutput("caption")),
      plotOutput("h2oplot"),
      h4(textOutput("captionA")),
      plotOutput("MeasureAPlot"),
      h4(textOutput("captionB")),
      plotOutput("MeasureBPlot")
  )
)))