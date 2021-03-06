library(igraph)
library(igraphdata)
data("karate")
#before image
filename <- "./imgs/karate_coords_via_layout_nicely.jpeg"
jpeg(filename = filename, width = 6, height = 4, units = "in", 
     quality = 95, res = 300, type = "cairo")
par(mar = c(1, 0, 1, 0))
plot(karate,
     vertex.size = 10,
     layout = layout_nicely,
     asp = .66,
     main = "coords via layout_nicely",
     rescale = T
)
dev.off()
canvas.width <- 600
canvas.height <- 400
x <- tkplot(karate, 
            vertex.size = 10,
            canvas.width = canvas.width,
            canvas.height = canvas.height
            )
#Here: Move nodes within the tkplot window to a layout you like!
coords01 <- tkplot.getcoords(x)
#after image
filename <- "./imgs/karate_coords_via_tkplot.jpeg"
jpeg(filename = filename, width = 6, height = 4, units = "in", quality = 95, res = 300, type = "cairo")
        par(mar = c(1, 0, 1, 0))
        plot(karate,
        vertex.size = 10,
        layout = coords01,
        asp = .66,
        main = "coords via tkplot"
     )
dev.off()
