#intro
karate <- make_graph("Zachary")
wc <- cluster_walktrap(karate)
modularity(wc)
membership(wc)
plot(wc, karate)
#cluster louvain
g <- make_full_graph(5) %du% make_full_graph(5) %du% make_full_graph(5)
plot(g)
g <- add_edges(g, c(1,6, 1,11, 6, 11))
plot(g)
cl <- cluster_louvain(g)
modularity(cl)
membership(cl)
plot(cl, g)
#cluster_fast_greedy
g <- make_full_graph(5) %du% make_full_graph(5) %du% make_full_graph(5)
g <- add_edges(g, c(1,6, 1,11, 6, 11))
fc <- cluster_fast_greedy(g)
membership(fc)
sizes(fc)
plot(fc, g)

# The function does the same; just put your community object in the community slot, your graph in the network one. 
# I would left the weight.between = 1 and tune the weight.within value.
edge.weights <- function(community, network, weight.within = 100, weight.between = 1) {
        bridges <- crossing(communities = community, graph = network)
        weights <- ifelse(test = bridges, yes = weight.between, no = weight.within)
        return(weights) 
}
#then transfer the weights to the weight slot in the nodes:
E(graph)$weight <- edge.weights(community, graph)

library(igraph)
library(igraphdata)
#I load the network
data(karate)
#for reproducible purposes
set.seed(23548723)
karateLayout <- layout_with_fr(karate)
par(mar = c(0,0,2,0))
plot(karate, vertex.size = 10, vertex.color = "steelblue4", edge.width = 1, 
     vertex.label = NA, edge.color = "darkgrey", layout = karateLayout,
     main = "Zachary's karate club network" )
#detect the communities by multi-level optimization of modularity
Communitykarate <- cluster_louvain(karate)
#customize colors
prettyColors <- c("turquoise4", "azure4", "olivedrab","deeppink4")
communityColors <- prettyColors[membership(Communitykarate)]
#just replot above but with colors based on membership
plot(x = Communitykarate, 
     y = karate, 
     edge.width = 1, 
     vertex.size = 10, 
     vertex.label = NA, 
     mark.groups = NULL, 
     layout = karateLayout, 
     col = communityColors,
     main = "Communities in Zachary's karate club network",
     edge.color = c("darkgrey","tomato2")[crossing(Communitykarate, karate) + 1]
)
#function w/ 
E(karate)$weight <- edge.weights(Communitykarate, karate)
# I use the original layout as a base for the new one
karateLayoutA <- layout_with_fr(karate, karateLayout)
# the graph with the nodes grouped
plot(x = Communitykarate, y = karate, edge.width = 1, vertex.size = 10, 
     mark.groups = NULL, layout = karateLayoutA, vertex.label = NA, col = communityColors, 
     c("darkgrey","tomato2")[crossing(Communitykarate, karate) + 1],
     main = "Communities in Zachary's karate club network (grouped)")
#more weight
E(karate)$weight <- edge.weights(Communitykarate, karate, weight.within = 1000)
karateLayoutB <- layout_with_fr(karate, karateLayout)
plot(x = Communitykarate, y = karate, edge.width = 1, vertex.size = 10,
     mark.groups = NULL, layout = karateLayoutB, vertex.label = NA, col = communityColors, 
     c("darkgrey","tomato2")[crossing(Communitykarate, karate) + 1],
     main = "Communities in Zachary's karate club network (grouped)")


