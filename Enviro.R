library(rvest)
library(htmlTable)
#air pollution forecast
#read the page
air_quality <- read_html("http://sparetheair.org/stay-informed/todays-air-quality/five-day-forecast")
###### First Draft
# day1 <- air_quality %>% 
#     html_node("div div #phcontent_0_divC1CCB") %>%
#     html_text() %>%
#     as.numeric()
# 
# day2 <- air_quality %>% 
#     html_node("div div #phcontent_0_divC2CCB") %>%
#     html_text() %>%
#     as.numeric()
# 
# day3 <- air_quality %>% 
#     html_node("div div #phcontent_0_divC3CCB") %>%
#     html_text() 
# 
# 
# day4 <- air_quality %>% 
#     html_node("div div #phcontent_0_divC4CCB") %>%
#     html_text()
# 
# day5 <- air_quality %>% 
#     html_node("div div #phcontent_0_divC5CCB") %>%
#     html_text() 

#combine the days values 
#cbind(day1, day2, day3, day4, day5)

#test grabbing just days
days <- html_node(air_quality, "div div .fcast-5days")
html_text(days)
#####

#Attempt to get whole thing
box <- html_nodes(air_quality,"div div .f5day")
content <- html_text(box)
#fulltext <-paste(content, collapse=" ")
fulltest <- gsub("\n"," ",content)
fulltext1 <- gsub("\n"," ",fulltext)
fulltext2 <- gsub("\r"," ", fulltext1)
fulltext3 <- gsub("\t"," ", fulltext2)

#testing <- gsub("\t"|"\n"|"\t"," ", fulltext2)

mytext <- unlist(strsplit(fulltext3," "))
wholething <- mytext[mytext != ""]
wholedays <- wholething[1:5]
wholedata <- wholething[6:69]
baydata <- wholedata[13:26]  
df <- data.frame(rbind(baydata[5:9], baydata[10:14]), row.names=c("AQI","PMI"))
names(df) <- wholedays  
htmlTable(df)

#firedanger forecast (7days)
fire <- read_html("http://www.myforecast.com/bin/firedanger.m?city=12064&zip_code=94611&metric=false")

firehtml <- html_nodes(fire, "tr:nth-child(11) .normal .normal:nth-child(3)")
firedayshtml <- html_nodes(fire, "tr:nth-child(11) tr+ tr td:nth-child(1)")
firedays <- html_text(firedayshtml)
fireforecast <- html_text(firehtml)


final_fire_forecast <- data.frame(fireforecast, row.names = firedays, stringsAsFactors = F)
htmlTable(final_fire_forecast)
