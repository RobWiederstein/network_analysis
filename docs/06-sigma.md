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

<!--html_preserve--><div id="htmlwidget-3c42adbec8f3e4c68fac" style="width:100%;height:480px;" class="sigmajs html-widget"></div>
<script type="application/json" data-for="htmlwidget-3c42adbec8f3e4c68fac">{"x":{"events":[],"kill":false,"data":{"nodes":[{"id":"1","label":"Q17","size":"3","color":"#B1E2A3","x":"11.549790","y":" 3.130737"},{"id":"2","label":"H34","size":"5","color":"#A5DBA3","x":"12.151904","y":"11.524760"},{"id":"3","label":"I87","size":"3","color":"#9AD4A4","x":" 3.982659","y":"11.479627"},{"id":"4","label":"S45","size":"3","color":"#76BA99","x":" 7.604699","y":"11.779827"},{"id":"5","label":"X24","size":"4","color":"#48998A","x":"15.217924","y":" 2.913574"},{"id":"6","label":"B2","size":"2","color":"#2D7E7E","x":" 3.639498","y":"15.133649"},{"id":"7","label":"L38","size":"3","color":"#236B76","x":" 2.338806","y":" 6.937474"},{"id":"8","label":"L12","size":"5","color":"#1C686F","x":"17.352930","y":"16.495753"},{"id":"9","label":"S97","size":"5","color":"#20986D","x":" 9.974744","y":" 2.979489"},{"id":"10","label":"I9","size":"3","color":"#24C96B","x":"13.828998","y":"16.412108"}],"edges":[{"id":"1","source":"1","target":"3"},{"id":"2","source":"2","target":"5"},{"id":"3","source":"3","target":"4"},{"id":"4","source":"4","target":"9"},{"id":"5","source":"5","target":"5"},{"id":"6","source":"6","target":"6"},{"id":"7","source":"7","target":"6"},{"id":"8","source":"8","target":"1"},{"id":"9","source":"9","target":"6"},{"id":"10","source":"10","target":"7"}]},"type":null,"button":[],"buttonevent":[],"crosstalk":{"crosstalk_key":null,"crosstalk_group":null}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->


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

<!--html_preserve--><div id="htmlwidget-45862922a4e710d09649" style="width:100%;height:480px;" class="sigmajs html-widget"></div>
<script type="application/json" data-for="htmlwidget-45862922a4e710d09649">{"x":{"events":[],"kill":false,"data":{"nodes":[{"id":"1","label":"light","time":"100","x":"13.189425","y":" 6.476124"},{"id":"2","label":"red","time":" 30","x":" 9.702849","y":" 3.891035"},{"id":"3","label":"yellow","time":" 10","x":"15.003481","y":"16.280967"},{"id":"4","label":"green","time":" 20","x":" 8.699696","y":" 4.545739"}],"edges":[{"id":"1","source":"1","target":"2"},{"id":"1","source":"1","target":"3"},{"id":"1","source":"1","target":"4"}]},"type":null,"button":[],"buttonevent":[],"crosstalk":{"crosstalk_key":null,"crosstalk_group":null}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

