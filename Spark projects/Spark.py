# -*- coding: utf-8 -*-
"""
Created on Sun Jul 28 15:58:47 2019

@author: bruno
"""

from pyspark.ml.feature import MinMaxScaler
from pyspark.ml.linalg import Vectors
from pyspark.sql import SparkSession

spark = SparkSession \
    .builder \
    .appName("Python Spark SQL basic example") \
    .config("spark.some.config.option", "some-value") \
    .getOrCreate()

features=spark.createDataFrame([(1,Vectors.dense([10,10000,1]),),
                               (2,Vectors.dense([20,30000,2]),),
                               (3,Vectors.dense([30,40000,3]),)],['id','features'])
features.take(1)
feature_scaler=MinMaxScaler(inputCol='features',outputCol='sfeatures')
smodel=feature_scaler.fit(features)
sfeatures=smodel.transform(features)
sfeatures.take(1)
sfeatures.select('features','sfeatures').show()

from pyspark.ml.linalg import Vectors
from pyspark.ml.feature import VectorAssembler
from pyspark.ml.clustering import KMeans

base=spark.read.csv('C:/Users/bruno/Downloads/Ex_Files_Spark_ML_AI (1)/Ex_Files_Spark_ML_AI/Exercise Files/Ch03/03_02/clustering_dataset.csv',header=True, inferSchema=True)
base.show()
vectorassembler=VectorAssembler(inputCols=['col1','col2','col3'],outputCol='features')
vcluster=vectorassembler.transform(base)
vcluster.show()

kmeans=KMeans().setK(3)
kmeans=kmeans.setSeed(1)
kmeans=kmeans.fit(vcluster)
centers=kmeans.clusterCenters()

