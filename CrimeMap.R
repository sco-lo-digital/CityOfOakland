library(ggmap)
#Read in file
Crime_Map <- read.csv("~/Downloads/90-Day_Crime_Map.csv", stringsAsFactors=FALSE) #your path
#Crime_Map <- read.csv(url("http://some.where.net/data/foo.csv"))
#Create character vector of addresses split from the coords
Temp <-unlist(strsplit(Crime_Map$Location, ", CA"))
#Keep only the address elements of the list and them to column Addys
Crime_Map$Addys <- Temp[c(TRUE, FALSE)]
#Keep only the coords elements of the list and add them to column coords
Crime_Map$coords <- Temp[c(FALSE, TRUE)]
#Remove rows with no long or lat, store in new dataframe
Crime_Map_Subsetted <- Crime_Map[!(Crime_Map$coords=="\n"), ]
#Remove coords from parentheses
Crime_Map_Subsetted$coords2 <- gsub("[\\(\\)]", "", regmatches(Crime_Map_Subsetted$coords, gregexpr("\\(.*?\\)", Crime_Map_Subsetted$coords)))
#Transform coordinates to dataframe
longlat <- Crime_Map_Subsetted$coords2 %>% strsplit(",") %>% unlist() %>% as.numeric() %>% matrix(ncol = 2, byrow = T) %>% data.frame()
#rename columns
names(longlat) <- c("Lat","Long")
#Add coords back to subsetted data
Crime_Map_Subsetted <- cbind(Crime_Map_Subsetted, longlat)

smaller <- Crime_Map_Subsetted[1:100,]
###################### GGMAP
oak_map <- get_map(location = "oakland, ca", maptype = "roadmap", zoom = 12)
ggmap(oak_map, extent = "normal") + geom_point(aes(x = Long, y = Lat), colour = "red", 
                                                 alpha = 0.4, size = 2, data = smaller)
