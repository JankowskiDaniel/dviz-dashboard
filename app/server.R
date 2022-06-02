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
library(hash)
library(readxl)
library(plotly)
library(flexdashboard)

matches = read.csv("../data/mainTable.csv")
h <- hash()
h[["de_nuke_6156803976143969921652992887300824718"]] <- "../data/quarter-finals/nip-faze-1-2/nip-vs-faze-m1-nuke-export.xlsx"
h[["de_overpass_6246294808284798401652992894371821767"]] <- "../data/quarter-finals/nip-faze-1-2/nip-vs-faze-m2-overpass-export.xlsx"
h[["de_inferno_6129343516433510251652992896293226512"]] <- "../data/quarter-finals/nip-faze-1-2/nip-vs-faze-m3-inferno-export.xlsx"
h[["de_vertigo_6169713723863713901653001495292796899"]] <- "../data/quarter-finals/spirit-furia-2-0/spirit-vs-furia-m1-vertigo-export.xlsx"
h[["de_ancient_6189363384583379821653001499268779520"]] <- "../data/quarter-finals/spirit-furia-2-0/spirit-vs-furia-m2-ancient-export.xlsx"
h[["de_vertigo_6227803555223546171653072046257518894"]] <- "../data/quarter-finals/ence-copenhagen-2-0/ence-vs-copenhagen-flames-m1-vertigo-export.xlsx"
h[["de_nuke_6144653951013944391653072050285187203"]] <- "../data/quarter-finals/ence-copenhagen-2-0/ence-vs-copenhagen-flames-m2-nuke-export.xlsx"
h[["de_inferno_6134814769764762671653079632385597301"]] <- "../data/quarter-finals/navi-heroic-2-1/natus-vincere-vs-heroic-m1-inferno-export.xlsx"
h[["de_ancient_6132695164325158151653088410392388334"]] <- "../data/quarter-finals/navi-heroic-2-1/natus-vincere-vs-heroic-m2-ancient-export.xlsx"
h[["de_nuke_6158233889413883561653088414297335272"]] <- "../data/quarter-finals/navi-heroic-2-1/natus-vincere-vs-heroic-m3-nuke-export.xlsx"
h[["de_mirage_6149234265054256971653161108318016110"]] <- "../data/semi-finals/faze-spirit-2-0/faze-vs-spirit-m1-mirage-export.xlsx"
h[["de_dust2_6164417349477338771653161146556651229"]] <- "../data/semi-finals/faze-spirit-2-0/faze-vs-spirit-m2-dust2-export.xlsx"
h[["de_nuke_6120393644743638661653172461261545720"]] <- "../data/semi-finals/ence-navi-0-2/ence-vs-natus-vincere-m1-nuke-export.xlsx"
h[["de_dust2_6168184025594020881653172467308458688"]] <- "../data/semi-finals/ence-navi-0-2/ence-vs-natus-vincere-m2-dust2-export.xlsx"
h[["de_inferno_6167926485136471891653258966546676159"]] <- "../data/final-faze-navi/faze-vs-natus-vincere-m1-inferno-export.xlsx"
h[["de_nuke_6121563804743798651653259127279941755"]] <- "../data/final-faze-navi/faze-vs-natus-vincere-m2-nuke-export.xlsx"



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
          max-height: 100%;
          max-width: 100%;
          
        }
        #cont {
          width: 100%;
          text-align: center;
          display: flex;
          justify-content: center;
          padding-top: 2%;
        }
        #logo {
        width: 100px;
        height: 100px;
        }
      
      </style>
      
      <div id=\"cont\">
        <div id=\"logo\">
        <img src=\"{{team1}.png\" alt=\"team1\" width=120 height=86>
        </div>
        <div id=\"main\">
        <center><h2>{{team1} <b>{{score_first}:{{score_second}</b> {{team2}</h2></center>
        <center><p>Map: {{map}</p></center>
        </div>
        <div id=\"logo\">
        <img src=\"{{team2}.png\" alt=\"team2\" width=120 height=86>
        </div>
      </div>
      <br>
      <hr width=75%>", .open="{{"
  )
}

display_heatmap = function(row){
  map = toString(select(row, ID))
  glue::glue(
    "<style>
      
    </style>
    <img src=\"{{map}.png\" alt=\"{{map}\" id=\"heat\">
    <p>Heat map based on kills</p>
    ", .open="{{"
  )
}

function(input, 
         output, session) { 
  output$table1 = renderDataTable({
    
    matches %>% select(Map, Name.team.1, Name.team.2)
  }, options = list(scrollX = TRUE), server = FALSE, selection=list(mode = "single", selected = 1))
  
  
  
  
  output$match_details = renderUI({
    match = input$table1_rows_selected
    if (length(match)) {
      row = filter(matches, X == match)
      
      HTML(template(row))
      
    } else {
      HTML("<center><p>not selected</p></center>")
    }
  
  })
  
  output$stat = renderPlotly({
    match1 = input$table1_rows_selected
    if (length(match1)){
      row = filter(matches, X == match1)
      hashname = toString(select(row, ID))
      file = h[[hashname]]
      if (input$selection == "Ratings"){
        # plot with ratings
        df = read_excel(file, sheet="Players")
        plot_ly(df,
                x = ~Rating, 
                y = ~Name,
                color = ~Team,
                colors = c("#f1a340","#2c7bb6"),
                type='bar') %>%
          layout(yaxis = list(categoryorder = "total ascending", title=FALSE, tickfont = list(size = 15)),
                 xaxis = list(range = c(0, 2.1), title=FALSE),
                 legend = list(x = 1, y = 0.5, font = list(size = 15)))
      } else if (input$selection == "K/D Ratio"){
        #plot with k/d ratio
      } else if (input$selection == "HS %"){
        #plot with hs%
        df = read_excel(file, sheet="Players")
        df = rename(df, 'HSper' = 'HS%')
        plot_ly(df,
                x = ~HSper, 
                y = ~Name,
                color = ~Team,
                colors = c("#f1a340","#2c7bb6"),
                type='bar') %>%
          layout(yaxis = list(categoryorder = "total ascending", title=FALSE, tickfont = list(size = 15)),
                 xaxis = list(range = c(0, 101), title=FALSE),
                 legend = list(x = 1, y = 0.5, font = list(size = 15)))
      } else if (input$selection == "Weapons"){
        #plot with weapons used in match

      }
    } else {
      
    }
    
  })
  
  output$heatmap = renderUI({
    match = input$table1_rows_selected
    if (length(match)) {
      row = filter(matches, X == match)
      HTML(display_heatmap(row))
      
    } else {
      HTML("<center><p>not selected</p></center>")
    }
  })
  
  output$avground = renderGauge({
    match1 = input$table1_rows_selected
    if(length(match1)){
      row = filter(matches, X == match1)
      hashname = toString(select(row, ID))
      file = h[[hashname]]
      df = read_excel(file, sheet="Rounds")
      df = rename(df, "duration" = "Duration (s)")
      avgroundtime = round(mean(df$duration),2)
      gauge(avgroundtime, min = 0, max = 200, symbol = "s")
    } else {
      print("No match selected.")
    }
  })

  
}