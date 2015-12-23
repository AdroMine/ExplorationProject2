library(data.table)
library(RColorBrewer)

## Reading Data
code <- readRDS("Source_Classification_Code.rds")
df <- readRDS("summarySCC_PM25.rds")
dt <- as.data.table(df)
## Initial Reading done


## Extracting relevant data.

## Grouping data by year, and then summing over each year to get the 
## total emissions in each year from all sources.
## This has been done using data.table implementation where
## we use dt[i,j,k] which returns for a data.table dt
## i rows, on which j has been applied after grouping by k.
## Also column names can be directly called inside [] of data tables.

emis <- dt[,.(Total=sum(Emissions)),by=.(year)]


## Now drawing a barplot to visualise the total emissions each year.
## A barplot can instantly visualise changes in emission levels over the years.
with(emis,barplot(height = Total,
                  names.arg = year,
                  col=brewer.pal(4,"Set1"),
                  main = "PM 2.5 Emissions in US (1999-2008)",
                  yaxt="n"
                  ))

## drawing y axis separately, since the default method uses scientific notation.
## so displaying in thousands tonnes.
marks <- seq(from = 0,to = 8000,by = 2000) ## The initial range was from 2E06-8E06

axis(side = 2,
     at = marks * 10 ^ 3,
     labels = marks) # draw the y axis tick marks and values at the given locations

### Write labels at the different places.
mtext(text = "Year",side = 1,line = 2,font=4) ## Create the X-axis label

mtext(text = "PM 2.5 Emissions in '000 tonnes",
      side = 2,font = 4,padj = -3) ## Create the Y-axis label

dev.copy(png,"plot1.png",width = 500, height = 450, units = "px")
dev.off()

## Emissions have decreased over the years.