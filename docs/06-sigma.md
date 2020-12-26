# Sigma JS {#sigma}




```r
#example for ?sigmajs::sigmajs
library(sigmajs)
nodes <- sg_make_nodes()
edges <- sg_make_edges(nodes)

sigmajs() %>%
  sg_nodes(nodes, id, label, size, color) %>%
  sg_edges(edges, id, source, target) 
```

<!--html_preserve--><div id="htmlwidget-fc3dc748524a799079de" style="width:100%;height:480px;" class="sigmajs html-widget"></div>
<script type="application/json" data-for="htmlwidget-fc3dc748524a799079de">{"x":{"events":[],"kill":false,"data":{"nodes":[{"id":"1","label":"T46","size":"2","color":"#B1E2A3","x":" 6.592881","y":"16.543743"},{"id":"2","label":"B80","size":"2","color":"#A5DBA3","x":"11.543673","y":" 8.573148"},{"id":"3","label":"N92","size":"2","color":"#9AD4A4","x":" 7.193314","y":"17.014395"},{"id":"4","label":"O67","size":"3","color":"#76BA99","x":" 2.521951","y":" 4.719840"},{"id":"5","label":"Q43","size":"2","color":"#48998A","x":" 8.334009","y":" 9.386095"},{"id":"6","label":"U47","size":"2","color":"#2D7E7E","x":" 3.950629","y":"10.961292"},{"id":"7","label":"G33","size":"5","color":"#236B76","x":"16.463441","y":" 3.664224"},{"id":"8","label":"W75","size":"5","color":"#1C686F","x":" 9.507463","y":"10.461446"},{"id":"9","label":"U47","size":"3","color":"#20986D","x":" 9.720603","y":"17.932588"},{"id":"10","label":"C55","size":"2","color":"#24C96B","x":"19.178803","y":" 3.158362"}],"edges":[{"id":"1","source":"1","target":"7"},{"id":"2","source":"2","target":"7"},{"id":"3","source":"3","target":"9"},{"id":"4","source":"4","target":"9"},{"id":"5","source":"5","target":"9"},{"id":"6","source":"6","target":"6"},{"id":"7","source":"7","target":"6"},{"id":"8","source":"8","target":"10"},{"id":"9","source":"9","target":"3"},{"id":"10","source":"10","target":"10"}]},"type":null,"button":[],"buttonevent":[],"crosstalk":{"crosstalk_key":null,"crosstalk_group":null}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->


## Stop light


```r
library(sigmajs)
library(tibble)
edges <- tibble(id = rep("1", 3),
                    source = rep("1", 3),
                    target = as.character(c(2:4))
                    )
nodes <- tibble(id = as.character(1:4),
                    label = c("light", "red", "yellow", "green"),
                    time = c(100, 30, 10, 20)
)
sigmajs() %>%
  sg_nodes(nodes, id, label, time) %>%
  sg_edges(edges, id, source, target) 
```

<!--html_preserve--><div id="htmlwidget-9c08d73f73b712e18197" style="width:100%;height:480px;" class="sigmajs html-widget"></div>
<script type="application/json" data-for="htmlwidget-9c08d73f73b712e18197">{"x":{"events":[],"kill":false,"data":{"nodes":[{"id":"1","label":"light","time":"100","x":" 6.787983","y":"12.305272"},{"id":"2","label":"red","time":" 30","x":"16.455402","y":"17.943401"},{"id":"3","label":"yellow","time":" 10","x":"19.167347","y":" 5.117149"},{"id":"4","label":"green","time":" 20","x":"16.013144","y":"18.112127"}],"edges":[{"id":"1","source":"1","target":"2"},{"id":"1","source":"1","target":"3"},{"id":"1","source":"1","target":"4"}]},"type":null,"button":[],"buttonevent":[],"crosstalk":{"crosstalk_key":null,"crosstalk_group":null}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

