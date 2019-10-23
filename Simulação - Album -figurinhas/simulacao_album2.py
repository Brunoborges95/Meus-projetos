# -*- coding: utf-8 -*-
"""
Created on Fri Feb  1 14:37:48 2019

@author: bruno
"""

import numpy as np
import matplotlib.pyplot as plt
import numpy.matlib as npm
import random


#Cria a base de figurinhas
numeroFigurinhasAlbum=639
a0 = np.array(range(0,numeroFigurinhasAlbum))
data=npm.repmat(a0, 1, 1000)
data=data[0].tolist()
data2=data
# the same, but preserving the data list
 
#Função que escolhe as figurinhas e exclui do banco de dados             
def faster(n):
    elem=[]
    data3=len(data)
    while len(data)>data3-n:
        index = random.randrange(len(data))
        elem.append(data[index])
        # direct deletion, no search needed
        del data[index] 
    return elem
 
#função que gera o pacote de figurinhas       
def geraPacote(numeroFigurinhasPacote):
    pacote=faster(numeroFigurinhasPacote)
    return pacote

#Código Principal       
if __name__ == '__main__':
    # Parametros
    numeroFigurinhasPacote=5   
    numeroAmostras=100
    album=np.zeros([numeroFigurinhasAlbum],dtype=bool)
    # Variaveis
    porcentagemPreenchida=1
    preenchimento=int(porcentagemPreenchida*numeroFigurinhasAlbum)
    # Código Principal
    media=0
    
    album=np.zeros([numeroFigurinhasAlbum,numeroAmostras],dtype=bool)            
    somaNumeroDePacotesUsados=np.zeros([numeroAmostras])
    numeroFigurinhasPreenchidas=np.zeros([numeroAmostras])
    num=1
    num2=1
    while len(data)>0:
        for i in range(numeroAmostras):
            if numeroFigurinhasPreenchidas[i]<preenchimento:
                pacote=geraPacote(numeroFigurinhasPacote)
                somaNumeroDePacotesUsados[i]=somaNumeroDePacotesUsados[i]+num
                print ("Amostra", i,'Usou',somaNumeroDePacotesUsados[i], 'pacotes', "Numero Figurinhas Preenchidas", numeroFigurinhasPreenchidas[i])
                for j in range(numeroFigurinhasPacote):
                    if (not album[pacote[j]][i]):
                        album[pacote[j]][i]=True
                        numeroFigurinhasPreenchidas[i]=numeroFigurinhasPreenchidas[i]+num
        num=+1
        

                        
        media=media+somaNumeroDePacotesUsados            
    media=media/numeroAmostras
    print ("Média de 100 simulações:", media)  

    plt.hist(somaNumeroDePacotesUsados)
    plt.xlabel('Número de Pacotes Necessários')
    plt.ylabel('Pessoas')
    ganho1=simulations
    Ganho=simulations*2.50
    sum(Ganho)
    
    ganhadores=[]
    if numeroFigurinhasPreenchidas[i]==numeroFigurinhasAlbum-1:
        ganhandores.append(i)
    
    plt.hist(numeroFigurinhasPreenchidas)
