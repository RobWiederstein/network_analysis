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
west.bound$heading <- "w"
east.bound$heading <- "e"
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
unique(df$from)
# to
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
df$knots <- as.numeric(stringr::word(df$speed))
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
           "New York",
           "New York",
           "New York",
           "New York",
           "New York",
           "England",
           "England",
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
                    knots
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
e <- get.edgelist(g)
l <- qgraph.layout.fruchtermanreingold(e,vcount=vcount(g),
                                       area=8*(vcount(g)^2),
                                       repulse.rad=(vcount(g)^3.1))
igraph::plot.igraph(g,
                    layout = layout_nicely,
                    edge.arrow.size = 0,
                    edge.width = E(g)$weight,
                    vertex.size = 20,
                    vertex.shape = "none",
                    vertex.frame.color = NA,
                    asp = 0)

file <- "./data/blue_ribald.graphml"
write_graph(g, file = file, format = "graphml")
