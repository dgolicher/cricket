i<-1
url<-paste("http://stats.espncricinfo.com/ci/engine/stats/index.html?class=11;page=",i,";template=results;type=team;view=innings",sep="")

tables <-readHTMLTable(url, stringsAsFactors = F)
t <- tables$"Innings by innings list"

for (i in 2:350)
{
  
  url<-paste("http://stats.espncricinfo.com/ci/engine/stats/index.html?class=11;page=",i,";template=results;type=team;view=innings",sep="")
  
  tables <-readHTMLTable(url, stringsAsFactors = F)
  tt <- tables$"Innings by innings list"
  t<-rbind(t,tt)
}

t$Total<-as.numeric(unlist(sub("\\/.*", "", t$Score)) )
t$Date<-as.Date(t$"Start Date",format="%d %b %Y") ## Set up the date format
t$Year<-year(t$Date)
t$Day<-day(t$Date)
t$Month<-month(t$Date)
t$Yday<-yday(t$Date)
t$RPO<-as.numeric(as.character(t$RPO))
t$type<-t$Opposition
t$type<-sub(" v.*", "", t$type)
t$Opposition<- sub(".*v", "v", t$Opposition)
d<-t


write.csv(d,"all-match_innings.csv")
