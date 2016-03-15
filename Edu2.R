##Installed libraries
library(ggplot2)
library(plotly)
library(magrittr)
library(ggthemes)
library(googleVis)
##Imported and reading all data
data1112 <- read.delim("~/Data_Science/Oakland/11-12 Suspension Rate.txt", stringsAsFactors=FALSE)
data1213 <- read.delim("~/Data_Science/Oakland/12-13 Suspension Rate.txt", stringsAsFactors=FALSE)
data1314 <- read.delim("~/Data_Science/Oakland/13-14 Suspension Rate.txt", stringsAsFactors=FALSE)
data1415 <- read.delim("~/Data_Science/Oakland/14-15 Suspension Rate.txt", stringsAsFactors=FALSE)
## Removed Truancy from 11-12 report
fdata1112 <- data1112[,c(1:8,11)]
head(fdata1112)
## Combined all data into one document
alldata <- rbind(fdata1112,data1213,data1314,data1415)
## Cleaning out NAs and state data
alldata <- alldata[c(1:23,28:50,55:76,81:102),]
#alldata$District <- as.factor(alldata$District)
alldata$Year <- as.factor(alldata$Year)
alldata$Suspension.Rate <- as.numeric(alldata$Suspension.Rate)
##Plotting Boxplot for review
#boxplot <- plot_ly(alldata, x=alldata$Suspension.Rate, type = "box")
#boxplot
#toString(alldata$Year)
#Test to annotate data
#plot_ly(alldata, x =alldata$District, y =alldata$Suspension.Rate, text = rownames(alldata$Suspension.Rate) mode = "markers+text", textfont = t, textpoition = "top middle")
subsetdata <- dplyr::filter(alldata, District == "Oakland Unified"| District == "Alameda Unified"|District == "Berkeley Unified")
#Plotting Data
#plot_ly(subsetdata, x =alldata$District, y =alldata$Suspension.Rate, mode = "markers+text") %>%
#layout(title = "Suspension Rates By School Disctrict", xlab="Suspension Rates", ylab="District")
suspension_plot <- ggplot(subsetdata, aes(x = District, y = Suspension.Rate, fill = Year)) + geom_bar(stat="identity") + ggtitle("Suspension Rate by District") + ylab("Suspension Rate") + scale_fill_economist()+ theme_economist()

enrollment_plot <- ggplot(subsetdata, aes(x = District, y = as.numeric(Cumulative.Enrollment), fill = Year)) + geom_bar(stat="identity") + ggtitle("Enrollment by District") + ylab("Enrollment ") + scale_fill_economist()+ theme_economist()

suspensiondf <- dplyr::select(subsetdata, District, Suspension.Rate, Year)
suspensiondf$Year <- as.character(suspensiondf$Year)
sus13 <- dplyr::filter(suspensiondf, Year == "2013-14")
sus13 <- dplyr::select(sus13, -Year)
names(sus13) <- c("District", "2013-14")
sus14 <- dplyr::filter(suspensiondf, Year == "2014-15")
sus14 <- dplyr::select(sus14, -Year)
names(sus14) <- c("District", "2014-15")
susdf <- dplyr::left_join(sus13, sus14, by = "District")
suspension_bar <- gvisBarChart(susdf, xvar = "District", options=list(isStacked =FALSE, title="Suspension Rate",width=200, height=200))
enrolldf <- dplyr::select(subsetdata, District, Cumulative.Enrollment, Year)
enr13 <- dplyr::filter(enrolldf, Year == "2013-14")
enr13 <- dplyr::select(enr13, -Year)
names(enr13) <- c("District", "2013-14")
enr14 <- dplyr::filter(enrolldf, Year == "2014-15")
enr14 <- dplyr::select(enr14, -Year)
names(enr14) <- c("District", "2014-15")
enrdf <- dplyr::left_join(enr13, enr14, by = "District")
enrdf$`2013-14` <- as.numeric(enrdf$`2013-14`)
enrdf$`2014-15` <- as.numeric(enrdf$`2014-15`)


enr_plot <- gvisBarChart(enrdf, options = list(title="Cumulative Enrollment\n by District\n '13-'14 & '14-'15", legend = "none"))
plot(enr_plot)
suspension_bar <- gvisBarChart(susdf, xvar = "District", options=list(isStacked =FALSE, title="Suspension Rate\n by District\n '13-'14 vs. '14-'15", legend = "none"))
plot(suspension_bar)
save.image("~/Data_Science/Oakland/Education.RData")
