library(data.table)
library(RColorBrewer)

###Reading Data
code <- readRDS("Source_Classification_Code.rds")
df <- readRDS("summarySCC_PM25.rds")
dt <- as.data.table(df)
### Initial Reading done

baltimore <- "24510" ## the code for Baltimore
california <- "06037" ## the code for California

## Again searching for motor vehicle in the same manner as in the previous question.

## Using grep to find row IDs of our required source of pollution and storing the
## SCC IDs in variable "mv".
mv <- code$SCC[grep(pattern = "motor",ignore.case = TRUE,x = code$SCC.Level.Three)]

## Extracting data regarding emissions caused by motor vehicles in 
## Baltimore and California.
## Again, this is using data.table and its methods
mvbaca <- dt[SCC %in% mv & (fips==baltimore | fips==california)]

## Computing total emissions after grouping by year and city combined.
mvbacatot <- mvbaca[,.(Total=sum(Emissions)),by=.(year,fips)]

## converting year and fips to factor
mvbacatot$year <- as.factor(mvbacatot$year)
mvbacatot$fips <- as.factor(mvbacatot$fips)

## renaming levels of fips
levels(mvbacatot$fips) <- c("California","Baltimore")


## Now there are various ways to compute change for the two places over the years.
## A simple method, which I use here is to compute the range of total emissions
## from all motor vehicles over the years. Or explicitly compute (Max - Min) for the 
## total emissions calculated earlier in mvbacatot table for each place. 

## Calculating range from the data table and storing it in variable Range.
Range <- mvbacatot[,.(Change = max(Total)-min(Total)),by=fips]

## Now drawing up a barchart to visualise these changes.
with(Range,
     barplot(Change,
             names.arg = fips,
             col=brewer.pal(3,"Set1"),
             main = expression(paste("Max Emission",phantom(0)-phantom(0),"Min Emission")),
             ylab = "Emissions in tonnes"
             ))
## Used expression() here for better subtraction symbol.
dev.copy(png,"plot6.png",width = 500, height = 500)
dev.off()

## California has seen greater change in its maximum versus minimum for the given years.

## Another method would be to compute the difference between the starting and end years.

## Yet another would be to compute the magnitude of change, the max/min value, which would
## give opposite results from this one, and show Baltimore to have witnessed the greater
## change in magnitude. We could also compute the percent change in values between the two 
## years, or compare the covariance.