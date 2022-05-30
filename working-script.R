library(here)
here("app", "www")

matches = read.csv("data/mainTable.csv")
a = img(src = "data/img/faze.jpg")

a = "C:/Users/janko/OneDrive/Pulpit/Artificial intelligence/SEM4/DATA VISUALIZATION/dviz-dashboard/data/semi-finals/faze-spirit-2-0/faze-vs-spirit-m1-mirage-export.xlsx"

library(readxl)
faze_vs_spirit_m1_mirage_export <- read_excel(a, sheet = "Players")
View(faze_vs_spirit_m1_mirage_export)
library(hash)
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

library(plotly)
library(ggplot2)
faze_vs_spirit_m1_mirage_export = faze_vs_spirit_m1_mirage_export %>% mutate(Team, replace(Team, Team == "FaZe Clan", "Faze_Clan"))
plot_ly(faze_vs_spirit_m1_mirage_export,
        x = ~Rating, 
        y = ~Name,
        color = ~Team,
        colors = c("#f1a340","#2c7bb6"),
        type='bar') %>%
  layout(yaxis = list(categoryorder = "total ascending", title=FALSE, tickfont = list(size = 15)),
         xaxis = list(range = c(0, 2.1), title=FALSE),
         legend = list(x = 1, y = 0.5, font = list(size = 15)))
