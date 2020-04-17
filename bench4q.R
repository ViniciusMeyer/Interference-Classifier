#install.packages('ggplot2')
#install.packages('reshape2')
#install.packages('gtable')
#install.packages('scales')
#install.packages("e1071")
#install.packages("tidyverse")
#install.packages("dplyr")
#install.packages("caret")
#install.packages("InformationValue")
#install.packages("randomForest")
#install.packages("MASS")
#install.packages("neuralnet")
#install.packages("nnet")
#install.packages("ranger")
#install.packages("ipred")
#install.packages("TH.data")
#install.packages("rpart")
#install.packages("stringr") 
%install.packages("gridExtra")




rm(list=ls())



library("e1071")
library(ggplot2)
library(reshape2)
library(gtable)
library(scales)
library(lattice)
library("stringr") 
require(gridExtra)

bench4q_inc_new <- "~/interference/r/bench4q/MYSQL/inc/source/inc_new.csv"

app_tittle <-bench4q_inc_new


#importing app
df_app <- read.csv2(app_tittle, sep=";")
app<-data.frame(df_app[,1],df_app[,2],df_app[,3],df_app[,4],df_app[,5],df_app[,6],df_app[,7],"")
app<-setNames(app,c("netp","nets","blk","mbw","llcmr","llcocc","cpu","category"))

time_app<- seq(1,nrow(df_app))
app_g<-data.frame(time_app,df_app[,1],df_app[,2],df_app[,3],df_app[,4],df_app[,5],df_app[,6],df_app[,7],"")
app_g<-setNames(app_g,c("time","netp","nets","blk","mbw","llcmr","llcocc","cpu","category"))



pdf("~/interference/r/PDP2020/bench4q1.pdf", width=10, height=2.5)

cp <- ggplot(app_g, aes(x=time)) 
cp <- cp+  geom_line(aes(y=cpu,linetype="cpu"), color="black") 
cp <- cp+  labs(color = 'Resources', x="Time (seconds)\n (A)", y="CPU Interference (%)") 
cp <- cp+  theme_bw()
cp <- cp+  scale_x_continuous(breaks= seq(0, max(app_g$time), by = 175))
cp <- cp + theme(legend.direction = "horizontal", legend.position = "top") #legend.position=c(0.5, 0.90))
cp <- cp+  scale_y_continuous(limits=c(0, 100))
cp <-cp + scale_linetype_manual(name=element_blank(),values=c(cpu="solid"))
cp <- cp + theme(text=element_text(family="Times"))

#cp

me <- ggplot(app_g, aes(x=time)) 
me <- me+  geom_line(aes(y=mbw, linetype="mbw"), color="black") 
me <- me+  labs(color = 'Resources', x="Time (seconds)\n (B)", y="MBW Interference (%)") 
me <- me+  theme_bw()
me <- me + theme(legend.direction = "horizontal", legend.position = "top")#legend.position=c(0.5, 0.90))
me <- me+  scale_x_continuous(breaks= seq(0, max(app_g$time), by = 175))
me <- me+  scale_y_continuous(limits=c(0, 100))
me <-me + scale_linetype_manual(name=element_blank(),values=c(mbw="solid"))
me <- me + theme(text=element_text(family="Times"))

#me

di <- ggplot(app_g, aes(x=time)) 
di <- di+  geom_line(aes(y=blk, linetype="blk"), color="black") 
di <- di+  labs(color = 'Resources', x="Time (seconds)\n (D)", y="Disk Interference (%)") 
di <- di+  theme_bw()
di <- di + theme(legend.direction = "horizontal", legend.position = "top")#legend.position=c(0.5, 0.90))
di <- di+  scale_x_continuous(breaks= seq(0, max(app_g$time), by = 175))
di <- di+  scale_y_continuous(limits=c(0, 100))
di <-di + scale_linetype_manual(name=element_blank(),values=c(blk="solid"))
di <- di + theme(text=element_text(family="Times"))

#di


ne <- ggplot(app_g, aes(x=time)) 
ne <- ne+  geom_line(aes(y=netp, linetype="netp"))
ne <- ne+  geom_line(aes(y=nets, linetype="nets")) 
ne <- ne+  labs(color="",x="Time (seconds)\n (E)", y="Network Interference (%)") 
ne <- ne+  theme_bw()
ne <- ne+  scale_x_continuous(breaks= seq(0, max(app_g$time), by = 175))
ne <- ne+  scale_y_continuous(limits=c(0, 100))
ne <- ne + theme(legend.direction = "horizontal", legend.position = "top")#legend.position=c(0.5, 0.90))
#ne <-ne + theme(legend.position = c(0.8, 0.75))
ne <-ne + scale_linetype_manual(name=element_blank(),values=c(netp="dotted", nets="solid")) 
ne <- ne + theme(text=element_text(family="Times"))

#ne


ca <- ggplot(app_g, aes(x=time)) 
ca <- ca +  geom_line(aes(y=llcmr, linetype="llcmr"))
ca <- ca +  geom_line(aes(y=llcocc, linetype="llcocc")) 
ca <- ca +  labs(color="",x="Time (seconds)\n (C)", y="Cache Interference (%)") 
ca <- ca +  theme_bw()
ca <- ca +  scale_x_continuous(breaks= seq(0, max(app_g$time), by = 175))
ca <- ca +  scale_y_continuous(limits=c(0, 100))
#ca <- ca + theme(legend.position = c(1.0, 0.75))
ca <- ca + theme(legend.direction = "horizontal", legend.position = "top")#legend.position=c(0.5, 0.90))
ca <- ca + scale_linetype_manual(name=element_blank(),values=c(llcmr="dotted", llcocc="solid")) 
ca <- ca + theme(text=element_text(family="Times"))
#ca

  grid.arrange(cp, me,ca,di,ne, nrow=1)

dev.off()
