library(data.table)
library(RColorBrewer)

###Reading Data
code <- readRDS("Source_Classification_Code.rds")
df <- readRDS("summarySCC_PM25.rds")
dt <- as.data.table(df)
### Initial Reading done

## To search for motor vehicles, I used SCC.Level.Three which only generated either
## motor vehicles or motorcycles when I searched for "motor". Searching Short.Name
## also returned rocket motor which was clearly not what we were looking for, 
## and excluded motorcycles when searching using motor vehicle. Now I believe 
## motorcycles should be included as well, and the simplest way to do everything 
## seemed to be the use SCC.Level.Three for searching

## Also, with "motor vehicle" instead of motor, only two records were obtained
## for Baltimore. Using just "motor" returned 88 records.


## Using grep to find row IDs of our required source of pollution and storing the
## SCC IDs in variable "mv".
mv <- code$SCC[grep(pattern = "motor",ignore.case = TRUE,x = code$SCC.Level.Three)]

## Extracting emissions data for baltimore city caused by motor vehicles.

baltimore <- "24510" ## the code for Baltimore

## This is again using data.table and its methods.
mvbalt <- dt[SCC %in% mv & fips==baltimore]

## computing total emissions by year
mvtot <- mvbalt[,.(Total=sum(Emissions)),by=.(year)]

## Again using barplot to show the change in emissions over the years.
with(mvtot,
     barplot(height = Total,
             names.arg = year,
             col=brewer.pal(4,"Set1"),
             main = "PM 2.5 Emissions from motor vehicles \n in Baltimore (1999-2008)"))

## Setting X and Y headings
mtext(text = "Year",side = 1,line = 2,font=4)
mtext(text = "Emissions in tonnes",side = 2,font = 4,padj = -3)

## copying to png file.
dev.copy(png,"plot5.png",width = 500, height = 500, units = "px")
dev.off()

## The plot here has pretty much similar emissions in 1999 and 2008, but vastly
## increased emissions in the years between. Strange... 