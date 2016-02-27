
library("httr")
library("jsonlite")

# start by getting the counties and their codes...
url <- "http://droughtmonitor.unl.edu/Ajax.aspx/ReturnAOI"
headers <- add_headers(
  "Accept" = "application/json, text/javascript, */*; q=0.01",
  "Accept-Encoding" = "gzip, deflate",
  "Accept-Language" = "en-US,en;q=0.8",
  "Content-Length" = "16",
  "Content-Type" = "application/json; charset=UTF-8",
  "Host" = "droughtmonitor.unl.edu",
  "Origin" = "http://droughtmonitor.unl.edu",
  "Proxy-Connection" = "keep-alive",
  "Referer" = "http://droughtmonitor.unl.edu/MapsAndData/DataTables.aspx",
  "User-Agent" = "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.116 Safari/537.36",
  "X-Requested-With" = "XMLHttpRequest"
)
a <- POST(url2, body="{'aoi':'county'}", headers2, encode="json")
tmp <- content(a)[[1]]
county_df <- data.frame(text=unname(unlist(sapply(tmp, "[", "Text"))),
                        value=unname(unlist(sapply(tmp, "[", "Value"))),
                        stringsAsFactors=FALSE)

# use the code for whatever county you want in the payload below...

url <- "http://droughtmonitor.unl.edu/Ajax.aspx/ReturnTabularDM"
payload <- "{'area':'06001', 'type':'county', 'statstype':'1'}"
headers <- add_headers(
  "Host" = "droughtmonitor.unl.edu",
  "Proxy-Connection" = "keep-alive",
  "Content-Length" = "50",
  "Accept" = "application/json, text/javascript, */*; q=0.01",
  "Origin" = "http://droughtmonitor.unl.edu",
  "X-Requested-With" = "XMLHttpRequest",
  "User-Agent" = "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.116 Safari/537.36",
  "Content-Type" = "application/json; charset=UTF-8",
  "Referer" = "http://droughtmonitor.unl.edu/MapsAndData/DataTables.aspx",
  "Accept-Encoding" = "gzip, deflate",
  "Accept-Language" = "en-US,en;q=0.8",
  "X-Requested-With" = "XMLHttpRequest"
)
a <- POST(url, body=payload, headers, encode="json")
tmp <- content(a)[[1]]
df <- data.frame(date=unname(unlist(sapply(tmp, "[", "Date"))),
                 d0=unname(unlist(sapply(tmp, "[", "D0"))),
                 d1=unname(unlist(sapply(tmp, "[", "D1"))),
                 d2=unname(unlist(sapply(tmp, "[", "D2"))),
                 d3=unname(unlist(sapply(tmp, "[", "D3"))),
                 d4=unname(unlist(sapply(tmp, "[", "D4"))),
                 stringsAsFactors=FALSE)

df$date <- as.Date(df$date)
smalldf <- df[1:16,]
#################
library(ggplot2)
plot <- ggplot(smalldf, aes(x=date, y=d4))+geom_area(aes(fill= factor(d4)))
plot
