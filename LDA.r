library(reticulate)
library(tm)

library(data.table)
library(dplyr)
library(ggplot2)
library(magrittr)
library(tidyr)
library(tidytext)
library(topicmodels)

use_virtualenv('C:/python_venv/venv2/', required = TRUE)
py_config()

ckip = import("ckiptagger")

ws = ckip$WS("./data")

sentence_list <- list(
  "這幾年來，在國軍的攜手努力下，我們積極推動的軍事改革、國防自主政策，都有很好的進展，包括國艦國造、國機國造等，都能按照既定期程執行，有效提升國防戰力。
  今天，在陸海空軍晉任將官勗勉典禮，我也期許我們國軍領導幹部，持續為國家培養人才，一起讓國軍的戰力不斷精進。
  當前，我們面對疫情的挑戰，以及瞬息萬變的國際情勢，我們國軍不僅不能有任何鬆懈，更要持續強化守護國家安全的力量，讓世界看見我們保家衛國的決心。
  特別是從疫情爆發以來，我們的國軍官兵秉持著「防疫視同作戰」的精神，積極投入各項防疫作為。只要當國人有需要的時候，就會立刻出動協助、支援。
  國軍是守護國家、保衛人民的堅實屏障，相信國人對國軍官兵的付出都深受感動，也非常肯定。身為三軍統帥，我也同感光榮。
  我也藉著今天，感謝國軍家人的支持，成為國軍進步的最大動力。我們會繼續努力，推動國防政策，守衛家園！"
  ,
  "最近，在疫情的挑戰下，我們仍有許多體育選手在國際舞台上表現精采，展現台灣的體育實力。
  下個月，第11屆 #世界運動會 也將在美國伯明罕舉行。今天，我來為我們的代表團授旗，期許選手們都能在世界賽場上發光發熱！
  其中，我們的女子拔河隊從2005年世運會開始，就奪下了連續4屆的金牌，這次更要以5連霸為目標。健力代表隊則從1993年的世運會開始，每屆都有奪牌的紀錄，期待選手們能夠再創佳績。
  還有我們的合球代表隊，目前是世界排名第3，亞洲排名第1。在上屆世運會也獲得銀牌，創下參賽以來最好的成績，希望這次能夠奪下金牌、再次刷新紀錄。
  疫情期間出國比賽很不容易，為了讓選手充分發揮實力，我們也設置四名隨隊的醫師，協助注意防疫，全程照顧代表團的健康安全。
  期待每一位選手都能在賽場上，挑戰自我，全力以赴，為自己取得最高的榮耀，也用最高的拚勁和韌性，讓世界看到台灣。
  我也要請大家一起關注賽事，為我們的選手加油！"
  ,
  "6個月至5歲幼兒，開放接種兩劑莫德納疫苗！
  這個月以來，第一劑疫苗涵蓋率已經超過九成，我們也要提升幼兒的疫苗保護力。指揮中心今天根據ACIP專家會議決議宣布：
  🔺6個月至5歲幼兒，開放接種兩劑莫德納疫苗，兩劑間隔4至8週以上。
  此外，針對5-11歲兒童，目前全國各地正進行第二劑疫苗接種作業，ACIP也建議若兩劑打滿5個月(150天)後，可以接種第三劑，而18歲以上成人可以接種Novavax疫苗第一、二、三、四劑。
  我也要提醒大家，疫苗接種時間及作業，待指揮中心及地方衛生局安排，請爸爸媽媽可以考慮帶孩子前往接種，一起守護我們的小小孩。
  還有7/1起，政府第二輪免費提供0至6歲幼兒(2015/9/2(含)後出生者為限)5劑快篩試劑，家長也都可以至健保特約藥局及衛生所領取。
  近來，全國疫情已經逐步趨緩，我們會持續做好防疫工作，穩健走向疫後正常生活。"
  ,
  "「抗癌小天使」潘盈希小妹妹不僅勇敢對抗病情，更是一位小畫家，用創作帶給很多人鼓勵。
  前陣子，盈希許下三個願望，其中一個是想找蔡想想。今天，我邀請盈希一家人來官邸，除了帶他們認識蔡想想，也一起介紹我家其他的毛小孩：阿才、樂樂、Bella、Bunny和Maru。
  雖然害羞的阿才一直躲起來，不太給我面子，不過，看到人就很興奮的樂樂，倒是跟盈希姊妹倆玩丟接球玩得蠻開心的。
  不只盈希勇敢接受治療，盈希的爸爸媽媽也很努力照顧孩子，並把這份經驗分享給社會，幫助更多人，真的很令人敬佩。
  我也要謝謝  鄭文燦 市長 以及  鄭運鵬 委員，先前協助盈希盡速解決確診通報等行政問題，讓她獲得妥善的治療照顧。
  相信大家都為盈希一家人的努力而感動，希望盈希能繼續加油，盡情享受創作的快樂！"
)

stop_words_list <- read.table(file = "./r_data/stop_words.txt", header = TRUE)
stop_words_list <- list(stop_words_list)[[1]][["X."]]
stop_words_list <- append(stop_words_list, c('，', '。', '、', '「', '」', '！', '#', '(', ')', ' ', '  ', '   '))


for(i in 1 : length(sentence_list)){
  sentence_list[[i]] <- gsub('\n', ' ', sentence_list[[i]])
}

word_sentence_list = ws(sentence_list)

for(i in 1 : length(word_sentence_list)){
  word_sentence_list[[i]] <- word_sentence_list[[i]][!word_sentence_list[[i]] %in% stop_words_list]
}

corp = Corpus(VectorSource(word_sentence_list))

dtm = DocumentTermMatrix(corp)

ap_lda <- LDA(dtm, k = 4, control = list(seed = 1234))
ap_lda

ap_topics <- tidy(ap_lda, matrix = "beta")
ap_topics

ap_top_terms <- ap_topics %>%
  group_by(topic) %>%
  top_n(10, beta) %>%
  ungroup() %>%
  arrange(topic, -beta)

ap_top_terms %>%
  mutate(term = reorder(term, beta)) %>%
  ggplot(aes(term, beta, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  coord_flip()
