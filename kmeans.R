##################################################
## Project: Interference-classifier
## Script purpose: Scientific reproducibility
## Date: 01-14-2021
## Author: Vinícius Meyer
##################################################

#prediction function for each interference class
predict_cpu.kmeans <-function(object, newdata)
{
  predict.kmeans(object, newdata, 7)
}

predict_mem.kmeans <-function(object, newdata)
{
  predict.kmeans(object, newdata, 4)
}

predict_disk.kmeans <-function(object, newdata)
{
  predict.kmeans(object, newdata, 3)
}

predict_net.kmeans <-function(object, newdata)
{
  predict.kmeans(object, newdata, 1)
}

predict_cache.kmeans <-function(object, newdata)
{
  predict.kmeans(object, newdata, 6)
}


#main prediction function
predict.kmeans <- function(object, newdata, var){
  low<-0
  mod<-0
  hig<-0
  centers <- object$centers
  n_centers <- nrow(centers)
  
  hig<-as.integer(which.max(centers[,var]))
  low<-as.integer(which.min(centers[,var]))
  
  for(i in 1:n_centers){
    if(low!=i && i!=hig){
      mod<-i
    }
  }
  
  result<- vector()
  a<-vector()
  dist_mat <- as.matrix(dist(rbind(centers, newdata)))
  dist_mat <- dist_mat[-seq(n_centers), seq(n_centers)]
  a<- max.col(-dist_mat)
  
  for(i in 1:length(a)){
    if(a[i]==low){
      result[i]<-"low"
    }else if(a[i]==mod){
      result[i]<-"mod"
    }else if(a[i]==hig){
      result[i]<-"hig"
    }
  }
  return(result)
}

cpu <- data.frame()
mem <- data.frame()
disk <- data.frame()
net <- data.frame()
cache <- data.frame()

#interference class division
for(i in 1:nrow(total)){
  if(total[i,8]=="cpu"){
    cpu<-bind_rows(cpu, total[i,]) 
  }
  if(total[i,8]=="mem"){
    mem<-bind_rows(mem, total[i,]) 
  }
  if(total[i,8]=="disk"){
    disk<-bind_rows(disk, total[i,]) 
  }
  if(total[i,8]=="net"){
    net<-bind_rows(net, total[i,]) 
  }
  if(total[i,8]=="cache"){
    cache<-bind_rows(cache, total[i,]) 
  }
}

#train kmeans for each interference class
cl_cpu <- kmeans(cpu[1:7],3, nstart = 20)
cl_mem <- kmeans(mem[1:7],3, nstart = 20)
cl_disk <- kmeans(disk[1:7],3, nstart = 20)
cl_net <- kmeans(net[1:7],3, nstart = 20)
cl_cache <- kmeans(cache[1:7], 3, nstart = 20)