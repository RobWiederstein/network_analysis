#libraries
library(qgraph)
#import file
txt <- "./data/gabasova/starwars-full-interactions-allCharacters.json"
star.wars <- jsonlite::fromJSON(txt = txt)
#json was list of two databases:  nodes and edges
nodes <- star.wars$nodes
edges <- star.wars$links
#creat graph object from dataframe
g <- igraph::graph_from_data_frame(d = edges,
                                   directed = F,
                                   vertices = nodes
                                   )
#find error--this was not fun.
ed <- sort(unique(c(edges$source, edges$target)))
print(paste0("#", setdiff(0:111, ed), " is missing from edge list."))
#add #79 and connect to 0 (R2D2) -- NA was causing problems
edges[451, ] <- c(79, 0, 1) #There was no #79 in edgelist
#Edges:  create column for edge.width attribute
edges$talk <- ggplot2::cut_interval(edges$value, 6)
levels(edges$talk) <- as.character(1:6)
edges$talk <- as.integer(edges$talk)
#Nodes--need to adjust column for 0-based index
nodes$id <- 0:111 #add id column
nodes <- dplyr::relocate(nodes, id, name, value, colour)
#create column for vertex.size attribute
nodes$scenes <- ggplot2::cut_interval(nodes$value, 6)
levels(nodes$scenes) <- 1:6
nodes$scenes <- as.character(nodes$scenes)
#convert to graph object from dataframe
g <- igraph::graph_from_data_frame(d = edges,
                                   directed = F,
                                   vertices = nodes
)
#Create method to spread nodes
e <- edges[, c(1, 2)]#get.edgelist(g)
l <- qgraph.layout.fruchtermanreingold(e,vcount=vcount(g))
#plot the graph
plot(g, 
     layout = qgraph.layout.fruchtermanreingold(e,
                                                vcount = vcount(g),
                                                area = 8 * (vcount(g) ^ 1),
                                                repulse.rad = (vcount(g) ^ 1)
                                                ),
     vertex.color = vertex.attributes(g)$colour,
     vertex.label = ifelse(V(g)$value > 35, V(g)$name, NA),
     vertex.label.color = "black",
     vertex.label.cex = .6,
     vertex.label.font = 2,
     vertex.size = as.integer(vertex.attributes(g)$scenes) * 2,
     vertex.frame.color="white",
     edge.width = edge.attributes(g)$talk * 1,
     edge.color = "#D3D3D3",
     asp = 0
     )


