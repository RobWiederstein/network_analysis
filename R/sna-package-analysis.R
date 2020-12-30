library(dlstats)
library(rvest)
#get table of rpkgs
rpkgs <- read_html("https://cran.r-project.org/web/packages/available_packages_by_name.html")
table <- rpkgs %>%
        html_table(fill = TRUE)
df <- do.call(rbind.data.frame, table)
colnames(df) <- c("name", "desc")
#add urls for scraping
links <- rpkgs %>%
        html_nodes("td a") %>%
        html_attr('href')
#convert paths to absolute     
links <- stringr::str_sub(links, start = 6)
links <- paste0("https://cran.r-project.org", links)
#get package name for merge


links[1:10]
gsub("../..", , links)
strinr::str_sub()
my.str <- "../../web/packages/A3/index.html"
str_sub(my.str, start = 6)
/web/packages/A3/index.html

tail(df)
df.1 <- df[grep("network", df$desc), ] #get network pkgs
df.2 <- 