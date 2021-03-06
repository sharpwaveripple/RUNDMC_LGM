library(mice)
library(lavaan)
library(semTools)
library(psych)

datafile <- "data/RUNDMC_datasheet_long.csv"
df <- read.csv(datafile, header=T)

# Ratios
df$hvratio06 <- (df$hv06 / df$tbv06)*1000
df$hvratio11 <- (df$hv11 / df$tbv11)*1000
df$hvratio15 <- (df$hv15 / df$tbv15)*1000

df$wmhratio06 <- log((df$wmh06 / df$tbv06)*100000)
df$wmhratio11 <- log((df$wmh11 / df$tbv11)*100000)
df$wmhratio15 <- log((df$wmh15 / df$tbv15)*100000)

# Psychomotor speed
df$ps06 <- df$pp1sat06 + df$stroop1sat06 + df$stroop2sat06 + df$ldstcorrect06
df$ps11 <- df$pp1sat11 + df$stroop1sat11 + df$stroop2sat11 + df$ldstcorrect11
df$ps15 <- df$pp1sat15 + df$stroop1sat15 + df$stroop2sat15 + df$ldstcorrect15

# Memory
df$mem06 <- df$wvlt123correctmean06 + df$wvltdelayrecall06 + 
            df$reyimmrecalltotalscore06 +	df$reydelayrecalltotalscore06 +
            df$pp2sat06 + df$pp3sat06
df$mem11 <- df$wvlt123correctmean11 + df$wvltdelayrecall11 + 
            df$reyimmrecalltotalscore11 +	df$reydelayrecalltotalscore11 +
            df$pp2sat11 + df$pp3sat11
df$mem15 <- df$wvlt123correctmean15 + df$wvltdelayrecall15 + 
            df$reyimmrecalltotalscore15 +	df$reydelayrecalltotalscore15 +
            df$pp2sat15 + df$pp3sat15

# Executive function
df$exf06 <- df$fluencyanimals06 + df$fluencyjobs06 + df$stroopinterference06 +	df$vsattotalsat06
df$exf11 <- df$fluencyanimals11 + df$fluencyjobs11 + df$stroopinterference11 +	df$vsattotalsat11
df$exf15 <- df$fluencysupermarket15 + df$fluencyjobs15 + df$stroopinterference15 +	df$vsattotalsat15                         

df$psexf06 <- df$pp1sat06 + df$stroop1sat06 + df$stroop2sat06 + df$ldstcorrect06 +
  df$fluencyanimals06 + df$fluencyjobs06 + df$stroopinterference06 +	df$vsattotalsat06
df$psexf11 <- df$pp1sat11 + df$stroop1sat11 + df$stroop2sat11 + df$ldstcorrect11 +
  df$fluencyanimals11 + df$fluencyjobs11 + df$stroopinterference11 +	df$vsattotalsat11
df$psexf15 <- df$pp1sat15 + df$stroop1sat15 + df$stroop2sat15 + df$ldstcorrect15 +
  df$fluencysupermarket15 + df$fluencyjobs15 + df$stroopinterference15 +	df$vsattotalsat15


# Correlations
variables <- c("wmh06", "wmhratio06", "hv06", "hvratio06", "ps06", "mem06", "exf06", "psexf06",
                 "wmh11", "wmhratio11", "hv11", "hvratio11", "ps11", "mem11", "exf11", "psexf11",
                 "wmh15", "wmhratio15", "hv15", "hvratio15", "ps15", "mem15", "exf15", "psexf15")
df.var <- df[variables]

df.var.incl <- df.var[complete.cases(df.var), ]

variables06 <- c("wmh06", "hv06", "ps06", "mem06", "exf06", "psexf06")
df.var.incl06 <- df.var.incl[variables06]
variables11 <- c("wmh11", "hv11", "ps11", "mem11", "exf11", "psexf11")
df.var.incl11 <- df.var.incl[variables11]
variables15 <- c("wmh15", "hv15", "ps15", "mem15", "exf15", "psexf15")
df.var.incl15 <- df.var.incl[variables15]

corr06.mat <- corr.test(df.var.incl06)
corr11.mat <- corr.test(df.var.incl11)
corr15.mat <- corr.test(df.var.incl15)



# Table
df.cross.wmh <- as.data.frame(matrix(0, ncol=6, nrow=4))
df.cross.wmh[1:4,1] <- round(corr06.mat$r[2:5,1], digits=3)
df.cross.wmh[1:4,3] <- round(corr11.mat$r[2:5,1], digits=3)
df.cross.wmh[1:4,5] <- round(corr15.mat$r[2:5,1], digits=3)
df.cross.wmh[1:4,2] <- round(corr06.mat$p[2:5,1], digits=3)
df.cross.wmh[1:4,4] <- round(corr11.mat$p[2:5,1], digits=3)
df.cross.wmh[1:4,6] <- round(corr15.mat$p[2:5,1], digits=3)
rownames(df.cross.wmh) <- c("hv", "psychomotor speed", "memory", "executive function")
colnames(df.cross.wmh) <- c("wmh06", "p-val", "wmh11", "p-val", "wmh15", "p-val")

df.cross.hv <- as.data.frame(matrix(0, ncol=6, nrow=4))
df.cross.hv[1,1] <- round(corr06.mat$r[1,2], digits=3)
df.cross.hv[2:4,1] <- round(corr06.mat$r[3:5,2], digits=3)
df.cross.hv[1,3] <- round(corr11.mat$r[1,2], digits=3)
df.cross.hv[2:4,3] <- round(corr11.mat$r[3:5,2], digits=3)
df.cross.hv[1,5] <- round(corr15.mat$r[1,2], digits=3)
df.cross.hv[2:4,5] <- round(corr15.mat$r[3:5,2], digits=3)
df.cross.hv[1,2] <- round(corr06.mat$p[2,1], digits=3)
df.cross.hv[2:4,2] <- round(corr06.mat$p[3:5,2], digits=3)
df.cross.hv[1,4] <- round(corr11.mat$p[2,1], digits=3)
df.cross.hv[2:4,4] <- round(corr11.mat$p[3:5,2], digits=3)
df.cross.hv[1,6] <- round(corr15.mat$p[2,1], digits=3)
df.cross.hv[2:4,6] <- round(corr15.mat$p[3:5,2], digits=3)
rownames(df.cross.hv) <- c("wmh", "psychomotor speed", "memory", "executive function")
colnames(df.cross.hv) <- c("hv06", "p-val", "hv11", "p-val", "hv15", "p-val")


# ratios
variables15ratio <- c("wmhratio15", "hvratio15", "mem15", "ps15", "exf15", "psexf15")
df.var.incl15ratio <- df.var.incl[variables15ratio]
corr15ratio.mat <- corr.test(df.var.incl15ratio)

variables06ratio <- c("wmhratio06", "hvratio06", "mem06", "ps06", "exf06", "psexf06")
df.var.incl06ratio <- df.var.incl[variables06ratio]
corr06ratio.mat <- corr.test(df.var.incl06ratio)

variables11ratio <- c("wmhratio11", "hvratio11", "mem11", "ps11", "exf11", "psexf11")
df.var.incl11ratio <- df.var.incl[variables11ratio]
corr11ratio.mat <- corr.test(df.var.incl11ratio)
