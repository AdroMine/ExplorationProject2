library(data.table)
library(RColorBrewer)

###Reading Data
code <- readRDS("Source_Classification_Code.rds")
df <- readRDS("summarySCC_PM25.rds")
dt <- as.data.table(df)
### Initial Reading done


## To search for coal related sources, I used Short.Name variable as search field.
## This yielded 239 SCC IDs. 

## Now many among these many looked like they probably did not involve combustion 
## of coal for instance everything related to mining of coal. But since no specific
## details regarding coal combustion were provided (regarding which processes 
## to include), and since 239 really are way too many to read about in detail, I 
## am going to assume that all of these are our required IDs.
## And for instance if we take mining of coal, all of the emissions released in 
## that process are for ultimately to generate more emissions by combustion 
## of coal, so including them in the emissions related to coal isn't really 
## a big stretch.


## To extract the IDs, grep was used to find the word coal in SCC$Short.Name.
## grep returned the rownumbers, and the corresponding SCC were extracted and
## saved in "coal" variable
coal <- code$SCC[grep(pattern = "coal",ignore.case = TRUE,x = code$Short.Name)]


## data matching the SCC IDs of coal were extracted from the data.table.
## Here the data table implementation was used, which is different from
## base data.frame implementation and doesn't require comma within the brackets,
## and column names can be directly used within.
coalemis <- dt[SCC %in% coal]

## Now grouping this data by year and computing total emissions for each year.
coaltot <- coalemis[,.(Total=sum(Emissions)),by=.(year)]
coaltot$year <- factor(coaltot$year) # converting year to factor

## Again a barplot does a nice job visualising the changes in emissions caused
## by coal. Barplot has been drawn using base plotting system here.
with(coaltot,
     barplot(height = Total,
             names.arg = year,
             col=brewer.pal(4,"Set1"),
             main = "PM 2.5 Emissions from coal combustion \nrelated sources in US (1999-2008)",
             yaxt="n"))

## Again drawing axis labels by hand since default used scientific notation
## which doesn't look very good or intuitive.
marks <- seq(from=100,to = 500,by = 100) ## creating points
axis(side = 2,at = marks*10^3,labels = marks) ## drawing the y-axis & its labels.

mtext(text = "Year",side = 1,line = 3,font=4) ## X-axis label
mtext(text = "Emissions in '000 tonnes",side = 2,font = 4,padj = -3) ## Y-axis label

dev.copy(png,"plot4.png",width = 500, height = 500)
dev.off()

## The emissions seem to have decreased.