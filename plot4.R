plot4 <- function() {
    #load necessary libraries
    library(dplyr)
    
    #create temp file and download file into it
    tf <- tempfile()
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", tf)
    
    #unzip and read the data from the file
    pow_consumption <- read.table(unz(tf,"household_power_consumption.txt"), sep = ";", colClasses = c(rep("character",2),rep("numeric",7)), header = TRUE, na.strings = "?")
    unlink(tf)
    
    #turn the Date column into a Date class and then filter the data set to include only the 2 days we're interested in
    pow_consumption <- mutate(pow_consumption, Date = as.Date(Date, "%d/%m/%Y"))
    minDate <- as.Date("2007-02-01")
    maxDate <- as.Date("2007-02-02")
    pow_consumption <- filter(pow_consumption, Date >= minDate & Date <= maxDate)
    
    #convert Time column to POSIXct
    pow_consumption <- mutate(pow_consumption, Time = as.POSIXct(paste(Date,Time," ")))
    
    #create png graphics device to store the plot
    png("plot4.png")
    
    #set num rows and cols and adjust margins
    par(mfrow = c(2,2), mar = c(4,4,2,1))
    
    #plot the Global Active Power
    plot(pow_consumption$Time, pow_consumption$Global_active_power, type = "l", ylab = "Global Active Power", xlab = "")
    
    #plot Voltage
    plot(pow_consumption$Time, pow_consumption$Voltage, type = "l", ylab = "Voltage", xlab = "datetime")
    
    #plot Energy Sub Metering
    plot(pow_consumption$Time, pow_consumption$Sub_metering_1, type = "l", ylab = "Energy sub metering", xlab = "")
    lines(pow_consumption$Time, pow_consumption$Sub_metering_2, col = "red")
    lines(pow_consumption$Time, pow_consumption$Sub_metering_3, col = "blue")
    legend("topright", lty = 1, col = c("black","red","blue"), legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), bty = "n")
    
    #plot Global Reactive Power
    plot(pow_consumption$Time, pow_consumption$Global_reactive_power, type = "l", ylab = "Global_reactive_power", xlab = "datetime")
    
    #close the graphics device
    dev.off()
}
