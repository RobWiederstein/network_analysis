library(igraph)
set.seed(1234)
G = erdos.renyi.game(20, 0.25)
V(G)$Group1 = sample(3,20, replace=TRUE)
plot(G, vertex.color=rainbow(3, alpha=0.4)[V(G)$Group1],
     vertex.label = V(G)$Group1)
#break
G_Grouped = G
E(G_Grouped)$weight = 1
set.seed(1234)
plot(G_Grouped,
     vertex.label = V(G_Grouped)$Group1)
## Add edges with high weight between all nodes in the same group
for(i in unique(V(G)$Group1)) {
        GroupV = which(V(G)$Group1 == i)
        G_Grouped = add_edges(G_Grouped, combn(GroupV, 2), attr=list(weight=5))
}
G_Grouped = add_edges(G_Grouped, combn(GroupV, 2), attr=list(weight=5))
## Now create a layout based on G_Grouped
set.seed(567)
LO = layout_with_fr(G_Grouped)

## Use the layout to plot the original graph
plot(G, vertex.color=rainbow(3, alpha=0.4)[V(G)$Group1], layout=LO)
