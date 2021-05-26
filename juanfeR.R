print("juanfeR(df,key) inserta subtotales en 'df' agrupando por 'key'")


juanfeR<-function(df,key){
  
  if(!require(janitor)){install.packages("janitor")}
  library(janitor)
  
  attr(df,"totals")<-NULL
  
  df<-as.data.frame(df[!is.na(df[,key]),])
  groups<-unique(df[,key])
  new_df<-c()
  
  for(g in groups){
    subset_df<-df[df[,key]==g,]
    if(nrow(subset_df)==1){
      new_df<-rbind(new_df,subset_df)
    }else{
      subtotal_row<-janitor::adorn_totals(dat = subset_df,where = "row")
      subtotal_row<-subtotal_row[nrow(subtotal_row),]
      new_df<-rbind(new_df,subtotal_row,subset_df)
    }
  }
  
  return(as.data.frame(new_df))
  
}
