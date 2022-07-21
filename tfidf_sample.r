library(magrittr)
library(tidytext)
library(ggplot2)
library(dplyr)

#設定工作目錄
setwd("F:/TA/SICSS/tfidf_samples")
#載入資料集
p1 <- read.delim("sample1.txt", header = F, sep = "\n")
p2 <- read.delim("sample2.txt", header = F, sep = "\n")
p3 <- read.delim("sample3.txt", header = F, sep = "\n")
p4 <- read.delim("sample4.txt", header = F, sep = "\n")
p5 <- read.delim("sample5.txt", header = F, sep = "\n")
#合併並標上檔案編號
ps <- rbind(p1, p2, p3, p4, p5)
ps <- bind_cols(doc = paste("p", c(rep(1, 6), rep(2, 7), rep(3, 7), rep(4, 6), rep(5,7)), sep = '') , ps)

#拆分成詞並計算各詞出現次數
words <- ps %>% 
  unnest_tokens(word, V1) %>% 
  count(doc, word, sort = T)

#計算各檔案總字數
total_words <- words %>% 
  group_by(doc) %>%
  summarize(total = sum(n))

words <- left_join(words, total_words)

#加入TF欄位
words <- words %>% mutate('tf' = n/total)
#可視化TF
ggplot(words, aes(tf, fill = doc)) +
  geom_histogram(show.legend = F) +
  facet_wrap(~doc, ncol = 2, scales = "free_y")

#加入IDF及TFIDF欄位
words <- words %>% bind_tf_idf(word, doc, n)