#  install.packages("ggplot2")
# install.packages("reshape2")
#  install.packages("gtable")
#  install.packages("scales")


library(ggplot2)
library(reshape2)
library(gtable)
library(scales)
#require(gridExtra)

##install.packages('clauswilke/ggtextures')


dframe <- read.csv2("~/interference/r/thesis_p2/graph3.csv", sep=",", header=T,dec=".")


pdf("~/interference/r/thesis_p2/graph3.pdf", width=4.5, height=2.8)


ggplot(dframe,aes(x=factor(as.character(host), levels=c("4", "6", "8","10","12","16","24"))))+
geom_bar(aes(y=cost,fill=w), stat="identity",position="dodge",width = .7)+
  #scale_fill_brewer('Speedup',palette=6)+
  scale_fill_manual(values = c("black", "grey"), 
                    name='',
                    breaks=c("a", "b"), 
                    labels=c("Ludwig et al.","Our Solution"))+
  
     
theme_bw() +
xlab("Number of Hosts") +
ylab("Cost") +
theme(text=element_text(family="Times"))+
theme(legend.position = "bottom") +
guides(fill = guide_legend(nrow = 1)) +
coord_cartesian(ylim = c(0, max(dframe$cost)))+

  
    facet_grid(.~x, scales = "free") 
   

dev.off()


