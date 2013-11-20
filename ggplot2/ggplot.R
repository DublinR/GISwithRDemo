library(maps)
library(ggplot2)
library(RColorBrewer)

#####################

states_map <- map_data("state")
ggplot(states_map, aes(x=long,y=lat,group=group)) + geom_polygon(fill="white",colour="black")
ggplot(states_map, aes(x=long,y=lat,group=group)) + geom_path + coord_map("mercator")

#####################

world_map <- map_data("world")
head(world_map)

#####################

east_asia <- map_data("world",region=c("Japan","China","North Korea","South Korea"))
ggplot(east_asia, aes(x=long,y=lat,group=group,fill=region)) + 
  geom_polygon(colours="black")+
  scale_fill_brewer(palette="Set2")

#Other Palettes : Accent,Paired, Set1

####################
IrlSet <- grep("Irel",world_map$region)
# IrlMap <- world_map[IrlSet,]
Ireland <- map_data("world",region=c("Ireland"))
ggplot(Ireland , aes(x=long,y=lat,group=group,fill=region)) + 
  geom_polygon(colours="black")+
  scale_fill_brewer(palette="Set2")
# Not Great !
###################

NWE <- map_data("world",region=c("Portugal","Ireland","Italy","Greece","Spain"))
ggplot(NWE , aes(x=long,y=lat,group=group,fill=region)) + 
  geom_polygon(colours="black")+
  scale_fill_brewer(palette="Set1")


NZ1 <- map_data("world",region="New Zealand")
NZ1 <- subset(NZ1, long>0 &lat> -48)  #trim off outlying islands
ggplot(NZ1,aes(x=long,y=lat,group=group)) + geom_path()

NZ2 <- map_data("nz")
ggplot(NZ2,aes(x=long,y=lat,group=group)) + geom_path()

###################

crimes <-data.frame(state =tolower(rownames(USArrests)),USArrests)
head(crimes)


library(maps)
states_map <- map_data("state")
crime_map <- merge(states_map,crimes,by.x="region",by.y="state")
head(crime_map)
install.packages("plyr")
library(plyr)
# Use this package for the arrange function().
crime_map <- arrange(crime_map,group,order)
head(crime_map)


###################
ggplot(crimes, aes(map_id=state,fill=Assault))+ 
  geom_polygon(colour="black")+
  expand_limits(x=states_map$long,y=states_map$lat) + 
  coord_map("polyconic")

###################
ggplot(crimes(aes(map_id=state,fill=Assault))+
   geom_map(map=state_map,colour="black") + 
   scale_fill_gradient2(low="#559999",mid="grey90",high="#BB650B",
                         midpoint=median(crimes$Assault)) +
   expand_limits(x=state_map$long,y=state_map$lat) +
   co_ordmap("polyconic")
###################       
ggplot(crimes(aes(map_id=state,fill=Assault))+
   geom_map(map=state_map,colour="black") + 
   expand_limits(x=state_map$long,y=state_map$lat) +
   co_ordmap("poyconic")
       
#Create a theme with many of the background elements removed.
theme_clean <-function(base_size=12){
require(grid)
    there_grey(base_size) %+replace%
          theme(
          axis.title =element_blank(),
          axis.text =element_blank(),
          panel.background =element_blank(),
          panel.grid =element_blank(),
          axis.tick.lengths=unit(0,"cm"),
          axis.tick.margins=unit(0,"cm"),
          panel.margins=unit(0,"cm"),
          plot.margin=unit(0,"cm"),
          complete=TRUE
        )
   }       
       
##############
ggplot(crimes(aes(map_id=state,fill=assault_q))+
    geom_map(map=state_map,colour="black") + 
    scale_fill_manual(values=pal)+
    expand_limits(x=state_map$long,y=state_map$lat) +
    co_ordmap("poyconic") + 
    labs(fill="Assault Rate \n Percentile" )+
    +theme_clean()
              
############
       