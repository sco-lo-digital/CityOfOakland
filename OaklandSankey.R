

#########

library(pacman)
p_load(RSocrata, networkD3, magrittr)
#Budget
budget <- read.socrata("https://data.oaklandnet.com/resource/w4j2-chmt.csv")    
    #Make 15-16 Budget
    newbudget <- budget %>% dplyr::filter(Fiscal.Year == "FY15-16") %>% dplyr::select( Expense.or.Revenue, Department, Fund, Account.Type, Value)
    newbudget$Department <- as.character(newbudget$Department)
    newbudget$Account.Type <- as.character(newbudget$Account.Type)
#Make General Fund
generalfund <- newbudget %>% dplyr::filter(Fund == 1010)

#Make General Fund Expenses
gf_expenses <- dplyr::filter(generalfund, Expense.or.Revenue == "Expense") 
gf_expenses <-aggregate(gf_expenses$Value, by=list(Department = gf_expenses$Department), FUN=sum)
#Make source 38, since its General Fund
gf_expenses$source <- rep(38, nrow(gf_expenses))
gf_expenses$target <- rep(100,nrow(gf_expenses))
names(gf_expenses) <- c("name", "value", "source", "target")


#Make General Fun Revenues
gf_revenues <- dplyr::filter(generalfund,Expense.or.Revenue=="Revenue")
gf_revenues  <- aggregate(gf_revenues$Value, by=list(Account=gf_revenues$Account.Type), FUN=sum)
gf_revenues$source <- rep(101, nrow(gf_revenues))
gf_revenues$target <- rep(38, nrow(gf_revenues))
names(gf_revenues) <- c("name", "value", "source", "target")

#Make Non-Discretionary Fund 
nondiscretionaryfund <- dplyr::filter(newbudget, Fund != 1010)

#Make ndf expenses
ndf_expenses <- dplyr::filter(nondiscretionaryfund, Expense.or.Revenue == "Expense") 
ndf_expenses <- aggregate(ndf_expenses$Value, by=list(Department = ndf_expenses$Department), FUN=sum)
#Source = 39, since ndf
ndf_expenses$source <- rep(39, nrow(ndf_expenses))
ndf_expenses$target <- rep(102, nrow(ndf_expenses))
names(ndf_expenses) <- c("name", "value", "source", "target")

#Make ndf revenues
ndf_revenues <- dplyr::filter(nondiscretionaryfund ,Expense.or.Revenue =="Revenue")
ndf_revenues  <- aggregate(ndf_revenues $Value, by = list(Account = ndf_revenues $Account.Type), FUN=sum)
ndf_revenues$source <- rep(103, nrow(ndf_revenues))
ndf_revenues$target <- rep(39, nrow(ndf_revenues))
names(ndf_revenues) <- c("name", "value", "source", "target")

#Combine each of the four parts into one data frame
df <- data.frame(rbind(gf_expenses, gf_revenues, ndf_expenses, ndf_revenues))
#Create Lookup Table for ids
lookUp <- data.frame(name = as.character(unique(df$name)), id = 0:37, stringsAsFactors = F)
#Add General Fund and Non-Discretionary to list of names
lookUp <- rbind(lookUp, data.frame(name = c("General Fund", "Non-Discretionary"), id =c(38,39), stringsAsFactors = F))
#Create new data frame
newdf <- dplyr::left_join(df, lookUp, by="name")


#re-write source
for (i in seq(along = newdf$source)) {
    
    if(newdf$source[i] <= 39) {
        newdf$source[i] <- newdf$source[i]
    } else {
        newdf$source[i] <- newdf$id[i]
    }
    
}

#re-write target
for (i in seq(along = newdf$target)) {
    
    if(newdf$target[i] <= 39) {
        newdf$target[i] <- newdf$target[i]
    } else {
        newdf$target[i] <- newdf$id[i]
    }
    
}
#### Data wrangling end

### Format data for Sankey
nodes <- data.frame(name = c(unique(newdf$name),"General Fund", "Non-Discretionary"), stringsAsFactors = F)
links <- data.frame(source = newdf$source, target = newdf$target, value = newdf$value/1000000, stringsAsFactors = F)
sankeyDF <- list(nodes = nodes, links = links)
#Publish Sankey
sankeyPlot <- sankeyNetwork(Links = sankeyDF$links, Nodes = sankeyDF$nodes, Source = "source",
              Target = "target", Value = "value", NodeID = "name", units = "$M", colourScale = JS("d3.scale.category20c()"),
              fontSize = 12, nodeWidth = 30)
save.image("~/Data_Science/Oakland/OaklandSankey.RData")
