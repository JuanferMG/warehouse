if(!require("pdftools")){install.packages("pdftools")}
library(pdftools)

disenyo <- unlist(strsplit(pdf_text("https://sedeapl.dgt.gob.es/IEST_INTER/pdfs/disenoRegistro/vehiculos/matriculaciones/MATRICULACIONES_MATRABA.pdf"),split = "\r\n")) 
variables<-gsub("\\s+", " ",trimws(disenyo[grep(pattern = "CHAR\\(", x = disenyo)]))
nombres<-sapply(strsplit(x = variables, split = " "), "[[", 2)
longitud<-function(t){
  t<-t[grep(pattern = "CHAR\\(", x = t)]
  t<-gsub(pattern = "\\)", replacement = "",x = t)
  t<-gsub(pattern = "CHAR\\(", replacement = "", x = t)
  t<-as.numeric(t)
  return(t)
}
posiciones<-unlist(lapply(X = strsplit(x = variables, split = " "), FUN =longitud))
formato<-data.frame(variable=nombres,longitud=posiciones)
View(formato)
