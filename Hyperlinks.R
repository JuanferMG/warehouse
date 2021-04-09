# Cargamos las librerias necesarias
if(!require(rvest)){install.packages("rvest")}; library(rvest)
if(!require(rgdal)){install.packages("rgdal")};library(rgdal)

# Definimos las variables
paises<-c("Germany", "Austria", "Belgium", "Bulgaria", "Czech_Republic", "Cyprus", "Croatia", "Denmark", "Slovakia",
          "Slovenia", "Spain", "Estonia", "Finland", "France", "Greece", "Hungary", "Ireland", "Italy",
          "Latvia", "Lithuania", "Luxembourg", "Malta", "Netherlands", "Poland", "Portugal", "Romania", "Sweden")
ISO3<-c("DEU", "AUT", "BEL", "BGR", "CZE", "CYP", "HRV", "DNK", "SVK", 
        "SVN", "ESP", "EST", "FIN", "FRA", "GRC", "HUN", "IRL", "ITA",
        "LVA", "LTU", "LUX", "MLT", "NLD", "POL", "PRT", "ROU", "SWE")
articulos<-c()

# Realizamos Web Scraping
url_base<-"https://en.wikipedia.org"
for(p in paises){
  page <- read_html(paste0(url_base,"/wiki/",p))
  links <- page %>% html_nodes("a") %>% html_attr("href") 
  links <- links[grepl("wiki",links)]
  articulos<-c(articulos,length(links))
}
datos<-data.frame(paises,ISO3,articulos)

# Obtenemos un objeto espacial con los paises del mundo
download.file("http://thematicmapping.org/downloads/TM_WORLD_BORDERS_SIMPL-0.3.zip" , destfile="MAPAMUNDI.zip")
unzip("MAPAMUNDI.zip")
mapamundi <- readOGR( 
  dsn= paste0(getwd()) , 
  layer="TM_WORLD_BORDERS_SIMPL-0.3",
  verbose=FALSE
)

# Filtramos los paises de la UE
europaUE <- mapamundi[mapamundi@data$ISO3%in%ISO3, ]

# Guardamos el mapa
png("UE.png", width = 20, height = 20, units = 'in', res = 300)
plot(europaUE, col="#FFCC00") 
title(main ="\u00BFQu\u00E9 pa\u00EDs de la UE es m\u00E1s importante en Wikipedia\u003F", cex.main=4, col.main= "#003399", 
      sub="\u00A9 2021 Juanfer Morala. Nota: N\u00FAmero de hiperv\u00EDnculos internos en la entrada principal de cada pa\u00EDs. Fuente: en.wikipedia.org", cex.sub=2, col.sub="#003399")
text(x = europaUE@data$LON, y = europaUE@data$LAT, labels = format(datos$articulos[match(europaUE$ISO3,datos$ISO3)], big.mark = ".", decimal.mark = ","),  cex=2, font=4, col="#003399")
dev.off()