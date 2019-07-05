# load_RASS.R
# script to read RASS data from ./data/Survdata.csv
# saves data to ./data/DT_RASS.Rdata
# started by Jim Lutz "Fri Jul  5 16:36:03 2019"

# set packages & etc
source("setup.R")

# setup  working directories
# use this for scripts 
wd <- getwd()
wd_data    <- paste(wd,"/data/",sep="")      # use this for interim data files
wd_charts  <-paste(wd,"/charts/",sep="")     # use this for charts, ggsave puts in /

# read the Survdata.csv
DT_RASS <-
  fread(file = paste0(wd_data,"Survdata.csv"))

# see what's there
length(names(DT_RASS))
# [1] 564
nrow(DT_RASS)
# [1] 25721

# save as an .Rdata file
save(DT_RASS, file = "data/DT_RASS.Rdata")

# look for weight
grep("wt",names(DT_RASS), value = TRUE)

# 'wt' is in there.
summary(DT_RASS$wt)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 14.3   119.7   201.9   448.0   248.4 14703.3 
# seems about right

sum(DT_RASS$wt)
# [1] 11523719
# looks about right

# look at distribution of wt
ggplot(data = DT_RASS, aes(x=1:25721, y=sort(wt))) +
  geom_step() + scale_y_log10() 

# look for pwhfuel3, Cleaned primary water heater fuel
DT_RASS[,list(weight = sum(wt)), by=pwhfuel3 ][order(-weight)]

