
from scipy.stats import norm
from scipy import stats

#Dado o desvio padrão 2 e média 8, encontrar a prob de ser menor que 6
norm.cdf(6,8,2)
#Dado o desvio padrão 2 e média 8, encontrar a prob de ser maior que 6
norm.sf(6,8,2)

import matplotlib.pyplot as plt
dados=norm.rvs(size=100)
stats.probplot(dados,plot=plt)
#teste para verificar se a distribuição é normal
stats.shapiro(dados)

