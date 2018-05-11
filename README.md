# DDoc2Vec

DDoc2Vec is a python implementation of distributed doc2vec. Most of the machine learning algorithams need mathematical representation of the data values when it comes to text getting mathematical representation of the text is very difficult because of the semantics involved with it. Doc2Vec is a solution for it. Here we are using an existing gensim doc2vec model and coverting it into a distributed model. 

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. 

### Prereqisites
Hadoop and spark should be setup with all the permissions to the user. 

These python packages are needed to be installed.

```
gensim
deepdist
sklearn
pyspark 
```

## Installing
Clone the repository 

download the  dataset [here](http://ai.stanford.edu/~amaas/data/sentiment/aclImdb_v1.tar.gz). 

```bash
$ wget http://ai.stanford.edu/~amaas/data/sentiment/aclImdb_v1.tar.gz
$ tar -xvf aclImdb_v1.tar.gz
$ mv aclImdb_v1.tar.gz/ data/
```
## Preparing the dataset
```
$ chmod +x dataPrepare.sh
$ ./dataPrepare.sh
```

