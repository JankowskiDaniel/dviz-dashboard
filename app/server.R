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
library(DT)
library(dplyr)



function(input, 
         output, session) { 
  output$table1 = renderDataTable({
    
    matches %>% select(Map, Name.team.1, Name.team.2)
  }, options = list(scrollX = TRUE), server = FALSE, selection="single")
  
  template = function(row){
    team1 = select(row, Name.team.1)
    team2 = select(row, Name.team.2)
    map = select(row, Map)
    score_first = select(row, Score.1st.team)
    score_second = select(row, Score.2nd.team)
    glue::glue(
      "
      <style>
        #main {
          display: inline;
          float: left;
          width: 50%;
        }
        img {
          float: left;
          display: block;
          margin-left:auto;
          margin-right:auto;
          
        }
        #cont {
          margin: auto;
          width: 85%;
          padding: 10px;
        }
      
      </style>
      
      <div id=\"cont\">
        <img src=\"{{team1}.png\" alt=\"team1\" width=120 height=86>
        <div id=\"main\">
        <center><h2>{{team1} <b>{{score_first}:{{score_second}</b> {{team2}</h2></center>
        <center><p>Map: {{map}</p></center>
        </div>
        <img src=\"{{team2}.png\" alt=\"team2\" width=120 height=86>
      </div>
      <br>
      <hr width=75%>", .open="{{"
    )
  }
  
  
  output$match_details = renderUI({
    match = input$table1_rows_selected
    if (length(match)) {
      row = filter(matches, X == match)
      
      HTML(template(row))
      
    } else {
      HTML("<center><p>not selected</p></center>")
    }
  
  })

  
}