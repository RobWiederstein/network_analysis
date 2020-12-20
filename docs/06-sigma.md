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

<!--html_preserve--><div id="htmlwidget-98d1d8ead3a636e18ee5" style="width:100%;height:480px;" class="sigmajs html-widget"></div>
<script type="application/json" data-for="htmlwidget-98d1d8ead3a636e18ee5">{"x":{"events":[],"kill":false,"data":{"nodes":[{"id":"1","label":"H34","size":"4","color":"#B1E2A3","x":" 4.644716","y":"11.888701"},{"id":"2","label":"O15","size":"2","color":"#A5DBA3","x":" 9.725542","y":" 6.920096"},{"id":"3","label":"P68","size":"2","color":"#9AD4A4","x":"15.153826","y":" 9.436637"},{"id":"4","label":"U47","size":"5","color":"#76BA99","x":" 5.288951","y":" 3.347408"},{"id":"5","label":"E57","size":"5","color":"#48998A","x":" 1.255447","y":"14.167803"},{"id":"6","label":"P94","size":"4","color":"#2D7E7E","x":"12.205716","y":"17.390706"},{"id":"7","label":"R70","size":"2","color":"#236B76","x":"15.652146","y":"17.507513"},{"id":"8","label":"O93","size":"2","color":"#1C686F","x":" 6.481481","y":" 5.424064"},{"id":"9","label":"I35","size":"4","color":"#20986D","x":" 1.064025","y":" 9.636505"},{"id":"10","label":"G33","size":"2","color":"#24C96B","x":" 1.979265","y":" 6.106214"}],"edges":[{"id":"1","source":"1","target":"3"},{"id":"2","source":"2","target":"5"},{"id":"3","source":"3","target":"9"},{"id":"4","source":"4","target":"5"},{"id":"5","source":"5","target":"10"},{"id":"6","source":"6","target":"9"},{"id":"7","source":"7","target":"10"},{"id":"8","source":"8","target":"7"},{"id":"9","source":"9","target":"7"},{"id":"10","source":"10","target":"7"}]},"type":null,"button":[],"buttonevent":[],"crosstalk":{"crosstalk_key":null,"crosstalk_group":null}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->


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

<!--html_preserve--><div id="htmlwidget-bbce3e85d020cf817be6" style="width:100%;height:480px;" class="sigmajs html-widget"></div>
<script type="application/json" data-for="htmlwidget-bbce3e85d020cf817be6">{"x":{"events":[],"kill":false,"data":{"nodes":[{"id":"1","label":"light","time":"100","x":"18.856603","y":" 1.803397"},{"id":"2","label":"red","time":" 30","x":"17.314751","y":"11.067663"},{"id":"3","label":"yellow","time":" 10","x":" 8.707195","y":"15.414128"},{"id":"4","label":"green","time":" 20","x":"10.790535","y":"17.838778"}],"edges":[{"id":"1","source":"1","target":"2"},{"id":"1","source":"1","target":"3"},{"id":"1","source":"1","target":"4"}]},"type":null,"button":[],"buttonevent":[],"crosstalk":{"crosstalk_key":null,"crosstalk_group":null}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

