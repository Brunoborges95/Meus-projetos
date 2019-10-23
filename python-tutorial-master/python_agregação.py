# -*- coding: utf-8 -*-
"""
Created on Fri Jun 28 23:02:45 2019

@author: bruno
"""

import pandas as pd

names=pd.read_csv('yob1880.txt', names=['nome','sex','births'])
names.head(10)

names.groupby('sex').sum()

years=range(1880,2011)

tabelas=[]

for ano in years:
    tabela=pd.read_csv('yob%d.txt' %ano, names=['nome','sex','births'])
    tabela['year']=ano
    tabelas.append(tabela)
    
    
tabelas2=pd.concat(tabelas, ignore_index='True')



def add_prop(group):
 # Integer division floors
 births = group.births.astype(float)
 group['prop'] = births / births.sum()
 return group
names = tabelas2.groupby(['year', 'sex']).apply(add_prop)

    
total_births = tabelas2.pivot_table('births', index=['year'], columns=['sex'], aggfunc=sum)

def get_top1000(group):
    return group.sort_index(by='births', ascending=False)[:1000]
grouped = names.groupby(['year', 'sex'])
top1000 = grouped.apply(get_top1000)

boys = top1000[top1000.sex == 'M']
boys1995= boys[boys.year==1995]


