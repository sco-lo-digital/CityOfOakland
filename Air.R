library(formattable, quietly = T)
library(rvest, quietly = T)
#Scott Jacobs
#Plot5.R


#Part 1: Air pollution forecast from sparetheair.org
#read the page
#0-50 Good Green
#51-100 Moderate Yellow
#101-150 Unhealthy for Sensitive Groups Orange
#151-200 Unhealthy  Red
#201-300 Very Unhealthy Purple --> Also red for simplicity
air_quality <- read_html("http://sparetheair.org/stay-informed/todays-air-quality/five-day-forecast")
#Scrape table
box <- html_nodes(air_quality,"div div .f5day")
content <- html_text(box)
#Text cleaning, removing artifacts
fulltext <- gsub("\n"," ",content)
fulltext1 <- gsub("\n"," ",fulltext)
fulltext2 <- gsub("\r"," ", fulltext1)
fulltext3 <- gsub("\t"," ", fulltext2)
#split the string into a character vector of strings
mytext <- unlist(strsplit(fulltext3," "))
#Leave empty spaces out, 
wholething <- mytext[mytext != ""]
#vector of days
Days <- wholething[1:5]
#character data for table construction
wholedata <- wholething[6:69]
#a subset of Oakland related data
baydata <- wholedata[13:26]  
#convert to data frame exactly as it is on website
mydf <- data.frame(rbind(baydata[5:9], baydata[10:14]), row.names=c("AQI","PMI"))
#transposed data frame (tidy data, observations in rows, variables in cols)
tmydf <- data.frame(cbind(Days, baydata[5:9], baydata[10:14]), row.names = NULL, stringsAsFactors = F)
#replace the names of the new df with the webscraped days of the week
names(tmydf) <- c("Day","AQI","PMI")
tmydf$PMI <- gsub("PM","",tmydf$PMI)
#Print to an html table the resulting dataframe
#eventually this will have some color coding or reactive element
#focus only on numeric variables
smaller <- tmydf[1:2,]
#Coerce to numeric
smaller$AQI <- as.numeric(smaller$AQI)
smaller$PMI <- as.numeric(smaller$PMI)
#Format ouput based on scale above
nicetable <- formattable(smaller, 
                         list( 
                             AQI = formatter("span", style = x ~ 
                                                 ifelse(x <= 50, style(display = "block",`border-radius` = "4px",
                                                                       padding = "0 4px",background = "green", 
                                                                       color = "white", font.weight = "bold"), 
                                                        ifelse(x <= 100, style(display = "block",`border-radius` = "4px",
                                                                               padding = "0 4px", background = "yellow", 
                                                                               color ="white", font.weight = "bold"), 
                                                               style(display = "block",`border-radius` = "4px",
                                                                     padding = "0 4px",background = "red", 
                                                                     color = "white", font.weight = "bold") ) ) ), 
                             PMI = formatter("span",style = x ~ 
                                                 ifelse(x == 2.5, style(display = "block",`border-radius` = "4px",
                                                                        padding = "0 4px",background = "red", 
                                                                        color = "white", font.weight = "bold"), 
                                                        style(display = "block",`border-radius` = "4px",
                                                              padding = "0 4px",background = "green", 
                                                              color = "white", font.weight = "bold") ) )
                         )
)

nicetable


save.image("~/Data_Science/Oakland/Air.RData")
