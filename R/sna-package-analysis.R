library(dlstats)
library(rvest)
library(ggthemes)
library(RColorBrewer)
#get table of rpkgs
rpkgs <- read_html("https://cran.r-project.org/web/packages/available_packages_by_name.html")
table <- rpkgs %>%
        html_table(fill = TRUE)
df.00 <- do.call(rbind.data.frame, table)
colnames(df.00) <- c("package", "desc")
df.00 <- na.omit(df.00)
#add urls for scraping
links <- rpkgs %>%
        html_nodes("td a") %>%
        html_attr('href')
#convert paths to absolute     
links <- stringr::str_sub(links, start = 6)
links <- paste0("https://cran.r-project.org", links)
#get package name for merge
package <- gsub("https://cran.r-project.org/web/packages/", "", links)
package <- gsub("/index.html", "", package)
df.links <- data.frame(package = package, links = links, stringsAsFactors = F)
#merge
df.01 <- dplyr::left_join(df.00, df.links) #drop 26
#see how many "network"
df.02 <- df.01[grep("[Nn]etwork", df.01$desc), ] #385
#now get summary of pages
pages <- df.02$links
df.02$summary <- sapply(pages, function(x){read_html(x) %>%
                html_node("h2+ p") %>%
                html_text()
}
)
#get downloads "dl"
dl.00 <- cran_stats(df.02$package, use_cache = T)
dl.00$package <- sapply(dl.00$package, as.character)
#merge latest downloads ("dl") to df.2
head(dl.00)
dl.01 <- 
        dl.00 %>%
        dplyr::filter(end == max(end))
df.03 <- merge(df.02, dl.01[, c(3,4)])

#total downloads each month for all packages
dl.02 <- dl.00 %>%
        group_by(end) %>%
        summarise(downloads = sum(downloads))
p <- ggplot(dl.02, aes(end, downloads))
p <- p + geom_line()
p <- p + scale_y_continuous(limits = c(0, 1.5e6))
p <- p + ggtitle("Total R Package Downloads by Month")
p
#total download for igraph package each month
dl.03 <- dl.00 %>%
        dplyr::filter(package == "igraph")
dl.02$package <- "total"
dl.04 <- rbind(dl.03[, c(2, 3, 4)], dl.02)
dl.04$package <- factor(dl.04$package, levels=c("total", "igraph"))
#plot total downloads to igraph downloads
p <- ggplot(dl.04, aes(end, downloads, group = package, color = package))
p <- p + geom_line()
p <- p + ggtitle("Total Package vs. igraph Downloads")
p <- p + scale_y_continuous(limits = c(0, 1.6e6),
                            name = "downloads",
                            breaks = c(0, 4e5, 8e5, 1.2e6, 1.6e6),
                            labels = c("0", ".4m", ".8m", "1.2m", "1.6m")
                        )
p <- p + scale_x_date(name = "",
                      limits = as.Date(c("2015-01-01", "2021-01-01"), format = "%Y-%m-%d"),
                      date_labels = "%Y"
)
p <- p + scale_color_brewer(type = "qual", palette = "Set1")
p <- p + theme(plot.title = element_text(hjust = 0.5))
p <- p + theme_gdocs()
p
filename <- "./imgs/total_pkg_vs_igraph_downloads_2015-2021.jpg"
ggsave(p, filename = filename, height = 4, width = 6, unit = "in")
#top 10 packages
dl.05 <- dl.00 %>%
        dplyr::filter(end == max(dl.02$end)) %>%
        arrange(-downloads) %>%
        slice_head(n = 15)
omit.pkgs <- c("RCurl", "snow", "nnet", "neuralnet")
dl.05 <- dl.05[-which(dl.05$package %in% omit.pkgs),  ]
top.10.network <- dl.05$package[1:10]
#filter to top 10 for plot
dl.05 <- dl.00 %>%
        dplyr::filter(package %in% top.10.network)
#set factor levels in order of download
dl.05$package <- factor(dl.05$package, levels = dput(top.10.network)                        )
#plot
p <- ggplot(dl.05, aes(end, downloads, group = package, color = package))
p <- p + geom_line()
p <- p + ggtitle("Top 10 Downloaded 'Network' Pkgs.")
p <- p + scale_x_date(name = "")
p <- p + scale_y_continuous(name = "downloads",
                            limits = c(0, 500000),
                            breaks = c(0, 125000, 250000, 375000, 500000),
                            labels = c("0", "125k", "250k", "375k", "500k")
)
p <- p + scale_color_brewer(type = "qual", palette = "Set1")
p <- p + theme(plot.title = element_text(hjust = 0.5))
p <- p + theme_gdocs()
p
filename <- "./imgs/top_10_network_packages_by_monthly_download.jpg"
ggsave(p, filename = filename, height = 4, width = 6, unit = "in")

#save file for table
df.04 <-
        df.03 %>%
        dplyr::filter(package %in% top.10.network) %>%
        select(package, downloads, summary)
file <- "./tbls/table_top_10_network_pkgs.RData"
save(df.04, file = file)
