#case study -- airlines -- three data sets
library(igraph)
## Gephy
file <- "./data/gephy/airlines.graphml"
g <- igraph::read.graph(file = file, format = "graphml")
plot(g, 
     vertex.label = NA,
     edge.label = NA,
     vertex.size = 2,
     asp = 0,
     )
list.vertex.attributes(g)
list.edge.attributes(g)
E(g)$id
head(V(g)$x)
head(V(g)$y)
head(V(g)$tooltip)
head(V(g)$id)
#edglist is 2101 in length.  Nodes are 235 in length
#Appears to be 2101 flights between 235 airports. There are
#lat and lon attributes.

