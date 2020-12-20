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

<!--html_preserve--><div id="htmlwidget-54c868f9bdf68c312d1a" style="width:100%;height:480px;" class="sigmajs html-widget"></div>
<script type="application/json" data-for="htmlwidget-54c868f9bdf68c312d1a">{"x":{"events":[],"kill":false,"data":{"nodes":[{"id":"1","label":"R70","size":"4","color":"#B1E2A3","x":" 2.615858","y":"16.053354"},{"id":"2","label":"U73","size":"4","color":"#A5DBA3","x":"10.933828","y":"15.826037"},{"id":"3","label":"H86","size":"5","color":"#9AD4A4","x":" 7.194800","y":" 4.740831"},{"id":"4","label":"O15","size":"5","color":"#76BA99","x":"11.563019","y":" 4.828129"},{"id":"5","label":"T46","size":"3","color":"#48998A","x":" 9.046631","y":"18.852359"},{"id":"6","label":"N40","size":"3","color":"#2D7E7E","x":"15.263113","y":"18.912316"},{"id":"7","label":"P42","size":"2","color":"#236B76","x":" 9.744794","y":"17.205676"},{"id":"8","label":"E57","size":"3","color":"#1C686F","x":" 1.354480","y":"10.596605"},{"id":"9","label":"W49","size":"4","color":"#20986D","x":"16.254353","y":" 9.513508"},{"id":"10","label":"N66","size":"4","color":"#24C96B","x":"12.854503","y":"13.427773"}],"edges":[{"id":"1","source":"1","target":"5"},{"id":"2","source":"2","target":"10"},{"id":"3","source":"3","target":"3"},{"id":"4","source":"4","target":"4"},{"id":"5","source":"5","target":"6"},{"id":"6","source":"6","target":"6"},{"id":"7","source":"7","target":"8"},{"id":"8","source":"8","target":"8"},{"id":"9","source":"9","target":"8"},{"id":"10","source":"10","target":"8"}]},"type":null,"button":[],"buttonevent":[],"crosstalk":{"crosstalk_key":null,"crosstalk_group":null}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->


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

<!--html_preserve--><div id="htmlwidget-a405eaa4d7992beacee3" style="width:100%;height:480px;" class="sigmajs html-widget"></div>
<script type="application/json" data-for="htmlwidget-a405eaa4d7992beacee3">{"x":{"events":[],"kill":false,"data":{"nodes":[{"id":"1","label":"light","time":"100","x":"10.450179","y":" 2.613551"},{"id":"2","label":"red","time":" 30","x":"15.085558","y":"16.137785"},{"id":"3","label":"yellow","time":" 10","x":" 6.374187","y":" 7.126601"},{"id":"4","label":"green","time":" 20","x":" 8.642574","y":" 8.658820"}],"edges":[{"id":"1","source":"1","target":"2"},{"id":"1","source":"1","target":"3"},{"id":"1","source":"1","target":"4"}]},"type":null,"button":[],"buttonevent":[],"crosstalk":{"crosstalk_key":null,"crosstalk_group":null}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

