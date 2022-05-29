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


dashboardPage(
  dashboardHeader(title = "PGL Major Antwerp 2022"),
  dashboardSidebar(sidebarMenu(
    menuItem("Matches", tabName = "dashboard", icon = icon("dashboard")),
    menuItem("Players", tabName = "widgets", icon = icon("fa-solid fa-user")),
    menuItem("Ranking", tabName = "teams", icon=icon("fa-solid fa-square-poll-vertical", lib = "font-awesome"))
  )),
  dashboardBody(
    tabItems(
      tabItem(tabName = "dashboard",
              fluidRow(
                box(width = 4, dataTableOutput("table1"), title="Matches", height = "50%"),
                tabBox(width = 8, title="Match Details", height = "50%",
                       tabPanel("Overview", uiOutput("match_details")),
                       tabPanel("Stats", selectInput("selection", "Select", c("Ratings","K/D Ratio","HS %","Weapons")), uiOutput("stat")),
                       tabPanel("Heat Map")
                       )
              ),
              fluidRow(
                box(width=12, title="Map details", height = "50%")
                
              )
              ),
                tabItem(tabName="widgets",
              h2("Players")
      ),
      tabItem(tabName="teams",
              h2("Teams")
              )
    )
  )
  
)
