
library(formattable, quietly = T)
library(rvest, quietly = T)
######Part 2: Firedanger forecast (7days)
#read in file to scrape
fire <- read_html("http://www.myforecast.com/bin/firedanger.m?city=12064&zip_code=94611&metric=false")
#pick out web elements of interest
firehtml <- html_nodes(fire, "tr:nth-child(11) .normal .normal:nth-child(3)")
#identify days of the week for forecast
firedayshtml <- html_nodes(fire, "tr:nth-child(11) tr+ tr td:nth-child(1)")
firedays <- html_text(firedayshtml)
#identify forecast
FireForecast <- html_text(firehtml)
#arrange final data frame
final_fire_forecast <- data.frame(FireForecast, row.names = firedays, stringsAsFactors = F)
#Remove the words "Fire danger" to clean up table
final_fire_forecast$FireForecast <- gsub("Fire danger", "", final_fire_forecast$FireForecast)


#Print to html table
#htmlTable(final_fire_forecast, header = "Fire Forecast", col.rgroup = c("none", "#F7F7F7"))

fire_table <- formattable(final_fire_forecast, 
            list(FireForecast = 
                     formatter("span", style = x ~ 
                                   ifelse(x == " very low", style(display = "block",`border-radius` = "4px",
                                                                  padding = "0 4px",background = "green", 
                                                                  color = "white", font.weight = "bold"), 
                                          ifelse(x == " low" , style(display = "block",`border-radius` = "4px",
                                                                     padding = "0 4px", background = "yellow", 
                                                                     color ="white", font.weight = "bold"), 
                                                 style(display = "block",`border-radius` = "4px",
                                                       padding = "0 4px",background = "red", 
                                                       color = "white", font.weight = "bold") ) ) ) ) )

save.image("~/Data_Science/Oakland/Fire.RData")