# Introduction {#intro}

## Terms

"A network is not just a metaphor: it is a precise, mathematical construct of nodes (vertices, actors) N and edges (ties, relations) E that can be directed or undirected." [@jasneyIntroductionSocialNetwork2018]

<div class="figure">
<!--html_preserve--><div id="htmlwidget-f69b407c34d45d7ca582" style="width:50%;height:480px;" class="grViz html-widget"></div>
<script type="application/json" data-for="htmlwidget-f69b407c34d45d7ca582">{"x":{"diagram":"digraph {\n\ngraph [layout = \"neato\",\n       outputorder = \"edgesfirst\",\n       bgcolor = \"white\"]\n\nnode [fontname = \"Helvetica\",\n      fontsize = \"10\",\n      shape = \"circle\",\n      fixedsize = \"true\",\n      width = \"0.5\",\n      style = \"filled\",\n      fillcolor = \"aliceblue\",\n      color = \"gray70\",\n      fontcolor = \"gray50\"]\n\nedge [fontname = \"Helvetica\",\n     fontsize = \"8\",\n     len = \"1.5\",\n     color = \"gray80\",\n     arrowsize = \"0.5\"]\n\n  \"1\" [label = \"N1\", fillcolor = \"#F0F8FF\", fontcolor = \"#000000\"] \n  \"2\" [label = \"N2\", fillcolor = \"#F0F8FF\", fontcolor = \"#000000\"] \n  \"3\" [label = \"N3\", fillcolor = \"#F0F8FF\", fontcolor = \"#000000\"] \n  \"4\" [label = \"N4\", fillcolor = \"#F0F8FF\", fontcolor = \"#000000\"] \n  \"5\" [label = \"N5\", fillcolor = \"#F0F8FF\", fontcolor = \"#000000\"] \n  \"6\" [label = \"N6\", fillcolor = \"#F0F8FF\", fontcolor = \"#000000\"] \n  \"7\" [label = \"N7\", fillcolor = \"#F0F8FF\", fontcolor = \"#000000\"] \n  \"8\" [label = \"N8\", fillcolor = \"#F0F8FF\", fontcolor = \"#000000\"] \n  \"9\" [label = \"N9\", fillcolor = \"#F0F8FF\", fontcolor = \"#000000\"] \n  \"10\" [label = \"N10\", fillcolor = \"#F0F8FF\", fontcolor = \"#000000\"] \n  \"11\" [label = \"N11\", fillcolor = \"#F0F8FF\", fontcolor = \"#000000\"] \n  \"12\" [label = \"N12\", fillcolor = \"#F0F8FF\", fontcolor = \"#000000\"] \n}","config":{"engine":"dot","options":null}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->
<p class="caption">(\#fig:node-graph)a node</p>
</div>

## Input formats

Building a network graph is challenging because of the number of potential input types. Users must first distinguish whether the input is an adjacency matrix, incidence matrix, or edge list.  Then, the user must know if the graph is directed or undirected, weighted or unweighted. 
[@holtzNetworkGraphD32020]

### Adjacency matrix

An adjacency matrix is a square matrix where the number of rows and columns are the same. `igraph` can read an adjacency matrix using the `graph_from_adjacency_matrix()` function.

<div class="figure" style="text-align: center">
<img src="./imgs/jasney-adj-matrix.png" alt="Nodes with adjacency matrix.  [@jasneyIntroductionSocialNetwork2018]" width="65%" />
<p class="caption">(\#fig:jasney-adjacency-matrix)Nodes with adjacency matrix.  [@jasneyIntroductionSocialNetwork2018]</p>
</div>


### Incidence matrix

The rows and colunms of an incidence matrix do not have to be equal.  Its shape can be rectangular in addition to square. `igraph` can read an incidence matrix using the `graph_from_incidence_matrix()`.




### Edge list

An edge list has 2 columns. Each observation represents a connection between two things.  The two column names are alternatively named (1) an origin and a destination or (2)a source and target, depending on the package used.  The column names are often the key to a successful importation of the data.  `igraph` imports an edge list `graph_from_data_frame()` function.

<div class="figure" style="text-align: center">
<img src="./imgs/jasney-edge-table.png" alt="Nodes with edge list.  [@jasneyIntroductionSocialNetwork2018]" width="65%" />
<p class="caption">(\#fig:jasney-incidence-matrix)Nodes with edge list.  [@jasneyIntroductionSocialNetwork2018]</p>
</div>






### Dataframe distinguished

## R packages

Three `R` packages are dedicated to network analysis and are available for download from CRAN:  `igraph`, `ggraph`, and `networkD3`.


You can write citations, too. For example, we are using the **bookdown** package [@R-bookdown] in this sample book, which was built on top of R Markdown and **knitr** [@xie2015].
