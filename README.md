# StataPostProduce
A Stata package that translates gr_edit commands into user-friendly codes.

## Installation
To install this program, just copy and paste the following line in your Stata prompt:
'''
net install gr_postproduce, from("https://raw.githubusercontent.com/DiegoCiccia/StataPostProduce/main") replace
'''

## The One Piece of Stata Programming
It has been more than 15 years since the first [posts](https://www.stata.com/statalist/archive/2007-07/msg00616.html) (complaining) about gr_edit were uploaded to Statalist. For those of you who are unfamiliar with gr_edit, it is a Stata command that allows the user to edit .gph files (Stata graphs) after they are generated. In principle, it is a very useful routine: you can use it for re-format graphs made by other people or you can modify figures which are printed in their default setting through external packages. One can also do the same tasks manually, through the graph editor. However, there are two problems in doing so:

1. this manual procedure cannot be nested in *loops*, therefore one has to change the settings of every graph, which may become quite cumbersome in case of large projects;
2. this manual procedure is not *replicable*, in the sense that it is performed outside programming routines and, if it is used to produce content for academic research, it would be necessary to provide a set of clear instructions for referees and/or other researchers about how to obtain the final images from their raw versions.

One may wonder: if it is *that* important, or, at least, convenient, to be able to post-produce graphs by code, then Stata would offer comprehensive and exhaustive documentation about this routine, *right*?

**Wrong**. As of Stata18, the gr_edit command remains without any official documentation:

![image](https://github.com/DiegoCiccia/StataPostProduce/assets/71022390/b07676b2-f6fa-451d-9c1f-d7d96ce7daa5)

Despite this, one can freely use gr_edit, even though simple commands, like, for instance, changing the title of a graph, look like line 4 of the following code block:

```
sysuse auto
scatter price mpg, saving(ex_graph.gph, replace)
graph use ex_graph.gph
gr_edit .title.text = {"Scatter Graph"}
graph close
erase ex_graph.gph
```




