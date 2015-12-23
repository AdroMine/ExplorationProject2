library(data.table)
library(RColorBrewer)

###Reading Data
code <- readRDS("Source_Classification_Code.rds")
df <- readRDS("summarySCC_PM25.rds")
dt <- as.data.table(df)
### Initial Reading done

## Extract total emissions from all sources for Baltimore
## The data.table implementation has been used here as well. 
baltimore <- "24510" ## fips id for Baltimore
emiss_balt <- dt[fips==baltimore,.(Total=sum(Emissions)),by=.(year)]
## subset rows where fips equals 24510, group them by year, and then compute sum for each.

## Again, a barplot here is the best way to visualise the changes in 
## total emissions over the years.

barplot(height = emiss_balt$Total,
        names.arg = emiss_balt$year,
        col=brewer.pal(4,"Set1"),
        main = "PM 2.5 Emissions in Baltimore-US (1999-2008)",
        xlab="Year",
        ylab="Emissions in tonnes"
        )

## copying plot screen to png file. A better method would have been to 
## create a png device, and directly plot to it. Especially useful if you
## want to change the resolution of the plot from the default 72ppi.
## using dev.copy in that situation leads to ugly graphics.
## But anyway, using dev.copy since more people are familiar with it.

dev.copy(png,"plot2.png",width = 500, height = 550,units = "px")
dev.off()

## The emissions have decreased from the 1999 levels, though the change has 
## been uneven.