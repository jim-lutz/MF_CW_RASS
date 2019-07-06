# load_MF_CW.R
# script to load MF CW data from ./data/DT_RASS.Rdata
# and look at data
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

# look at DWLTYPE to see if it's multifamily
DT_RASS[ , list(n=length(wt)),by=DWLTYPE][order(DWLTYPE)]
  #    DWLTYPE     n
  # 1:       1 14263  Single-family detached house
  # 2:       2  1828  Townhouse, duplex, or row house
  # 3:       3  1900  Apartment or condominium (2 – 4 units)
  # 4:       4  4062  Apartment or condominium (5 or more units)
  # 5:       5  1703  Mobile home
  # 6:       6   300  Other
  # 7:      97  1665  NA?

# Do you have the use of laundry equipment in your home? (LNDRYEQP)
DT_RASS[ , list(n=length(wt)), by=LNDRYEQP]
#    LNDRYEQP     n 
# 1:        1 21291 Yes
# 2:        3  1046 No, laundry facilities are located in a common area of the building.
# 3:        2  3384 I do not use laundry facilities in my building 

# see about LNDRYEQP vs CWHWLD CWWWLD CWCWLD
DT_RASS[ , list(n=length(wt)), by=CWHWLD]

# tally clothes washer loads per week 
# but not 99 or 97
DT_RASS[CWHWLD==97 | CWHWLD==99, CWHWLD:=0]
DT_RASS[CWWWLD==97 | CWWWLD==99, CWWWLD:=0]
DT_RASS[CWCWLD==97 | CWCWLD==99, CWCWLD:=0]
DT_RASS[, CWLD:= CWHWLD + CWWWLD + CWCWLD ]

DT_RASS[ , list(n=length(wt)), by=CWLD][order(CWLD)]

# compare to DWLTYPE
DT_RASS[ LNDRYEQP==1 , list(ave_loads=mean(CWLD)),by=DWLTYPE]
#    DWLTYPE ave_loads
# 1:       2  4.235257
# 2:       1  4.856844
# 3:       5  3.980641
# 4:       4  3.667508
# 5:       3  3.891816
# 6:       6  4.242991
# 7:      97  4.557796

DT_RASS[ LNDRYEQP==2 , list(ave_loads=mean(CWLD)),by=DWLTYPE]
#    DWLTYPE ave_loads
# 1:       1         0
# 2:       4         0
# 3:       3         0
# 4:       2         0
# 5:      97         0
# 6:       5         0
# 7:       6         0

DT_RASS[ LNDRYEQP==3 , list(ave_loads=mean(CWLD)),by=DWLTYPE]
DWLTYPE ave_loads
# 1:       1         0
# 2:       4         0
# 3:       2         0
# 4:       3         0
# 5:       6         0
# 6:      97         0
# 7:       5         0


