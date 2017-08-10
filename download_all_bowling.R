library(XML)

i<-1
url<-paste("http://stats.espncricinfo.com/ci/engine/stats/index.html?class=11;page=",i,";template=results;type=bowling;view=innings",sep="")
#

system.time(tables <-readHTMLTable(url, stringsAsFactors = F))
t <- tables$"Innings by innings list"

for (i in 2:3808)
{
  
  url<-paste("http://stats.espncricinfo.com/ci/engine/stats/index.html?class=11;page=",i,";template=results;type=bowling;view=innings",sep="")
  
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
d$BPO<-as.numeric(as.character(d$BPO))
d$Mdns<-as.numeric(as.character(d$"Mdns"))
d$Runs<-as.numeric(as.character(d$"Runs"))
d$type<-d$Opposition
d$type<-sub(" v.*", "", d$type)
d$Opposition<- sub(".*v", "v", d$Opposition)

write.csv(d,"all-bowling.csv")
