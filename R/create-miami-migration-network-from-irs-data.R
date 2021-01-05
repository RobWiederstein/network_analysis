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
        dplyr::filter(y1_countyfips != "000") %>%
        dplyr::filter(!y2_statefips %in%  as.character(c(57:59, 96:98))) %>%
        dplyr::filter(y1_statefips == "12") %>%#FL
        dplyr::filter(y1_countyfips == "086")

#county-to-county-inflow
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
move.in.2 <- dplyr::select(move.in.2, source, target, y1_state:n1)
colnames(move.in.2) <- gsub("y1_", "", colnames(move.in.2))

edges <- tibble(rbind(move.out.2, move.in.2))

#eliminate miami to miami
#edges <- edges[-which(edges$source == "12086" & edges$target == "12086"), ]
file <- "./data/irs/maimi-migration-edges.csv"
write.csv(edges, file = file, row.names = F)

#create node data set from edges
nodes <- tibble(id = unique(c(edges$source, edges$target)))
nodes <- merge(nodes, edges[, 2:5], 
               by.x = "id", 
               by.y = "target", 
               all.x = F
               )        
        
        

