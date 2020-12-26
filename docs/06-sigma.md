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

<!--html_preserve--><div id="htmlwidget-3685a8dc72edabac14bd" style="width:100%;height:480px;" class="sigmajs html-widget"></div>
<script type="application/json" data-for="htmlwidget-3685a8dc72edabac14bd">{"x":{"events":[],"kill":false,"data":{"nodes":[{"id":"1","label":"S71","size":"5","color":"#B1E2A3","x":"13.300527","y":"14.454099"},{"id":"2","label":"D30","size":"2","color":"#A5DBA3","x":"16.119551","y":" 1.153526"},{"id":"3","label":"X76","size":"4","color":"#9AD4A4","x":"14.968211","y":" 4.218223"},{"id":"4","label":"E83","size":"4","color":"#76BA99","x":"11.812678","y":" 6.565034"},{"id":"5","label":"S19","size":"5","color":"#48998A","x":"16.523108","y":" 9.355493"},{"id":"6","label":"T72","size":"5","color":"#2D7E7E","x":"12.471372","y":"11.682074"},{"id":"7","label":"G33","size":"3","color":"#236B76","x":"14.420636","y":" 5.191045"},{"id":"8","label":"G33","size":"4","color":"#1C686F","x":"15.075621","y":" 1.649690"},{"id":"9","label":"N14","size":"4","color":"#20986D","x":"11.938672","y":" 6.060638"},{"id":"10","label":"M13","size":"5","color":"#24C96B","x":" 6.252252","y":"13.653885"}],"edges":[{"id":"1","source":"1","target":"8"},{"id":"2","source":"2","target":"9"},{"id":"3","source":"3","target":"8"},{"id":"4","source":"4","target":"2"},{"id":"5","source":"5","target":"3"},{"id":"6","source":"6","target":"2"},{"id":"7","source":"7","target":"8"},{"id":"8","source":"8","target":"2"},{"id":"9","source":"9","target":"4"},{"id":"10","source":"10","target":"9"}]},"type":null,"button":[],"buttonevent":[],"crosstalk":{"crosstalk_key":null,"crosstalk_group":null}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->


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

<!--html_preserve--><div id="htmlwidget-3e4a8925c7d3dbba9a31" style="width:100%;height:480px;" class="sigmajs html-widget"></div>
<script type="application/json" data-for="htmlwidget-3e4a8925c7d3dbba9a31">{"x":{"events":[],"kill":false,"data":{"nodes":[{"id":"1","label":"light","time":"100","x":" 3.093963","y":"4.076152"},{"id":"2","label":"red","time":" 30","x":" 6.308307","y":"2.330558"},{"id":"3","label":"yellow","time":" 10","x":" 2.533134","y":"8.916790"},{"id":"4","label":"green","time":" 20","x":"17.392123","y":"1.866334"}],"edges":[{"id":"1","source":"1","target":"2"},{"id":"1","source":"1","target":"3"},{"id":"1","source":"1","target":"4"}]},"type":null,"button":[],"buttonevent":[],"crosstalk":{"crosstalk_key":null,"crosstalk_group":null}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

