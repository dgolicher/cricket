library(XML)

i<-1
i
yr<-2017
url<-paste("http://stats.espncricinfo.com/ci/engine/stats/index.html?class=11;page=",i,";spanmax2=31+Dec+",yr,";spanmin2=1+Jan+",yr,";spanval2=span;template=results;type=batting;view=innings",sep="")
url
#

system.time(tables <-readHTMLTable(url, stringsAsFactors = F))
t <- tables$"Innings by innings list"

for (i in 2:220)
{
  
  url<-paste("http://stats.espncricinfo.com/ci/engine/stats/index.html?class=11;page=",i,";spanmax2=31+Dec+",yr,";spanmin2=1+Jan+",yr,";spanval2=span;template=results;type=batting;view=innings",sep="")
  
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
d$Notout<-gsub('[0-9]+', '', d$Runs) ## Set up a column for not out innings
d$Notout<-gsub("\\*","TRUE",d$Notout) ## Convert asterixs
d$Runs<-as.numeric(gsub("\\D+", "", d$Runs)) ## Now turn the runs as a numeric column
d$Date<-as.Date(d$"Start Date",format="%d %b %Y") ## Set up the date format
d$Year<-year(d$Date)
d$Day<-day(d$Date)
d$Month<-month(d$Date)
d$Yday<-yday(d$Date)
d$BF<-as.numeric(as.character(d$BF))
d$SR<-as.numeric(as.character(d$SR))
d$Fours<-as.numeric(as.character(d$"4s"))
d$Sixs<-as.numeric(as.character(d$"6s"))
d$type<-d$Opposition
d$type<-sub(" v.*", "", d$type)
d$Opposition<- sub(".*v", "v", d$Opposition)

write.csv(d,"all-innings.csv")