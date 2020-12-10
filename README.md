# ML-Driven Classification Scheme for DynamicInterference-Aware Resource Scheduling in Cloud Infrastructure

This repository refers to a paper submitted to **Journal of Systems Architecture**.

https://www.journals.elsevier.com/journal-of-systems-architecture

Here, you will find all used codes and results from this work.</br>

Authors: Vinícius Meyer, Dionatrã F. Kirchoff, Matheus L. da Silva and César A. F. De Rose</br> 
School of Technology, Pontifical Catholic University of Rio Grande do Sul (PUCRS) - Porto Alegre, Brazil</br> 
Reference: to appear</br> 

## How-to-use

**Classifier.R** is the main class to run the interference-aware classification from a given profiled application. 
Few variables need to be filled, as follows:

**app_tittle** receives the profiled data from a given period in CSV format.

**period** refers to the segmentation period to be classified. For example: if it is set to 25, it means the total profiled data will be divided into four parts; 50% into two; and so on.

**technique** set the classification technique. In this paper, we only use SVM + K-means to classify interference, but other techniques have been tested in preliminary phases, such as Artificial Neural Network + K-means, Decision Tree + K-means, K-Nearest Neighbor + K-means, and Random Forest + K-means. With a minimal development effort, it is possible to use them.

**method** set the method used outcome classification. In this paper, we only use "L" (level), which means that all classes of interference (CPU, Cache, Disk, Network, and Memory) will receive one of four defined levels (High, Moderate, Low, or Absent) using the K-means model. Other types of classifications were tested in preliminary experiments, such as: "C"(class) returns the major class of interference, this means that from a given profiled period, the most representative, or the interference class that suffers the most, will be exposed; or "P"(percent) that brings the percentage of each class of interference from a given period.

## Folders

**training_dataset** refers to data used to build the machine learning models (SVM and K-means).

**source** contains the profiled data from used applications (Bench4Q, LinkBench, and TPC-H).

**accuracy** presents the font codes to perform the accuracy evaluation phase.


If you have any question please do not hesitate to contact us through vinicius.meyer@edu.pucrs.br</br>


