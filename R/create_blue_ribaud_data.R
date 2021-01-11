library(rvest)
library(polite)
library(janitor)
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
df <- df %>% clean_names()
#col-1, remove footnote brackets
df$ship <- gsub("\\[[0-9][0-9]\\]", "", df$ship)
# omit flag
df$flag <- NULL
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
           "New York",
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
file <- "./data/rkw/blue-ribald-geocode-places.csv"
write.csv(df.places, file = file, row.names = F)
#merge when node dataframe created
df <- dplyr::select(df, 
                    ship,
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

g <- igraph::graph_from_data_frame(d = edges,
                                   directed = T,
                                   vertices = nodes
)
library(qgraph)
l <- layout_with_kk(g)
#l <- layout_with_fr(g)
l <- norm_coords(l, ymin=-10, ymax=10, xmin=-10, xmax=10)
jpeg(file = "./imgs/blue_ribald_network_graph.jpeg",
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
                    main = "Blue Riband Destinations",
                    sub = "1838 - 1952")
dev.off()
file <- "./data/blue_ribald.graphml"
write_graph(g, file = file, format = "graphml")


str(df)
df.1 <- 
        df %>%
        gather(key = key, value = value, -ship, -year, -line, -from, -to, -heading)

library(ggplot2)
library(dplyr)
mydf <- dplyr::filter(df.1, key == "duration" | key == "knots")
p <- ggplot(mydf, aes(year, value, group = heading, color = heading))
p <- p + geom_line()
p <- p + facet_grid(. ~ key)
p

library(maps)
library(geosphere)
map("world")
xlim <- c(-75, 10)
ylim <- c(40.0000, 55)
map("world", col="#f2f2f2", fill=TRUE, bg="white", lwd=0.05, xlim=xlim, ylim=ylim)

#from, to , weight and a lat lon

airports <- read.csv("http://datasets.flowingdata.com/tuts/maparcs/airports.csv", header=TRUE) 
flights <- read.csv("http://datasets.flowingdata.com/tuts/maparcs/flights.csv", header=TRUE, as.is=TRUE)

xlim <- c(-171.738281, -56.601563)
ylim <- c(12.039321, 71.856229)
map("world", col="#f2f2f2", fill=TRUE, bg="white", lwd=0.05, xlim=xlim, ylim=ylim)
fsub <- flights[flights$airline == "AA",]

for (j in 1:length(fsub$airline)) {
        air1 <- airports[airports$iata == fsub[j,]$airport1,]
        air2 <- airports[airports$iata == fsub[j,]$airport2,]
        
        inter <- gcIntermediate(c(air1[1,]$long, air1[1,]$lat), c(air2[1,]$long, air2[1,]$lat), n=100, addStartEnd=TRUE)
        
        lines(inter, col="black", lwd=0.8)
}

