from gensim import utils
from gensim.models.doc2vec import LabeledSentence
from gensim.models import Doc2Vec
from gensim.models.doc2vec import TaggedDocument
import numpy
# randoml
from random import shuffle
# classifierfrom deepdist import DeepDist
from sklearn.linear_model import LogisticRegression
from deepdist import DeepDist
from pyspark import SparkContext
sc = SparkContext()
corpus =sc.textFile('hdfs:///user/hadoop/data/tagged_docs_shuffled.txt').map(
    lambda s: TaggedDocument(s[19:].split(), [s[:18]]))

def gradient(model, taggedData):
    syn0, syn1, doctag = model.wv.syn0.copy(), model.syn1neg.copy(), model.docvecs.vectors_docs.copy()
    model.train(taggedData,total_examples=model.corpus_count,epochs=3)
    return {'syn0': model.wv.syn0 - syn0,'syn1':model.syn1neg-syn1,'doctag':model.docvecs.vectors_docs-doctag}

def descent(model, update):
    model.wv.syn0 += update['syn0']
    model.syn1neg += update['syn1']
    model.docvecs.vectors_docs += update['doctag']
collectedCorpus = corpus.collect()
doc2VecModel = Doc2Vec(collectedCorpus)
with DeepDist(doc2VecModel,master='192.168.91.1:5000') as dd:
    for i in range(3):
        dd.train(corpus,gradient,descent)


train_arrays = numpy.zeros((25000, 100))
train_labels = numpy.zeros(25000)
for i in range(12500):
    prefix_train_pos = 'TRAIN_POS' + "%09d"%(i+1,)
    prefix_train_neg = 'TRAIN_NEG' + "%09d"%(i+1,)
    train_arrays[i] = dd.model[prefix_train_pos]
    train_arrays[12500 + i] =dd.model[prefix_train_neg]
    train_labels[i] = 1
    train_labels[12500 + i] = 0
test_arrays = numpy.zeros((25000, 100))
test_labels = numpy.zeros(25000)
for i in range(12500):
    prefix_test_pos = 'TEST__POS' + "%09d"%(i+1,)
    prefix_test_neg = 'TEST__NEG' + "%09d"%(i+1,)
    test_arrays[i] = dd.model[prefix_test_pos]
    test_arrays[12500 + i] = dd.model[prefix_test_neg]
    test_labels[i] = 1
    test_labels[12500 + i] = 0
classifier = LogisticRegression()
classifier.fit(train_arrays, train_labels)

print classifier.score(test_arrays, test_labels)