#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(flexdashboard)
library(shiny)
library(shinydashboard)
library(DT)
library(dplyr)
library(hash)
library(readxl)
library(plotly)
library(fontawesome)
library(rsconnect)


matches = read.csv("www/data/mainTable.csv")
h <- hash()
h[["de_nuke_6156803976143969921652992887300824718"]] <- "www/data/quarter-finals/nip-faze-1-2/nip-vs-faze-m1-nuke-export.xlsx"
h[["de_overpass_6246294808284798401652992894371821767"]] <- "www/data/quarter-finals/nip-faze-1-2/nip-vs-faze-m2-overpass-export.xlsx"
h[["de_inferno_6129343516433510251652992896293226512"]] <- "www/data/quarter-finals/nip-faze-1-2/nip-vs-faze-m3-inferno-export.xlsx"
h[["de_vertigo_6169713723863713901653001495292796899"]] <- "www/data/quarter-finals/spirit-furia-2-0/spirit-vs-furia-m1-vertigo-export.xlsx"
h[["de_ancient_6189363384583379821653001499268779520"]] <- "www/data/quarter-finals/spirit-furia-2-0/spirit-vs-furia-m2-ancient-export.xlsx"
h[["de_vertigo_6227803555223546171653072046257518894"]] <- "www/data/quarter-finals/ence-copenhagen-2-0/ence-vs-copenhagen-flames-m1-vertigo-export.xlsx"
h[["de_nuke_6144653951013944391653072050285187203"]] <- "www/data/quarter-finals/ence-copenhagen-2-0/ence-vs-copenhagen-flames-m2-nuke-export.xlsx"
h[["de_inferno_6134814769764762671653079632385597301"]] <- "www/data/quarter-finals/navi-heroic-2-1/natus-vincere-vs-heroic-m1-inferno-export.xlsx"
h[["de_ancient_6132695164325158151653088410392388334"]] <- "www/data/quarter-finals/navi-heroic-2-1/natus-vincere-vs-heroic-m2-ancient-export.xlsx"
h[["de_nuke_6158233889413883561653088414297335272"]] <- "www/data/quarter-finals/navi-heroic-2-1/natus-vincere-vs-heroic-m3-nuke-export.xlsx"
h[["de_mirage_6149234265054256971653161108318016110"]] <- "www/data/semi-finals/faze-spirit-2-0/faze-vs-spirit-m1-mirage-export.xlsx"
h[["de_dust2_6164417349477338771653161146556651229"]] <- "www/data/semi-finals/faze-spirit-2-0/faze-vs-spirit-m2-dust2-export.xlsx"
h[["de_nuke_6120393644743638661653172461261545720"]] <- "www/data/semi-finals/ence-navi-0-2/ence-vs-natus-vincere-m1-nuke-export.xlsx"
h[["de_dust2_6168184025594020881653172467308458688"]] <- "www/data/semi-finals/ence-navi-0-2/ence-vs-natus-vincere-m2-dust2-export.xlsx"
h[["de_inferno_6167926485136471891653258966546676159"]] <- "www/data/final-faze-navi/faze-vs-natus-vincere-m1-inferno-export.xlsx"
h[["de_nuke_6121563804743798651653259127279941755"]] <- "www/data/final-faze-navi/faze-vs-natus-vincere-m2-nuke-export.xlsx"



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
        <center><h2>{{team1} <b><br>{{score_first}:{{score_second}<br></b> {{team2}</h2></center>
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
      #heat {
      max-height: 100%;
      max-width: 100%
      }
      #heatdiv {
      height: 600px;
      width: 100%;
      text-align: center;
      display: flex;
      justify-content: center;
      padding-top: 2%;
      }
    </style>
    <div id=\"heatdiv\">
    <img src=\"{{map}.png\" alt=\"{{map}\" id=\"heat\">
    </div>
    ", .open="{{"
  )
}

display_map = function(row){
  map = toString(select(row, Map))
  glue::glue(
    "<style>
      #mapimg {
        max-height: 100%;
        max-width: 100%;
      }
      #mapdiv {
        max-height: 100%;
        max-width: 100%;
      }
    </style>
    <div id=\"mapdiv\">
    <img src=\"{{map}.png\" alt=\"{{map}\" id=\"mapimg\">
    </div>
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
      } else if (input$selection == "Equipment value"){
        #plot with eq value
        df = read_excel(file, sheet="Rounds")
        df = rename(df, "eq1" = "Equipement value team 1")
        df = rename(df, "eq2" = "Equipement value team 2")
        team1 = toString(select(row, Name.team.1))
        team2 = toString(select(row, Name.team.2))
        plot_ly(df, x=~Number, y=~eq1, name = team1, type="scatter", mode="lines", line = list(color="rgb(0, 192, 239)", width = 2)) %>%
            add_trace( y=~eq2, name=team2, line = list(color = "rgb(216, 27, 96)", width = 2)) %>%
            layout(xaxis = list(title = "Round", dtick=1, tick0=1),
                             yaxis = list(tickprefix="$", title=""))
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
        df = select(read_excel(file, sheet="Kills"), one_of(c("Killer", "Killer team", "Victim", "Weapon")))
        kwp_series <- df %>% group_by(Killer, Weapon) %>% summarise(n = n())
        weapons_kils <- df %>% group_by(Weapon) %>% summarise(n = n())
        
        sc = data.frame("all-kills", "kills", sum(weapons_kils$n), "")
        colnames(sc) = c("id", "label", "value", "parents")
        for (i in 1:nrow(weapons_kils)) {
          temp = data.frame(weapons_kils$Weapon[i], weapons_kils$Weapon[i], weapons_kils$n[i], "all-kills")
          colnames(temp) = c("id", "label", "value", "parents")
          sc <- bind_rows(sc, temp)
        }
        for (i in 1:nrow(kwp_series)) {
          temp = data.frame(paste(kwp_series$Killer[i], "-", kwp_series$Weapon[i]), kwp_series$Killer[i], kwp_series$n[i], kwp_series$Weapon[i])
          colnames(temp) = c("id", "label", "value", "parents")
          sc <- bind_rows(sc, temp)
        }
        
        
        plt <- plot_ly()
        plt <- plt %>%
          add_trace(
            ids = sc$id,
            labels = sc$label,
            parents = sc$parents,
            values = sc$value,
            type = 'sunburst',
            branchvalues = 'total',
            insidetextorientation='radial',
            maxdepth = 3
          )
        plt <- plt %>% layout(sunburstcolorway = c('#003fde', '#7689a5', '#9da684', '#cf9481', '#ff009c', '#c0f693', '#8fddd1', '#57b5f5', '#007eff'))
        
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
     # print("No match selected.")
      gauge(0, min = 0, max = 200, symbol = "s")
    }
  })

  output$displaymap = renderUI({
    match = input$table1_rows_selected
    if (length(match)) {
      row = filter(matches, X == match)
      HTML(display_map(row))
      
    } else {
      HTML("<center><p>not selected</p></center>")
    }
  })
  
  display_stats = function(df, team1, team2){
    
    p11 = toString(select(filter(arrange(filter(df, Team == team1), desc(Score)), row_number()==1), Name))
    p12 = toString(select(filter(arrange(filter(df, Team == team1), desc(Score)), row_number()==2), Name))
    p13 = toString(select(filter(arrange(filter(df, Team == team1), desc(Score)), row_number()==3), Name))
    p14 = toString(select(filter(arrange(filter(df, Team == team1), desc(Score)), row_number()==4), Name))
    p15 = toString(select(filter(arrange(filter(df, Team == team1), desc(Score)), row_number()==5), Name))
    p21 = toString(select(filter(arrange(filter(df, Team == team2), desc(Score)), row_number()==1), Name))
    p22 = toString(select(filter(arrange(filter(df, Team == team2), desc(Score)), row_number()==2), Name))
    p23 = toString(select(filter(arrange(filter(df, Team == team2), desc(Score)), row_number()==3), Name))
    p24 = toString(select(filter(arrange(filter(df, Team == team2), desc(Score)), row_number()==4), Name))
    p25 = toString(select(filter(arrange(filter(df, Team == team2), desc(Score)), row_number()==5), Name))
    
    glue::glue(
     "<style>
         #parent {
          margin: 0 auto;
          display: flex;
          justify-content: center;
          width: 50%;
          
    }
         #leftchild {
          flex: 1;
          margin: 10px;
          text-align: left;
          margin-right: 20px;
         }
    #rightchild {
          flex: 1;
          margin: 10px;
          text-align: right;
    }
     </style>
     <center><h3><u>Lineups</u></h3></center>
     <center><p>(<span style=\"color:green\">Kills</span>/<span style=\"color:blue\">Assists</span>/<span style=\"color:red\">Deaths</span>)</p></center>
     <div id=\"parent\">
     
      <div id=\"leftchild\">
        <h4><b>{{team1}</b></h4>
        <p>{{p11} (<span style=\"color:green\">{{toString(select(filter(df, Name == p11), Kills))}</span>/<span style=\"color:blue\">{{toString(select(filter(df, Name == p11), Assists))}</span>/<span style=\"color:red\">{{toString(select(filter(df, Name == p11), Deaths))}</span>)</p>
        <p>{{p12} (<span style=\"color:green\">{{toString(select(filter(df, Name == p12), Kills))}</span>/<span style=\"color:blue\">{{toString(select(filter(df, Name == p12), Assists))}</span>/<span style=\"color:red\">{{toString(select(filter(df, Name == p12), Deaths))}</span>)</p>
        <p>{{p13} (<span style=\"color:green\">{{toString(select(filter(df, Name == p13), Kills))}</span>/<span style=\"color:blue\">{{toString(select(filter(df, Name == p13), Assists))}</span>/<span style=\"color:red\">{{toString(select(filter(df, Name == p13), Deaths))}</span>)</p>
        <p>{{p14} (<span style=\"color:green\">{{toString(select(filter(df, Name == p14), Kills))}</span>/<span style=\"color:blue\">{{toString(select(filter(df, Name == p14), Assists))}</span>/<span style=\"color:red\">{{toString(select(filter(df, Name == p14), Deaths))}</span>)</p>
        <p>{{p15} (<span style=\"color:green\">{{toString(select(filter(df, Name == p15), Kills))}</span>/<span style=\"color:blue\">{{toString(select(filter(df, Name == p15), Assists))}</span>/<span style=\"color:red\">{{toString(select(filter(df, Name == p15), Deaths))}</span>)</p>
      </div>
      <div id=\"rightchild\">
        <h4><b>{{team2}</b></h4>
        <p>(<span style=\"color:green\">{{toString(select(filter(df, Name == p21), Kills))}</span>/<span style=\"color:blue\">{{toString(select(filter(df, Name == p21), Assists))}</span>/<span style=\"color:red\">{{toString(select(filter(df, Name == p21), Deaths))}</span>) {{p21}</p>
        <p>(<span style=\"color:green\">{{toString(select(filter(df, Name == p22), Kills))}</span>/<span style=\"color:blue\">{{toString(select(filter(df, Name == p22), Assists))}</span>/<span style=\"color:red\">{{toString(select(filter(df, Name == p22), Deaths))}</span>) {{p22}</p>
        <p>(<span style=\"color:green\">{{toString(select(filter(df, Name == p23), Kills))}</span>/<span style=\"color:blue\">{{toString(select(filter(df, Name == p23), Assists))}</span>/<span style=\"color:red\">{{toString(select(filter(df, Name == p23), Deaths))}</span>) {{p23}</p>
        <p>(<span style=\"color:green\">{{toString(select(filter(df, Name == p24), Kills))}</span>/<span style=\"color:blue\">{{toString(select(filter(df, Name == p24), Assists))}</span>/<span style=\"color:red\">{{toString(select(filter(df, Name == p24), Deaths))}</span>) {{p24}</p>
        <p>(<span style=\"color:green\">{{toString(select(filter(df, Name == p25), Kills))}</span>/<span style=\"color:blue\">{{toString(select(filter(df, Name == p25), Assists))}</span>/<span style=\"color:red\">{{toString(select(filter(df, Name == p25), Deaths))}</span>) {{p25}</p>
        
      </div>
     </div>
     ", .open="{{" 
    )
  }
  
  output$tablestats = renderUI({
    match = input$table1_rows_selected
    if(length(match)){
      row = filter(matches, X == match)
      team1 = toString(select(row, Name.team.1))
      team2 = toString(select(row, Name.team.2))
      #print(team1)
      hashname = toString(select(row, ID))
      file = h[[hashname]]
      df = read_excel(file, sheet="Players")
      HTML(display_stats(df, team1, team2))
    } else {
      
    }
  })
  
  
  output$bombexp = renderValueBox({
    match1 = input$table1_rows_selected
    if(length(match1)){
      row = filter(matches, X == match1)
      hashname = toString(select(row, ID))
      file = h[[hashname]]
      df = read_excel(file, sheet="Rounds")
      df = rename(df, "bombexp" = "Bomb Exploded")
      bombs = sum(df$bombexp)
      valueBox(
        bombs, "BOMBS EXPLOSIONS",  color = "yellow", icon = icon("bomb")
      )
    } else {
      valueBox(
        0, "BOMBS EXPLOSIONS",  color = "yellow", icon = icon("bomb")
      )
    }
  })
  
  output$defused = renderValueBox({
    match1 = input$table1_rows_selected
    if(length(match1)){
      row = filter(matches, X == match1)
      hashname = toString(select(row, ID))
      file = h[[hashname]]
      df = read_excel(file, sheet="Rounds")
      df = rename(df, "bombdef" = "Bomb defused")
      defs = sum(df$bombdef)
      valueBox(
        defs, "BOMBS DEFUSED",  color = "blue", icon = icon("hand-holding-medical", lib = "font-awesome")
      )
    } else {
      valueBox(
        0, "BOMBS DEFUSED",  color = "blue", icon = icon("hand-holding-medical", lib = "font-awesome")
      )
    }
  })
  
  output$team1money = renderValueBox({
    match = input$table1_rows_selected
    if(length(match)){
      row = filter(matches, X == match)
      hashname = toString(select(row, ID))
      file = h[[hashname]]
      df = read_excel(file, sheet="Rounds")
      df = rename(df, "eq" = "Equipement value team 1")
      money = sum(df$eq)
      team1 = toString(select(row, Name.team.1))
      valueBox(paste0(money, "$"), paste0(toupper(team1), " - TOTAL EQ VALUE"), icon=icon("money-bill"))
    } else {
      valueBox(paste0(NaN, "$"), paste0(toupper(NaN), " - TOTAL EQ VALUE"), icon=icon("money-bill"))
    }
  })
  
  output$team2money = renderValueBox({
    match = input$table1_rows_selected
    if(length(match)){
      row = filter(matches, X == match)
      hashname = toString(select(row, ID))
      file = h[[hashname]]
      df = read_excel(file, sheet="Rounds")
      df = rename(df, "eq" = "Equipement value team 2")
      money = sum(df$eq)
      team2 = toString(select(row, Name.team.2))
      valueBox(paste0(money, "$"), paste0(toupper(team2), " - TOTAL EQ VALUE"), color = "maroon", icon=icon("money-bill"))
    } else {
      valueBox(paste0(NaN, "$"), paste0(toupper(NaN), " - TOTAL EQ VALUE"), color = "maroon", icon=icon("money-bill"))
    }
  })
  
  output$secabout = renderUI({
    text = glue::glue("
      <style>
        #abouttext {
          font-size: 20px;
        }
        </style>
                      <center><h1>About</h1></center>
                      <div id=\"abouttext\">
                      <p>The dashboard presents data on the knockout matches of the <b>PGL Major Antwerp 2022 </b>(one of the most important CS:GO tournaments this year). 
                       After selecting a match played between two teams, the user gets access to comprehensive visualizations, which helps analyse the match and 
                      evaluate player’s performance: </p>
                      <ul>
                        <li>Result of the match</li>
                        <li>Map played during the match</li>
                        <li>Lineups of the teams</li>
                        <li>Rating of each player</li>
                        <li>Teams equipment value during the match</li>
                        <li>Headshot percentage of each player</li>
                        <li>Distribution of kills between players (in case of used weapons)</li>
                        <li>Kill heat map</li>
                        <li>Number of defused bombs and explosions</li>
                        <li>Total equipment value of each team</li>
                        <li>Average round duration</li>
                      </ul>
                      </div>
  ", .open = "{{"
                        )
    HTML(text)
  })
  
  
}