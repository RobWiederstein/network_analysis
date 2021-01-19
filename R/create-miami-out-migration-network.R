#https://www.irs.gov/statistics/soi-tax-stats-migration-data-2017-2018
library(dplyr)
#county-to-county-outflow
url <- "https://www.irs.gov/pub/irs-soi/countyoutflow1718.csv"
destfile <- paste0("./data/irs/", basename(url))
if(!file.exists(destfile)){
        download.file(url = url, destfile = destfile, method = "curl")
}
move.out.1 <- read.csv(file = destfile, colClasses = "character")
move.out.1$n1 <- as.integer(move.out.1$n1)
# omit total records
move.out.2 <- 
        move.out.1 %>%
        dplyr::filter(y1_statefips == "12") %>%#FL
        dplyr::filter(y1_countyfips == "086") %>% #miami-dade
        dplyr::filter(y1_countyfips != "000") %>%
        dplyr::filter(!y2_statefips %in%  as.character(c(57:59, 96:98))) %>%
        dplyr::filter(n1 > 100) %>%
        dplyr::arrange(-n1)

# create edge list source to target
move.out.2$source <- paste0(move.out.2$y1_statefips, move.out.2$y1_countyfips)
move.out.2$target <- paste0(move.out.2$y2_statefips, move.out.2$y2_countyfips)
move.out.2 <- dplyr::select(move.out.2, source, target, y2_state:n1)
colnames(move.out.2) <- gsub("y2_", "", colnames(move.out.2))

#eliminate miami to miami
edges <- move.out.2#[-which(move.out.2$source == "12086" & move.out.2$target == "12086"), ]
file <- "./data/irs/miami-out-migration-edges.csv"
write.csv(edges, file = file, row.names = F)

#create node data set from edges
nodes <- tibble(id = unique(c(edges$source, edges$target)))
nodes.1 <- merge(nodes, edges[2:5], by.x = "id", by.y = "target", all.x = T)
#nodes.2 <- dplyr::distinct(nodes.1)
nodes.1$n1 <- as.integer(nodes.1$n1)

nodes.2 <- 
        nodes.1 %>%
        group_by(id, state, countyname) %>%
        summarize(returns = sum(n1))
nodes.2 <- dplyr::distinct(nodes.2)
nodes.2$countyname <- gsub("[Cc]ity|[Cc]ounty|Parrish|Non-migrants", "", nodes.2$countyname)
nodes.2$label <- paste0(nodes.2$countyname,", ", nodes.2$state, "\n", nodes.2$returns)
nodes.2$group <- 0
nodes.2$group[which(nodes.2$state == "FL")] <- 1

#save file and sweep env
file <- "./data/irs/miami-out-migration-nodes.csv"
write.csv(nodes.2, file = file, row.names = F)
rm(list = ls())
# import
edges <- data.table::fread("./data/irs/miami-out-migration-edges.csv")
nodes <- data.table::fread("./data/irs/miami-out-migration-nodes.csv")
set.seed(1234)
# create network
g1 <- igraph::graph_from_data_frame(d = edges,
                                   directed = T,
                                   vertices = nodes
)
g1 <- simplify(g1, remove.multiple = F, remove.loops = T)
#chart #1 - will it plot?
plot.igraph(g1)
#chart #2 - open the space
plot.igraph(g1,
            vertex.label = NA,
            main = "vertex.label = NA"
            )
plot.igraph(g1,
            vertex.label = NA,
            vertex.size = 1,
            main = "vertex.size = 1"
            )
plot.igraph(g1,
            vertex.label = NA,
            vertex.size = 1,
            edge.arrow.size = .1,
            main = "edge.arrow.size = .1"
)
list.vertex.attributes(g1)
#create variable for vertex.size -- cut number returns into 5
nodes$quintile <- ggplot2::cut_number(nodes$returns, n = 5)
levels(nodes$quintile) <- 1:5
nodes$quintile <- as.character(nodes$quintile)
nodes$quintile <- as.integer(nodes$quintile)
set.seed(1234)
g2 <- igraph::graph_from_data_frame(d = edges,
                                          directed = T,
                                          vertices = nodes
)
plot.igraph(g2,
            vertex.label = NA,
            vertex.size = V(g2)$quintile ^2,
            edge.arrow.size = .1,
            main = "vertex.size"
)

#create color column for vertex.color
library(viridis)
library(tibble)
#create node color palette and merge w/ node df
my.colors <- tibble(quintile = 1:5,
                    colors = viridis(5, option = "D")
)
nodes <- dplyr::left_join(nodes, my.colors)
g3 <- igraph::graph_from_data_frame(d = edges,
                                          directed = F,
                                          vertices = nodes
)
plot.igraph(g3,
            vertex.label = NA,
            vertex.size = V(g3)$quintile ^2,
            vertex.color = V(g3)$colors,
            edge.arrow.size = .1,
            main = "vertex.color"
)

# ## Layout Nodes
# edge.weights <- function(community, network, weight.within = 100, weight.between = 1) {
#         bridges <- crossing(communities = community, graph = network)
#         weights <- ifelse(test = bridges, yes = weight.between, no = weight.within)
#         return(weights) 
# }
# #detect the communities by multi-level optimization of modularity
# #communityMiami <- cluster_louvain(g3)
# communityMiami <- cluster_fast_greedy(g3)
# #layout
# miamiLayout <- layout_with_fr(g3)
# #plot
# plot(x = communityMiami, 
#      y = g3, 
#      edge.width = 1, 
#      vertex.size = 10, 
#      vertex.label = NA, 
#      mark.groups = NULL, 
#      layout = miamiLayout, 
#      vertex.color = V(g3)$colors,
#      main = "Communities in Miami"
#      #edge.color = c("darkgrey","tomato2")[crossing(Communitykarate, karate) + 1]
# )
# #function w/ 
# E(g3)$weight <- edge.weights(communityMiami, g3)
# # I use the original layout as a base for the new one
# miamiLayout <- layout_with_fr(g3, miamiLayout)
# plot(x = communityMiami, 
#      y = g3, 
#      edge.width = 1, 
#      vertex.size = 10, 
#      mark.groups = NULL, 
#      layout = miamiLayout, 
#      vertex.label = NA, 
#      col = V(g3)$colors,
#      c("darkgrey","tomato2")[crossing(communityMiami, g3) + 1],
#      main = "Communities in Zachary's karate club network (grouped)"
#      )



