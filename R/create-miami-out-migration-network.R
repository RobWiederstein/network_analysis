#https://www.irs.gov/statistics/soi-tax-stats-migration-data-2017-2018
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
        arrange(-n1)

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
#set miami to 0
#nodes.2$returns[which(nodes.2$id == "12086")] <- 0

#save file and sweep env
file <- "./data/irs/miami-out-migration-nodes.csv"
write.csv(nodes.2, file = file, row.names = F)
rm(list = ls())
# import
edges <- data.table::fread("./data/irs/miami-out-migration-edges.csv")
nodes <- data.table::fread("./data/irs/miami-out-migration-nodes.csv")
# create network
g1 <- igraph::graph_from_data_frame(d = edges,
                                   directed = T,
                                   vertices = nodes
)
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




library(qgraph)
e <- get.edgelist(g)
l <- qgraph.layout.fruchtermanreingold(e,vcount=vcount(g))
plot(g,
     vertex.label.cex = as.integer(vertex.attributes(g)$quintile) / 5,
     vertex.size = as.integer(vertex.attributes(g)$quintile) ^ 1.75,
     edge.arrow.size = .1,
     layout = layout_nicely,
     mark.groups = c(1L, 8L, 12L, 15L, 18L, 20L, 35L, 36L, 37L, 40L, 41L, 42L, 43L, 
                     44L, 45L, 48L, 52L, 54L, 58L, 59L, 60L, 62L, 63L, 64L, 66L, 67L, 
                     68L, 69L, 70L),
     mark.col="#C5E5E7",
     asp = 0,
     main = "Out Migration"
)
#create variable for vertex.size
nodes.2$quintile <- ggplot2::cut_number(nodes.2$returns, n = 5)
levels(nodes.2$quintile) <- 1:5
nodes.2$quintile <- as.character(nodes.2$quintile)
#create color column for vertex.color
my.colors <- tibble(quintile = 1:5,
                    colors <- viridis(5, option = "D")
)
nodes.2 <- merge(nodes.2, my.colors)
colnames(nodes.2)[7] <- "color"
nodes.2 <- dplyr::select(nodes.2, id:color, quintile)