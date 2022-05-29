library(here)
here("app", "www")

matches = read.csv("data/mainTable.csv")
a = img(src = "data/img/faze.jpg")

a = "C:/Users/janko/OneDrive/Pulpit/Artificial intelligence/SEM4/DATA VISUALIZATION/dviz-dashboard/data/semi-finals/faze-spirit-2-0/faze-vs-spirit-m1-mirage-export.xlsx"

library(readxl)
faze_vs_spirit_m1_mirage_export <- read_excel(a, sheet = "Kills")
View(faze_vs_spirit_m1_mirage_export)
