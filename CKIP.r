library(reticulate)

use_python("C:/Users/user/AppData/Local/Programs/Python/Python39/python.exe")
py_config()

ckip = import("ckiptagger")

ws = ckip$WS("./data")
pos = ckip$POS("./data")
ner = ckip$NER("./data")

sentence_list <- list(
  "傅達仁今將執行安樂死，卻突然爆出自己20年前遭緯來體育台封殺，他不懂自己哪裡得罪到電視台。",
  "美國參議院針對今天總統布什所提名的勞工部長趙小蘭展開認可聽證會，預料她將會很順利通過參議院支持，成為該國有史以來第一位的華裔女性內閣成員。",
  "",
  "土地公有政策?？還是土地婆有政策。.",
  "… 你確定嗎… 不要再騙了……",
  "最多容納59,000個人,或5.9萬人,再多就不行了.這是環評的結論.",
  "科長說:1,坪數對人數為1:3。2,可以再增加。"
)

word_to_weight <- list(
  "土地公" = 1,
  "土地婆" = 1,
  "公有" = 2,
  "緯來體育台" = 1
)

dictionary = ckip$construct_dictionary(word_to_weight)

word_sentence_list = ws(sentence_list, recommend_dictionary = dictionary)
pos_sentence_list = pos(word_sentence_list)
entity_sentence_list = ner(word_sentence_list, pos_sentence_list)

for(i in 1 : length(sentence_list)){
  print(i)
  print(sentence_list[[i]])
  
  tmp1 = word_sentence_list[[i]]
  tmp2 = pos_sentence_list[[i]]
  tmp3 = list(entity_sentence_list[[i]])
  
  if(length(tmp1) > 0){
    for(j in 1 : length(tmp1)){
      print(paste(tmp1[[j]], tmp2[[j]]))
    }
  }
  
  if(length(tmp3) > 0){
    for(j in 1 : length(tmp3)){
      print(tmp3[[j]])
    }
  }
}
