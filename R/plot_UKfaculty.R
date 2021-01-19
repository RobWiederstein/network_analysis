data("UKfaculty")
#shorten to "g" for graph
g <- UKfaculty
#what is it?
g
head(V(g))
head(E(g))
list.vertex.attributes(g)
V(g)$Group
table(V(g)$Group)
#edges
list.edge.attributes(g)
summary(E(g)$weight)
#understand "weight" distribution
summary(E(g)$weight)
qplot(E(g)$weight)
table(E(g)$weight)
#community detection algorithms
wc <- cluster_walktrap(g)
modularity(wc)
membership(wc)
plot(wc, g)

par(mar = c(0, 0, 0, 0))
set.seed(1234)
plot.igraph(UKfaculty,
            vertex.size = 1,
            layout = layout_with_drl,
            edge.arrow.width = 0,
            asp = 0
            
)
V()