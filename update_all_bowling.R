## See notes on updating batting

library(XML)

i<-1
i
yr<-2017
url<-paste("http://stats.espncricinfo.com/ci/engine/stats/index.html?class=11;page=",i,";spanmax2=31+Dec+",yr,";spanmin2=1+Jan+",yr,";spanval2=span;template=results;type=bowling;view=innings",sep="")
url
#

system.time(tables <-readHTMLTable(url, stringsAsFactors = F))
t <- tables$"Innings by innings list"

for (i in 2:220)
{
  
  url<-paste("http://stats.espncricinfo.com/ci/engine/stats/index.html?class=11;page=",i,";spanmax2=31+Dec+",yr,";spanmin2=1+Jan+",yr,";spanval2=span;template=results;type=bowling;view=innings",sep="")
  
  try(tables <-readHTMLTable(url, stringsAsFactors = F))
  try(tt <- tables$"Innings by innings list")
  try(t<-rbind(t,tt))
}


d<-t

library(lubridate)
library(ggplot2)
library(dplyr)


d$Player<-as.character(d$Player) ## Can leave the team name in
d$Country<- unlist(sub("\\).*", "", sub(".*\\(", "", d$Player)) ) ## Extract the country from the player's name
d$Date<-as.Date(d$"Start Date",format="%d %b %Y") ## Set up the date format
d$Year<-year(d$Date)
d$Day<-day(d$Date)
d$Month<-month(d$Date)
d$Yday<-yday(d$Date)
d$Overs<-as.numeric(as.character(d$Overs))
d$BPO<-6 ## A potential problem here, as all modern games have 6, so column missing
d$Mdns<-as.numeric(as.character(d$"Mdns"))
d$Runs<-as.numeric(as.character(d$"Runs"))
d$type<-d$Opposition
d$type<-sub(" v.*", "", d$type)
d$Opposition<- sub(".*v", "v", d$Opposition)

## The problem with the BPO column needs fixing as they don't match
write.csv(d,"all-bowling-2017.csv")
d1<-read.csv("all-bowling.csv")
d1<-d1[,-which(names(d1)=="BPO")] ## Remove the whole column
d1<-subset(d1,d1$Year<yr)
d2<-read.csv("all-bowling-2017.csv")
d2<-d2[,-which(names(d2)=="BPO")]
d<-rbind(d1,d2)

