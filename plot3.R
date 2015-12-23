library(data.table)
library(RColorBrewer)
library(ggplot2)

###Reading Data
code <- readRDS("Source_Classification_Code.rds")
df <- readRDS("summarySCC_PM25.rds")
dt <- as.data.table(df)
### Initial Reading done


## I have here taken the total emissions when grouped by both year and 
## emission source type. The data.table method was much faster than the other
## methods, and was hence used.
baltimore <- "24510" ## the code for Baltimore

## Extracting total emissions for Baltimore
balt2 <- dt[fips=="24510",.(Total=sum(Emissions)),by=.(year,type)]

## converting year to factor for better graphing in ggplot
balt2$year <- factor(balt2$year)


## Again using barplots to visualise the changes in emissions 
## for each point type through the years.

## First define the data to plot, grouped by year and colour to be filled by
## year as well.

g <- ggplot(balt2,
       aes(x=year,
           y=Total,
           group=year,
           fill=year)
       ) 
## Then adding the barplot, setting stat to "identity" which tells ggplot to look
## for height in the 'y' variable and using 'type' of emissions as 
## facetting variable

g <- g  + geom_bar(stat="identity") + facet_wrap(facets = ~type) 

## and finally using RcolorBrewer for colours.
g <- g  + scale_fill_brewer(palette = "Set1")
## Adding Title
g <- g  + ggtitle("PM 2.5 Emissions for different source types in Baltimore (1999-2008)")

## Changing varoius theme elements and printing
g + theme_bw() + theme(axis.text = element_text(size=12),
                       axis.title = element_text(size=16),
                       legend.position = "none",plot.title = element_text(size=18)) 
dev.copy(png,"plot3.png",width=700,heigh = 600)
dev.off()

## The changes for various categories can be easily visualised.