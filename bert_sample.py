import keras_bert as kb
import numpy as np
import os

#Set file paths
pretrained_path = 'F:\\TA\\SICSS\\BERT\\chinese_roberta_wwm_ext_L-12_H-768_A-12'
config_path = os.path.join(pretrained_path, 'bert_config.json')
checkpoint_path = os.path.join(pretrained_path, 'bert_model.ckpt')
vocab_path = os.path.join(pretrained_path, 'vocab.txt')

#Tokenization and preprocess
token_dict = kb.load_vocabulary(vocab_path)
tokenizer = kb.Tokenizer(token_dict)

text = "這幾年來，在國軍的攜手努力下，我們積極推動的軍事改革、國防自主政策，都有很好的進展"
tok = tokenizer.tokenize(text) #'[CLS]', '這', '幾', '年', ... '進', '展', '[SEP]'
tok[12] = '[MASK]'
tok[13] = '[MASK]'
#'[CLS]', '這', '幾', '年', '來', '，', '在', '國', '軍', '的', '攜', '手', '[MASK]', '[MASK]', '下', ..., '進', '展', '[SEP]'

indices = np.array([[token_dict[t] for t in tok] + [0] * (512 - len(tok))])
segment = np.array([[0] * 512])
masks = np.array([[0] * 12 + [1, 1] + [0] * (512 - 14)])

#prediction
model = kb.load_trained_model_from_checkpoint(config_path, checkpoint_path, training = True)
pred = model.predict([indices, segment, masks])[0].argmax(axis = -1).tolist()

token_dict_rev = {v:k for k, v in token_dict.items()}

print("".join(list(map(lambda x : token_dict_rev[x], pred[0][1:20]))))
#這幾年來，在國軍的攜手努力下，我們積極 (...)