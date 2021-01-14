##################################################
## Project: Interference-classifier
## Script purpose: Scientific reproducibility
## Date: 01-14-2021
## Author: Vinícius Meyer
##################################################

library('clValid')

source("./input_dataset.R")
folder_source <- "./training_dataset/"
total<-input_dataset(folder_source)


cl_total <- kmeans(total[1:7],3, nstart = 20)


# load package
library(fossil)
true_label <- as.numeric(total$category)

# perform k-means clustering
my_kmeans <- kmeans(x = total[,-8], centers = 3)

# Rand index
rand.index(true_label, my_kmeans$cluster)


