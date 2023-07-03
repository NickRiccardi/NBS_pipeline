rm(list=ls(all.name=TRUE))
library(readxl)
library(stringr)
library(tidyverse)
data <- read_xlsx("new_results_3.5.xlsx", col_names = FALSE)
label <- read.table("AICHALabels.txt")
cog <- read.table("COG.txt")
ttest <- read_xlsx("new_ttest_3.5.xlsx", col_names = FALSE)

node1 <- data$...1
node2 <- data$...2
label1 <- as.character(label$V1[node1])
label2 <- as.character(label$V1[node2])
label1_1 <- substr(label1,1, nchar(label1)-4)
label1_2 <- substr(label1,nchar(label1), nchar(label1))
label1_new <- paste(label1_1, label1_2, sep="-")
label2_1 <- substr(label2,1, nchar(label2)-4)
label2_2 <- substr(label2,nchar(label2), nchar(label2))
label2_new <- paste(label2_1, label2_2, sep="-")

df.ttest <- data.frame(ttest=ttest$...1,
                       ttest_group=rep(NA,dim(data)[1]))
df.ttest$ttest_group[df.ttest$ttest<0] <- "*"
df.ttest$ttest_group[df.ttest$ttest>3.5 & df.ttest$ttest<4.5] <- "+"
df.ttest$ttest_group[df.ttest$ttest>4.5 & df.ttest$ttest<=5.5] <- "++"
df.ttest$ttest_group[df.ttest$ttest>5.5 ] <- "+++"
table(df.ttest$ttest_group)

df.ttest$connectivity1 <- label1
df.ttest$connectivity2 <- label2
df.ttest$connection <- paste(label1_new, '<-->', label2_new)
df.ttest$connectivity_new <- paste(df.ttest$ttest_group,  df.ttest$connection) 
df.ttest <- df.ttest %>% arrange(ttest)

uni.connct.all <- unique(df.ttest$connectivity_new)
write.csv(uni.connct.all, file="allconnection_Z.csv", quote = FALSE, row.names = FALSE, col.names = FALSE)

## Strongest Connection
df.ttest.strong <- df.ttest[df.ttest$ttest_group == "+++",]
uni.connct <- unique(df.ttest.strong$connection)
write.csv(uni.connct, file="strongconnection_Z.csv", quote = FALSE, row.names = FALSE, col.names = FALSE)
