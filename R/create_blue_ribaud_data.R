library(rvest)
library(polite)
library(lubridate)
library(igraph)
#scrape
html <- read_html("https://en.wikipedia.org/wiki/Blue_Riband#Eastbound_record_breakers")
tables <- html %>% html_table()
#extract
west.bound <- tables[[1]]
east.bound <- tables[[2]]
# add heading variable
west.bound$heading <- "west"
east.bound$heading <- "east"
#combine west.bound and east.bound into df
df <- tibble(rbind(west.bound, east.bound))
#clean names
df <- df %>% janitor::clean_names()
#col-1, remove footnote brackets
df$ship <- gsub("\\[[0-9][0-9]\\]", "", df$ship)
# add flag
html <- read_html("https://en.wikipedia.org/wiki/Blue_Riband#Eastbound_record_breakers")
flags <-
        html %>%
        html_nodes(".wikitable img") %>%
        html_attr("alt")
df.flags <- tibble(flags = flags, country = "")
df.flags$country[grep("United Kingdom", df.flags$flags)] <- "GBR"
df.flags$country[grep("United States", df.flags$flags)] <- "USA"
df.flags$country[grep("Germany", df.flags$flags)] <- "DEU"
df.flags$country[grep("France", df.flags$flags)] <- "FRA"
df.flags$country[grep("Italy", df.flags$flags)] <- "ITA"
df$flag <- df.flags$country
#abbreviate
df$line <- gsub("British & American", "BritAm", df$line)
# from
df$from <- gsub("The ", "", df$from)
unique(df$from)
# to
df$to <- gsub(",", "", df$to)
unique(df$to)
# distance
df$nm <- gsub(",", "", substr(df$distance, start = 1, stop = 5))
df$nm <- as.integer(df$nm)
# elapsed time
df$et1 <- gsub(" d| h| m", "", df$days_hours_minutes)
a <- str_split(df$et1, pattern = ", ")
df$days <- as.integer(unlist(lapply(a, "[", 1)))
df$hours <- as.integer(unlist(lapply(a, "[", 2)))
df$minutes <- as.integer(unlist(lapply(a, "[", 3)))
#
df$duration <- 0
for(i in 1:nrow(df)){
x <- as.numeric(as.duration(period(c(df$days[i], df$hours[i], df$minutes[i]), 
                                   units = c("days", "hour", "minute")
                                   )
                            ),
                "days"
                )
df$duration[i] <- x
}
# speed
df$speed <- as.numeric(stringr::word(df$speed))
#geo tag https://developers.google.com/maps/documentation/geolocation/overview
# https://www.storybench.org/geocode-csv-addresses-r/
city <- unique(c(df$from, df$to))
# "Sandy Bank" plots on the west side of UK
state <- c("Ireland",
           "England",
           "England",
           "England",
           "England",
           "France",
           "Spain",
           "England",
           "New York",
           "Canada",
           "New Jersey",
           "New York",
           "New York",
           "New York, USA",
           "New York",
           "England"
)
df.places <- tibble(city = city, 
                    state = state,
                    address = paste(city, state, sep = ", "))


library(ggmap)
my.geocodes <- lapply(df.places$address, function(x){
        ggmap::geocode(location = x,
                output = "latlon",
                force = FALSE
                )
}
)
df.places$lat <- sapply(my.geocodes, "[[", 2)
df.places$lon <- sapply(my.geocodes, "[[", 1)
#sanity check --google maps upload
file <- "./data/rkw/blue-riband-geocode-places.csv"
write.csv(df.places, file = file, row.names = F)
#merge when node dataframe created
df <- dplyr::select(df, 
                    ship,
                    flag,
                    year,
                    line,
                    from,
                    to,
                    heading,
                    nm,
                    duration,
                    speed
                    )
df$n <- 1

df.1 <-
        df %>%
        group_by(from, to) %>%
        summarize(weight = sum(n))

edges <- df.1

nodes <- tibble(city = unique(c(df$from, df$to)))
nodes <- merge(nodes, df.places)
colnames(nodes)[1] <- "id"
#write out "total" df
file <- "./data/rkw/blue_ribald_total.csv"
write.csv(df, file = file, row.names = FALSE)
#write out "edges" df
file <- "./data/rkw/blue_ribald_edges.csv"
write.csv(edges, file = file, row.names = FALSE)
#write out "nodes" df
file <- "./data/rkw/blue_ribald_nodes.csv"
write.csv(nodes, file = file, row.names = FALSE)
#create network
g <- igraph::graph_from_data_frame(d = edges,
                                   directed = T,
                                   vertices = nodes
)
#plot igraph kk
l <- layout_with_kk(g)
l <- norm_coords(l, ymin=-10, ymax=10, xmin=-10, xmax=10)
jpeg(file = "./imgs/blue_riband_network_graph_kk_layout.jpeg",
     width = 7,
     height = 5,
     units = "in",
     quality = 0, 
     res = 600)
igraph::plot.igraph(g,
                    axes = F,
                    layout= l,
                    edge.arrow.size = .2,
                    edge.width = E(g)$weight,
                    vertex.size = 5,
                    vertex.shape = "circle",
                    vertex.frame.color = "white",
                    vertex.color = "skyblue",
                    vertex.label.cex = .75,
                    vertex.label.dist = -1.3,
                    margin = c(0, 0, 0, 0),
                    asp = 0,
                    main = "Blue Riband Ports",
                    sub = "1838 - 1952")
dev.off()
#plot igraph fr
l <- layout_with_fr(g)
l <- norm_coords(l, ymin=-10, ymax=10, xmin=-10, xmax=10)
jpeg(file = "./imgs/blue_riband_network_graph_fr_layout.jpeg",
     width = 7,
     height = 5,
     units = "in",
     quality = 0, 
     res = 600)
igraph::plot.igraph(g,
                    axes = F,
                    layout= layout_with_fr,
                    edge.arrow.size = .2,
                    edge.width = E(g)$weight,
                    vertex.size = 5,
                    vertex.shape = "circle",
                    vertex.frame.color = "white",
                    vertex.color = "skyblue",
                    vertex.label.cex = .75,
                    vertex.label.dist = -1.3,
                    margin = c(0, 0, 0, 0),
                    asp = 0,
                    main = "Blue Riband Ports",
                    sub = "1838 - 1952")
dev.off()
df.2 <- 
        df %>%
        gather(key = key, value = value, 
               -ship, -flag, -year, -line, -from, -to, -heading)

library(ggplot2)
library(dplyr)
mydf <- dplyr::filter(df.2, key == "duration" | key == "speed")
p <- ggplot(mydf, aes(year, value, group = heading, color = heading))
p <- p + geom_line()
p <- p + facet_grid(. ~ key)
p

library(maps)
library(geosphere)
pal <- colorRampPalette(c("#333333", "white", "#1292db"))
colors <- pal(100)

#map("world")
xlim <- c(-80, 10)
ylim <- c(30, 60)
pdf(file = "./imgs/blue_riband_great_circles.pdf",
    width = 11,
    height = 7
)
    
    map("world", 
    col="#191919",
    fill=TRUE, 
    bg="#000000", 
    lwd=0.05,
    mar = c(0, 0, 0, 0),
    xlim=xlim, 
    ylim=ylim
    )
edges <- dplyr::arrange(edges, weight)
maxcnt <- max(edges$weight)

# I never would've have gotten this but for flowingdata!
for (i in 1:nrow(edges)) {
        port1 <- nodes[nodes$id == edges[i,]$from,]
        port2 <- nodes[nodes$id == edges[i,]$to,]
        inter <- gcIntermediate(c(port1[1,]$lon, port1[1,]$lat), c(port2[1,]$lon, port2[1,]$lat), n=100, addStartEnd=TRUE)
        colindex <- round( (edges[i,]$weight / maxcnt) * length(colors) )
        lines(inter, col=colors[colindex], lwd=2)
}
dev.off()
