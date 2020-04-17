#  install.packages("ggplot2")
 # install.packages("reshape2")
#  install.packages("gtable")
#  install.packages("scales")
  
  
  library(ggplot2)
  library(reshape2)
  library(gtable)
  library(scales)
  ##install.packages('clauswilke/ggtextures')
  
  
  dframe <- read.csv2("~/interference/r/PDP2020/graph.csv", sep=",", header=T,dec=",")
  
  pdf("~/interference/r/PDP2020/graph.pdf", width=4, height=2)
  ggplot(dframe,aes(x=host))+ 
    geom_bar(aes(y=cost,fill=w), stat="identity",position="dodge",width = 1.5)+
    
    scale_fill_manual(values = c("black", "grey"), 
                      name='',
                      breaks=c("a", "b"), 
                      labels=c("Related Work","Our Solution"))+
    
    theme_bw() + 
    xlab("Number of Hosts") +
    ylab("Cost") +
    theme(text=element_text(family="Times"))+
    theme(legend.position = "right") +
    guides(fill = guide_legend(nrow = 2)) +
    scale_x_continuous(breaks = seq(4, 12, by = 2))+
    coord_cartesian(ylim = c(0, max(dframe$cost)))
    
    #scale_y_continuous(trans = "log10")
    
    #facet_grid(arq~.) 
  
dev.off()
  






data <- read.csv(system.file("extdata", "monthlyexp.csv", package="patternplot"))
data<-data[which(data$Location=='City 1'),]
#Example 1
x<-factor(dframe$w, c('Housing', 'Food',  'Childcare'))
y<-data$Amount


##install.packages('patternplot')
#library(patternplot)
#x<-factor(dframe$host, c('4', '6',  '8',  '10',  '12'))
#y<-dframe$cost
#g<-dframe$w
#pattern.type<-c('hdashes', 'crosshatch')
#pattern.color=c('black', 'black')
#background.color=c('white','white')
#density<-c(10, 5)
#patternbar(dframe,x, y, group=g,ylab='Cost', 
#                  pattern.type=pattern.type,pattern.color=pattern.color, 
#                  background.color=background.color, pattern.line.size=0.2,
#                  frame.color=c('black', 'black'), density=density,legend.type="h",legend.h = 5,
#           legend.y.pos = 0.5)


