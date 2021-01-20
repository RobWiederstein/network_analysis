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
#walktrap
wc <- cluster_walktrap(g)
modularity(wc)
membership(wc)
plot(wc, g)
#eigen
ec <- cluster_leading_eigen(g)
modularity(ec)
membership(ec)
plot(ec, g,
     edge.arrow.width = 0)
#louvai
lc <- cluster_fast_greedy(g)


par(mar = c(0, 0, 0, 0))
set.seed(1234)
plot(ec,
        g,
        vertex.size = 8,
        layout = layout_with_drl,
        edge.arrow.width = 0,
        edge.color = "gray",
        asp = 0
            
)
V()