library(readxl)
library(stringr)
library(tidyverse)
data <- read_xlsx("new_results_3.5.xlsx", col_names = FALSE)
#data <- read_xlsx("Results_5.0.xlsx", col_names = FALSE)

label <- read.table("AICHALabels.txt")
cog <- read.table("COG.txt")
ttest <- read_xlsx("new_ttest_3.5.xlsx", col_names = FALSE)
node1 <- data$...1
node2 <- data$...2

node1_uni <- unique(node1)
node2_uni <- unique(node2)

nodes <- c(node1,node2)
nodes_uni <- unique(nodes)

nodes_sort <- sort(nodes_uni)

label_select <- as.character(label$V1[nodes_sort])
cog_select_1 <- cog$V1[nodes_sort]
cog_select_2 <- cog$V2[nodes_sort]
cog_select_3 <- cog$V3[nodes_sort]
color <- rep(1, length(nodes_sort))
color[substr(label_select,nchar(label_select) ,nchar(label_select)) == "R"] <- 2
ind <- grep("-", strsplit(label_select, "")[[1]])

# label file
loc1 <- str_locate(label_select,"-")[,1]
label_output <- rep("",length(loc1))
for (i in 1:length(loc1)) {
  temp <- label_select[i]
  label_output[i] <- substr(temp,1,loc1[i]-1)
}
label_output <- str_replace_all(label_output, "_", "-")
label_output2 <- str_replace_all(label_select, "_", "-")
write.csv(label_output2, file = "new_XLabel_3.5_Z.csv", 
         quote = FALSE, row.names = FALSE, col.names = FALSE)

# node file
df_label <- data.frame(label = label_select,
                       label_group = label_output,
                       color = as.numeric(as.factor(label_output)))
# df_label <- df_label %>% 
#   mutate(color = as.numeric(as.factor(label_group)))
label_ind <- (as.numeric(!duplicated(df_label$color)) + 1)/1000 + 0.999
results_label <- data.frame(cog_select_1,cog_select_2,cog_select_3,
                            #df_label$color, 
                            color,
                            label_ind,df_label$label_group)
write.table(results_label,"nodes.txt", 
            row.names  = FALSE, col.names = FALSE, 
            sep = "      ",quote = FALSE)

# edge file
data <- as.data.frame(data)
matrix_edge <- matrix(0,ncol = length(nodes_uni), nrow = length(nodes_uni))
df_edge <- as.data.frame(matrix_edge)
row.names(df_edge) <- as.character(sort(nodes_uni))
colnames(df_edge) <- as.character(sort(nodes_uni))
# str_replace_all(df_label.label_group,"_","-")
index <- data[,1:2]
for (i in 1:nrow(data[,1:2])) {
  indexi <- as.numeric(index[i,])
  df_edge[as.character(indexi[1]),as.character(indexi[2])] <- 1
  #df_edge[as.character(indexi[2]),as.character(indexi[1])] <- 1
}
df_edge[as.character(indexi[1]),as.character(indexi[2])]
sum(df_edge == 1)
write.table(df_edge,"edge.txt",row.names  = FALSE, col.names = FALSE, sep = "   ")