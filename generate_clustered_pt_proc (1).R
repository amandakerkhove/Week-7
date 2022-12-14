#Generate clustered spatial point process

library(spatstat)
library(ggplot2)

#define variables
#variables that control the size and strength of clusters
val.at.center=1
effect.range=10
background=0.001


#CSR plot
val.at.center=1
effect.range=50
background=0.001


#Clustered Process
val.at.center=1
effect.range=15
background=0.001

#Q4 clustered small scale and not large
val.at.center= 1
effect.range=28
background=0.95


#variables that control the number of points and spatial dimensions
Pointnum=100
Xmin=-50
Xmax=50
Ymin=-50
Ymax=50

#define the center locations and set up the distance vector
centers=matrix(data=c(-25,-25,25,25,-25,25,-25,25),nrow=4,ncol=2)
dist=matrix(nrow=4,ncol=1)

#define outputs
output.X=matrix(nrow = Pointnum, ncol = 1)
output.Y=matrix(nrow = Pointnum, ncol = 1)

#precalcs - calculate the slope of the clustering effect
slope=(val.at.center-background)/effect.range

#set a counter
outcounter=0

#main for loop
for (i in 1:100000){
  #generate a random candidate point
  x.candidate=runif(1, min=Xmin, max=Xmax)
  y.candidate=runif(1, min=Ymin, max=Ymax)
  
  #calculate the distance between the candidate point and the nearest cluster center
  for (j in 1:4){
  dist[j]=sqrt((x.candidate-centers[j,1])^2+(y.candidate-centers[j,2])^2)
  }
  min.dist=min(dist)
  
  #calculate the probability of retaining the candidate point
  if(min.dist<effect.range){
    prob=val.at.center-slope*min.dist
  }
  else
    prob=background

  #roll the dice to see if you keep the candidate point
  testval=runif(1,min=0,max=1)  
  if (testval<prob){
    outcounter=outcounter+1
    keep=1
    output.X[outcounter]=x.candidate
    output.Y[outcounter]=y.candidate
  }

  #if you've reached your target number of points, break from the for loop
  if(outcounter==Pointnum){
    break
  }
}

#plot the points and the cluster centers
plot(output.X,output.Y)
points(centers,type="p", col="red", pch=21, bg="red")

#create a point pattern object for analysis using the spatstat library
output_ppp = ppp(output.X, output.Y, c(Xmin,Xmax), c(Ymin,Ymax))
#question 2
quadrat.test(output_ppp, nx=2, ny= 2, alternative = "clustered") 
#Question 3

plot(Kest(output_ppp))

plot(envelope(output_ppp, Kest))

plot(density(output_ppp))

#Q4



