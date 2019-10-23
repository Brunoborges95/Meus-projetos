# Import SparkSession
from pyspark.sql import SparkSession

# Build the SparkSession
spark = SparkSession.builder \
   .master("local") \
   .appName("Linear Regression Model") \
   .config("spark.executor.memory", "1gb") \
   .getOrCreate()
   
   
"""Note que os dados foram salvos
 em uma variável chamada rdd, que significa 
 Resilient Distributed Dataset, a principal 
 estrutura de dados do Spark.
  Essa estrutura permite trabalhar com computação 
  distribuída, ou seja, os dados serão distribuídos entre os nós do cluster, e controlados pelo nó master. 
  Desta forma pode-se processá-los em paralelo, aumentando a velocidade de processamento."""
sc = spark.sparkContext
rdd = sc.textFile('C:/Users/bruno/Documents/Machine Learning/Spark projects/Salary_Data.csv')
rdd.take(2)

# Split lines on commas
rdd = rdd.map(lambda line: line.split(","))

# Inspect the first line
rdd.take(5)
rdd.first()

# Take top elements
rdd.top(1)

# Import the necessary modules 
from pyspark.sql import Row

# Map the RDD to a DF
df = rdd.map(lambda line: Row(YearsExperience=line[0], Salary=line[1])).toDF()
# Show the top 20 rows 
df.show()
"""O método .printSchema mostra algumas informações sobre os tipos 
de dados presentes nas colunas, conforme linha abaixo."""
df.printSchema()

# Import all from `sql.types`
from pyspark.sql.types import *

# Write a custom function to convert the data type of DataFrame columns
def convertColumn(df, names, newType):
    for name in names: 
        df = df.withColumn(name, df[name].cast(newType))
    return df 

# Assign all column names to `columns`
columns = ['YearsExperience', 'Salary']

# Conver the `df` columns to `FloatType()`
df = convertColumn(df, columns, Flo())
df.show()
df.select('Salary').show(10)
df.groupBy("Salary").count().sort("Salary",ascending=False).show()
df.describe().show()

"""Agora é hora de começar a tratar os dados de modo à deixá-los no formato que o algoritmo de Machine Learning espera. Para isso, usa-se o módulo DenseVector. 
Este DenseVector é uma maneira otimizada de lidar com valores numéricos, acelerando o processamento realizado pelo Spark.
Assim, mapeia-se as linhas do df transformando-as em DenseVector, e cria-se um novo dataframe, chamado df, com as colunas ‘label’ e ‘features’.

Recordando que uma Regressão Linear é um problema de Aprendizado Supervisionado, ou seja, o algoritmo necessita do ‘ground truth’, os rótulos das entradas, 
de modo que ele possa comparar com sua saída e calcular alguma métrica de erro, como Erro Quadrático Médio (do inglês, Mean Squared Error, MSE), 
bastante empregado em problemas de Regressão."""

#Import DenseVector
from pyspark.mllib.linalg import DenseVector
# Define the `input_data` 
input_data = df.rdd.map(lambda x: (x[0], DenseVector(x[1:])))

# Replace `df` with the new DataFrame
df = spark.createDataFrame(input_data, ["label", "features"])
df.show()

import pandas as pd
pd.DataFrame(df.take(5), columns=df.columns)

# Import `StandardScaler` 
from pyspark.ml.feature import StandardScaler

# Initialize the `standardScaler`
standardScaler = StandardScaler(inputCol="features", outputCol="features_scaled")

# Fit the DataFrame to the scaler
scaler = standardScaler.fit(df)

# Transform the data in `df` with the scaler
scaled_df = scaler.transform(df)

# Inspect the result
scaled_df.take(2)

# Split the data into train and test sets
train_data, test_data = df.randomSplit([.75,.25],seed=1234)

# Import `LinearRegression`
from pyspark.ml.regression import LinearRegression

# Initialize `lr`
lr = LinearRegression(labelCol="label", maxIter=10)

# Fit the data to the model
linearModel = lr.fit(train_data)

# Generate predictions
predicted = linearModel.transform(test_data)

# Extract the predictions and the "known" correct labels
predictions = predicted.select("prediction").rdd.map(lambda x: x[0])
labels = predicted.select("label").rdd.map(lambda x: x[0])

# Zip `predictions` and `labels` into a list
predictionAndLabel = predictions.zip(labels).collect()

# Print out first 5 instances of `predictionAndLabel` 
predictionAndLabel[:5]

# Coefficients for the model
linearModel.coefficients

# Intercept for the model
linearModel.intercept

# Get the RMSE
linearModel.summary.rootMeanSquaredError

# Get the R2
linearModel.summary.r2
spark.stop()

