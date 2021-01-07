library(rvest)

datos<-c()

for(anyo in 2004:2020){
  
  url<-paste0("https://www.euromillones.com.es/",
              "historico/resultados-euromillones-",
              anyo,".html")
  
  texto<-read_html(url)
  texto<-html_nodes(texto,"table")
  sorteo<-html_table(texto[[1]], fill = T)
  n<-min(which(sorteo[2,]=="N\u00DAMEROS"))
  numeros<-as.matrix(sorteo[3:nrow(sorteo),c(n:(n+6))])
  # 5 numeros y 2 estrellas
  colnames(numeros)<-c(paste0("N",1:5),"E1", "E2")
  rownames(numeros)<-NULL
  datos<-rbind(datos,numeros)
  
}

datos<-as.data.frame(datos)
datos[] <- lapply(datos, function(x) as.numeric(as.character(x)))
datos<-datos[complete.cases(datos),]
