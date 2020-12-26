# DiagrammeR Package {#DiagR}

Hello world.


```r
library(DiagrammeR)
#graph 1 - nodes only
n <- 5
ndf <-
  create_node_df(
    n = n,
    label = paste0("N", 1:n)
  )
graph1 <- create_graph(nodes_df = ndf)
graph1 %>% render_graph(layout = "nicely")
```

```
## Warning: The `x` argument of `as_tibble.matrix()` must have column names if `.name_repair` is omitted as of tibble 2.0.0.
## Using compatibility `.name_repair`.
## This warning is displayed once every 8 hours.
## Call `lifecycle::last_warnings()` to see where this warning was generated.
```

<div class="figure" style="text-align: center">
<!--html_preserve--><div id="htmlwidget-1e8199e26db46346a32c" style="width:50%;height:480px;" class="grViz html-widget"></div>
<script type="application/json" data-for="htmlwidget-1e8199e26db46346a32c">{"x":{"diagram":"digraph {\n\ngraph [layout = \"neato\",\n       outputorder = \"edgesfirst\",\n       bgcolor = \"white\"]\n\nnode [fontname = \"Helvetica\",\n      fontsize = \"10\",\n      shape = \"circle\",\n      fixedsize = \"true\",\n      width = \"0.5\",\n      style = \"filled\",\n      fillcolor = \"aliceblue\",\n      color = \"gray70\",\n      fontcolor = \"gray50\"]\n\nedge [fontname = \"Helvetica\",\n     fontsize = \"8\",\n     len = \"1.5\",\n     color = \"gray80\",\n     arrowsize = \"0.5\"]\n\n  \"1\" [label = \"N1\", fillcolor = \"#F0F8FF\", fontcolor = \"#000000\", pos = \"123.128722586983,117.074019730452!\"] \n  \"2\" [label = \"N2\", fillcolor = \"#F0F8FF\", fontcolor = \"#000000\", pos = \"122.593185858356,118.604368582682!\"] \n  \"3\" [label = \"N3\", fillcolor = \"#F0F8FF\", fontcolor = \"#000000\", pos = \"121.837401264965,116.088037641171!\"] \n  \"4\" [label = \"N4\", fillcolor = \"#F0F8FF\", fontcolor = \"#000000\", pos = \"120.503824114065,117.017398823553!\"] \n  \"5\" [label = \"N5\", fillcolor = \"#F0F8FF\", fontcolor = \"#000000\", pos = \"120.969098347455,118.567911965101!\"] \n}","config":{"engine":"dot","options":null}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->
<p class="caption">(\#fig:unconnected-node-graph)unconnected nodes</p>
</div>


```r
#graph 2 - connection
edf <-
  create_edge_df(
    from = rep(2, n),
    to   = 1:n,
    rel  = letters[1:n]
  )
graph2 <- create_graph(nodes_df = ndf, edges_df = edf)
graph2 %>% render_graph(layout = "nicely",
                        output = "visNetwork")
```

<div class="figure" style="text-align: center">
<!--html_preserve--><div id="htmlwidget-3a33224ff5de189682a9" style="width:50%;height:480px;" class="visNetwork html-widget"></div>
<script type="application/json" data-for="htmlwidget-3a33224ff5de189682a9">{"x":{"nodes":{"id":[1,2,3,4,5],"group":[null,null,null,null,null],"label":["N1","N2","N3","N4","N5"]},"edges":{"id":[1,2,3,4,5],"from":[2,2,2,2,2],"to":[1,2,3,4,5],"label":["a","b","c","d","e"]},"nodesToDataframe":true,"edgesToDataframe":true,"options":{"width":"100%","height":"100%","nodes":{"shape":"dot"},"manipulation":{"enabled":false},"edges":{"arrows":{"to":{"enabled":true,"scaleFactor":1}}},"physics":{"solver":"barnesHut","stabilization":{"enabled":true,"onlyDynamicEdges":false,"fit":true}},"layout":{"improvedLayout":true}},"groups":[null],"width":null,"height":null,"idselection":{"enabled":false},"byselection":{"enabled":false},"main":null,"submain":null,"footer":null,"background":"rgba(0, 0, 0, 0)"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->
<p class="caption">(\#fig:connected-node-diagram)connected nodes with edges labeled</p>
</div>


```r
#graph3--add attributes
n <- 5
ndf <-
  create_node_df(
    n = n,
    label = paste0("N", 1:n),
    type = "a",
    style = "filled",
    color = "aqua",
    shape = c(rep("circle", n-1), "triangle")
  )

edf <-
  create_edge_df(
    from = rep(2, n),
    to = 1:n,
    rel = letters[1:5],
    length = seq(from = 50,
                 to = n * 50,
                 by = 50),
    color = c("green", "red", "yellow", "blue", "brown"),
    width = seq(from = 2, 
                to = 10, 
                by = 2
    )
    )
edf
```

```
##   id from to rel length  color width
## 1  1    2  1   a     50  green     2
## 2  2    2  2   b    100    red     4
## 3  3    2  3   c    150 yellow     6
## 4  4    2  4   d    200   blue     8
## 5  5    2  5   e    250  brown    10
```

```r
graph3 <- create_graph(nodes_df = ndf, edges_df = edf)
graph3 %>% render_graph(output = "visNetwork",
                        layout = "tree")
```

<div class="figure" style="text-align: center">
<!--html_preserve--><div id="htmlwidget-0608ed9c863b5f8f7a3e" style="width:50%;height:480px;" class="visNetwork html-widget"></div>
<script type="application/json" data-for="htmlwidget-0608ed9c863b5f8f7a3e">{"x":{"nodes":{"id":[1,2,3,4,5],"group":["a","a","a","a","a"],"label":["N1","N2","N3","N4","N5"],"style":["filled","filled","filled","filled","filled"],"color":["aqua","aqua","aqua","aqua","aqua"],"shape":["circle","circle","circle","circle","triangle"]},"edges":{"id":[1,2,3,4,5],"from":[2,2,2,2,2],"to":[1,2,3,4,5],"label":["a","b","c","d","e"],"length":[50,100,150,200,250],"color":["green","red","yellow","blue","brown"],"width":[2,4,6,8,10]},"nodesToDataframe":true,"edgesToDataframe":true,"options":{"width":"100%","height":"100%","nodes":{"shape":"dot"},"manipulation":{"enabled":false},"edges":{"arrows":{"to":{"enabled":true,"scaleFactor":1}}},"physics":{"solver":"barnesHut","stabilization":{"enabled":true,"onlyDynamicEdges":false,"fit":true}},"layout":{"improvedLayout":true}},"groups":["a"],"width":null,"height":null,"idselection":{"enabled":false},"byselection":{"enabled":false},"main":null,"submain":null,"footer":null,"background":"rgba(0, 0, 0, 0)"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->
<p class="caption">(\#fig:connected-nodes-with-attributes)connected nodes with attributes</p>
</div>

