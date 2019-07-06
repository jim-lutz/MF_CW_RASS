# load_MF_CW.R
# script to load MF CW data from ./data/DT_RASS.Rdata
# and make plots
# started by Jim Lutz "Fri Jul  5 16:54:07 2019"

# set packages & etc
source("setup.R")

# setup  working directories
# use this for scripts 
wd <- getwd()
wd_data    <- paste(wd,"/data/",sep="")      # use this for interim data files
wd_charts  <-paste(wd,"/charts/",sep="")     # use this for charts, ggsave puts in /

# load the .Rdata file
load(file = "data/DT_RASS.Rdata")

# look at the data
# see ./data/2009_RASS_survey_with_variables.pdf
# and ./data/SurvCONTENTS.pdf

# number of occupants
DT_RASS$numi

# look for anything like number of occupants
grep("num",names(DT_RASS), value = TRUE)

# look at summary of numi
summary(DT_RASS$numi)
  #  Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
  # 1.000   2.000   2.000   2.647   3.000  42.000    1257 
# Max = 42?, NA's = 1257?

DT_RASS[,list(n=sum(numi, na.rm = TRUE)), by=numi]
# lot of fractional values of numi?

DT_RASS[numi==2.915720, list(NR0_5,
                             NR6_18,
                             NR19_34,
                             NR35_54,
                             NR55_64,
                             NR65_99) ]
# mostly 97 and 0?
summary(DT_RASS$NR0_5)
  #  Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
  # 0.000   0.000   0.000   1.399   0.000  97.000 

# assume 97 = NA, sum wt Sample Weight by NR0_5
DT_RASS[NR0_5!=97, list(n=sum(wt)),by=NR0_5][order(NR0_5)]


# look at distribution of number of occupants
ggplot(data = DT_RASS[NR0_5!=97], aes(x=NR0_5, y=wt) ) +
  geom_col()





