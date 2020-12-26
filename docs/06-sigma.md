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

<!--html_preserve--><div id="htmlwidget-4ce0732e957cb0180075" style="width:100%;height:480px;" class="sigmajs html-widget"></div>
<script type="application/json" data-for="htmlwidget-4ce0732e957cb0180075">{"x":{"events":[],"kill":false,"data":{"nodes":[{"id":"1","label":"K63","size":"3","color":"#B1E2A3","x":" 8.119751","y":"11.296214"},{"id":"2","label":"Q43","size":"3","color":"#A5DBA3","x":"11.435866","y":" 7.711726"},{"id":"3","label":"W49","size":"4","color":"#9AD4A4","x":" 2.204193","y":" 8.384236"},{"id":"4","label":"A53","size":"3","color":"#76BA99","x":" 9.020488","y":"10.421917"},{"id":"5","label":"N66","size":"3","color":"#48998A","x":"11.807512","y":"14.164627"},{"id":"6","label":"U73","size":"5","color":"#2D7E7E","x":" 8.565911","y":" 4.555785"},{"id":"7","label":"W23","size":"5","color":"#236B76","x":"10.045613","y":" 7.982950"},{"id":"8","label":"Z26","size":"2","color":"#1C686F","x":" 2.785259","y":"12.240911"},{"id":"9","label":"P94","size":"3","color":"#20986D","x":" 3.860419","y":"16.056103"},{"id":"10","label":"R96","size":"3","color":"#24C96B","x":"18.539009","y":" 1.433857"}],"edges":[{"id":"1","source":"1","target":"5"},{"id":"2","source":"2","target":"10"},{"id":"3","source":"3","target":"10"},{"id":"4","source":"4","target":"9"},{"id":"5","source":"5","target":"7"},{"id":"6","source":"6","target":"8"},{"id":"7","source":"7","target":"10"},{"id":"8","source":"8","target":"8"},{"id":"9","source":"9","target":"6"},{"id":"10","source":"10","target":"2"}]},"type":null,"button":[],"buttonevent":[],"crosstalk":{"crosstalk_key":null,"crosstalk_group":null}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->


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

<!--html_preserve--><div id="htmlwidget-85acf841e998d795a2ee" style="width:100%;height:480px;" class="sigmajs html-widget"></div>
<script type="application/json" data-for="htmlwidget-85acf841e998d795a2ee">{"x":{"events":[],"kill":false,"data":{"nodes":[{"id":"1","label":"light","time":"100","x":" 8.295598","y":" 3.121582"},{"id":"2","label":"red","time":" 30","x":"15.834615","y":" 8.012605"},{"id":"3","label":"yellow","time":" 10","x":"11.127363","y":"11.515894"},{"id":"4","label":"green","time":" 20","x":" 2.200882","y":"19.858589"}],"edges":[{"id":"1","source":"1","target":"2"},{"id":"1","source":"1","target":"3"},{"id":"1","source":"1","target":"4"}]},"type":null,"button":[],"buttonevent":[],"crosstalk":{"crosstalk_key":null,"crosstalk_group":null}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

