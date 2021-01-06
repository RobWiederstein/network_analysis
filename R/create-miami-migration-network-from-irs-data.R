#https://www.irs.gov/statistics/soi-tax-stats-migration-data-2017-2018
#county-to-county-outflow
url <- "https://www.irs.gov/pub/irs-soi/countyoutflow1718.csv"
destfile <- paste0("./data/irs/", basename(url))
if(!file.exists(destfile)){
        download.file(url = url, destfile = destfile, method = "curl")
}
move.out.1 <- read.csv(file = destfile, colClasses = "character")
# omit total records
move.out.2 <- 
        move.out.1 %>%
        dplyr::filter(y1_statefips == "12") %>%#FL
        dplyr::filter(y1_countyfips == "086") %>% #miami-dade
        dplyr::filter(y1_countyfips != "000") %>%
        dplyr::filter(!y2_statefips %in%  as.character(c(57:59, 96:98)))
        

####### county-to-county-inflow
url <- "https://www.irs.gov/pub/irs-soi/countyinflow1718.csv"
destfile <- paste0("./data/irs/", basename(url))
if(!file.exists(destfile)){
        download.file(url = url, destfile = destfile, method = "curl")
}
move.in.1 <- read.csv(file = destfile, colClasses = "character")

# omit total records
move.in.2 <-
        move.in.1 %>%
        dplyr::filter(y1_countyfips != "000") %>%
        dplyr::filter(!y1_statefips %in%  as.character(c(57:59, 96:98))) %>%
        dplyr::filter(y2_statefips == "12") %>%#FL
        dplyr::filter(y2_countyfips == "086")

#create edge list source to target
#part 1
move.out.2$source <- paste0(move.out.2$y1_statefips, move.out.2$y1_countyfips)
move.out.2$target <- paste0(move.out.2$y2_statefips, move.out.2$y2_countyfips)
move.out.2 <- dplyr::select(move.out.2, source, target, y2_state:n1)
colnames(move.out.2) <- gsub("y2_", "", colnames(move.out.2))

#part 2
move.in.2$source <- paste0(move.in.2$y1_statefips, move.in.2$y1_countyfips)
move.in.2$target <- paste0(move.in.2$y2_statefips, move.in.2$y2_countyfips)
move.in.2$state <- "FL"
move.in.2$countyname <- "Miami-Dade County"
move.in.2 <- dplyr::select(move.in.2, source, target, state, countyname, n1)

edges <- tibble(rbind(move.out.2, move.in.2))

#eliminate miami to miami
edges <- edges[-which(edges$source == "12086" & edges$target == "12086"), ]
file <- "./data/irs/miami-migration-edges.csv"
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
nodes.2$countyname <- gsub("[Cc]ity|[Cc]ounty|Parrish", "", nodes.2$countyname)
nodes.2$label <- paste(nodes.2$countyname, nodes.2$state, sep = ", ")
file <- "./data/irs/miami-migration-nodes.csv"
write.csv(nodes.2, file = file, row.names = F)

edges <- data.table::fread("./data/irs/miami-migration-edges.csv")
nodes <- data.table::fread("./data/irs/miami-migration-nodes.csv")
g <- igraph::graph_from_data_frame(d = edges,
                                   directed = T,
                                   vertices = nodes
)
plot(g,
     vertex.label.cex = .5,
     vertex.size = .5,
     edge.arrow.size = .1,
     layout = layout_nicely,
     mark.groups = ,
     asp = 0
)


