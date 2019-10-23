# -*- coding: utf-8 -*-
"""
Created on Fri Feb  1 14:37:48 2019

@author: bruno
"""

import numpy as np
import matplotlib.pyplot as plt

def geraPacote(numeroFigurinhasPacote,numeroFigurinhasAlbum):
    pacote=np.random.randint(0,numeroFigurinhasAlbum,numeroFigurinhasPacote)
    return pacote

if __name__ == '__main__':
    # Parametros
    numeroFigurinhasPacote=5
    numeroFigurinhasAlbum=639    
    numeroAmostras=100
    simulations=np.empty([numeroAmostras])
    album=np.zeros([numeroFigurinhasAlbum],dtype=bool)
    # Variaveis
    porcentagemPreenchida=1
    preenchimento=int(porcentagemPreenchida*numeroFigurinhasAlbum)
    # Código Principal
    media=0
    for i in range(numeroAmostras):
        print ("Amostra", i)
        album=np.zeros([numeroFigurinhasAlbum],dtype=bool)        
        numeroFigurinhasPreenchidas=0    
        somaNumeroDePacotesUsados=0
        while (numeroFigurinhasPreenchidas<preenchimento):
            pacote=geraPacote(numeroFigurinhasPacote,numeroFigurinhasAlbum)
            somaNumeroDePacotesUsados=somaNumeroDePacotesUsados+1
            for j in range(numeroFigurinhasPacote):
                if (not album[pacote[j]]):
                    album[pacote[j]]=True
                    numeroFigurinhasPreenchidas=numeroFigurinhasPreenchidas+1
                    print ("Numero Figurinhas Preenchidas", numeroFigurinhasPreenchidas)
        simulations[i]=somaNumeroDePacotesUsados            
        media=media+somaNumeroDePacotesUsados            
    media=media/numeroAmostras
    print ("Média de 100 simulações:", media)  

    plt.hist(simulations)
    plt.xlabel('Número de Pacotes Necessários')
    plt.ylabel('Pessoas')
    #acumulativo
    plt.hist(simulations, normed=1, cumulative=1)
    plt.xlabel('Número de Pacotes Necessários')
    plt.ylabel('Porcentagem Pessoas')
    ganho1=simulations
    Ganho=simulations*2.50
    sum(Ganho)