library(tmcn)
library(readxl)

data(NTUSD)
negative_dict <- NTUSD$negative_cht
positive_dict <- NTUSD$positive_cht

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

tokenize_content <- read_xlsx("Sentiment sample.xlsx")

negative_dict <- unique(negative_dict)
positive_dict <- unique(positive_dict)

weight <- rep(1, length(negative_dict))  
negative_dict <- cbind(negative_dict, weight) 
weight <- rep(-1, length(positive_dict))  
positive_dict <- cbind(positive_dict, weight)  

Semantic_dict <- rbind(positive_dict, negative_dict)
colnames(Semantic_dict)<-c("text","weight")

result <- merge(tokenize_content,Semantic_dict,by = "text",all.x = TRUE, sort =TRUE)

