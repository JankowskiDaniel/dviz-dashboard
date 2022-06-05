#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(flexdashboard)
library(shiny)
library(shinydashboard)
library(DT)
library(plotly)
library(fontawesome)



dashboardPage(
  dashboardHeader(title = "PGL Major Antwerp 2022"),
  dashboardSidebar(sidebarMenu(
    menuItem("Matches", tabName = "dashboard", icon = icon("gamepad")),
    menuItem("About", tabName = "about", icon = icon("question"))
  )),
  dashboardBody(
    tabItems(
      tabItem(tabName = "dashboard",
              fluidRow(
                box(width=3, verticalLayout(valueBoxOutput("defused", width="100%"),valueBoxOutput("bombexp", width="100%"))),
                box(width=3, gaugeOutput("avground"), title="AVG Round time"),
                box(width=3, verticalLayout(valueBoxOutput("team1money", width="100%"),valueBoxOutput("team2money", width="100%"))),
                box(width=3, title="Map", uiOutput("displaymap"))
              ),
              fluidRow(
                box(width = 4, dataTableOutput("table1"), title="Matches", height = "50%"),
                tabBox(width = 8, title="Match Details", height = "50%",
                       tabPanel("Overview", uiOutput("match_details"), uiOutput("tablestats")),
                       tabPanel("Stats", selectInput("selection", "Select", c("Ratings","Equipment value","HS %","Weapons")), plotlyOutput("stat")),
                       tabPanel("Heat Map", uiOutput("heatmap"))
                       )
              ),
              
      ),
      tabItem(tabName = "about",
              box(width = 12, uiOutput("secabout")))
    )
  )
  
)
