# StataPostProduce
A Stata package that translates gr_edit commands into user-friendly codes.
BETA VERSION

## Setup
To install this program, just copy and paste the following line in your Stata prompt:

```
net install gr_postproduce, from("https://raw.githubusercontent.com/DiegoCiccia/StataPostProduce/main") replace
```

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

## A brute force solution
One way to solve this problem is to do some reverse engineering, that is, collect all the instances of gr_edit commands under a single program. This is the philosophy of gr_postproduce. Let's generate a graph:
```
clear
set obs 50
set seed 0
gen v1 = uniform()
gen v2 = v1 * -2 + uniform() 
gen v3 = uniform()
scatter v1 v2 || scatter v1 v3 || lfit v1 v2, saving("demo.gph", replace) leg(pos(6) cols(3))

```
![demo](https://github.com/DiegoCiccia/StataPostProduce/assets/71022390/c96307e8-4e21-4cc5-b288-ffd36fccecc7)

Assume that you got demo.gph without its source code and you want to change its design (add a title, add axes titles, change the colors, ...). One way to do it would be through the following gr_edit commands:
```
gr_edit .title.text = {"Demo"} 
gr_edit .xaxis1.title.text = {"x title"} 
gr_edit .yaxis1.title.text = {"y title"} 
gr_edit .plotregion1.plot1.style.editstyle marker(fillcolor(red)) editcopy 
gr_edit .plotregion1.plot1.style.editstyle marker(linestyle(color(red))) editcopy 
gr_edit .plotregion1.plot2.style.editstyle marker(size(1)) editcopy 
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(blue)) editcopy 
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(blue))) editcopy 
gr_edit .plotregion1.plot3.style.editstyle line(pattern(solid)) editcopy 
gr_edit .plotregion1.plot3.style.editstyle line(color(black)) editcopy 
gr_edit .legend.plotregion1.label[1].text = {} 
gr_edit .legend.plotregion1.label[1].text.Arrpush First Variable 
gr_edit .legend.plotregion1.label[2].text = {} 
gr_edit .legend.plotregion1.label[2].text.Arrpush Second Variable 
```
The syntax above is quite complex and cannot be learned from official documentation. The only way to learn gr_edit is by recording the manual changes to existing graphs. This is a procedure that is [documented])(https://www.stata.com/support/faqs/graphics/graph-recorder/) in Stata. 

This program is meant to be a "translator" from Stata syntax to gr_edit. You can use the following line to replicate the edited graph:

```
gr_postproduce demo, title("Demo") xtitle("x title") ytitle("y title") obj(1 mc(red), 2 msiz(1) mc(blue), 3 lp(solid) lc(black)) leg_rename("First Variable", "Second Variable")
```
A lot more familiar, I suppose. Notice the *obj* options: it applies new options to each of the 3 graph objects in the figure (two scatters and a linear fit). Let's see the updated graph:

![demo_post](https://github.com/DiegoCiccia/StataPostProduce/assets/71022390/91cc2bf1-bc80-4e07-af22-cace412d6267)

## Next steps

So far, this command can set new titles, change colors and patterns of graph objects and change the content and position of the legend. There are several ways to improve on that. However, due to the coding strategy of this command, all new developments critically hinge on the analysis of .grec files which are generated through the Stata Graph Recorder. Therefore, keep me updated on what is currently missing and share with me any feature that you would like to incorporate in this command.
