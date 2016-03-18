#questions/comments to: Alice Parkes, parkes.alice@uqam.ca 514-987-3000, ext 1463
#2016-03-17
#this script makes a 2-panel biplot
#it plots several variables in 2 panels (or "facets"), one on top of the other, with a shared x-axis and the possibly of different y-axes
#STEP 1: import the data from a csv file in wide format
#time T1  AV   Vn   T4
#1    30  10   0.5  100
#2    25  12   0.4  150
#3    27  18   0.6  140

#STEP 2: "melt" the data into long format
#time variable value
#1    T1       30
#2    T1       25
#3    T1       27
#1    AV       10
#2    AV       12
#3    AV       18
#1    Vn       0.5
#2    Vn       0.4
#3    Vn       0.6
#1    T4       100
#2    T4       150
#3    T4       140

#STEP 3: add a column to indicate in which panel the data will be plotted
#time variable value  panel
#1    T1       30     T variables
#2    T1       25     T variables
#3    T1       27     T variables
#1    AV       10     V variables
#2    AV       12     V variables
#3    AV       18     V variables
#1    Vn       0.5    V variables
#2    Vn       0.4    V variables
#3    Vn       0.6    V variables
#1    T4       100    T variables
#2    T4       150    T variables
#3    T4       140    T variables

#STEP 4: plot with ggplot and facet_grid and save a jpg of the plot


setwd("/Users/aliceparkes/Documents/CarBBAS/R")
library(reshape)
library(ggplot2)

#STEP 1: import the data from a csv file with headers in wide format and examine it
GRIL <- read.table("2panelplotdata.csv", header=TRUE, sep=",", strip.white=TRUE)
str(GRIL)
dim(GRIL)

#STEP 2: "melt" the data into long format
GRIL.long <- melt(GRIL, id="time", variable_name="variable")
str(GRIL.long)
head(GRIL.long)
tail(GRIL.long)

#STEP 3: add a column to indicate in which panel the data will be plotted. There are many ways to build this categorical column. I just copied the variable name column, then assigned the panel based on the contents of the name.
#first copy variable name column
GRIL.long$panel <- GRIL.long$variable
#then substitute variable names that start with "T" with the label "T variables" or whatever you want (it will appear beside the panel in the graph)
#use the wildcard ".*" after the T
GRIL.long$panel <- gsub("T.*", "T variables", GRIL.long$panel)
#then substitute variable names that contain a "V" with the label "V variables" or whatever you want (it will appear beside the panel in the graph)
#use the wildcard ".*" before and after the V
GRIL.long$panel <- gsub(".*V.*", "V variables", GRIL.long$panel)
str(GRIL.long)
#check that every value was assigned a panel for plotting, using a frequency table
table(GRIL.long$panel)
#T variables V variables 
#          6           6 
#the panels will be in alphabetical order based on the panel label

#STEP 4: plot with ggplot and facets and save a jpg of the plot
#the "panel~." separates the data into facets according to the indication in the column called "panel"
#the scales="free_y" lets R use y-axes of different scales for each panel, so that they are appropriate for the range of values being plotted
#drop=FALSE means plot the variable even if there are no values for that variable (missing data) so you will see the variable listed in the legend, but no data will be plotted
p1 <- ggplot(data=GRIL.long, aes(x=time, y=value)) + geom_line(aes(colour=variable))
p1 + facet_grid(panel~., scales="free_y", drop=FALSE)

#save a jpg of the 2-panel plot
jpeg("2panelplot.jpg")
p1 <- ggplot(data=GRIL.long, aes(x=time, y=value)) + geom_line(aes(colour=variable))
p1 + facet_grid(panel~., scales="free_y", drop=FALSE)
dev.off()
#graphics.off() closes all open graphics, dev.off() closes only the last one open

#replacing "panel~." with "~variable", will make each variable appear in a separate panel
#if you have many variables, the panels (facets) will wrap and you can decide how many rows of panels, eg. with 40 variables, nrow=4 will make 4 rows of 10 panels each
jpeg("2panelplot_4panels.jpg")
p1 <- ggplot(data=GRIL.long, aes(x=time, y=value)) + geom_line()
p1 + facet_wrap(~variable, scales="free_y", drop=FALSE, nrow=2)
dev.off()

