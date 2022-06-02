#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(DT)
library(plotly)
library(flexdashboard)


dashboardPage(
  dashboardHeader(title = "PGL Major Antwerp 2022"),
  dashboardSidebar(sidebarMenu(
    menuItem("Matches", tabName = "dashboard", icon = icon("dashboard"))
  )),
  dashboardBody(
    tabItems(
      tabItem(tabName = "dashboard",
              fluidRow(
                box(width=4, gaugeOutput("avground"), title="AVG Round time", height="20%"),
                box(width=4, title="Another box"),
                box(width=4, title="Another box")
                #valueBox(),
                #valueBox()
                
              ),
              fluidRow(
                box(width = 4, dataTableOutput("table1"), title="Matches", height = "50%"),
                tabBox(width = 8, title="Match Details", height = "50%",
                       tabPanel("Overview", uiOutput("match_details")),
                       tabPanel("Stats", selectInput("selection", "Select", c("Ratings","K/D Ratio","HS %","Weapons")), plotlyOutput("stat")),
                       tabPanel("Heat Map", uiOutput("heatmap"))
                       )
              )
              
      )
    )
  )
  
)
