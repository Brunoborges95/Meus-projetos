import pandas as pd
import numpy as np

base=pd.read_csv('iris.csv')
base.shape
#Gero uma amostra de zeros, com reposicao,com 150 elementos de mesma probabilidade
amostra=np.random.choice(a=[0,1],size=150,replace=True, p=[0.5,0.5])

len(amostra)
np.random.seed(12345) #Repetir a aleatoriedade de uma função

#Aqui eu produzo uma amostra estrtificada, onde seleciono 25 elementos de cada especie da base iris

from sklearn.model_selection import train_test_split
base['class'].value_counts()

X,x1,y,y1=train_test_split(base.iloc[:,0:4], base.iloc[:,4],test_size=0.5,stratify=base.iloc[:,4])
y.value_counts()

#pacote para amostragem sistematica
from math import ceil

população=150
amostra=15
k=ceil(população/amostra)
r=np.random.randint(1,high=k+1,size=1)
r=r[0]
sorteados=[]
for i in range(amostra):
    sorteados.append(r)
    r+=k
