if(!require(readxl)){install.packages("readxl")}; library(readxl)
if(!require(png)){install.packages("png")}; library(png)
if(!require(httr)){install.packages("httr")}; library(httr)
if(!require(ggplot2)){install.packages("ggplot2")}; library(ggplot2)
if(!require(gganimate)){install.packages("gganimate")}; library(gganimate)
if(!require(grid)){install.packages("grid")}; library(grid)

url_datos<-"http://www.reptile-database.org/data/reptile_checklist_2020_12.xlsx"
url_imagen<-"https://cdn.pixabay.com/photo/2016/07/03/15/32/lizard-1494944_1280.png"

GET(url_datos, write_disk(datos <- tempfile(fileext = ".xlsx")))
reptiles <- as.data.frame(read_excel(path = datos, sheet = 1))

GET(url_imagen, write_disk(imagen <- tempfile(fileext = ".png")))
img <- rasterGrob(readPNG(imagen), interpolate=TRUE)

x<-reptiles$Author
x<-gsub(pattern = "\\(", replacement = "", x = x)
x<-gsub(pattern = "\\)", replacement = "", x = x)
x<-substr(x,nchar(x)-3,nchar(x))
reptiles$anyo<-as.numeric(x)
t<-table(reptiles$anyo)

datos<-data.frame(Anyo=as.numeric(names(t)),Especies=as.numeric(t),Agregado=NA)
datos$Agregado[1]<-datos$Especies[1]
for(i in 2:nrow(datos)){datos$Agregado[i]<-datos$Agregado[i-1]+datos$Especies[i]}

g<-ggplot(datos,aes(Anyo, Agregado)) + geom_point(size=3,colour="forestgreen") + geom_line(size=2,colour="forestgreen") +
  annotation_custom(img, xmax = 1940) +
  labs(title=paste0("Cat\u00E1logo de Reptiles. ",min(datos$Anyo),"-",max(datos$Anyo)),
       x="",
       y="Especies descubiertas",
       caption="\u00A9 2021 Juanfer Morala. Fuente: reptile-database.org") + 
  geom_text(aes(x = min(Anyo), y = min(Agregado), label = as.factor(Anyo)) , hjust=-5, vjust = -0.2, alpha = 0.5,  col = "forestgreen", size = 20) +
  theme_minimal() +
  theme(plot.title = element_text(size=40,hjust = 0.5,face="bold", colour = "forestgreen"),
        axis.text=element_text(size=16),
        axis.title=element_text(size=18,face="bold",colour="forestgreen"),
        plot.caption = element_text(color = "black",face = "italic", size = 12, hjust=1)) +
  transition_reveal(Anyo)
  
animate(g, width = 900, height = 500)
anim_save("Cat\u00E1logo de Reptiles.gif")
