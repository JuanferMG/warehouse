library(rvest)
library(maps)
library(ggplot2)

url<-"https://worldpopulationreview.com/world-cities"
texto<-read_html(url)
texto<-html_nodes(texto,"table")
ciudades<-html_table(texto[[1]], fill = T)

ciudades$Name[ciudades$Name=="Mumbai"]<-"Bombay"
ciudades$Name[ciudades$Name=="Kolkata"]<-"Calcutta"
ciudades$Country[ciudades$Country=="Dr Congo"]<-"Congo Democratic Republic"

data(world.cities)

world.cities$name<-tolower(world.cities$name)
ciudades$Name<-tolower(ciudades$Name)

top=1:20; visit.x<-c(); visit.y<-c();
for(i in top){
  visit.x<-c(visit.x, world.cities$long[world.cities$name==ciudades$Name[i] & world.cities$country.etc==ciudades$Country[i]])
  visit.y<-c(visit.y, world.cities$lat[world.cities$name==ciudades$Name[i] & world.cities$country.etc==ciudades$Country[i]])
}


mapamundi <- borders("world", colour="gray50", fill="gray50") 
mp <- ggplot() + mapamundi + geom_point(aes(x=visit.x, y=visit.y) ,color="blue", size=3) + 
  labs(title="Las 20 ciudades m\u00E1s pobladas del mundo", 
       y="Latitud", 
       x="Longitud", 
       caption="Elaboraci\u00F3n propia mediante Web Scraping de worldpopulationreview.com considerando la poblaci\u00F3n de 2020.")+
  theme(plot.title = element_text(size=16,hjust = 0.5,face="bold"),
        plot.caption = element_text(color = "black",face = "italic", size = 6, hjust=1)) 
mp
ggsave(filename = paste0("Mapa Top Ciudades.png"), mp,
       width = 9, height = 5, dpi = 300, units = "in", device='png')
