##################################################
## Project: Interference-classifier
## Script purpose: Scientific reproducibility
## Date: 01-14-2021
## Author: Vinícius Meyer
##################################################


#clean memory information (start fresh)
rm(list=ls())

#load/install R packages
requiredPackages = c('stats','e1071','ggplot2','reshape2','gtable','scales','lattice','stringr','caret','ipred','dplyr')
for(p in requiredPackages){
  if(!require(p,character.only = TRUE)) install.packages(p)
  library(p,character.only = TRUE)
}


#load R files from project
if(.Platform$OS.type == "unix") {

  print("OS - Linux")
  folder_source <- "./training_dataset/"
  source("./input_dataset.R")
  total <- input_dataset(folder_source)
  source("./kmeans.R")
  source("./SVM.R")
  
  #load all traces from experiments
  linkbench_inc <- "./source/linkbench/inc.csv"
  linkbench_dec <- "./source/linkbench/dec.csv"
  linkbench_osc <- "./source/linkbench/osc.csv"
  linkbench_con <- "./source/linkbench/con.csv"
  tpch_inc <- "./source/tpch/inc.csv"
  tpch_osc <- "./source/tpch/osc.csv"
  tpch_dec <- "./source/tpch/dec.csv"
  tpch_con <- "./source/tpch/con.csv"
  bench4q_inc <- "./source/bench4q/inc.csv"
  bench4q_osc <- "./source/bench4q/osc.csv"
  bench4q_con <- "./source/bench4q/con.csv"
  bench4q_dec <- "./source/bench4q/dec.csv"
  result <- "./result.pdf"
  
}else {
  print("OS - Windows")
  folder_source <- paste(getwd(),"/training_dataset/", sep="")
  source(paste(getwd(),"/input_dataset.R",sep=""))
  total <- input_dataset(folder_source)
  source(paste(getwd(),"/kmeans.R",sep=""))
  source(paste(getwd(),"/SVM.R",sep=""))

  #load all traces from experiments
  linkbench_inc <- paste(getwd(),"/source/linkbench/inc.csv",sep="")
  linkbench_dec <- paste(getwd(),"/source/linkbench/dec.csv",sep="")
  linkbench_osc <- paste(getwd(),"/source/linkbench/osc.csv",sep="")
  linkbench_con <- paste(getwd(),"/source/linkbench/con.csv",sep="")
  tpch_inc <- paste(getwd(),"/source/tpch/inc.csv",sep="")
  tpch_osc <- paste(getwd(),"/source/tpch/osc.csv",sep="")
  tpch_dec <- paste(getwd(),"/source/tpch/dec.csv",sep="")
  tpch_con <- paste(getwd(),"/source/tpch/con.csv",sep="")
  bench4q_inc <- paste(getwd(),"/source/bench4q/inc.csv",sep="")
  bench4q_osc <- paste(getwd(),"/source/bench4q/osc.csv",sep="")
  bench4q_con <- paste(getwd(),"/source/bench4q/con.csv",sep="")
  bench4q_dec <- paste(getwd(),"/source/bench4q/dec.csv",sep="")
  result <- paste(getwd(),"/result.pdf",sep="")
}


app_tittle <- bench4q_inc  
period <- 25  #% of sample
method<- "L" # "C"(class) or "P"(percent) or "L" (level) -> here we used only Level (L)


#importing app
df_app <- read.csv2(app_tittle, sep=";")
app<-data.frame(df_app[,1],df_app[,2],df_app[,3],df_app[,4],df_app[,5],df_app[,6],df_app[,7],"")
app<-setNames(app,c("netp","nets","blk","mbw","llcmr","llcocc","cpu","category"))

time_app<- seq(1,nrow(df_app))
app_g<-data.frame(time_app,df_app[,1],df_app[,2],df_app[,3],df_app[,4],df_app[,5],df_app[,6],df_app[,7],"")
app_g<-setNames(app_g,c("time","netp","nets","blk","mbw","llcmr","llcocc","cpu","category"))

#set interval in %
inter <-max(time_app)*1.01*(period/100)
if(inter-as.integer(inter)>=0.5){
  interval<-as.integer(inter)
}else{
  interval<-as.integer(inter+1)
}


#choose SVM methods
if(method=="C"){
  classifier <- as.data.frame(svm_classifier_class(app,interval))
}else if(method=="P"){
  classifier <-  svm_classifier_percent(app,interval)
}else if(method=="L"){
  classifier <-  svm_classifier_level(app,interval)
}
  

#print result classification (width and height need to be resized depending on the data quantity)
pdf(result, width=5.5, height=2.75)

# plot configuration
p <- ggplot(app_g, aes(x=time)) 
#lines
p <- p+  geom_line(aes(y=netp,color="netp")) 
p <- p+  geom_line(aes(y=nets,color="nets")) 
p <- p+  geom_line(aes(y=blk,color="blk")) 
p <- p+  geom_line(aes(y=mbw,color="mbw"))
p <- p+  geom_line(aes(y=llcmr,color="llcmr")) 
p <- p+  geom_line(aes(y=llcocc,color="llcocc"))
p <- p+  geom_line(aes(y=cpu,color="cpu")) 
#color
p <- p+  scale_color_manual(values = c(
    'netp' = 'darkblue',  
    'nets' = 'red',
    'blk' = 'green',
    'mbw' = 'blue',
    'llcmr' = 'darkgray',
    'llcocc' = 'orange',
    'cpu' = 'black')) 
#labels
p <- p+  labs(color = 'Resources', x="Time (seconds)", y="Interference (%)") 
#general configuration
p <- p+  theme_bw()  
p <- p+  scale_x_continuous(breaks= seq(0, max(app_g$time), by = 100))
p <- p+  theme(text=element_text(family="Times")) 
p <- p+  theme(legend.position = "right")
p <- p+  guides(colour = guide_legend(nrow = 7))

pos.x <- vector()
pos.y <- vector()
titles <- vector()
pos.x2 <- vector()
titles2 <- vector()

#plot Class
if(method=="C"){


    for(i in 1:nrow(classifier)){
    p <- p + geom_vline(xintercept = classifier[i-1,1], color="black",linetype = "longdash")
    
    pos.x <- c(pos.x, ((i-1)*interval)+(interval/2))
    pos.y <- c(pos.y, -7)
    titles <- c(titles, as.character(classifier[i,2]))
    #print(paste(titles," - ", classifier[i,2]))
    #print(paste(i," X:",((i-1)*interval)+(interval/2)," Y:",-7," - ", paste(" ",classifier_class[i,2])))
  }
  p <- p + annotate("text", x = pos.x, y = pos.y, label = titles,size=3)
  lim_inf<- -10

#plot Percent or Level  
}else if(method=="P" || method=="L" ){
  
  control<-0
  yy<- 0
  #p <- p + geom_vline(xintercept = 0, color="black",linetype = "longdash")
  for(i in 1:nrow(classifier)){
   

    if(control==classifier[i,1]){
     
        
    
      #print((control)*interval)
      pos.x <- c(pos.x, (control*interval+(interval/2.7)))
      pos.x2 <- c(pos.x2, (control*interval+(2*interval/2.7)))
      #print(yy-7)
      pos.y <- c(pos.y, yy-7)
      #print(paste("X: ", (control)*interval, " Y:", yy-7))
      yy<- yy -7
      titles <- c(titles, as.character(classifier[i,2]))
      titles2 <- c(titles2, as.character(classifier[i,3]))
      #print(classifier[i,2])
      if(control!=classifier[i+1,1] && !is.na(classifier[i+1,1])){
        
        #print(classifier[i+1,1])
        p <- p + geom_vline(xintercept = (control+1)*interval, color="black",linetype = "longdash")
        control<- control+1
        yy<- 0
      }
    }
  }
  p <- p + annotate("text", x = pos.x, y = pos.y, label = titles ,size=3)
  p <- p + annotate("text", x = pos.x2, y = pos.y, label = titles2 ,size=3)
  
  lim_inf<- min(pos.y)
}
p <- p+  scale_y_continuous(limits=c(lim_inf, 100))

#final plot
p 

dev.off()
