#Flowing Data -- https://flowingdata.com/2011/05/05/where-do-major-airlines-fly-in-the-united-states/
airports <- read.csv("http://datasets.flowingdata.com/tuts/maparcs/airports.csv", header=TRUE) 
flights <- read.csv("http://datasets.flowingdata.com/tuts/maparcs/flights.csv", header=TRUE, as.is=TRUE)
